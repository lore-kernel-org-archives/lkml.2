Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2LGLoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 06:44:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53486 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080Ab2LGLoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 06:44:05 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Vaibhav Hiremath <hvaibhav@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Afzal Mohammed <afzal@ti.com>
Subject: [PATCH 05/10] video: da8xx-fb: store current display information
Date: Fri, 7 Dec 2012 17:14:01 +0530
Message-ID: <5080c99f685171d40aa8c05464b80f837c694383.1354874432.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1354874432.git.afzal@ti.com>
References: <cover.1354874432.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

store current videomode and controller data so that reconfiguring can
be done easily. Reconfiguring would be required in fb_set_par, which
is going to be added soon.

If these details are not stored, the work probe does to retrieve these
information would have to repeated at the place of reconfiguring and
modifying platform data would be necessary to handle controller data
changes like bpp.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 79862ff..072074d 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -182,6 +182,8 @@ struct da8xx_fb_par {
 #endif
 	void (*panel_power_ctrl)(int);
 	u32 pseudo_palette[16];
+	struct fb_videomode	mode;
+	struct lcd_ctrl_config	cfg;
 };
 
 static struct fb_var_screeninfo da8xx_fb_var;
@@ -1314,6 +1316,8 @@ static int __devinit fb_probe(struct platform_device *device)
 	}
 
 	fb_videomode_to_var(&da8xx_fb_var, lcdc_info);
+	fb_var_to_videomode(&par->mode, &da8xx_fb_var);
+	par->cfg = *lcd_cfg;
 
 	if (lcd_init(par, lcd_cfg, lcdc_info) < 0) {
 		dev_err(&device->dev, "lcd_init failed\n");
-- 
1.7.12

