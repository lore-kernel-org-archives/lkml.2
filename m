Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab1IBOoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 10:44:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62309 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab1IBOoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 10:44:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jean Delvare <khali@linux-fr.org>
Subject: [PATCH 1/2] misc: remove CONFIG_MISC_DEVICES
Date: Fri, 2 Sep 2011 16:43:14 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Luciano Coelho <coelho@ti.com>, Randy Dunlap <rdunlap@xenotime.net>,
        matti.j.aaltonen@nokia.com, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net> <201108311849.37273.arnd@arndb.de> <20110902143713.307bbebe@endymion.delvare>
In-Reply-To: <20110902143713.307bbebe@endymion.delvare>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109021643.14275.arnd@arndb.de>
X-Provags-ID: V02:K0:/KWQPXwpR+vWSxeEqM3cEu2dFYQsfK3hzh1osBsekDs
 pGTEmr61tD8VWyZQeJcM+tJMefqdQCTXf/Xro9tYewxZhgCwpL
 dzg372C+q27kFrYL31xNEiJNrQFVD7txl2SYvxM1RGjFw1tALD
 6jQzBzkK1RwtaPZwztxZpHzoyo0WpFmlX9oLwzCt8a2/3EL3yP
 cVKPdBcoP2VjDjnS60AiRmszoJh8kaGKsN9Ci7pe/Qa5BmZSA4
 vNPjM0VDuD+4OxqJ+Yexs+iU/0qbjLG9nlABm4zbq1iQ0EtsBN
 l5YVk80SxFS3o2RG72lD0SK9zjZN6JbbMnP+0ba7NdVVfCmxng
 IqrGI7E1n3kfXLnCimvM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since misc devices have nothing in common besides fitting in no
other category, there is no need to group them in one Kconfig
symbol. Simply removing the symbol gets rid of all sorts of
Kconfig warnings about missing dependencies when another driver
selects a misc driver without also selecting MISC_DEVICES.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-davinci/Kconfig |    6 ------
 arch/unicore32/Kconfig        |    1 -
 drivers/misc/Kconfig          |   26 ++++++++------------------
 drivers/mmc/host/Kconfig      |    1 -
 4 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index c0deaca..3755cec 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -61,7 +61,6 @@ config MACH_DAVINCI_EVM
 	bool "TI DM644x EVM"
 	default ARCH_DAVINCI_DM644x
 	depends on ARCH_DAVINCI_DM644x
-	select MISC_DEVICES
 	select EEPROM_AT24
 	select I2C
 	help
@@ -71,7 +70,6 @@ config MACH_DAVINCI_EVM
 config MACH_SFFSDR
 	bool "Lyrtech SFFSDR"
 	depends on ARCH_DAVINCI_DM644x
-	select MISC_DEVICES
 	select EEPROM_AT24
 	select I2C
 	help
@@ -105,7 +103,6 @@ config MACH_DAVINCI_DM6467_EVM
 	default ARCH_DAVINCI_DM646x
 	depends on ARCH_DAVINCI_DM646x
 	select MACH_DAVINCI_DM6467TEVM
-	select MISC_DEVICES
 	select EEPROM_AT24
 	select I2C
 	help
@@ -119,7 +116,6 @@ config MACH_DAVINCI_DM365_EVM
 	bool "TI DM365 EVM"
 	default ARCH_DAVINCI_DM365
 	depends on ARCH_DAVINCI_DM365
-	select MISC_DEVICES
 	select EEPROM_AT24
 	select I2C
 	help
@@ -131,7 +127,6 @@ config MACH_DAVINCI_DA830_EVM
 	default ARCH_DAVINCI_DA830
 	depends on ARCH_DAVINCI_DA830
 	select GPIO_PCF857X
-	select MISC_DEVICES
 	select EEPROM_AT24
 	select I2C
 	help
@@ -208,7 +203,6 @@ config MACH_TNETV107X
 config MACH_MITYOMAPL138
 	bool "Critical Link MityDSP-L138/MityARM-1808 SoM"
 	depends on ARCH_DAVINCI_DA850
-	select MISC_DEVICES
 	select EEPROM_AT24
 	select I2C
 	help
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index e57dcce..5fb023a 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -244,7 +244,6 @@ config I2C_BATTERY_BQ27200
 config I2C_EEPROM_AT24
 	tristate "I2C EEPROMs AT24 support"
 	select PUV3_I2C
-	select MISC_DEVICES
 	select EEPROM_AT24
 
 config LCD_BACKLIGHT
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 2d6423c..c11e5ba 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -2,23 +2,7 @@
 # Misc strange devices
 #
 
-# This one has to live outside of the MISC_DEVICES conditional,
-# because it may be selected by drivers/platform/x86/hp_accel.
-config SENSORS_LIS3LV02D
-	tristate
-	depends on INPUT
-	select INPUT_POLLDEV
-	default n
-
-menuconfig MISC_DEVICES
-	bool "Misc devices"
-	---help---
-	  Say Y here to get to see options for device drivers from various
-	  different categories. This option alone does not add any kernel code.
-
-	  If you say N, all options in this submenu will be skipped and disabled.
-
-if MISC_DEVICES
+menu "Misc devices"
 
 config AD525X_DPOT
 	tristate "Analog Devices Digital Potentiometers"
@@ -344,6 +328,12 @@ config ISL29020
 	  This driver can also be built as a module.  If so, the module
 	  will be called isl29020.
 
+config SENSORS_LIS3LV02D
+	tristate
+	depends on INPUT
+	select INPUT_POLLDEV
+	default n
+
 config SENSORS_TSL2550
 	tristate "Taos TSL2550 ambient light sensor"
 	depends on I2C && SYSFS
@@ -507,4 +497,4 @@ source "drivers/misc/ti-st/Kconfig"
 source "drivers/misc/lis3lv02d/Kconfig"
 source "drivers/misc/carma/Kconfig"
 
-endif # MISC_DEVICES
+endmenu
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 8c87096..4fb03d4 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -477,7 +477,6 @@ config MMC_SDHI
 config MMC_CB710
 	tristate "ENE CB710 MMC/SD Interface support"
 	depends on PCI
-	select MISC_DEVICES
 	select CB710_CORE
 	help
 	  This option enables support for MMC/SD part of ENE CB710/720 Flash
-- 
1.7.1

