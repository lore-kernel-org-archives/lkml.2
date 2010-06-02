Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab0FBLjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 07:39:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62452 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab0FBLiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 07:38:54 -0400
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, Tony Lindgren <tony@atomide.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 09/11] OMAP2: Devkit8000: Using gpio_is_valid macro
Date: Wed,  2 Jun 2010 13:37:49 +0200
Message-Id: <1275478671-24563-10-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275478671-24563-1-git-send-email-weber@corscience.de>
References: <1275478671-24563-1-git-send-email-weber@corscience.de>
X-Provags-ID: V01U2FsdGVkX18bT/z/WCfke4Ag7n4M2fTV9Z0EiQcCHnXrLZk
 v75Ex96pqorg5QchuHqqRGRxTTTjyeS26knasNhkob9MFYa2qJ
 q0y10a7ulCKApgDTmGptg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the macro gpio_is_valid for check of valid gpio pins.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 arch/arm/mach-omap2/board-devkit8000.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 3da88c8..dbd16de 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -134,27 +134,27 @@ static int devkit8000_panel_enable_lcd(struct omap_dss_device *dssdev)
 	twl_i2c_write_u8(TWL4030_MODULE_GPIO, 0x80, REG_GPIODATADIR1);
 	twl_i2c_write_u8(TWL4030_MODULE_LED, 0x0, 0x0);
 
-	if (dssdev->reset_gpio != -EINVAL)
+	if (gpio_is_valid(dssdev->reset_gpio))
 		gpio_set_value(dssdev->reset_gpio, 1);
 	return 0;
 }
 
 static void devkit8000_panel_disable_lcd(struct omap_dss_device *dssdev)
 {
-	if (dssdev->reset_gpio != -EINVAL)
+	if (gpio_is_valid(dssdev->reset_gpio))
 		gpio_set_value(dssdev->reset_gpio, 0);
 }
 
 static int devkit8000_panel_enable_dvi(struct omap_dss_device *dssdev)
 {
-	if (dssdev->reset_gpio != -EINVAL)
+	if (gpio_is_valid(dssdev->reset_gpio))
 		gpio_set_value(dssdev->reset_gpio, 1);
 	return 0;
 }
 
 static void devkit8000_panel_disable_dvi(struct omap_dss_device *dssdev)
 {
-	if (dssdev->reset_gpio != -EINVAL)
+	if (gpio_is_valid(dssdev->reset_gpio))
 		gpio_set_value(dssdev->reset_gpio, 0);
 }
 
-- 
1.7.1

