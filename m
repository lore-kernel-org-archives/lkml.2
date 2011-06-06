Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab1FFXBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 19:01:07 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:14107 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab1FFXBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:01:06 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-131.messagelabs.com!1307401264!26853572!1
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.99]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] leds: simplify Kconfig depends on
Date: Mon, 6 Jun 2011 16:00:41 -0700
User-Agent: KMail/1.9.9
CC: <rpurdie@rpsys.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106061600.42229.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the led drivers and triggers depend on LEDS_CLASS. Remove
all the "depends on LEDS_CLASS" by wrapping everything with
"if LEDS_CLASS/endif".

There are a couple leds drivers that did not specify depends
on LEDS_CLASS but according to the code and the defconfigs
it is required.

LEDS_COBALT_RAQ is also safe to wrap in the if/endif because
LEDS_CLASS is a bool.

Also, remove all the "depends on LEDS_TRIGGERS" by wrapping all
the triggers with "if LEDS_TRIGGERS/endif".

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Richard Purdie <rpurdie@linux.intel.com>

---

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 23f0d5e..fd428e4 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -21,13 +21,12 @@ config LEDS_GPIO_REGISTER
 	  As this function is used by arch code it must not be compiled as a
 	  module.
 
-if NEW_LEDS
+if LEDS_CLASS
 
 comment "LED drivers"
 
 config LEDS_88PM860X
 	tristate "LED Support for Marvell 88PM860x PMIC"
-	depends on LEDS_CLASS
 	depends on MFD_88PM860X
 	help
 	  This option enables support for on-chip LED drivers found on Marvell
@@ -35,7 +34,6 @@ config LEDS_88PM860X
 
 config LEDS_ATMEL_PWM
 	tristate "LED Support using Atmel PWM outputs"
-	depends on LEDS_CLASS
 	depends on ATMEL_PWM
 	help
 	  This option enables support for LEDs driven using outputs
@@ -43,7 +41,6 @@ config LEDS_ATMEL_PWM
 
 config LEDS_LM3530
 	tristate "LCD Backlight driver for LM3530"
-	depends on LEDS_CLASS
 	depends on I2C
 	help
 	  This option enables support for the LCD backlight using
@@ -53,7 +50,6 @@ config LEDS_LM3530
 
 config LEDS_LOCOMO
 	tristate "LED Support for Locomo device"
-	depends on LEDS_CLASS
 	depends on SHARP_LOCOMO
 	help
 	  This option enables support for the LEDs on Sharp Locomo.
@@ -61,7 +57,6 @@ config LEDS_LOCOMO
 
 config LEDS_MIKROTIK_RB532
 	tristate "LED Support for Mikrotik Routerboard 532"
-	depends on LEDS_CLASS
 	depends on MIKROTIK_RB532
 	help
 	  This option enables support for the so called "User LED" of
@@ -69,7 +64,6 @@ config LEDS_MIKROTIK_RB532
 
 config LEDS_S3C24XX
 	tristate "LED Support for Samsung S3C24XX GPIO LEDs"
-	depends on LEDS_CLASS
 	depends on ARCH_S3C2410
 	help
 	  This option enables support for LEDs connected to GPIO lines
@@ -77,14 +71,12 @@ config LEDS_S3C24XX
 
 config LEDS_AMS_DELTA
 	tristate "LED Support for the Amstrad Delta (E3)"
-	depends on LEDS_CLASS
 	depends on MACH_AMS_DELTA
 	help
 	  This option enables support for the LEDs on Amstrad Delta (E3).
 
 config LEDS_NET48XX
 	tristate "LED Support for Soekris net48xx series Error LED"
-	depends on LEDS_CLASS
 	depends on SCx200_GPIO
 	help
 	  This option enables support for the Soekris net4801 and net4826 error
@@ -102,21 +94,18 @@ config LEDS_NET5501
 
 config LEDS_FSG
 	tristate "LED Support for the Freecom FSG-3"
-	depends on LEDS_CLASS
 	depends on MACH_FSG
 	help
 	  This option enables support for the LEDs on the Freecom FSG-3.
 
 config LEDS_WRAP
 	tristate "LED Support for the WRAP series LEDs"
-	depends on LEDS_CLASS
 	depends on SCx200_GPIO
 	help
 	  This option enables support for the PCEngines WRAP programmable LEDs.
 
 config LEDS_ALIX2
 	tristate "LED Support for ALIX.2 and ALIX.3 series"
-	depends on LEDS_CLASS
 	depends on X86 && !GPIO_CS5535 && !CS5535_GPIO
 	help
 	  This option enables support for the PCEngines ALIX.2 and ALIX.3 LEDs.
@@ -124,21 +113,19 @@ config LEDS_ALIX2
 
 config LEDS_COBALT_QUBE
 	tristate "LED Support for the Cobalt Qube series front LED"
