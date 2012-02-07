Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab2BGFOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 00:14:55 -0500
Received: from mail2.nsc.com ([12.238.8.132]:39239 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751179Ab2BGFOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 00:14:53 -0500
X-WSS-ID: 0LZ0BWP-0A-1K8-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 6 Feb 2012 21:14:42 -0800
Subject: [PATCH v4 4/5] leds-lm3530: remove LM3530_ALS_ZONE_REG code
Thread-Topic: [PATCH v4 4/5] leds-lm3530: remove LM3530_ALS_ZONE_REG
 code
Thread-Index: AczlV2XrXFM88fSgSNWUKlX21jkLdQ==
Message-ID: <B567DBAB974C0544994013492B949F8E3812ED44A9@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 632E6CCE1LS10196167-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LM3530_ALS_ZONE_REG is read-only register.
Writing this register is not necessary.

* patch base version : kernel 3.2.4

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lm3530.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index 8ec7b2b..548eaa5 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -26,7 +26,6 @@
 #define LM3530_GEN_CONFIG		0x10
 #define LM3530_ALS_CONFIG		0x20
 #define LM3530_BRT_RAMP_RATE		0x30
-#define LM3530_ALS_ZONE_REG		0x40
 #define LM3530_ALS_IMP_SELECT		0x41
 #define LM3530_BRT_CTRL_REG		0xA0
 #define LM3530_ALS_ZB0_REG		0x60
@@ -38,7 +37,7 @@
 #define LM3530_ALS_Z2T_REG		0x72
 #define LM3530_ALS_Z3T_REG		0x73
 #define LM3530_ALS_Z4T_REG		0x74
-#define LM3530_REG_MAX			15
+#define LM3530_REG_MAX			14
 
 /* General Control Register */
 #define LM3530_EN_I2C_SHIFT		(0)
@@ -118,7 +117,6 @@ static const u8 lm3530_reg[LM3530_REG_MAX] = {
 	LM3530_GEN_CONFIG,
 	LM3530_ALS_CONFIG,
 	LM3530_BRT_RAMP_RATE,
-	LM3530_ALS_ZONE_REG,
 	LM3530_ALS_IMP_SELECT,
 	LM3530_BRT_CTRL_REG,
 	LM3530_ALS_ZB0_REG,
@@ -217,18 +215,17 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 	reg_val[0] = gen_config;	/* LM3530_GEN_CONFIG */
 	reg_val[1] = als_config;	/* LM3530_ALS_CONFIG */
 	reg_val[2] = brt_ramp;		/* LM3530_BRT_RAMP_RATE */
-	reg_val[3] = 0x00;		/* LM3530_ALS_ZONE_REG */
-	reg_val[4] = als_imp_sel;	/* LM3530_ALS_IMP_SELECT */
-	reg_val[5] = brightness;	/* LM3530_BRT_CTRL_REG */
-	reg_val[6] = zones[0];		/* LM3530_ALS_ZB0_REG */
-	reg_val[7] = zones[1];		/* LM3530_ALS_ZB1_REG */
-	reg_val[8] = zones[2];		/* LM3530_ALS_ZB2_REG */
-	reg_val[9] = zones[3];		/* LM3530_ALS_ZB3_REG */
-	reg_val[10] = LM3530_DEF_ZT_0;	/* LM3530_ALS_Z0T_REG */
-	reg_val[11] = LM3530_DEF_ZT_1;	/* LM3530_ALS_Z1T_REG */
-	reg_val[12] = LM3530_DEF_ZT_2;	/* LM3530_ALS_Z2T_REG */
-	reg_val[13] = LM3530_DEF_ZT_3;	/* LM3530_ALS_Z3T_REG */
-	reg_val[14] = LM3530_DEF_ZT_4;	/* LM3530_ALS_Z4T_REG */
+	reg_val[3] = als_imp_sel;	/* LM3530_ALS_IMP_SELECT */
+	reg_val[4] = brightness;	/* LM3530_BRT_CTRL_REG */
+	reg_val[5] = zones[0];		/* LM3530_ALS_ZB0_REG */
+	reg_val[6] = zones[1];		/* LM3530_ALS_ZB1_REG */
+	reg_val[7] = zones[2];		/* LM3530_ALS_ZB2_REG */
+	reg_val[8] = zones[3];		/* LM3530_ALS_ZB3_REG */
+	reg_val[9] = LM3530_DEF_ZT_0;	/* LM3530_ALS_Z0T_REG */
+	reg_val[10] = LM3530_DEF_ZT_1;	/* LM3530_ALS_Z1T_REG */
+	reg_val[11] = LM3530_DEF_ZT_2;	/* LM3530_ALS_Z2T_REG */
+	reg_val[12] = LM3530_DEF_ZT_3;	/* LM3530_ALS_Z3T_REG */
+	reg_val[13] = LM3530_DEF_ZT_4;	/* LM3530_ALS_Z4T_REG */
 
 	if (!drvdata->enable) {
 		ret = regulator_enable(drvdata->regulator);
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated




