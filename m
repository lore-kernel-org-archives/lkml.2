Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab3AGFGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:06:04 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40466 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab3AGFFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:05:17 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, <nsekhar@ti.com>,
        <hvaibhav@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH v2 09/10] video: da8xx-fb: report correct pixclock
Date: Mon, 7 Jan 2013 10:36:03 +0530
Message-ID: <87e8130658ff6fb27afce873b32c44543583cc73.1357303978.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1357303978.git.afzal@ti.com>
References: <cover.1357303978.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update "var" pixclock with the value that is configurable in hardware.
This lets user know the actual pixclock.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 663b3c5..c7393f1 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -690,6 +690,15 @@ static inline unsigned da8xx_fb_calc_clk_divider(struct da8xx_fb_par *par,
 	return par->lcd_fck_rate / (PICOS2KHZ(pixclock) * 1000);
 }
 
+static inline unsigned da8xx_fb_round_clk(struct da8xx_fb_par *par,
+					  unsigned pixclock)
+{
+	unsigned div;
+
+	div = da8xx_fb_calc_clk_divider(par, pixclock);
+	return KHZ2PICOS(par->lcd_fck_rate / (1000 * div));
+}
+
 static inline void da8xx_fb_config_clk_divider(unsigned div)
 {
 	/* Configure the LCD clock divisor. */
@@ -966,6 +975,8 @@ static int fb_check_var(struct fb_var_screeninfo *var,
 	if (var->yres + var->yoffset > var->yres_virtual)
 		var->yoffset = var->yres_virtual - var->yres;
 
+	var->pixclock = da8xx_fb_round_clk(par, var->pixclock);
+
 	return err;
 }
 
-- 
1.7.9.5

