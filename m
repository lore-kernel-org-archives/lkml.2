Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab0C3SSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 14:18:11 -0400
Received: from p01c11o149.mxlogic.net ([208.65.144.72]:56307 "EHLO
	p01c11o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab0C3SSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 14:18:03 -0400
X-MXL-Hash: 4bb2405b77a6b0f3-63a92cb70dfd084488a9a94a090250a82910e02d
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: linux kernel <linux-kernel@vger.kernel.org>
CC: Richard Purdie <rpurdie@rpsys.net>
Date: Tue, 30 Mar 2010 13:17:35 -0500
Subject: [PATCH] backlight: Kconfig cleanup
Thread-Topic: [PATCH] backlight: Kconfig cleanup
Thread-Index: AcrQNUXeDKyeinGpTSakjgbVKCntAg==
Message-ID: <0D753D10438DA54287A00B02708426976369153982@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010032501)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.97]
X-AnalysisOut: [v=1.0 c=1 a=VphdPIyG4kEA:10 a=IkcTkHD0fZMA:10 a=qhvANl0gla]
X-AnalysisOut: [z90f+3g7Keqg==:17 a=i00gxMtYAAAA:8 a=-sM3sDvmAAAA:8 a=XndE]
X-AnalysisOut: [7kqvmR9D0FIjeOoA:9 a=khpvO3JWlaxtTJ5vjWwA:7 a=MM9G1QX_lzqX]
X-AnalysisOut: [DIeXm1SJIky8rGMA:4 a=QEXdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=1]
X-AnalysisOut: [30E6OD_8ZAA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o2UIISmE000801

Cleanup the "depends on" logic by wrapping the affected config options in
appropriate if/endif blocks.

Remove all the "default n" since that is the default default.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Richard Purdie <rpurdie@rpsys.net>

---

Rebased to 2.6.34-rc2

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index c025c84..4dfb5f4 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -8,12 +8,13 @@ menuconfig BACKLIGHT_LCD_SUPPORT
 	  Enable this to be able to choose the drivers for controlling the
 	  backlight and the LCD panel on some platforms, for example on PDAs.
 
+if BACKLIGHT_LCD_SUPPORT
+
 #
 # LCD
 #
 config LCD_CLASS_DEVICE
         tristate "Lowlevel LCD controls"
-	depends on BACKLIGHT_LCD_SUPPORT
 	default m
 	help
 	  This framework adds support for low-level control of LCD.
@@ -24,31 +25,32 @@ config LCD_CLASS_DEVICE
 	  To have support for your specific LCD panel you will have to
 	  select the proper drivers which depend on this option.
 
+if LCD_CLASS_DEVICE
+
 config LCD_CORGI
 	tristate "LCD Panel support for SHARP corgi/spitz model"
-	depends on LCD_CLASS_DEVICE && SPI_MASTER && PXA_SHARPSL
+	depends on SPI_MASTER && PXA_SHARPSL
 	help
 	  Say y here to support the LCD panels usually found on SHARP
 	  corgi (C7x0) and spitz (Cxx00) models.
 
 config LCD_L4F00242T03
 	tristate "Epson L4F00242T03 LCD"
-	depends on LCD_CLASS_DEVICE && SPI_MASTER && GENERIC_GPIO
+	depends on SPI_MASTER && GENERIC_GPIO
 	help
 	  SPI driver for Epson L4F00242T03. This provides basic support
 	  for init and powering the LCD up/down through a sysfs interface.
 
 config LCD_LMS283GF05
 	tristate "Samsung LMS283GF05 LCD"
-	depends on LCD_CLASS_DEVICE && SPI_MASTER && GENERIC_GPIO
+	depends on SPI_MASTER && GENERIC_GPIO
 	help
 	  SPI driver for Samsung LMS283GF05. This provides basic support
 	  for powering the LCD up/down through a sysfs interface.
 
 config LCD_LTV350QV
 	tristate "Samsung LTV350QV LCD Panel"
-	depends on LCD_CLASS_DEVICE && SPI_MASTER
-	default n
+	depends on SPI_MASTER
 	help
 	  If you have a Samsung LTV350QV LCD panel, say y to include a
 	  power control driver for it.  The panel starts up in power
@@ -59,60 +61,53 @@ config LCD_LTV350QV
 
 config LCD_ILI9320
 	tristate
-	depends on LCD_CLASS_DEVICE && BACKLIGHT_LCD_SUPPORT
-	default n
 	help
 	  If you have a panel based on the ILI9320 controller chip
 	  then say y to include a power driver for it.
 
 config LCD_TDO24M
 	tristate "Toppoly TDO24M  and TDO35S LCD Panels support"
-	depends on LCD_CLASS_DEVICE && SPI_MASTER
-	default n
+	depends on SPI_MASTER
 	help
 	  If you have a Toppoly TDO24M/TDO35S series LCD panel, say y here to
 	  include the support for it.
 
 config LCD_VGG2432A4
 	tristate "VGG2432A4 LCM device support"
-	depends on BACKLIGHT_LCD_SUPPORT && LCD_CLASS_DEVICE && SPI_MASTER
+	depends on SPI_MASTER
 	select LCD_ILI9320
-	default n
 	help
 	  If you have a VGG2432A4 panel based on the ILI9320 controller chip
 	  then say y to include a power driver for it.
 
 config LCD_PLATFORM
 	tristate "Platform LCD controls"
-	depends on LCD_CLASS_DEVICE
 	help
 	  This driver provides a platform-device registered LCD power
 	  control interface.
 
 config LCD_TOSA
 	tristate "Sharp SL-6000 LCD Driver"
-	depends on LCD_CLASS_DEVICE && SPI
-	depends on MACH_TOSA
-	default n
+	depends on SPI && MACH_TOSA
 	help
 	  If you have an Sharp SL-6000 Zaurus say Y to enable a driver
 	  for its LCD.
 
 config LCD_HP700
 	tristate "HP Jornada 700 series LCD Driver"
-	depends on LCD_CLASS_DEVICE
 	depends on SA1100_JORNADA720_SSP && !PREEMPT
 	default y
 	help
 	  If you have an HP Jornada 700 series handheld (710/720/728)
 	  say Y to enable LCD control driver.
 
+endif # LCD_CLASS_DEVICE
+
 #
 # Backlight
 #
 config BACKLIGHT_CLASS_DEVICE
         tristate "Lowlevel Backlight controls"
-	depends on BACKLIGHT_LCD_SUPPORT
 	default m
 	help
 	  This framework adds support for low-level control of the LCD
@@ -121,9 +116,11 @@ config BACKLIGHT_CLASS_DEVICE
 	  To have support for your specific LCD panel you will have to
 	  select the proper drivers which depend on this option.
 
+if BACKLIGHT_CLASS_DEVICE
+
 config BACKLIGHT_ATMEL_LCDC
 	bool "Atmel LCDC Contrast-as-Backlight control"
-	depends on BACKLIGHT_CLASS_DEVICE && FB_ATMEL
+	depends on FB_ATMEL
 	default y if MACH_SAM9261EK || MACH_SAM9G10EK || MACH_SAM9263EK
 	help
 	  This provides a backlight control internal to the Atmel LCDC
@@ -136,8 +133,7 @@ config BACKLIGHT_ATMEL_LCDC
 
 config BACKLIGHT_ATMEL_PWM
 	tristate "Atmel PWM backlight control"
-	depends on BACKLIGHT_CLASS_DEVICE && ATMEL_PWM
-	default n
+	depends on ATMEL_PWM
 	help
 	  Say Y here if you want to use the PWM peripheral in Atmel AT91 and
 	  AVR32 devices. This driver will need additional platform data to know
@@ -148,7 +144,6 @@ config BACKLIGHT_ATMEL_PWM
 
 config BACKLIGHT_GENERIC
 	tristate "Generic (aka Sharp Corgi) Backlight Driver"
-	depends on BACKLIGHT_CLASS_DEVICE
 	default y
 	help
 	  Say y to enable the generic platform backlight driver previously
@@ -157,7 +152,7 @@ config BACKLIGHT_GENERIC
 
 config BACKLIGHT_LOCOMO
 	tristate "Sharp LOCOMO LCD/Backlight Driver"
-	depends on BACKLIGHT_CLASS_DEVICE && SHARP_LOCOMO
+	depends on SHARP_LOCOMO
 	default y
 	help
 	  If you have a Sharp Zaurus SL-5500 (Collie) or SL-5600 (Poodle) say y to
@@ -165,7 +160,7 @@ config BACKLIGHT_LOCOMO
 
 config BACKLIGHT_OMAP1
 	tristate "OMAP1 PWL-based LCD Backlight"
-	depends on BACKLIGHT_CLASS_DEVICE && ARCH_OMAP1
+	depends on ARCH_OMAP1
 	default y
 	help
 	  This driver controls the LCD backlight level and power for
@@ -174,7 +169,7 @@ config BACKLIGHT_OMAP1
 
 config BACKLIGHT_HP680
 	tristate "HP Jornada 680 Backlight Driver"
-	depends on BACKLIGHT_CLASS_DEVICE && SH_HP6XX
+	depends on SH_HP6XX
 	default y
 	help
 	  If you have a HP Jornada 680, say y to enable the
@@ -182,7 +177,6 @@ config BACKLIGHT_HP680
 
 config BACKLIGHT_HP700
 	tristate "HP Jornada 700 series Backlight Driver"
-	depends on BACKLIGHT_CLASS_DEVICE
 	depends on SA1100_JORNADA720_SSP && !PREEMPT
 	default y
 	help
@@ -191,76 +185,70 @@ config BACKLIGHT_HP700
 
 config BACKLIGHT_PROGEAR
 	tristate "Frontpath ProGear Backlight Driver"
-	depends on BACKLIGHT_CLASS_DEVICE && PCI && X86
-	default n
+	depends on PCI && X86
 	help
 	  If you have a Frontpath ProGear say Y to enable the
 	  backlight driver.
 
 config BACKLIGHT_CARILLO_RANCH
 	tristate "Intel Carillo Ranch Backlight Driver"
-	depends on BACKLIGHT_CLASS_DEVICE && LCD_CLASS_DEVICE && PCI && X86 && FB_LE80578
-	default n
+	depends on LCD_CLASS_DEVICE && PCI && X86 && FB_LE80578
 	help
 	  If you have a Intel LE80578 (Carillo Ranch) say Y to enable the
 	  backlight driver.
 
 config BACKLIGHT_PWM
 	tristate "Generic PWM based Backlight Driver"
-	depends on BACKLIGHT_CLASS_DEVICE && HAVE_PWM
+	depends on HAVE_PWM
 	help
 	  If you have a LCD backlight adjustable by PWM, say Y to enable
 	  this driver.
 
 config BACKLIGHT_DA903X
 	tristate "Backlight Driver for DA9030/DA9034 using WLED"
-	depends on BACKLIGHT_CLASS_DEVICE && PMIC_DA903X
+	depends on PMIC_DA903X
 	help
 	  If you have a LCD backlight connected to the WLED output of DA9030
 	  or DA9034 WLED output, say Y here to enable this driver.
 
 config BACKLIGHT_MAX8925
 	tristate "Backlight driver for MAX8925"
-	depends on BACKLIGHT_CLASS_DEVICE && MFD_MAX8925
+	depends on MFD_MAX8925
 	help
 	  If you have a LCD backlight connected to the WLED output of MAX8925
 	  WLED output, say Y here to enable this driver.
 
 config BACKLIGHT_MBP_NVIDIA
        tristate "MacBook Pro Nvidia Backlight Driver"
-       depends on BACKLIGHT_CLASS_DEVICE && X86
-       default n
+       depends on X86
        help
          If you have an Apple Macbook Pro with Nvidia graphics hardware say Y
 	 to enable a driver for its backlight
 
 config BACKLIGHT_TOSA
 	tristate "Sharp SL-6000 Backlight Driver"
-	depends on BACKLIGHT_CLASS_DEVICE && I2C
-	depends on MACH_TOSA && LCD_TOSA
-	default n
+	depends on I2C && MACH_TOSA && LCD_TOSA
 	help
 	  If you have an Sharp SL-6000 Zaurus say Y to enable a driver
 	  for its backlight
 
 config BACKLIGHT_SAHARA
 	tristate "Tabletkiosk Sahara Touch-iT Backlight Driver"
-	depends on BACKLIGHT_CLASS_DEVICE && X86
-	default n
+	depends on X86
 	help
 	  If you have a Tabletkiosk Sahara Touch-iT, say y to enable the
 	  backlight driver.
 
 config BACKLIGHT_WM831X
 	tristate "WM831x PMIC Backlight Driver"
-	depends on BACKLIGHT_CLASS_DEVICE && MFD_WM831X
+	depends on MFD_WM831X
 	help
 	  If you have a backlight driven by the ISINK and DCDC of a
 	  WM831x PMIC say y to enable the backlight driver for it.
 
 config BACKLIGHT_ADX
 	tristate "Avionic Design Xanthos Backlight Driver"
-	depends on BACKLIGHT_CLASS_DEVICE && ARCH_PXA_ADX
+	depends on ARCH_PXA_ADX
 	default y
 	help
 	  Say Y to enable the backlight driver on Avionic Design Xanthos-based
@@ -268,7 +256,7 @@ config BACKLIGHT_ADX
 
 config BACKLIGHT_ADP5520
 	tristate "Backlight Driver for ADP5520/ADP5501 using WLED"
-	depends on BACKLIGHT_CLASS_DEVICE && PMIC_ADP5520
+	depends on PMIC_ADP5520
 	help
 	  If you have a LCD backlight connected to the BST/BL_SNK output of
 	  ADP5520 or ADP5501, say Y here to enable this driver.
@@ -278,7 +266,10 @@ config BACKLIGHT_ADP5520
 
 config BACKLIGHT_88PM860X
 	tristate "Backlight Driver for 88PM8606 using WLED"
-	depends on BACKLIGHT_CLASS_DEVICE && MFD_88PM860X
+	depends on MFD_88PM860X
 	help
 	  Say Y to enable the backlight driver for Marvell 88PM8606.
 
+endif # BACKLIGHT_CLASS_DEVICE
+
+endif # BACKLIGHT_LCD_SUPPORT
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
