Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab2BMNMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 08:12:40 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60786 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab2BMNMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 08:12:39 -0500
Message-ID: <1329138752.2982.2.camel@phoenix>
Subject: [PATCH] drivers/leds/leds-lm3530.c: Move the code setting
 gen_config to one place
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 13 Feb 2012 21:12:32 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the readability by moving the code setting gen_config to one place.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-lm3530.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index e59c166..af3f8b8 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -158,9 +158,16 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 	gen_config = (pltfm->brt_ramp_law << LM3530_RAMP_LAW_SHIFT) |
 			((pltfm->max_current & 7) << LM3530_MAX_CURR_SHIFT);
 
-	if (drvdata->mode == LM3530_BL_MODE_MANUAL ||
-	    drvdata->mode == LM3530_BL_MODE_ALS)
-		gen_config |= (LM3530_ENABLE_I2C);
+	switch (drvdata->mode) {
+	case LM3530_BL_MODE_MANUAL:
+	case LM3530_BL_MODE_ALS:
+		gen_config |= LM3530_ENABLE_I2C;
+		break;
+	case LM3530_BL_MODE_PWM:
+		gen_config |= LM3530_ENABLE_PWM | LM3530_ENABLE_PWM_SIMPLE |
+			      (pltfm->pwm_pol_hi << LM3530_PWM_POL_SHIFT);
+		break;
+	}
 
 	if (drvdata->mode == LM3530_BL_MODE_ALS) {
 		if (pltfm->als_vmax == 0) {
@@ -194,11 +201,6 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 
 	}
 
-	if (drvdata->mode == LM3530_BL_MODE_PWM)
-		gen_config |= (LM3530_ENABLE_PWM) |
-				(pltfm->pwm_pol_hi << LM3530_PWM_POL_SHIFT) |
-				(LM3530_ENABLE_PWM_SIMPLE);
-
 	brt_ramp = (pltfm->brt_ramp_fall << LM3530_BRT_RAMP_FALL_SHIFT) |
 			(pltfm->brt_ramp_rise << LM3530_BRT_RAMP_RISE_SHIFT);
 
-- 
1.7.5.4



