Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab2HaJ0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:26:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44596 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab2HaJ0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:26:12 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/22] lp8727_charger: return if the battery is discharging
Thread-Topic: [PATCH 16/22] lp8727_charger: return if the battery is
 discharging
Thread-Index: Ac2HWqVLnM8BXUbAQuWg4PWlq+KKfA==
Date: Fri, 31 Aug 2012 09:26:06 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1F2C@DQHE02.ent.ti.com>
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

 If the charger is pulled out, just return as DISCHARGING.
 Then no need for additional 'else' statement.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index ce59282..ee1dfaa 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -336,15 +336,16 @@ static int lp8727_battery_get_property(struct power_supply *psy,
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
-		if (lp8727_is_charger_attached(psy->name, pchg->devid)) {
-			lp8727_read_byte(pchg, LP8727_STATUS1, &read);
+		if (!lp8727_is_charger_attached(psy->name, pchg->devid)) {
+			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+			return 0;
+		}
+
+		lp8727_read_byte(pchg, LP8727_STATUS1, &read);
 
-			val->intval = (read & LP8727_CHGSTAT) == LP8727_STAT_EOC ?
+		val->intval = (read & LP8727_CHGSTAT) == LP8727_STAT_EOC ?
 				POWER_SUPPLY_STATUS_FULL :
 				POWER_SUPPLY_STATUS_CHARGING;
-		} else {
-			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
-		}
 		break;
 	case POWER_SUPPLY_PROP_HEALTH:
 		lp8727_read_byte(pchg, LP8727_STATUS2, &read);
-- 
1.7.9.5


Best Regards,
Milo


