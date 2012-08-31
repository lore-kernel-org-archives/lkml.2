Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab2HaJYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:24:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45106 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab2HaJYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:24:43 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/22] lp8727_charger: use the definition rather than enum
Thread-Topic: [PATCH 09/22] lp8727_charger: use the definition rather than
 enum
Thread-Index: Ac2HWnChNt9htvjkRgm663axNBoqaw==
Date: Fri, 31 Aug 2012 09:24:37 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1ED3@DQHE02.ent.ti.com>
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

 Enum lp8727_chg_state can be removed because only one charger status
 is used - EOC(End Of Charge).

 To check whether the EOC is reached or not, use simple comparison
 rather than shift-operation.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 1a5f4b2..32bf157 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -55,6 +55,7 @@
 #define CHGSTAT		(3 << 4)
 #define CHPORT		(1 << 6)
 #define DCPORT		(1 << 7)
+#define LP8727_STAT_EOC			0x30
 
 /* STATUS2 register */
 #define TEMP_STAT	(3 << 5)
@@ -69,13 +70,6 @@ enum lp8727_dev_id {
 	ID_MAX,
 };
 
-enum lp8727_chg_stat {
-	PRECHG,
-	CC,
-	CV,
-	EOC,
-};
-
 enum lp8727_die_temp {
 	LP8788_TEMP_75C,
 	LP8788_TEMP_95C,
@@ -348,10 +342,10 @@ static int lp8727_battery_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_STATUS:
 		if (lp8727_is_charger_attached(psy->name, pchg->devid)) {
 			lp8727_read_byte(pchg, STATUS1, &read);
-			if (((read & CHGSTAT) >> 4) == EOC)
-				val->intval = POWER_SUPPLY_STATUS_FULL;
-			else
-				val->intval = POWER_SUPPLY_STATUS_CHARGING;
+
+			val->intval = (read & CHGSTAT) == LP8727_STAT_EOC ?
+				POWER_SUPPLY_STATUS_FULL :
+				POWER_SUPPLY_STATUS_CHARGING;
 		} else {
 			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
 		}
-- 
1.7.9.5


Best Regards,
Milo


