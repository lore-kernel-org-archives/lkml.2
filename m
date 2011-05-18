Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab1ERLzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 07:55:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62221 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932763Ab1ERLzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 07:55:48 -0400
X-AuditID: cbfee61b-b7c62ae0000056ed-e4-4dd3b3c2df94
Date: Wed, 18 May 2011 20:55:36 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH] Exynos4: Move GPIO drivers to drivers/gpio
To: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, kgene.kim@samsung.com, linux-arm-kernel@lists.infradead.org
Message-id: <20110518115536.GA31059@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 18 May 2011 11:55:45.0889 (UTC)
 FILETIME=[858B1D10:01CC1552]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

Samsung Exynos4 gpio driver moved to drivers/gpio.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/arch/arm/mach-exynos4/gpiolib.c b/drivers/gpio/exynos4-gpio.c
similarity index 100%
rename from arch/arm/mach-exynos4/gpiolib.c
rename to drivers/gpio/exynos4-gpio.c
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
 
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d3b2953..7938449 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -75,6 +75,12 @@ config GPIO_BASIC_MMIO
 	help
 	  Say yes here to support basic memory-mapped GPIO controllers.
 
+config GPIO_EXYNOS4
+	bool "Samsung Exynos4 GPIO support"
+	depends on CPU_EXYNOS4210
+	help
+	  Say yes here to support Samsung Exynos4 GPIO controllers.
+
 config GPIO_IT8761E
 	tristate "IT8761E GPIO support"
 	depends on GPIOLIB
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index becef59..f2373d0 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
 obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
 obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
+obj-$(CONFIG_GPIO_EXYNOS4)	+= exynos4-gpio.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
 obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
 obj-$(CONFIG_GPIO_MAX7300)	+= max7300.o
