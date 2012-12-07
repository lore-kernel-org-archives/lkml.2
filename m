Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab2LGLoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 06:44:34 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42688 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080Ab2LGLoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 06:44:30 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Vaibhav Hiremath <hvaibhav@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Afzal Mohammed <afzal@ti.com>
Subject: [PATCH 09/10] video: da8xx-fb: report correct pixclock
Date: Fri, 7 Dec 2012 17:14:25 +0530
Message-ID: <1936484ebde94f0c18462f2eec2dab05da087b27.1354874432.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1354874432.git.afzal@ti.com>
References: <cover.1354874432.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update "var" pixclock with the value that is configurable in hardware.
This lets user know the actual pixclock.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c | 11 +++++++++++
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
1.7.12

