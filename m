Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab1FFHG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 03:06:58 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:39500 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab1FFHG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 03:06:57 -0400
Subject: [PATCH] gpio: reorganize drivers
To: linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 06 Jun 2011 01:06:56 -0600
Message-ID: <20110606070553.9829.40823.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sort the gpio makefile and enforce the naming convention gpio-*.c for
gpio drivers.

v2: cleaned up filenames in Kconfig and comment blocks

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/gpio/Kconfig             |   32 ++++-----------
 drivers/gpio/Makefile            |   81 ++++++++++++++++++++------------------
 drivers/gpio/gpio-74x164.c       |    0 
 drivers/gpio/gpio-ab8500.c       |    0 
 drivers/gpio/gpio-adp5520.c      |    0 
 drivers/gpio/gpio-adp5588.c      |    0 
 drivers/gpio/gpio-bt8xx.c        |    0 
 drivers/gpio/gpio-cs5535.c       |    0 
 drivers/gpio/gpio-ep93xx.c       |    2 -
 drivers/gpio/gpio-exynos4.c      |    5 +-
 drivers/gpio/gpio-generic.c      |    6 +--
 drivers/gpio/gpio-it8761e.c      |    2 -
 drivers/gpio/gpio-janz-ttl.c     |    0 
 drivers/gpio/gpio-langwell.c     |    4 +-
 drivers/gpio/gpio-max7300.c      |    2 -
 drivers/gpio/gpio-max7301.c      |    2 -
 drivers/gpio/gpio-max730x.c      |    2 -
 drivers/gpio/gpio-max732x.c      |    2 -
 drivers/gpio/gpio-mc33880.c      |    2 -
 drivers/gpio/gpio-mcp23s08.c     |    2 -
 drivers/gpio/gpio-ml-ioh.c       |    0 
 drivers/gpio/gpio-pca953x.c      |    2 -
 drivers/gpio/gpio-pcf857x.c      |    2 -
 drivers/gpio/gpio-pch.c          |    0 
 drivers/gpio/gpio-pl061.c        |    4 --
 drivers/gpio/gpio-plat-samsung.c |    3 -
 drivers/gpio/gpio-rdc321x.c      |    0 
 drivers/gpio/gpio-s5pc100.c      |    5 +-
 drivers/gpio/gpio-s5pv210.c      |    5 +-
 drivers/gpio/gpio-sch.c          |    2 -
 drivers/gpio/gpio-stmpe.c        |    0 
 drivers/gpio/gpio-sx150x.c       |    0 
 drivers/gpio/gpio-tc3589x.c      |    0 
 drivers/gpio/gpio-timberdale.c   |    2 -
 drivers/gpio/gpio-tps65910.c     |    2 -
 drivers/gpio/gpio-twl4030.c      |    2 -
 drivers/gpio/gpio-u300.c         |    5 --
 drivers/gpio/gpio-ucb1400.c      |    0 
 drivers/gpio/gpio-vr41xx.c       |    0 
 drivers/gpio/gpio-vx855.c        |    0 
 drivers/gpio/gpio-wm831x.c       |    2 -
 drivers/gpio/gpio-wm8350.c       |    2 -
 drivers/gpio/gpio-wm8994.c       |    2 -
 drivers/gpio/gpio-xilinx.c       |    0 
 44 files changed, 78 insertions(+), 106 deletions(-)
 rename drivers/gpio/{74x164.c => gpio-74x164.c} (100%)
 rename drivers/gpio/{ab8500-gpio.c => gpio-ab8500.c} (100%)
 rename drivers/gpio/{adp5520-gpio.c => gpio-adp5520.c} (100%)
 rename drivers/gpio/{adp5588-gpio.c => gpio-adp5588.c} (100%)
 rename drivers/gpio/{bt8xxgpio.c => gpio-bt8xx.c} (100%)
 rename drivers/gpio/{cs5535-gpio.c => gpio-cs5535.c} (100%)
 rename drivers/gpio/{basic_mmio_gpio.c => gpio-generic.c} (99%)
 rename drivers/gpio/{it8761e_gpio.c => gpio-it8761e.c} (98%)
 rename drivers/gpio/{janz-ttl.c => gpio-janz-ttl.c} (100%)
 rename drivers/gpio/{langwell_gpio.c => gpio-langwell.c} (99%)
 rename drivers/gpio/{max7300.c => gpio-max7300.c} (98%)
 rename drivers/gpio/{max7301.c => gpio-max7301.c} (98%)
 rename drivers/gpio/{max730x.c => gpio-max730x.c} (99%)
 rename drivers/gpio/{max732x.c => gpio-max732x.c} (99%)
 rename drivers/gpio/{mc33880.c => gpio-mc33880.c} (98%)
 rename drivers/gpio/{mcp23s08.c => gpio-mcp23s08.c} (99%)
 rename drivers/gpio/{ml_ioh_gpio.c => gpio-ml-ioh.c} (100%)
 rename drivers/gpio/{pca953x.c => gpio-pca953x.c} (99%)
 rename drivers/gpio/{pcf857x.c => gpio-pcf857x.c} (99%)
 rename drivers/gpio/{pch_gpio.c => gpio-pch.c} (100%)
 rename drivers/gpio/{pl061.c => gpio-pl061.c} (99%)
 rename drivers/gpio/{rdc321x-gpio.c => gpio-rdc321x.c} (100%)
 rename drivers/gpio/{sch_gpio.c => gpio-sch.c} (99%)
 rename drivers/gpio/{stmpe-gpio.c => gpio-stmpe.c} (100%)
 rename drivers/gpio/{sx150x.c => gpio-sx150x.c} (100%)
 rename drivers/gpio/{tc3589x-gpio.c => gpio-tc3589x.c} (100%)
 rename drivers/gpio/{timbgpio.c => gpio-timberdale.c} (99%)
 rename drivers/gpio/{tps65910-gpio.c => gpio-tps65910.c} (98%)
 rename drivers/gpio/{twl4030-gpio.c => gpio-twl4030.c} (99%)
 rename drivers/gpio/{ucb1400_gpio.c => gpio-ucb1400.c} (100%)
 rename drivers/gpio/{vr41xx_giu.c => gpio-vr41xx.c} (100%)
 rename drivers/gpio/{vx855_gpio.c => gpio-vx855.c} (100%)
 rename drivers/gpio/{wm831x-gpio.c => gpio-wm831x.c} (99%)
 rename drivers/gpio/{wm8350-gpiolib.c => gpio-wm8350.c} (98%)
 rename drivers/gpio/{wm8994-gpio.c => gpio-wm8994.c} (99%)
 rename drivers/gpio/{xilinx_gpio.c => gpio-xilinx.c} (100%)

 drivers/gpio/Kconfig                               |   32 ++------
 drivers/gpio/Makefile                              |   81 ++++++++++----------
 drivers/gpio/{74x164.c => gpio-74x164.c}           |    0
 drivers/gpio/{ab8500-gpio.c => gpio-ab8500.c}      |    0
 drivers/gpio/{adp5520-gpio.c => gpio-adp5520.c}    |    0
 drivers/gpio/{adp5588-gpio.c => gpio-adp5588.c}    |    0
 drivers/gpio/{bt8xxgpio.c => gpio-bt8xx.c}         |    0
 drivers/gpio/{cs5535-gpio.c => gpio-cs5535.c}      |    0
 drivers/gpio/gpio-ep93xx.c                         |    2 -
 drivers/gpio/gpio-exynos4.c                        |    5 +-
 drivers/gpio/{basic_mmio_gpio.c => gpio-generic.c} |    6 +-
 drivers/gpio/{it8761e_gpio.c => gpio-it8761e.c}    |    2 +-
 drivers/gpio/{janz-ttl.c => gpio-janz-ttl.c}       |    0
 drivers/gpio/{langwell_gpio.c => gpio-langwell.c}  |    4 +-
 drivers/gpio/{max7300.c => gpio-max7300.c}         |    2 -
 drivers/gpio/{max7301.c => gpio-max7301.c}         |    2 -
 drivers/gpio/{max730x.c => gpio-max730x.c}         |    2 -
 drivers/gpio/{max732x.c => gpio-max732x.c}         |    2 +-
 drivers/gpio/{mc33880.c => gpio-mc33880.c}         |    2 +-
 drivers/gpio/{mcp23s08.c => gpio-mcp23s08.c}       |    2 +-
 drivers/gpio/{ml_ioh_gpio.c => gpio-ml-ioh.c}      |    0
 drivers/gpio/{pca953x.c => gpio-pca953x.c}         |    2 +-
 drivers/gpio/{pcf857x.c => gpio-pcf857x.c}         |    2 +-
 drivers/gpio/{pch_gpio.c => gpio-pch.c}            |    0
 drivers/gpio/{pl061.c => gpio-pl061.c}             |    4 +-
 drivers/gpio/gpio-plat-samsung.c                   |    3 +-
 drivers/gpio/{rdc321x-gpio.c => gpio-rdc321x.c}    |    0
 drivers/gpio/gpio-s5pc100.c                        |    5 +-
 drivers/gpio/gpio-s5pv210.c                        |    5 +-
 drivers/gpio/{sch_gpio.c => gpio-sch.c}            |    2 +-
 drivers/gpio/{stmpe-gpio.c => gpio-stmpe.c}        |    0
 drivers/gpio/{sx150x.c => gpio-sx150x.c}           |    0
 drivers/gpio/{tc3589x-gpio.c => gpio-tc3589x.c}    |    0
 drivers/gpio/{timbgpio.c => gpio-timberdale.c}     |    2 +-
 drivers/gpio/{tps65910-gpio.c => gpio-tps65910.c}  |    2 +-
 drivers/gpio/{twl4030-gpio.c => gpio-twl4030.c}    |    2 +-
 drivers/gpio/gpio-u300.c                           |    5 +-
 drivers/gpio/{ucb1400_gpio.c => gpio-ucb1400.c}    |    0
 drivers/gpio/{vr41xx_giu.c => gpio-vr41xx.c}       |    0
 drivers/gpio/{vx855_gpio.c => gpio-vx855.c}        |    0
 drivers/gpio/{wm831x-gpio.c => gpio-wm831x.c}      |    2 +-
 drivers/gpio/{wm8350-gpiolib.c => gpio-wm8350.c}   |    2 +-
 drivers/gpio/{wm8994-gpio.c => gpio-wm8994.c}      |    2 +-
 drivers/gpio/{xilinx_gpio.c => gpio-xilinx.c}      |    0
 44 files changed, 78 insertions(+), 106 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index afe44aa..a7fcc83 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -63,6 +63,9 @@ config GPIO_SYSFS
 	  Kernel drivers may also request that a particular GPIO be
 	  exported to userspace; this can be useful when debugging.
 
