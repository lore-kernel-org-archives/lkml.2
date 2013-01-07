Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab3AGFEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:04:50 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38921 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3AGFEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:04:45 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, <nsekhar@ti.com>,
        <hvaibhav@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH v2 05/10] video: da8xx-fb: store current display information
Date: Mon, 7 Jan 2013 10:35:24 +0530
Message-ID: <9ebbc3ce648ee1afa72d52e0dacfcbae28272eb9.1357303978.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1357303978.git.afzal@ti.com>
References: <cover.1357303978.git.afzal@ti.com>
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
 drivers/video/da8xx-fb.c |    4 ++++
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
1.7.9.5

