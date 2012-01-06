Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075Ab2AFAI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 19:08:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53709 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab2AFAIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 19:08:25 -0500
Message-ID: <4F063B75.8020207@lwfinger.net>
Date: Thu, 05 Jan 2012 18:08:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Randy Dunlap <rdunlap@xenotime.net>, netdev@vger.kernel.org,
        gwingerde@gmail.com, davem@davemloft.net, bhutchings@solarflare.com,
        greg@kroah.com, arnd@arndb.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] drivers: misc: Remove MISC_DEVICES config option
References: <1325796541-11402-1-git-send-email-festevam@gmail.com> <4F0635FE.6050507@xenotime.net>
In-Reply-To: <4F0635FE.6050507@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio,

Does this patch fix your problem?

Larry

Index: wireless-testing-new/drivers/misc/Kconfig
===================================================================
--- wireless-testing-new.orig/drivers/misc/Kconfig
+++ wireless-testing-new/drivers/misc/Kconfig
@@ -10,6 +10,17 @@ config SENSORS_LIS3LV02D
         select INPUT_POLLDEV
         default n

+# This selection is used by several wireless devices, and placing it outside
+# the MISC_DEVICES conditional allows those drivers to be built no matter
+# the MISC_DEVICES value.
+config EEPROM_93CX6
+       tristate "EEPROM 93CX6 support"
+       help
+         This is a driver for the EEPROM chipsets 93c46 and 93c66.
+         The driver supports both read as well as write commands.
+
+         If unsure, say N.
+
  menuconfig MISC_DEVICES
         bool "Misc devices"
         ---help---
Index: wireless-testing-new/drivers/misc/eeprom/Kconfig
===================================================================
--- wireless-testing-new.orig/drivers/misc/eeprom/Kconfig
+++ wireless-testing-new/drivers/misc/eeprom/Kconfig
@@ -62,14 +62,6 @@ config EEPROM_MAX6875
           will be called max6875.


-config EEPROM_93CX6
-       tristate "EEPROM 93CX6 support"
-       help
-         This is a driver for the EEPROM chipsets 93c46 and 93c66.
-         The driver supports both read as well as write commands.
-
-         If unsure, say N.
-
  config EEPROM_93XX46
         tristate "Microwire EEPROM 93XX46 support"
         depends on SPI && SYSFS