+config GPIO_GENERIC
+	tristate
+
 # put drivers in the right section, in alphabetical order
 
 config GPIO_MAX730X
@@ -70,16 +73,11 @@ config GPIO_MAX730X
 
 comment "Memory mapped GPIO drivers:"
 
-config GPIO_BASIC_MMIO_CORE
-	tristate
-	help
-	  Provides core functionality for basic memory-mapped GPIO controllers.
-
-config GPIO_BASIC_MMIO
-	tristate "Basic memory-mapped GPIO controllers support"
-	select GPIO_BASIC_MMIO_CORE
+config GPIO_GENERIC_PLATFORM
+	tristate "Generic memory-mapped GPIO controller support (MMIO platform device)"
+	select GPIO_GENERIC
 	help
-	  Say yes here to support basic memory-mapped GPIO controllers.
+	  Say yes here to support basic platform_device memory-mapped GPIO controllers.
 
 config GPIO_IT8761E
 	tristate "IT8761E GPIO support"
@@ -145,9 +143,6 @@ config GPIO_SCH
 	  The Intel Tunnel Creek processor has 5 GPIOs powered by the
 	  core power rail and 9 from suspend power supply.
 
-	  This driver can also be built as a module. If so, the module
-	  will be called sch-gpio.
-
 config GPIO_VX855
 	tristate "VIA VX855/VX875 GPIO"
 	depends on MFD_SUPPORT && PCI
