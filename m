Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab2LGLoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 06:44:15 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53490 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080Ab2LGLoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 06:44:11 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Vaibhav Hiremath <hvaibhav@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Afzal Mohammed <afzal@ti.com>
Subject: [PATCH 06/10] video: da8xx-fb: store clk rate even if !CPUFREQ
Date: Fri, 7 Dec 2012 17:14:07 +0530
Message-ID: <61d844963821c50084bd4dfe789c9dedf7c5ca59.1354874432.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1354874432.git.afzal@ti.com>
References: <cover.1354874432.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

store lcd clk rate always, i.e. irrespective of whether CPUFREQ is
enabled or not. This can be used to get clk rate directly instead of
enquiring with clock framework with clk handle every time.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 072074d..e858438 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -178,8 +178,8 @@ struct da8xx_fb_par {
 	unsigned int		which_dma_channel_done;
 #ifdef CONFIG_CPU_FREQ
 	struct notifier_block	freq_transition;
-	unsigned int		lcd_fck_rate;
 #endif
+	unsigned int		lcd_fck_rate;
 	void (*panel_power_ctrl)(int);
 	u32 pseudo_palette[16];
 	struct fb_videomode	mode;
@@ -1306,9 +1306,7 @@ static int __devinit fb_probe(struct platform_device *device)
 
 	par = da8xx_fb_info->par;
 	par->lcdc_clk = fb_clk;
-#ifdef CONFIG_CPU_FREQ
 	par->lcd_fck_rate = clk_get_rate(fb_clk);
-#endif
 	par->pxl_clk = lcdc_info->pixclock;
 	if (fb_pdata->panel_power_ctrl) {
 		par->panel_power_ctrl = fb_pdata->panel_power_ctrl;
-- 
1.7.12

