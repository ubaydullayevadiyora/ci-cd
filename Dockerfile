# 1-bosqich: build stage
FROM node:18-alpine AS builder

WORKDIR /app

# package.json va package-lock.json fayllarni qo‘shamiz
COPY package*.json ./

# CI install
RUN npm ci

# Barcha project fayllarni qo‘shamiz
COPY . .

# Build buyrug‘i (NestJS uchun --prod kerak emas, optional)
RUN npm run build

# 2-bosqich: run stage
FROM node:18-alpine

WORKDIR /app

# build qilingan fayllarni olib o‘tamiz
COPY --from=builder /app/dist ./dist

# package.json va lock faylni qo‘shamiz
COPY package*.json ./

# faqat prod dependencies ni o‘rnatamiz
RUN npm ci --omit=dev

# start qilamiz
CMD ["node", "dist/main.js"]