@@ -210,9 +205,6 @@ config GPIO_PCA953X
 
 	  16 bits:	pca9535, pca9539, pca9555, tca6416
 
-	  This driver can also be built as a module.  If so, the module
-	  will be called pca953x.
-
 config GPIO_PCA953X_IRQ
 	bool "Interrupt controller support for PCA953x"
 	depends on GPIO_PCA953X=y
@@ -304,17 +296,12 @@ config GPIO_ADP5520
 	  This option enables support for on-chip GPIO found
 	  on Analog Devices ADP5520 PMICs.
 
-	  To compile this driver as a module, choose M here: the module will
-	  be called adp5520-gpio.
-
 config GPIO_ADP5588
 	tristate "ADP5588 I2C GPIO expander"
 	depends on I2C
 	help
 	  This option enables support for 18 GPIOs found
 	  on Analog Devices ADP5588 GPIO Expanders.
-	  To compile this driver as a module, choose M here: the module will be
-	  called adp5588-gpio.
 
 config GPIO_ADP5588_IRQ
 	bool "Interrupt controller support for ADP5588"
@@ -436,9 +423,6 @@ config GPIO_UCB1400
 	  This enables support for the Philips UCB1400 GPIO pins.
 	  The UCB1400 is an AC97 audio codec.
 
-	  To compile this driver as a module, choose M here: the
-	  module will be called ucb1400_gpio.
-
 comment "MODULbus GPIO expanders:"
 
 config GPIO_JANZ_TTL
@@ -449,7 +433,7 @@ config GPIO_JANZ_TTL
 	  This driver provides support for driving the pins in output
 	  mode only. Input mode is not supported.
 
-config AB8500_GPIO
+config GPIO_AB8500
 	bool "ST-Ericsson AB8500 Mixed Signal Circuit gpio functions"
 	depends on AB8500_CORE && BROKEN
 	help
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 8733d02..8109ae6 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -4,49 +4,52 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
 obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 
-obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
-obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
-obj-$(CONFIG_GPIO_BASIC_MMIO_CORE)	+= basic_mmio_gpio.o
-obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
+# Device drivers. Generally keep list sorted alphabetically
+obj-$(CONFIG_GPIO_GENERIC)	+= gpio-generic.o
+
+obj-$(CONFIG_GPIO_74X164)	+= gpio-74x164.o
+obj-$(CONFIG_GPIO_AB8500)	+= gpio-ab8500.o
+obj-$(CONFIG_GPIO_ADP5520)	+= gpio-adp5520.o
+obj-$(CONFIG_GPIO_ADP5588)	+= gpio-adp5588.o
+obj-$(CONFIG_GPIO_BT8XX)	+= gpio-bt8xx.o
+obj-$(CONFIG_GPIO_CS5535)	+= gpio-cs5535.o
 obj-$(CONFIG_GPIO_EP93XX)	+= gpio-ep93xx.o
 obj-$(CONFIG_GPIO_EXYNOS4)	+= gpio-exynos4.o
