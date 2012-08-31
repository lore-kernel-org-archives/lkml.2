Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab2HaJZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:25:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43987 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab2HaJZO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:25:14 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/22] lp8727_charger: use specific definition
Thread-Topic: [PATCH 11/22] lp8727_charger: use specific definition
Thread-Index: Ac2HWoIHHz4E8TdJQbqHhKq11hwZlA==
Date: Fri, 31 Aug 2012 09:25:07 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1EE3@DQHE02.ent.ti.com>
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

 Add new LP8727_ICHG_SHIFT definition and replace a magic number.
 Reuse definition for the size of interrupt register buffer.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 65c9840..254bbe0 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -59,6 +59,9 @@
 #define LP8727_TEMP_STAT	(3 << 5)
 #define LP8727_TEMP_SHIFT	5
 
+/* CHGCTRL2 register */
+#define LP8727_ICHG_SHIFT	4
+
 enum lp8727_dev_id {
 	LP8727_ID_NONE,
 	LP8727_ID_TA,
@@ -222,11 +225,11 @@ static void lp8727_enable_chgdet(struct lp8727_chg *pchg)
 
 static void lp8727_delayed_func(struct work_struct *_work)
 {
-	u8 intstat[2], idno, vbus;
+	u8 intstat[LP8788_NUM_INTREGS], idno, vbus;
 	struct lp8727_chg *pchg =
 	    container_of(_work, struct lp8727_chg, work.work);
 
-	if (lp8727_read_bytes(pchg, LP8727_INT1, intstat, 2)) {
+	if (lp8727_read_bytes(pchg, LP8727_INT1, intstat, LP8788_NUM_INTREGS)) {
 		dev_err(pchg->dev, "can not read INT registers\n");
 		return;
 	}
@@ -401,7 +404,7 @@ static void lp8727_charger_changed(struct power_supply *psy)
 		if (pchg->chg_parm) {
 			eoc_level = pchg->chg_parm->eoc_level;
 			ichg = pchg->chg_parm->ichg;
-			val = (ichg << 4) | eoc_level;
+			val = (ichg << LP8727_ICHG_SHIFT) | eoc_level;
 			lp8727_write_byte(pchg, LP8727_CHGCTRL2, val);
 		}
 	}
-- 
1.7.9.5


Best Regards,
Milo


