Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934586Ab1ETFov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:44:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43955 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930Ab1ETFou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:44:50 -0400
X-AuditID: cbfee61b-b7c62ae0000056ed-af-4dd5ffd01e70
Date: Fri, 20 May 2011 14:44:41 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH 0/4] Samsung: Move Samsung SoCs GPIO drivers to drivers/gpio
To: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, kgene.kim@samsung.com, linux-arm-kernel@lists.infradead.org
Message-id: <20110520054441.GA9952@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 20 May 2011 05:44:47.0252 (UTC)
 FILETIME=[07302540:01CC16B1]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf:

  Linux 2.6.39 (2011-05-18 21:06:34 -0700)

Kyungmin Park (4):
      Move to Samsung common GPIO library to drivers/gpio
      Move the exynos4 GPIO to drivers/gpio
      Move the s5pv210 GPIO to drivers/gpio
      Move the s5pc100 GPIO to drivers/gpio

 arch/arm/mach-exynos4/Makefile                     |    2 +-
 arch/arm/mach-s5pc100/Makefile                     |    2 +-
 arch/arm/mach-s5pv210/Makefile                     |    2 +-
 arch/arm/plat-samsung/Makefile                     |    1 -
 drivers/gpio/Kconfig                               |   24 ++++++++++++++++++++
 drivers/gpio/Makefile                              |    4 +++
 .../gpiolib.c => drivers/gpio/exynos4-gpio.c       |    0
 .../gpiolib.c => drivers/gpio/s5pc100-gpio.c       |    0
 .../gpiolib.c => drivers/gpio/s5pv210-gpio.c       |    0
 .../gpiolib.c => drivers/gpio/samsung-gpiolib.c    |    3 +-
 10 files changed, 33 insertions(+), 5 deletions(-)
 rename arch/arm/mach-exynos4/gpiolib.c => drivers/gpio/exynos4-gpio.c (100%)
 rename arch/arm/mach-s5pc100/gpiolib.c => drivers/gpio/s5pc100-gpio.c (100%)
 rename arch/arm/mach-s5pv210/gpiolib.c => drivers/gpio/s5pv210-gpio.c (100%)
 rename arch/arm/plat-samsung/gpiolib.c => drivers/gpio/samsung-gpiolib.c (99%)

diff --git a/arch/arm/mach-exynos4/Makefile b/arch/arm/mach-exynos4/Makefile
index 9be104f..3bb3f57 100644
--- a/arch/arm/mach-exynos4/Makefile
+++ b/arch/arm/mach-exynos4/Makefile
@@ -13,7 +13,7 @@ obj-				:=
 # Core support for EXYNOS4 system
 
 obj-$(CONFIG_CPU_EXYNOS4210)	+= cpu.o init.o clock.o irq-combiner.o
-obj-$(CONFIG_CPU_EXYNOS4210)	+= setup-i2c0.o gpiolib.o irq-eint.o dma.o
+obj-$(CONFIG_CPU_EXYNOS4210)	+= setup-i2c0.o irq-eint.o dma.o
 obj-$(CONFIG_PM)		+= pm.o sleep.o
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq.o
 
diff --git a/arch/arm/mach-s5pc100/Makefile b/arch/arm/mach-s5pc100/Makefile
index eecab57..a5e6e60 100644
--- a/arch/arm/mach-s5pc100/Makefile
+++ b/arch/arm/mach-s5pc100/Makefile
@@ -11,7 +11,7 @@ obj-				:=
 
 # Core support for S5PC100 system
 
-obj-$(CONFIG_CPU_S5PC100)	+= cpu.o init.o clock.o gpiolib.o
+obj-$(CONFIG_CPU_S5PC100)	+= cpu.o init.o clock.o
 obj-$(CONFIG_CPU_S5PC100)	+= setup-i2c0.o
 obj-$(CONFIG_CPU_S5PC100)	+= dma.o
 
diff --git a/arch/arm/mach-s5pv210/Makefile b/arch/arm/mach-s5pv210/Makefile
index 11f1790..50907ac 100644
--- a/arch/arm/mach-s5pv210/Makefile
+++ b/arch/arm/mach-s5pv210/Makefile
@@ -12,7 +12,7 @@ obj-				:=
 
 # Core support for S5PV210 system
 
