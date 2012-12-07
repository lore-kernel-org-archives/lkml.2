Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab2LGLn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 06:43:56 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43206 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab2LGLnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 06:43:53 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Vaibhav Hiremath <hvaibhav@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Afzal Mohammed <afzal@ti.com>
Subject: [PATCH 03/10] video: da8xx-fb: use modedb helper to update var
Date: Fri, 7 Dec 2012 17:13:48 +0530
Message-ID: <47a912e27138208279c3ecfcd6815b1cc032f484.1354874432.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1354874432.git.afzal@ti.com>
References: <cover.1354874432.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

modedb structure is now used to store panel information, run modedb
helper over it for initial update of "var" information instead of
equating each fields.

While at it, remove redundant update of bits_per_pixel.

Note: pixclock is overridden with proper value using an existing code
as currently modedb is having it in Hz instead of ps, this would be
fixed in a later change and this overide would be removed.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index c8e97de..0c404ed 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -1329,6 +1329,8 @@ static int __devinit fb_probe(struct platform_device *device)
 		par->panel_power_ctrl(1);
 	}
 
+	fb_videomode_to_var(&da8xx_fb_var, lcdc_info);
+
 	if (lcd_init(par, lcd_cfg, lcdc_info) < 0) {
 		dev_err(&device->dev, "lcd_init failed\n");
 		ret = -EFAULT;
@@ -1381,25 +1383,9 @@ static int __devinit fb_probe(struct platform_device *device)
 		goto err_release_pl_mem;
 	}
 
-	/* Initialize par */
-	da8xx_fb_info->var.bits_per_pixel = lcd_cfg->bpp;
-
-	da8xx_fb_var.xres = lcdc_info->xres;
-	da8xx_fb_var.xres_virtual = lcdc_info->xres;
-
-	da8xx_fb_var.yres         = lcdc_info->yres;
-	da8xx_fb_var.yres_virtual = lcdc_info->yres * LCD_NUM_BUFFERS;
-
 	da8xx_fb_var.grayscale =
 	    lcd_cfg->panel_shade == MONOCHROME ? 1 : 0;
 	da8xx_fb_var.bits_per_pixel = lcd_cfg->bpp;
-
-	da8xx_fb_var.hsync_len = lcdc_info->hsync_len;
-	da8xx_fb_var.vsync_len = lcdc_info->vsync_len;
-	da8xx_fb_var.right_margin = lcdc_info->right_margin;
-	da8xx_fb_var.left_margin  = lcdc_info->left_margin;
-	da8xx_fb_var.lower_margin = lcdc_info->lower_margin;
-	da8xx_fb_var.upper_margin = lcdc_info->upper_margin;
 	da8xx_fb_var.pixclock = da8xxfb_pixel_clk_period(par);
 
 	/* Initialize fbinfo */
-- 
1.7.12