+obj-$(CONFIG_GPIO_IT8761E)	+= gpio-it8761e.o
+obj-$(CONFIG_GPIO_JANZ_TTL)	+= gpio-janz-ttl.o
+obj-$(CONFIG_GPIO_LANGWELL)	+= gpio-langwell.o
+obj-$(CONFIG_GPIO_MAX730X)	+= gpio-max730x.o
+obj-$(CONFIG_GPIO_MAX7300)	+= gpio-max7300.o
+obj-$(CONFIG_GPIO_MAX7301)	+= gpio-max7301.o
+obj-$(CONFIG_GPIO_MAX732X)	+= gpio-max732x.o
+obj-$(CONFIG_GPIO_MC33880)	+= gpio-mc33880.o
+obj-$(CONFIG_GPIO_MCP23S08)	+= gpio-mcp23s08.o
+obj-$(CONFIG_GPIO_ML_IOH)	+= gpio-ml-ioh.o
 obj-$(CONFIG_GPIO_MXS)		+= gpio-mxs.o
+obj-$(CONFIG_PLAT_NOMADIK)	+= gpio-nomadik.o
+obj-$(CONFIG_ARCH_OMAP)		+= gpio-omap.o
+obj-$(CONFIG_GPIO_PCA953X)	+= gpio-pca953x.o
+obj-$(CONFIG_GPIO_PCF857X)	+= gpio-pcf857x.o
+obj-$(CONFIG_GPIO_PCH)		+= gpio-pch.o
+obj-$(CONFIG_GPIO_PL061)	+= gpio-pl061.o
+obj-$(CONFIG_GPIO_RDC321X)	+= gpio-rdc321x.o
+
 obj-$(CONFIG_GPIO_PLAT_SAMSUNG)	+= gpio-plat-samsung.o
 obj-$(CONFIG_GPIO_S5PC100)	+= gpio-s5pc100.o
 obj-$(CONFIG_GPIO_S5PV210)	+= gpio-s5pv210.o
-obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
-obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
-obj-$(CONFIG_GPIO_MAX7300)	+= max7300.o
-obj-$(CONFIG_GPIO_MAX7301)	+= max7301.o
-obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
-obj-$(CONFIG_GPIO_MC33880)	+= mc33880.o
-obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
-obj-$(CONFIG_GPIO_74X164)	+= 74x164.o
-obj-$(CONFIG_ARCH_OMAP)         += gpio-omap.o
-obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
-obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
-obj-$(CONFIG_GPIO_PCH)		+= pch_gpio.o
-obj-$(CONFIG_GPIO_PL061)	+= pl061.o
-obj-$(CONFIG_GPIO_STMPE)	+= stmpe-gpio.o
-obj-$(CONFIG_GPIO_TC3589X)	+= tc3589x-gpio.o
-obj-$(CONFIG_GPIO_TIMBERDALE)	+= timbgpio.o
-obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
-obj-$(CONFIG_GPIO_UCB1400)	+= ucb1400_gpio.o
-obj-$(CONFIG_GPIO_XILINX)	+= xilinx_gpio.o
-obj-$(CONFIG_GPIO_CS5535)	+= cs5535-gpio.o
-obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
-obj-$(CONFIG_GPIO_IT8761E)	+= it8761e_gpio.o
-obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.o
-obj-$(CONFIG_GPIO_WM831X)	+= wm831x-gpio.o
-obj-$(CONFIG_GPIO_WM8350)	+= wm8350-gpiolib.o
-obj-$(CONFIG_GPIO_WM8994)	+= wm8994-gpio.o
-obj-$(CONFIG_GPIO_SCH)		+= sch_gpio.o
+
+obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
+obj-$(CONFIG_GPIO_STMPE)	+= gpio-stmpe.o
+obj-$(CONFIG_GPIO_SX150X)	+= gpio-sx150x.o
+obj-$(CONFIG_GPIO_TC3589X)	+= gpio-tc3589x.o
+obj-$(CONFIG_GPIO_TIMBERDALE)	+= gpio-timberdale.o
+obj-$(CONFIG_GPIO_TPS65910)	+= gpio-tps65910.o
+obj-$(CONFIG_GPIO_TWL4030)	+= gpio-twl4030.o
 obj-$(CONFIG_MACH_U300)		+= gpio-u300.o
