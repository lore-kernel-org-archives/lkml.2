Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab2HaJ0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:26:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44585 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab2HaJ0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:26:01 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/22] lp8727_charger: make lp8727_charger_get_propery()
 simpler
Thread-Topic: [PATCH 15/22] lp8727_charger: make
 lp8727_charger_get_propery() simpler
Thread-Index: Ac2HWp8hR/XSARHfTYat9or2xxScOA==
Date: Fri, 31 Aug 2012 09:25:55 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1F24@DQHE02.ent.ti.com>
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

 Charger has only one valid property - ONLINE.
 If the property is not ONLINE, then just return quickly.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 880bb7b..2507b2b 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -305,9 +305,10 @@ static int lp8727_charger_get_property(struct power_supply *psy,
 {
 	struct lp8727_chg *pchg = dev_get_drvdata(psy->dev->parent);
 
-	if (psp == POWER_SUPPLY_PROP_ONLINE)
-		val->intval = lp8727_is_charger_attached(psy->name,
-							 pchg->devid);
+	if (psp != POWER_SUPPLY_PROP_ONLINE)
+		return -EINVAL;
+
+	val->intval = lp8727_is_charger_attached(psy->name, pchg->devid);
 
 	return 0;
 }
-- 
1.7.9.5


Best Regards,
Milo


