Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab3AGFFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:05:03 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38938 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab3AGFEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:04:55 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, <nsekhar@ti.com>,
        <hvaibhav@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH v2 06/10] video: da8xx-fb: store clk rate even if !CPUFREQ
Date: Mon, 7 Jan 2013 10:35:37 +0530
Message-ID: <619b7f8d9cbdd7e6f89fdbcb94bc4ce91d269fdd.1357303978.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1357303978.git.afzal@ti.com>
References: <cover.1357303978.git.afzal@ti.com>
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
 drivers/video/da8xx-fb.c |    4 +---
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
1.7.9.5

