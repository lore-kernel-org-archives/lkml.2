Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab2HaJ0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:26:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37705 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab2HaJ01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:26:27 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/22] lp8727_charger: clean up lp8727_charger_changed()
Thread-Topic: [PATCH 17/22] lp8727_charger: clean up lp8727_charger_changed()
Thread-Index: Ac2HWquvTFhV8gtKTCmoTEVJMAXzcA==
Date: Fri, 31 Aug 2012 09:26:22 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1F34@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: Dxbi LqYL P7U8 Qk89 RPeb RkmM S7FY T49R UFLd Ucw5 Wlrb
 Y0YT ce7f djoK fPY3
 jeZ8;3;YQBuAHQAbwBuAC4AdgBvAHIAbwBuAHQAcwBvAHYAQABsAGkAbgBhAHIAbwAuAG8AcgBnADsAZAB3AG0AdwAyAEAAaQBuAGYAcgBhAGQAZQBhAGQALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{827C7C59-44F1-42D8-94BB-2D468DDC17C8};bQBpAGwAbwAuAGsAaQBtAEAAdABpAC4AYwBvAG0A;Fri,
 31 Aug 2012 09:26:16
 GMT;WwBQAEEAVABDAEgAIAAxADcALwAyADIAXQAgAGwAcAA4ADcAMgA3AF8AYwBoAGEAcgBnAGUAcgA6ACAAYwBsAGUAYQBuACAAdQBwACAAbABwADgANwAyADcAXwBjAGgAYQByAGcAZQByAF8AYwBoAGEAbgBnAGUAZAAoACkA
x-cr-puzzleid: {827C7C59-44F1-42D8-94BB-2D468DDC17C8}
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Declare a variable at one line.
 Just return when no charger exists to make code simpler.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index ee1dfaa..a01059f 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -393,16 +393,20 @@ static int lp8727_battery_get_property(struct power_supply *psy,
 static void lp8727_charger_changed(struct power_supply *psy)
 {
 	struct lp8727_chg *pchg = dev_get_drvdata(psy->dev->parent);
+	u8 eoc_level;
+	u8 ichg;
 	u8 val;
-	u8 eoc_level, ichg;
-
-	if (lp8727_is_charger_attached(psy->name, pchg->devid)) {
-		if (pchg->chg_parm) {
-			eoc_level = pchg->chg_parm->eoc_level;
-			ichg = pchg->chg_parm->ichg;
-			val = (ichg << LP8727_ICHG_SHIFT) | eoc_level;
-			lp8727_write_byte(pchg, LP8727_CHGCTRL2, val);
-		}
+
+	/* skip if no charger exists */
+	if (!lp8727_is_charger_attached(psy->name, pchg->devid))
+		return;
+
+	/* update charging parameters */
+	if (pchg->chg_parm) {
+		eoc_level = pchg->chg_parm->eoc_level;
+		ichg = pchg->chg_parm->ichg;
+		val = (ichg << LP8727_ICHG_SHIFT) | eoc_level;
+		lp8727_write_byte(pchg, LP8727_CHGCTRL2, val);
 	}
 }
 
-- 
1.7.9.5


Best Regards,
Milo


