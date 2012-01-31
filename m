Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab2AaHeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 02:34:25 -0500
Received: from mail2.nsc.com ([12.238.8.132]:55785 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752968Ab2AaHeX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 02:34:23 -0500
X-WSS-ID: 0LYNJP6-0A-MMS-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 30 Jan 2012 23:34:07 -0800
Subject: [PATCH v3 5/6] leds-lm3530: replace pltfm with pdata
Thread-Topic: [PATCH v3 5/6] leds-lm3530: replace pltfm with pdata
Thread-Index: Aczf6rc5hLbR2VBYQHe6ZfQELcCwjA==
Message-ID: <B567DBAB974C0544994013492B949F8E3812DEC935@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 633946F81LS10038293-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use 'pdata' rather than 'pltfm' in lm3530_init_registers().

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/leds/leds-lm3530.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index fdb3988..3bb3c09 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -150,11 +150,11 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 	u8 als_imp_sel = 0;
 	u8 brightness;
 	u8 reg_val[LM3530_REG_MAX];
-	struct lm3530_platform_data *pltfm = drvdata->pdata;
+	struct lm3530_platform_data *pdata = drvdata->pdata;
 	struct i2c_client *client = drvdata->client;
 
-	gen_config = (pltfm->brt_ramp_law << LM3530_RAMP_LAW_SHIFT) |
-			((pltfm->max_current & 7) << LM3530_MAX_CURR_SHIFT);
+	gen_config = (pdata->brt_ramp_law << LM3530_RAMP_LAW_SHIFT) |
+			((pdata->max_current & 7) << LM3530_MAX_CURR_SHIFT);
 
 	if (drvdata->mode == LM3530_BL_MODE_MANUAL ||
 	    drvdata->mode == LM3530_BL_MODE_ALS)
@@ -162,27 +162,27 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 
 	if (drvdata->mode == LM3530_BL_MODE_ALS) {
 		als_config =
-			(pltfm->als_avrg_time << LM3530_ALS_AVG_TIME_SHIFT) |
+			(pdata->als_avrg_time << LM3530_ALS_AVG_TIME_SHIFT) |
 			(LM3530_ENABLE_ALS) |
-			(pltfm->als_input_mode << LM3530_ALS_SEL_SHIFT);
+			(pdata->als_input_mode << LM3530_ALS_SEL_SHIFT);
 
 		als_imp_sel =
-			(pltfm->als1_resistor_sel << LM3530_ALS1_IMP_SHIFT) |
-			(pltfm->als2_resistor_sel << LM3530_ALS2_IMP_SHIFT);
+			(pdata->als1_resistor_sel << LM3530_ALS1_IMP_SHIFT) |
+			(pdata->als2_resistor_sel << LM3530_ALS2_IMP_SHIFT);
 	}
 
 	if (drvdata->mode == LM3530_BL_MODE_PWM)
 		gen_config |= (LM3530_ENABLE_PWM) |
-				(pltfm->pwm_pol_hi << LM3530_PWM_POL_SHIFT) |
+				(pdata->pwm_pol_hi << LM3530_PWM_POL_SHIFT) |
 				(LM3530_ENABLE_PWM_SIMPLE);
 
-	brt_ramp = (pltfm->brt_ramp_fall << LM3530_BRT_RAMP_FALL_SHIFT) |
-			(pltfm->brt_ramp_rise << LM3530_BRT_RAMP_RISE_SHIFT);
+	brt_ramp = (pdata->brt_ramp_fall << LM3530_BRT_RAMP_FALL_SHIFT) |
+			(pdata->brt_ramp_rise << LM3530_BRT_RAMP_RISE_SHIFT);
 
 	if (drvdata->brightness)
 		brightness = drvdata->brightness;
 	else
-		brightness = drvdata->brightness = pltfm->brt_val;
+		brightness = drvdata->brightness = pdata->brt_val;
 
 	reg_val[0] = gen_config;	/* LM3530_GEN_CONFIG */
 	reg_val[1] = als_config;	/* LM3530_ALS_CONFIG */
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated




