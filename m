Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab0HZEs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 00:48:29 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63618 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab0HZEsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 00:48:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=i5MrvKgh/AzzFOHFWOZZT10IYL9O5hdBz2V/LvjpP+x5NBvctpbPYHKmvJyjwMioNQ
         Qz1ITJXtmH31XQHwBxzyINbvjtlB8Np8wElU1Wi4rF/W17Y3PE5nKgWQLHpLOOK7W+XY
         SqF02wTda4obl41CjJ3U/ACj/EP2CVevwUv10=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: marek.vasut@gmail.com, linux-arm-kernel@lists.infradead.org,
        haojian.zhuang@marvell.com, eric.y.miao@gmail.com,
        linux-kernel@vger.kernel.org
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH v3 2/2] pxa168: added initial support for TPO TD043MTEA1 LCD display on Aspenite
Date: Wed, 25 Aug 2010 23:51:55 -0400
Message-Id: <1282794715-28640-3-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282794715-28640-1-git-send-email-mark.brown314@gmail.com>
References: <1282794715-28640-1-git-send-email-mark.brown314@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
---
 arch/arm/mach-mmp/aspenite.c |   60 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mmp/aspenite.c b/arch/arm/mach-mmp/aspenite.c
index 0629394..9e1bd6b 100644
--- a/arch/arm/mach-mmp/aspenite.c
+++ b/arch/arm/mach-mmp/aspenite.c
@@ -23,6 +23,7 @@
 #include <mach/mfp-pxa168.h>
 #include <mach/pxa168.h>
 #include <mach/gpio.h>
+#include <video/pxa168fb.h>
 
 #include "common.h"
 
@@ -66,6 +67,36 @@ static unsigned long common_pin_config[] __initdata = {
 	GPIO115_I2S_BCLK,
 	GPIO116_I2S_RXD,
 	GPIO117_I2S_TXD,
+
+	/* LCD */
+	GPIO56_LCD_FCLK_RD,
+	GPIO57_LCD_LCLK_A0,
+	GPIO58_LCD_PCLK_WR,
+	GPIO59_LCD_DENA_BIAS,
+	GPIO60_LCD_DD0,
+	GPIO61_LCD_DD1,
+	GPIO62_LCD_DD2,
+	GPIO63_LCD_DD3,
+	GPIO64_LCD_DD4,
+	GPIO65_LCD_DD5,
+	GPIO66_LCD_DD6,
+	GPIO67_LCD_DD7,
+	GPIO68_LCD_DD8,
+	GPIO69_LCD_DD9,
+	GPIO70_LCD_DD10,
+	GPIO71_LCD_DD11,
+	GPIO72_LCD_DD12,
+	GPIO73_LCD_DD13,
+	GPIO74_LCD_DD14,
+	GPIO75_LCD_DD15,
+	GPIO76_LCD_DD16,
+	GPIO77_LCD_DD17,
+	GPIO78_LCD_DD18,
+	GPIO79_LCD_DD19,
+	GPIO80_LCD_DD20,
+	GPIO81_LCD_DD21,
+	GPIO82_LCD_DD22,
+	GPIO83_LCD_DD23,
 };
 
 static struct smc91x_platdata smc91x_info = {
@@ -134,6 +165,34 @@ static struct i2c_board_info aspenite_i2c_info[] __initdata = {
 	{ I2C_BOARD_INFO("wm8753", 0x1b), },
 };
 
+static struct fb_videomode video_modes[] = {
+	[0] = {
+		.pixclock	= 30120,
+		.refresh	= 60,
+		.xres		= 800,
+		.yres		= 480,
+		.hsync_len	= 1,
+		.left_margin	= 215,
+		.right_margin	= 40,
+		.vsync_len	= 1,
+		.upper_margin	= 34,
+		.lower_margin	= 10,
+		.sync		= FB_SYNC_VERT_HIGH_ACT | FB_SYNC_HOR_HIGH_ACT,
+	},
+};
+
+struct pxa168fb_mach_info aspenite_lcd_info = {
+	.id			= "Graphic Frame",
+	.modes			= video_modes,
+	.num_modes		= ARRAY_SIZE(video_modes),
+	.pix_fmt		= PIX_FMT_RGB565,
+	.io_pin_allocation_mode = PIN_MODE_DUMB_24,
+	.dumb_mode		= DUMB_MODE_RGB888,
+	.active			= 1,
+	.panel_rbswap		= 0,
+	.invert_pixclock	= 0,
+};
+
 static void __init common_init(void)
 {
 	mfp_config(ARRAY_AND_SIZE(common_pin_config));
@@ -143,6 +202,7 @@ static void __init common_init(void)
 	pxa168_add_twsi(1, NULL, ARRAY_AND_SIZE(aspenite_i2c_info));
 	pxa168_add_ssp(1);
 	pxa168_add_nand(&aspenite_nand_info);
+	pxa168_add_fb(&aspenite_lcd_info);
 
 	/* off-chip devices */
 	platform_device_register(&smc91x_device);
-- 
1.7.0.4