-	depends on LEDS_CLASS
 	depends on MIPS_COBALT
 	help
 	  This option enables support for the front LED on Cobalt Qube series
 
 config LEDS_COBALT_RAQ
 	bool "LED Support for the Cobalt Raq series"
-	depends on LEDS_CLASS=y && MIPS_COBALT
+	depends on MIPS_COBALT
 	select LEDS_TRIGGERS
 	help
 	  This option enables support for the Cobalt Raq series LEDs.
 
 config LEDS_SUNFIRE
 	tristate "LED support for SunFire servers."
-	depends on LEDS_CLASS
 	depends on SPARC64
 	select LEDS_TRIGGERS
 	help
@@ -147,7 +134,6 @@ config LEDS_SUNFIRE
 
 config LEDS_HP6XX
 	tristate "LED Support for the HP Jornada 6xx"
-	depends on LEDS_CLASS
 	depends on SH_HP6XX
 	help
 	  This option enables LED support for the handheld
@@ -155,7 +141,6 @@ config LEDS_HP6XX
 
 config LEDS_PCA9532
 	tristate "LED driver for PCA9532 dimmer"
-	depends on LEDS_CLASS
 	depends on I2C && INPUT && EXPERIMENTAL
 	help
 	  This option enables support for NXP pca9532
@@ -174,7 +159,6 @@ config LEDS_PCA9532_GPIO
 
 config LEDS_GPIO
 	tristate "LED Support for GPIO connected LEDs"
-	depends on LEDS_CLASS
 	depends on GENERIC_GPIO
 	help
 	  This option enables support for the LEDs connected to GPIO
@@ -202,7 +186,6 @@ config LEDS_GPIO_OF
 
 config LEDS_LP3944
 	tristate "LED Support for N.S. LP3944 (Fun Light) I2C chip"
-	depends on LEDS_CLASS
 	depends on I2C
 	help
 	  This option enables support for LEDs connected to the National
@@ -214,7 +197,7 @@ config LEDS_LP3944
 
 config LEDS_LP5521
 	tristate "LED Support for N.S. LP5521 LED driver chip"
-	depends on LEDS_CLASS && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for the National Semiconductor
 	  LP5521 LED driver. It is 3 channel chip with programmable engines.
@@ -223,7 +206,7 @@ config LEDS_LP5521
 
 config LEDS_LP5523
 	tristate "LED Support for N.S. LP5523 LED driver chip"
-	depends on LEDS_CLASS && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for the National Semiconductor
 	  LP5523 LED driver. It is 9 channel chip with programmable engines.
@@ -232,7 +215,6 @@ config LEDS_LP5523
 
 config LEDS_CLEVO_MAIL
 	tristate "Mail LED on Clevo notebook"
-	depends on LEDS_CLASS
 	depends on X86 && SERIO_I8042 && DMI
 	help
 	  This driver makes the mail LED accessible from userspace
@@ -263,7 +245,6 @@ config LEDS_CLEVO_MAIL
 
 config LEDS_PCA955X
 	tristate "LED Support for PCA955x I2C chips"
-	depends on LEDS_CLASS
 	depends on I2C
 	help
 	  This option enables support for LEDs connected to PCA955x
@@ -272,7 +253,6 @@ config LEDS_PCA955X
 
 config LEDS_WM831X_STATUS
 	tristate "LED support for status LEDs on WM831x PMICs"
-	depends on LEDS_CLASS
 	depends on MFD_WM831X
 	help
 	  This option enables support for the status LEDs of the WM831x
@@ -280,7 +260,6 @@ config LEDS_WM831X_STATUS
 
 config LEDS_WM8350
 	tristate "LED Support for WM8350 AudioPlus PMIC"
-	depends on LEDS_CLASS
 	depends on MFD_WM8350
 	help
 	  This option enables support for LEDs driven by the Wolfson
@@ -288,7 +267,6 @@ config LEDS_WM8350
 
 config LEDS_DA903X
 	tristate "LED Support for DA9030/DA9034 PMIC"
-	depends on LEDS_CLASS
 	depends on PMIC_DA903X
 	help
 	  This option enables support for on-chip LED drivers found
@@ -296,7 +274,6 @@ config LEDS_DA903X
 
 config LEDS_DAC124S085
 	tristate "LED Support for DAC124S085 SPI DAC"
-	depends on LEDS_CLASS
 	depends on SPI
 	help
 	  This option enables support for DAC124S085 SPI DAC from NatSemi,
@@ -304,21 +281,18 @@ config LEDS_DAC124S085
 
 config LEDS_PWM
 	tristate "PWM driven LED Support"
