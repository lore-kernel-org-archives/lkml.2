Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1JBOst (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:48:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53124 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab1JBOq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:46:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 03/30] video/omap: fix build dependencies
Date: Sun,  2 Oct 2011 16:45:33 +0200
Message-Id: <1317566760-25681-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Il1vYsTYtsGxAPG6OF7gJKNFKebOiSl6fjGHF1XQsy1
 Aces/X9R06nyEiI3DOIWKvQxHsPS40bc2Rug7zaCEd05J6yfC+
 MHLbmCsN/i0jot2gwVDWC+wwT5OPremjcvW8A/hENsSOrm7TYS
 IYCxfrH0jEQIaq7rJACTWALlAxs1jPQPA9VVI/bLnm66qUDLK8
 VwYJdBlRT54v5ReNVlOiQkgmZeHWxszkyQTPueGf+10dLEgQZh
 BJDlC+WIcA2JDe7H8tAXwL/7Z1la0YdPyImDnrF2zIYaaEjOTo
 rp0EPxW9J9B3oxoL1c+UdFJjh5amVIqViraq9FENKuJs6GGiRH
 umk4Hb03EOIdqaVyjCxwrfuVricQSqMAsTA5PL0YR3aCH1jnVP
 3/CzyggIw3/GA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Four of the LCD panel drivers depend on the backlight class,
so add the dependency in Kconfig.
Selecting the BACKLIGHT_CLASS_DEVICE symbol does not generally
work since it has other dependencies.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/video/omap2/displays/Kconfig |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/video/omap2/displays/Kconfig b/drivers/video/omap2/displays/Kconfig
index 609a280..8e4278c 100644
--- a/drivers/video/omap2/displays/Kconfig
+++ b/drivers/video/omap2/displays/Kconfig
@@ -19,13 +19,15 @@ config PANEL_LGPHILIPS_LB035Q02
 config PANEL_SHARP_LS037V7DW01
         tristate "Sharp LS037V7DW01 LCD Panel"
         depends on OMAP2_DSS_DPI
-        select BACKLIGHT_CLASS_DEVICE
+        depends on BACKLIGHT_CLASS_DEVICE
         help
           LCD Panel used in TI's SDP3430 and EVM boards
 
 config PANEL_NEC_NL8048HL11_01B
 	tristate "NEC NL8048HL11-01B Panel"
 	depends on OMAP2_DSS_DPI
+	depends on SPI
+	depends on BACKLIGHT_CLASS_DEVICE
 	help
 		This NEC NL8048HL11-01B panel is TFT LCD
 		used in the Zoom2/3/3630 sdp boards.
@@ -33,6 +35,7 @@ config PANEL_NEC_NL8048HL11_01B
 config PANEL_TAAL
         tristate "Taal DSI Panel"
         depends on OMAP2_DSS_DSI
+        depends on BACKLIGHT_CLASS_DEVICE
         help
           Taal DSI command mode panel from TPO.
 
@@ -45,7 +48,7 @@ config PANEL_TPO_TD043MTEA1
 config PANEL_ACX565AKM
 	tristate "ACX565AKM Panel"
 	depends on OMAP2_DSS_SDI && SPI
-	select BACKLIGHT_CLASS_DEVICE
+	depends on BACKLIGHT_CLASS_DEVICE
 	help
 	  This is the LCD panel used on Nokia N900
 endmenu
-- 
1.7.5.4

