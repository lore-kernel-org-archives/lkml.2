Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720Ab0LUKXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 05:23:09 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:33332 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933556Ab0LUKXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 05:23:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=xglAEWujNA97otDtq28VLZ/uRSUBxyzvGzhzmPOwcTJIUt4Dpf5Q1pDmt0j9xGHjZD
         t0t1hj5akUpXUI0YOe8L9niPTZva1i7uPXU8dRef3WbsI4LrldiZhtQ68w3tJ4yv6DcQ
         J8AW/+4BhlBIEjaCMEjiclqz09bTLJy2yzydw=
Subject: [PATCH v2] OMAP2: Devkit8000: Use _cansleep GPIO functions for
 display reset lines
From: Daniel Morsing <daniel.morsing@gmail.com>
To: tony@atomide.com
Cc: daniel.morsing@gmail.com, weber@corscience.de, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 11:23:13 +0100
Message-ID: <1292926993.9611.10.camel@morsing>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The display reset lines are connected to a TPS65930 which may sleep
when changing GPIO values. Use the appropriate function to silence
a nasty warning from gpiolib.

Signed-off-by: Daniel Morsing <daniel.morsing@gmail.com>
Acked-by: Thomas Weber <weber@corscience.de>
---

Gmail destroyed the previous patch send, so resending with a sane client.

---
 arch/arm/mach-omap2/board-devkit8000.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 53ac762..f1f58f5 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -118,27 +118,27 @@ static int devkit8000_panel_enable_lcd(struct omap_dss_device *dssdev)
 	twl_i2c_write_u8(TWL4030_MODULE_LED, 0x0, 0x0);
 
 	if (gpio_is_valid(dssdev->reset_gpio))
-		gpio_set_value(dssdev->reset_gpio, 1);
+		gpio_set_value_cansleep(dssdev->reset_gpio, 1);
 	return 0;
 }
 
 static void devkit8000_panel_disable_lcd(struct omap_dss_device *dssdev)
 {
 	if (gpio_is_valid(dssdev->reset_gpio))
-		gpio_set_value(dssdev->reset_gpio, 0);
+		gpio_set_value_cansleep(dssdev->reset_gpio, 0);
 }
 
 static int devkit8000_panel_enable_dvi(struct omap_dss_device *dssdev)
 {
 	if (gpio_is_valid(dssdev->reset_gpio))
-		gpio_set_value(dssdev->reset_gpio, 1);
+		gpio_set_value_cansleep(dssdev->reset_gpio, 1);
 	return 0;
 }
 
 static void devkit8000_panel_disable_dvi(struct omap_dss_device *dssdev)
 {
 	if (gpio_is_valid(dssdev->reset_gpio))
-		gpio_set_value(dssdev->reset_gpio, 0);
+		gpio_set_value_cansleep(dssdev->reset_gpio, 0);
 }
 
 static struct regulator_consumer_supply devkit8000_vmmc1_supply =
-- 
1.7.3.3