-obj-$(CONFIG_CPU_S5PV210)	+= cpu.o init.o clock.o dma.o gpiolib.o
+obj-$(CONFIG_CPU_S5PV210)	+= cpu.o init.o clock.o dma.o
 obj-$(CONFIG_CPU_S5PV210)	+= setup-i2c0.o
 obj-$(CONFIG_S5PV210_PM)	+= pm.o sleep.o
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq.o
diff --git a/arch/arm/plat-samsung/Makefile b/arch/arm/plat-samsung/Makefile
index e9de58a..53eb15b 100644
--- a/arch/arm/plat-samsung/Makefile
+++ b/arch/arm/plat-samsung/Makefile
@@ -19,7 +19,6 @@ obj-y				+= gpio.o
 obj-y				+= gpio-config.o
 obj-y				+= dev-asocdma.o
 
-obj-$(CONFIG_SAMSUNG_GPIOLIB_4BIT)	+= gpiolib.o
 obj-$(CONFIG_SAMSUNG_CLKSRC)	+= clock-clksrc.o
 
 obj-$(CONFIG_SAMSUNG_IRQ_UART)	+= irq-uart.o
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d3b2953..d838f5b 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -75,6 +75,30 @@ config GPIO_BASIC_MMIO
 	help
 	  Say yes here to support basic memory-mapped GPIO controllers.
 
+config GPIO_EXYNOS4
+	bool "Samsung Exynos4 GPIO library support"
+	default y if CPU_EXYNOS4210
+	help
+	  Say yes here to support Samsung Exynos4 series SoCs GPIO library
+
+config GPIO_SAMSUNG
+	bool "Samsung SoCs GPIO library support"
+	default y if SAMSUNG_GPIOLIB_4BIT
+	help
+	  Say yes here to support Samsung SoCs GPIO library
+
+config GPIO_S5PC100
+	bool "Samsung S5PC100 GPIO library support"
+	default y if CPU_S5PC100
+	help
+	  Say yes here to support Samsung S5PC100 SoC GPIO library
+
+config GPIO_S5PV210
+	bool "Samsung S5PV210/S5PC110 GPIO library support"
+	default y if CPU_S5PV210
+	help
+	  Say yes here to support Samsung S5PV210/S5PC110 SoC GPIO library
+
 config GPIO_IT8761E
 	tristate "IT8761E GPIO support"
 	depends on GPIOLIB
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index becef59..738386f 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -11,6 +11,10 @@ obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
 obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
 obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
+obj-$(CONFIG_GPIO_EXYNOS4)	+= exynos4-gpio.o
+obj-$(CONFIG_GPIO_SAMSUNG)	+= samsung-gpiolib.o
+obj-$(CONFIG_GPIO_S5PC100)	+= s5pc100-gpio.o
+obj-$(CONFIG_GPIO_S5PV210)	+= s5pv210-gpio.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
 obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
 obj-$(CONFIG_GPIO_MAX7300)	+= max7300.o
diff --git a/arch/arm/mach-exynos4/gpiolib.c b/drivers/gpio/exynos4-gpio.c
similarity index 100%
rename from arch/arm/mach-exynos4/gpiolib.c
rename to drivers/gpio/exynos4-gpio.c
diff --git a/arch/arm/mach-s5pc100/gpiolib.c b/drivers/gpio/s5pc100-gpio.c
similarity index 100%
rename from arch/arm/mach-s5pc100/gpiolib.c
rename to drivers/gpio/s5pc100-gpio.c
diff --git a/arch/arm/mach-s5pv210/gpiolib.c b/drivers/gpio/s5pv210-gpio.c
similarity index 100%
rename from arch/arm/mach-s5pv210/gpiolib.c
rename to drivers/gpio/s5pv210-gpio.c
diff --git a/arch/arm/plat-samsung/gpiolib.c b/drivers/gpio/samsung-gpiolib.c
similarity index 99%
rename from arch/arm/plat-samsung/gpiolib.c
rename to drivers/gpio/samsung-gpiolib.c
index ea37c04..925b66e 100644
--- a/arch/arm/plat-samsung/gpiolib.c
+++ b/drivers/gpio/samsung-gpiolib.c
@@ -1,4 +1,5 @@
-/* arch/arm/plat-samsung/gpiolib.c
+/*
+ * drivers/gpio/samsung-gpiolib.c
  *
  * Copyright 2008 Openmoko, Inc.
  * Copyright 2008 Simtec Electronics
