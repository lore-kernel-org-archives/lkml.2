Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab0LUHrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 02:47:52 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:46578 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab0LUHrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 02:47:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Edi8IOJS47TZifuhCFBH1ngrZ03Wy1PSgTaypEWN9HFqhM0rfcFyIX+AOGwNrvW3aa
         jR8sSRlfTH1qJ++JBk9kPDFeJfY+JF8cCHn2Nm+crQF9irxCihtM1O5YbxK542yxjbDD
         rxsCut8iWQZ/MYREi+1e8siL3sNPadSl8xgFI=
MIME-Version: 1.0
Date: Tue, 21 Dec 2010 08:47:49 +0100
Message-ID: <AANLkTi=XEvW3iYLdaR_w+Mi_+Rpan+6QDC2qq8DnG_WH@mail.gmail.com>
Subject: [PATCH] OMAP2: Devkit8000: Use _cansleep GPIO functions for display
 reset lines
From: Daniel Morsing <daniel.morsing@gmail.com>
To: tony@atomide.com
Cc: daniel.morsing@gmail.com, weber@corscience.de, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The display reset lines are connected to a TPS65930 which may sleep
when changing GPIO values. Use the appropriate function to silence
a nasty warning from gpiolib.

Signed-off-by: Daniel Morsing <daniel.morsing@gmail.com>
---
 arch/arm/mach-omap2/board-devkit8000.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c
b/arch/arm/mach-omap2/board-devkit8000.c
index 53ac762..f1f58f5 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -118,27 +118,27 @@ static int devkit8000_panel_enable_lcd(struct
omap_dss_device *dssdev)
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