-obj-$(CONFIG_PLAT_NOMADIK)	+= gpio-nomadik.o
-obj-$(CONFIG_GPIO_RDC321X)	+= rdc321x-gpio.o
-obj-$(CONFIG_GPIO_JANZ_TTL)	+= janz-ttl.o
-obj-$(CONFIG_GPIO_SX150X)	+= sx150x.o
-obj-$(CONFIG_GPIO_VX855)	+= vx855_gpio.o
-obj-$(CONFIG_GPIO_ML_IOH)	+= ml_ioh_gpio.o
-obj-$(CONFIG_AB8500_GPIO)       += ab8500-gpio.o
-obj-$(CONFIG_GPIO_TPS65910)	+= tps65910-gpio.o
+obj-$(CONFIG_GPIO_UCB1400)	+= gpio-ucb1400.o
+obj-$(CONFIG_GPIO_VR41XX)	+= gpio-vr41xx.o
+obj-$(CONFIG_GPIO_VX855)	+= gpio-vx855.o
+obj-$(CONFIG_GPIO_WM831X)	+= gpio-wm831x.o
+obj-$(CONFIG_GPIO_WM8350)	+= gpio-wm8350.o
+obj-$(CONFIG_GPIO_WM8994)	+= gpio-wm8994.o
+obj-$(CONFIG_GPIO_XILINX)	+= gpio-xilinx.o
diff --git a/drivers/gpio/74x164.c b/drivers/gpio/gpio-74x164.c
similarity index 100%
rename from drivers/gpio/74x164.c
rename to drivers/gpio/gpio-74x164.c
diff --git a/drivers/gpio/ab8500-gpio.c b/drivers/gpio/gpio-ab8500.c
similarity index 100%
rename from drivers/gpio/ab8500-gpio.c
rename to drivers/gpio/gpio-ab8500.c
diff --git a/drivers/gpio/adp5520-gpio.c b/drivers/gpio/gpio-adp5520.c
similarity index 100%
rename from drivers/gpio/adp5520-gpio.c
rename to drivers/gpio/gpio-adp5520.c
diff --git a/drivers/gpio/adp5588-gpio.c b/drivers/gpio/gpio-adp5588.c
similarity index 100%
rename from drivers/gpio/adp5588-gpio.c
rename to drivers/gpio/gpio-adp5588.c
diff --git a/drivers/gpio/bt8xxgpio.c b/drivers/gpio/gpio-bt8xx.c
similarity index 100%
rename from drivers/gpio/bt8xxgpio.c
rename to drivers/gpio/gpio-bt8xx.c
diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/gpio-cs5535.c
similarity index 100%
rename from drivers/gpio/cs5535-gpio.c
rename to drivers/gpio/gpio-cs5535.c
diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
index 415dce3..c33c9a8 100644
--- a/drivers/gpio/gpio-ep93xx.c
+++ b/drivers/gpio/gpio-ep93xx.c
@@ -1,6 +1,4 @@
 /*
- * linux/arch/arm/mach-ep93xx/gpio.c
- *
  * Generic EP93xx GPIO handling
  *
  * Copyright (c) 2008 Ryan Mallon <ryan@bluewatersys.com>
diff --git a/drivers/gpio/gpio-exynos4.c b/drivers/gpio/gpio-exynos4.c
index d54ca6a..6093a14 100644
--- a/drivers/gpio/gpio-exynos4.c
+++ b/drivers/gpio/gpio-exynos4.c
@@ -1,10 +1,9 @@
-/* linux/arch/arm/mach-exynos4/gpiolib.c
+/*
+ * EXYNOS4 - GPIOlib support
  *
  * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
- * EXYNOS4 - GPIOlib support
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/gpio-generic.c
similarity index 99%
rename from drivers/gpio/basic_mmio_gpio.c
rename to drivers/gpio/gpio-generic.c
index 8152e9f..231714d 100644
--- a/drivers/gpio/basic_mmio_gpio.c
+++ b/drivers/gpio/gpio-generic.c
@@ -1,5 +1,5 @@
 /*
- * Driver for basic memory-mapped GPIO controllers.
+ * Generic driver for memory-mapped GPIO controllers.
  *
  * Copyright 2008 MontaVista Software, Inc.
  * Copyright 2008,2010 Anton Vorontsov <cbouatmailru@gmail.com>
@@ -404,7 +404,7 @@ int __devinit bgpio_init(struct bgpio_chip *bgc,
 }
 EXPORT_SYMBOL_GPL(bgpio_init);
 
-#ifdef CONFIG_GPIO_BASIC_MMIO
+#ifdef CONFIG_GPIO_GENERIC_PLATFORM
 
 static void __iomem *bgpio_map(struct platform_device *pdev,
 			       const char *name,
@@ -541,7 +541,7 @@ static void __exit bgpio_platform_exit(void)
 }
 module_exit(bgpio_platform_exit);
 
-#endif /* CONFIG_GPIO_BASIC_MMIO */
+#endif /* CONFIG_GPIO_GENERIC_PLATFORM */
 
 MODULE_DESCRIPTION("Driver for basic memory-mapped GPIO controllers");
 MODULE_AUTHOR("Anton Vorontsov <cbouatmailru@gmail.com>");
