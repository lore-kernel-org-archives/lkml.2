Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab3AGFFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:05:21 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60479 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab3AGFFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:05:15 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, <nsekhar@ti.com>,
        <hvaibhav@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH v2 08/10] video: da8xx-fb: store struct device *
Date: Mon, 7 Jan 2013 10:35:55 +0530
Message-ID: <f85f1ca720c376f60ee4bbf3dda010b8f8bcabb2.1357303978.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1357303978.git.afzal@ti.com>
References: <cover.1357303978.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

store struct device pointer so that dev_dbg/err can be used outside
of probe.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 19ee560..663b3c5 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -154,6 +154,7 @@ static inline void lcdc_write(unsigned int val, unsigned int addr)
 }
 
 struct da8xx_fb_par {
+	struct device		*dev;
 	resource_size_t p_palette_base;
 	unsigned char *v_palette_base;
 	dma_addr_t		vram_phys;
@@ -1295,6 +1296,7 @@ static int __devinit fb_probe(struct platform_device *device)
 	}
 
 	par = da8xx_fb_info->par;
+	par->dev = &device->dev;
 	par->lcdc_clk = fb_clk;
 	par->lcd_fck_rate = clk_get_rate(fb_clk);
 	if (fb_pdata->panel_power_ctrl) {
-- 
1.7.9.5

