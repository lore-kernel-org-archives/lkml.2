Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab2AEUtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 15:49:17 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48405 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab2AEUtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 15:49:15 -0500
From: Fabio Estevam <festevam@gmail.com>
To: netdev@vger.kernel.org
Cc: gwingerde@gmail.com, larry.finger@lwfinger.net, davem@davemloft.net,
        bhutchings@solarflare.com, greg@kroah.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] drivers: misc: Remove MISC_DEVICES config option
Date: Thu,  5 Jan 2012 18:49:01 -0200
Message-Id: <1325796541-11402-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MISC_DEVICES option alone does not select any kernel code and can cause dependency build warnings, such as:

warning: (KS8851 && AX88796_93CX6 && RTL8180 && RTL8187 && ADM8211 && RT2400PCI && RT2500PCI && RT61PCI && RT2800PCI && R8187SE) selects EEPROM_93CX6 which has unmet direct dependencies (MISC_DEVICES)

Remove MISC_DEVICES option so that any dependency on this symbol is avoided.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
This applies against linux-next

 drivers/misc/Kconfig                |   17 +++--------------
 drivers/mmc/host/Kconfig            |    1 -
 drivers/net/ethernet/micrel/Kconfig |    1 -
 3 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 6a1a092..c779509 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -2,24 +2,14 @@
 # Misc strange devices
 #
 
-# This one has to live outside of the MISC_DEVICES conditional,
-# because it may be selected by drivers/platform/x86/hp_accel.
+menu "Misc devices"
+
 config SENSORS_LIS3LV02D
 	tristate
 	depends on INPUT
 	select INPUT_POLLDEV
 	default n
 
-menuconfig MISC_DEVICES
-	bool "Misc devices"
-	---help---
-	  Say Y here to get to see options for device drivers from various
-	  different categories. This option alone does not add any kernel code.
-
-	  If you say N, all options in this submenu will be skipped and disabled.
-
-if MISC_DEVICES
-
 config AD525X_DPOT
 	tristate "Analog Devices Digital Potentiometers"
 	depends on (I2C || SPI) && SYSFS
@@ -516,5 +506,4 @@ source "drivers/misc/ti-st/Kconfig"
 source "drivers/misc/lis3lv02d/Kconfig"
 source "drivers/misc/carma/Kconfig"
 source "drivers/misc/altera-stapl/Kconfig"
-
-endif # MISC_DEVICES
+endmenu
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index cf444b0..00fcbed 100644
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
diff --git a/drivers/net/ethernet/micrel/Kconfig b/drivers/net/ethernet/micrel/Kconfig
index 1ea811c..fe42fc0 100644
--- a/drivers/net/ethernet/micrel/Kconfig
+++ b/drivers/net/ethernet/micrel/Kconfig
@@ -42,7 +42,6 @@ config KS8851
 	select NET_CORE
 	select MII
 	select CRC32
-	select MISC_DEVICES
 	select EEPROM_93CX6
 	---help---
 	  SPI driver for Micrel KS8851 SPI attached network chip.
-- 
1.7.1