diff --git a/drivers/gpio/it8761e_gpio.c b/drivers/gpio/gpio-it8761e.c
similarity index 98%
rename from drivers/gpio/it8761e_gpio.c
rename to drivers/gpio/gpio-it8761e.c
index 48fc43c..278b813 100644
--- a/drivers/gpio/it8761e_gpio.c
+++ b/drivers/gpio/gpio-it8761e.c
@@ -1,5 +1,5 @@
 /*
- *  it8761_gpio.c - GPIO interface for IT8761E Super I/O chip
+ *  GPIO interface for IT8761E Super I/O chip
  *
  *  Author: Denis Turischev <denis@compulab.co.il>
  *
diff --git a/drivers/gpio/janz-ttl.c b/drivers/gpio/gpio-janz-ttl.c
similarity index 100%
rename from drivers/gpio/janz-ttl.c
rename to drivers/gpio/gpio-janz-ttl.c
diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/gpio-langwell.c
similarity index 99%
rename from drivers/gpio/langwell_gpio.c
rename to drivers/gpio/gpio-langwell.c
index bd6571e..e7a7ea7 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -1,4 +1,6 @@
-/* langwell_gpio.c Moorestown platform Langwell chip GPIO driver
+/*
+ * Moorestown platform Langwell chip GPIO driver
+ *
  * Copyright (c) 2008 - 2009,  Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/gpio/max7300.c b/drivers/gpio/gpio-max7300.c
similarity index 98%
rename from drivers/gpio/max7300.c
rename to drivers/gpio/gpio-max7300.c
index 962f661..a5ca0ab 100644
--- a/drivers/gpio/max7300.c
+++ b/drivers/gpio/gpio-max7300.c
@@ -1,6 +1,4 @@
 /*
- * drivers/gpio/max7300.c
- *
  * Copyright (C) 2009 Wolfram Sang, Pengutronix
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/gpio/max7301.c b/drivers/gpio/gpio-max7301.c
similarity index 98%
rename from drivers/gpio/max7301.c
rename to drivers/gpio/gpio-max7301.c
index 92a100d..741acfc 100644
--- a/drivers/gpio/max7301.c
+++ b/drivers/gpio/gpio-max7301.c
@@ -1,6 +1,4 @@
 /*
- * drivers/gpio/max7301.c
- *
  * Copyright (C) 2006 Juergen Beisert, Pengutronix
  * Copyright (C) 2008 Guennadi Liakhovetski, Pengutronix
  * Copyright (C) 2009 Wolfram Sang, Pengutronix
diff --git a/drivers/gpio/max730x.c b/drivers/gpio/gpio-max730x.c
similarity index 99%
rename from drivers/gpio/max730x.c
rename to drivers/gpio/gpio-max730x.c
index 94ce773..05e2dac 100644
--- a/drivers/gpio/max730x.c
+++ b/drivers/gpio/gpio-max730x.c
@@ -1,6 +1,4 @@
 /**
- * drivers/gpio/max7301.c
- *
  * Copyright (C) 2006 Juergen Beisert, Pengutronix
  * Copyright (C) 2008 Guennadi Liakhovetski, Pengutronix
  * Copyright (C) 2009 Wolfram Sang, Pengutronix
diff --git a/drivers/gpio/max732x.c b/drivers/gpio/gpio-max732x.c
similarity index 99%
rename from drivers/gpio/max732x.c
rename to drivers/gpio/gpio-max732x.c
index ad6951e..9504120 100644
--- a/drivers/gpio/max732x.c
+++ b/drivers/gpio/gpio-max732x.c
@@ -1,5 +1,5 @@
 /*
- *  max732x.c - I2C Port Expander with 8/16 I/O
+ *  MAX732x I2C Port Expander with 8/16 I/O
  *
  *  Copyright (C) 2007 Marvell International Ltd.
  *  Copyright (C) 2008 Jack Ren <jack.ren@marvell.com>
diff --git a/drivers/gpio/mc33880.c b/drivers/gpio/gpio-mc33880.c
similarity index 98%
rename from drivers/gpio/mc33880.c
rename to drivers/gpio/gpio-mc33880.c
index 4ec7975..b3b4652 100644
--- a/drivers/gpio/mc33880.c
+++ b/drivers/gpio/gpio-mc33880.c
@@ -1,5 +1,5 @@
 /*
- * mc33880.c MC33880 high-side/low-side switch GPIO driver
+ * MC33880 high-side/low-side switch GPIO driver
  * Copyright (c) 2009 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/gpio/mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
similarity index 99%
rename from drivers/gpio/mcp23s08.c
rename to drivers/gpio/gpio-mcp23s08.c
index 40e0760..0083ec0 100644
--- a/drivers/gpio/mcp23s08.c
+++ b/drivers/gpio/gpio-mcp23s08.c
@@ -1,5 +1,5 @@
 /*
- * mcp23s08.c - SPI gpio expander driver
+ * MCP23S08 SPI gpio expander driver
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/gpio/ml_ioh_gpio.c b/drivers/gpio/gpio-ml-ioh.c
similarity index 100%
rename from drivers/gpio/ml_ioh_gpio.c
rename to drivers/gpio/gpio-ml-ioh.c
diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/gpio-pca953x.c
similarity index 99%
rename from drivers/gpio/pca953x.c
rename to drivers/gpio/gpio-pca953x.c
index 63022b1..a610864 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1,5 +1,5 @@
 /*
- *  pca953x.c - 4/8/16 bit I/O ports
+ *  PCA953x 4/8/16 bit I/O ports
  *
  *  Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
  *  Copyright (C) 2007 Marvell International Ltd.
diff --git a/drivers/gpio/pcf857x.c b/drivers/gpio/gpio-pcf857x.c
similarity index 99%
rename from drivers/gpio/pcf857x.c
rename to drivers/gpio/gpio-pcf857x.c
index 879b473..7369fdd 100644
--- a/drivers/gpio/pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -1,5 +1,5 @@
 /*
- * pcf857x - driver for pcf857x, pca857x, and pca967x I2C GPIO expanders
+ * Driver for pcf857x, pca857x, and pca967x I2C GPIO expanders
  *
  * Copyright (C) 2007 David Brownell
  *
diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/gpio-pch.c
similarity index 100%
rename from drivers/gpio/pch_gpio.c
rename to drivers/gpio/gpio-pch.c
diff --git a/drivers/gpio/pl061.c b/drivers/gpio/gpio-pl061.c
similarity index 99%
rename from drivers/gpio/pl061.c
rename to drivers/gpio/gpio-pl061.c
index 6fcb28c..2c5a18f 100644
--- a/drivers/gpio/pl061.c
+++ b/drivers/gpio/gpio-pl061.c
@@ -1,7 +1,5 @@
 /*
- *  linux/drivers/gpio/pl061.c
- *
- *  Copyright (C) 2008, 2009 Provigent Ltd.
+ * Copyright (C) 2008, 2009 Provigent Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/gpio/gpio-plat-samsung.c b/drivers/gpio/gpio-plat-samsung.c
index ea37c04..ef67f19 100644
--- a/drivers/gpio/gpio-plat-samsung.c
+++ b/drivers/gpio/gpio-plat-samsung.c
@@ -1,5 +1,4 @@
-/* arch/arm/plat-samsung/gpiolib.c
- *
+/*
  * Copyright 2008 Openmoko, Inc.
  * Copyright 2008 Simtec Electronics
  *      Ben Dooks <ben@simtec.co.uk>
diff --git a/drivers/gpio/rdc321x-gpio.c b/drivers/gpio/gpio-rdc321x.c
similarity index 100%
rename from drivers/gpio/rdc321x-gpio.c
rename to drivers/gpio/gpio-rdc321x.c
diff --git a/drivers/gpio/gpio-s5pc100.c b/drivers/gpio/gpio-s5pc100.c
index 2842394..7f87b0c 100644
--- a/drivers/gpio/gpio-s5pc100.c
+++ b/drivers/gpio/gpio-s5pc100.c
@@ -1,4 +1,5 @@
-/* linux/arch/arm/mach-s5pc100/gpiolib.c
+/*
+ * S5PC100 - GPIOlib support
  *
  * Copyright (c) 2010 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
@@ -6,8 +7,6 @@
  *  Copyright 2009 Samsung Electronics Co
  *  Kyungmin Park <kyungmin.park@samsung.com>
  *
- * S5PC100 - GPIOlib support
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
diff --git a/drivers/gpio/gpio-s5pv210.c b/drivers/gpio/gpio-s5pv210.c
index 1ba20a7..eb12f16 100644
--- a/drivers/gpio/gpio-s5pv210.c
+++ b/drivers/gpio/gpio-s5pv210.c
@@ -1,10 +1,9 @@
-/* linux/arch/arm/mach-s5pv210/gpiolib.c
+/*
+ * S5PV210 - GPIOlib support
  *
  * Copyright (c) 2010 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
  *
- * S5PV210 - GPIOlib support
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
diff --git a/drivers/gpio/sch_gpio.c b/drivers/gpio/gpio-sch.c
similarity index 99%
rename from drivers/gpio/sch_gpio.c
rename to drivers/gpio/gpio-sch.c
index 5606042..1635158 100644
--- a/drivers/gpio/sch_gpio.c
+++ b/drivers/gpio/gpio-sch.c
@@ -1,5 +1,5 @@
 /*
- *  sch_gpio.c - GPIO interface for Intel Poulsbo SCH
+ * GPIO interface for Intel Poulsbo SCH
  *
  *  Copyright (c) 2010 CompuLab Ltd
  *  Author: Denis Turischev <denis@compulab.co.il>
diff --git a/drivers/gpio/stmpe-gpio.c b/drivers/gpio/gpio-stmpe.c
similarity index 100%
rename from drivers/gpio/stmpe-gpio.c
rename to drivers/gpio/gpio-stmpe.c
diff --git a/drivers/gpio/sx150x.c b/drivers/gpio/gpio-sx150x.c
similarity index 100%
rename from drivers/gpio/sx150x.c
rename to drivers/gpio/gpio-sx150x.c
diff --git a/drivers/gpio/tc3589x-gpio.c b/drivers/gpio/gpio-tc3589x.c
similarity index 100%
rename from drivers/gpio/tc3589x-gpio.c
rename to drivers/gpio/gpio-tc3589x.c
diff --git a/drivers/gpio/timbgpio.c b/drivers/gpio/gpio-timberdale.c
similarity index 99%
rename from drivers/gpio/timbgpio.c
rename to drivers/gpio/gpio-timberdale.c
index 0265872..c593bd4 100644
--- a/drivers/gpio/timbgpio.c
+++ b/drivers/gpio/gpio-timberdale.c
@@ -1,5 +1,5 @@
 /*
- * timbgpio.c timberdale FPGA GPIO driver
+ * Timberdale FPGA GPIO driver
  * Copyright (c) 2009 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/gpio/tps65910-gpio.c b/drivers/gpio/gpio-tps65910.c
similarity index 98%
rename from drivers/gpio/tps65910-gpio.c
rename to drivers/gpio/gpio-tps65910.c
index 8d1ddfd..4171033 100644
--- a/drivers/gpio/tps65910-gpio.c
+++ b/drivers/gpio/gpio-tps65910.c
@@ -1,5 +1,5 @@
 /*
- * tps65910-gpio.c  --  TI TPS6591x
+ * TI TPS6591x GPIO driver
  *
  * Copyright 2010 Texas Instruments Inc.
  *
diff --git a/drivers/gpio/twl4030-gpio.c b/drivers/gpio/gpio-twl4030.c
similarity index 99%
rename from drivers/gpio/twl4030-gpio.c
rename to drivers/gpio/gpio-twl4030.c
index 57635ac..b8b4f22 100644
--- a/drivers/gpio/twl4030-gpio.c
+++ b/drivers/gpio/gpio-twl4030.c
@@ -1,5 +1,5 @@
 /*
- * twl4030_gpio.c -- access to GPIOs on TWL4030/TPS659x0 chips
+ * Access to GPIOs on TWL4030/TPS659x0 chips
  *
  * Copyright (C) 2006-2007 Texas Instruments, Inc.
  * Copyright (C) 2006 MontaVista Software, Inc.
diff --git a/drivers/gpio/gpio-u300.c b/drivers/gpio/gpio-u300.c
index d927901..fd2dfee 100644
--- a/drivers/gpio/gpio-u300.c
+++ b/drivers/gpio/gpio-u300.c
@@ -1,11 +1,8 @@
 /*
- *
- * arch/arm/mach-u300/gpio.c
- *
+ * U300 GPIO module.
  *
  * Copyright (C) 2007-2009 ST-Ericsson AB
  * License terms: GNU General Public License (GPL) version 2
- * U300 GPIO module.
  * This can driver either of the two basic GPIO cores
  * available in the U300 platforms:
  * COH 901 335   - Used in DB3150 (U300 1.0) and DB3200 (U330 1.0)
diff --git a/drivers/gpio/ucb1400_gpio.c b/drivers/gpio/gpio-ucb1400.c
similarity index 100%
rename from drivers/gpio/ucb1400_gpio.c
rename to drivers/gpio/gpio-ucb1400.c
diff --git a/drivers/gpio/vr41xx_giu.c b/drivers/gpio/gpio-vr41xx.c
similarity index 100%
rename from drivers/gpio/vr41xx_giu.c
rename to drivers/gpio/gpio-vr41xx.c
diff --git a/drivers/gpio/vx855_gpio.c b/drivers/gpio/gpio-vx855.c
similarity index 100%
rename from drivers/gpio/vx855_gpio.c
rename to drivers/gpio/gpio-vx855.c
diff --git a/drivers/gpio/wm831x-gpio.c b/drivers/gpio/gpio-wm831x.c
similarity index 99%
rename from drivers/gpio/wm831x-gpio.c
rename to drivers/gpio/gpio-wm831x.c
index 309644c..31a9ed7 100644
--- a/drivers/gpio/wm831x-gpio.c
+++ b/drivers/gpio/gpio-wm831x.c
@@ -1,5 +1,5 @@
 /*
- * wm831x-gpio.c  --  gpiolib support for Wolfson WM831x PMICs
+ * gpiolib support for Wolfson WM831x PMICs
  *
  * Copyright 2009 Wolfson Microelectronics PLC.
  *
diff --git a/drivers/gpio/wm8350-gpiolib.c b/drivers/gpio/gpio-wm8350.c
similarity index 98%
rename from drivers/gpio/wm8350-gpiolib.c
rename to drivers/gpio/gpio-wm8350.c
index 3599992..a06af51 100644
--- a/drivers/gpio/wm8350-gpiolib.c
+++ b/drivers/gpio/gpio-wm8350.c
@@ -1,5 +1,5 @@
 /*
- * wm835x-gpiolib.c  --  gpiolib support for Wolfson WM835x PMICs
+ * gpiolib support for Wolfson WM835x PMICs
  *
  * Copyright 2009 Wolfson Microelectronics PLC.
  *
diff --git a/drivers/gpio/wm8994-gpio.c b/drivers/gpio/gpio-wm8994.c
similarity index 99%
rename from drivers/gpio/wm8994-gpio.c
rename to drivers/gpio/gpio-wm8994.c
index c822baa..96198f3 100644
--- a/drivers/gpio/wm8994-gpio.c
+++ b/drivers/gpio/gpio-wm8994.c
@@ -1,5 +1,5 @@
 /*
- * wm8994-gpio.c  --  gpiolib support for Wolfson WM8994
+ * gpiolib support for Wolfson WM8994
  *
  * Copyright 2009 Wolfson Microelectronics PLC.
  *
diff --git a/drivers/gpio/xilinx_gpio.c b/drivers/gpio/gpio-xilinx.c
similarity index 100%
rename from drivers/gpio/xilinx_gpio.c
rename to drivers/gpio/gpio-xilinx.c