-	depends on LEDS_CLASS
 	depends on HAVE_PWM
 	help
 	  This option enables support for pwm driven LEDs
 
 config LEDS_REGULATOR
 	tristate "REGULATOR driven LED support"
-	depends on LEDS_CLASS
 	depends on REGULATOR
 	help
 	  This option enables support for regulator driven LEDs.
 
 config LEDS_BD2802
 	tristate "LED driver for BD2802 RGB LED"
-	depends on LEDS_CLASS
 	depends on I2C
 	help
 	  This option enables support for BD2802GU RGB LED driver chips
@@ -326,7 +300,6 @@ config LEDS_BD2802
 
 config LEDS_INTEL_SS4200
 	tristate "LED driver for Intel NAS SS4200 series"
-	depends on LEDS_CLASS
 	depends on PCI && DMI
 	help
 	  This option enables support for the Intel SS4200 series of
@@ -336,7 +309,6 @@ config LEDS_INTEL_SS4200
 
 config LEDS_LT3593
 	tristate "LED driver for LT3593 controllers"
-	depends on LEDS_CLASS
 	depends on GENERIC_GPIO
 	help
 	  This option enables support for LEDs driven by a Linear Technology
@@ -345,7 +317,6 @@ config LEDS_LT3593
 
 config LEDS_ADP5520
 	tristate "LED Support for ADP5520/ADP5501 PMIC"
-	depends on LEDS_CLASS
 	depends on PMIC_ADP5520
 	help
 	  This option enables support for on-chip LED drivers found
@@ -356,7 +327,6 @@ config LEDS_ADP5520
 
 config LEDS_DELL_NETBOOKS
 	tristate "External LED on Dell Business Netbooks"
-	depends on LEDS_CLASS
 	depends on X86 && ACPI_WMI
 	help
 	  This adds support for the Latitude 2100 and similar
@@ -364,7 +334,6 @@ config LEDS_DELL_NETBOOKS
 
 config LEDS_MC13783
 	tristate "LED Support for MC13783 PMIC"
-	depends on LEDS_CLASS
 	depends on MFD_MC13783
 	help
 	  This option enable support for on-chip LED drivers found
@@ -372,7 +341,6 @@ config LEDS_MC13783
 
 config LEDS_NS2
 	tristate "LED support for Network Space v2 GPIO LEDs"
-	depends on LEDS_CLASS
 	depends on MACH_NETSPACE_V2 || MACH_INETSPACE_V2 || MACH_NETSPACE_MAX_V2 || D2NET_V2
 	default y
 	help
@@ -401,17 +369,17 @@ config LEDS_ASIC3
 
 config LEDS_TRIGGERS
 	bool "LED Trigger support"
-	depends on LEDS_CLASS
 	help
 	  This option enables trigger support for the leds class.
 	  These triggers allow kernel events to drive the LEDs and can
 	  be configured via sysfs. If unsure, say Y.
 
+if LEDS_TRIGGERS
+
 comment "LED Triggers"
 
 config LEDS_TRIGGER_TIMER
 	tristate "LED Timer Trigger"
-	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be controlled by a programmable timer
 	  via sysfs. Some LED hardware can be programmed to start
@@ -423,14 +391,12 @@ config LEDS_TRIGGER_TIMER
 config LEDS_TRIGGER_IDE_DISK
 	bool "LED IDE Disk Trigger"
 	depends on IDE_GD_ATA
-	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be controlled by IDE disk activity.
 	  If unsure, say Y.
 
 config LEDS_TRIGGER_HEARTBEAT
 	tristate "LED Heartbeat Trigger"
-	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be controlled by a CPU load average.
 	  The flash frequency is a hyperbolic function of the 1-minute
@@ -439,7 +405,6 @@ config LEDS_TRIGGER_HEARTBEAT
 
 config LEDS_TRIGGER_BACKLIGHT
 	tristate "LED backlight Trigger"
-	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be controlled as a backlight device: they
 	  turn off and on when the display is blanked and unblanked.
@@ -448,7 +413,6 @@ config LEDS_TRIGGER_BACKLIGHT
 
 config LEDS_TRIGGER_GPIO
 	tristate "LED GPIO Trigger"
-	depends on LEDS_TRIGGERS
 	depends on GPIOLIB
 	help
 	  This allows LEDs to be controlled by gpio events. It's good
@@ -461,12 +425,12 @@ config LEDS_TRIGGER_GPIO
 
 config LEDS_TRIGGER_DEFAULT_ON
 	tristate "LED Default ON Trigger"
-	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be initialised in the ON state.
 	  If unsure, say Y.
 
 comment "iptables trigger is under Netfilter config (LED target)"
-	depends on LEDS_TRIGGERS
 
-endif # NEW_LEDS
+endif # LEDS_TRIGGERS
+
+endif # LEDS_CLASS
