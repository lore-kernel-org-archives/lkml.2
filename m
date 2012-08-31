Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab2HaJ05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:26:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44642 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab2HaJ04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:26:56 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 19/22] lp8727_charger: fix typo - chg_parm to chg_param
Thread-Topic: [PATCH 19/22] lp8727_charger: fix typo - chg_parm to chg_param
Thread-Index: Ac2HWr7450fFNGcSRWO0V4MRIUn7cA==
Date: Fri, 31 Aug 2012 09:26:49 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1F63@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 62102c4..b3295a7 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -91,7 +91,7 @@ struct lp8727_chg {
 	struct delayed_work work;
 	struct lp8727_platform_data *pdata;
 	struct lp8727_psy *psy;
-	struct lp8727_chg_param *chg_parm;
+	struct lp8727_chg_param *chg_param;
 	enum lp8727_dev_id devid;
 	unsigned long debounce_jiffies;
 	int irq;
@@ -183,14 +183,14 @@ static void lp8727_id_detection(struct lp8727_chg *pchg, u8 id, int vbusin)
 	switch (id) {
 	case 0x5:
 		devid = LP8727_ID_TA;
-		pchg->chg_parm = pdata ? pdata->ac : NULL;
+		pchg->chg_param = pdata ? pdata->ac : NULL;
 		break;
 	case 0xB:
 		if (lp8727_is_dedicated_charger(pchg)) {
-			pchg->chg_parm = pdata ? pdata->ac : NULL;
+			pchg->chg_param = pdata ? pdata->ac : NULL;
 			devid = LP8727_ID_DEDICATED_CHG;
 		} else if (lp8727_is_usb_charger(pchg)) {
-			pchg->chg_parm = pdata ? pdata->usb : NULL;
+			pchg->chg_param = pdata ? pdata->usb : NULL;
 			devid = LP8727_ID_USB_CHG;
 			swctrl = LP8727_SW_DM1_DM | LP8727_SW_DP2_DP;
 		} else if (vbusin) {
@@ -200,7 +200,7 @@ static void lp8727_id_detection(struct lp8727_chg *pchg, u8 id, int vbusin)
 		break;
 	default:
 		devid = LP8727_ID_NONE;
-		pchg->chg_parm = NULL;
+		pchg->chg_param = NULL;
 		break;
 	}
 
@@ -404,9 +404,9 @@ static void lp8727_charger_changed(struct power_supply *psy)
 		return;
 
 	/* update charging parameters */
-	if (pchg->chg_parm) {
-		eoc_level = pchg->chg_parm->eoc_level;
-		ichg = pchg->chg_parm->ichg;
+	if (pchg->chg_param) {
+		eoc_level = pchg->chg_param->eoc_level;
+		ichg = pchg->chg_param->ichg;
 		val = (ichg << LP8727_ICHG_SHIFT) | eoc_level;
 		lp8727_write_byte(pchg, LP8727_CHGCTRL2, val);
 	}
-- 
1.7.9.5


Best Regards,
Milo


