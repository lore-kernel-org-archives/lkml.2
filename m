Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2HaJXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:23:06 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45000 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab2HaJWz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:22:55 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/22] lp8727_charger: use devm_kzalloc()
Thread-Topic: [PATCH 01/22] lp8727_charger: use devm_kzalloc()
Thread-Index: Ac2HWi7XmHqc4HPbThS2+bYpr4wi/A==
Date: Fri, 31 Aug 2012 09:22:46 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1E60@DQHE02.ent.ti.com>
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

 Use devm_kzalloc() rather than kzalloc()/kfree() to
 make allocating/freeing the private data simpler.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 5c56d7e..0d3cb1d 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -360,7 +360,7 @@ static int lp8727_register_psy(struct lp8727_chg *pchg)
 {
 	struct lp8727_psy *psy;
 
-	psy = kzalloc(sizeof(*psy), GFP_KERNEL);
+	psy = devm_kzalloc(pchg->dev, sizeof(*psy), GFP_KERNEL);
 	if (!psy)
 		return -ENOMEM;
 
@@ -405,7 +405,6 @@ err_psy_batt:
 err_psy_usb:
 	power_supply_unregister(&psy->ac);
 err_psy_ac:
-	kfree(psy);
 	return -EPERM;
 }
 
@@ -419,7 +418,6 @@ static void lp8727_unregister_psy(struct lp8727_chg *pchg)
 	power_supply_unregister(&psy->ac);
 	power_supply_unregister(&psy->usb);
 	power_supply_unregister(&psy->batt);
-	kfree(psy);
 }
 
 static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
@@ -430,7 +428,7 @@ static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	if (!i2c_check_functionality(cl->adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
 		return -EIO;
 
-	pchg = kzalloc(sizeof(*pchg), GFP_KERNEL);
+	pchg = devm_kzalloc(&cl->dev, sizeof(*pchg), GFP_KERNEL);
 	if (!pchg)
 		return -ENOMEM;
 
@@ -462,7 +460,6 @@ static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	return 0;
 
 error:
-	kfree(pchg);
 	return ret;
 }
 
@@ -474,7 +471,6 @@ static int __devexit lp8727_remove(struct i2c_client *cl)
 	free_irq(pchg->client->irq, pchg);
 	flush_workqueue(pchg->irqthread);
 	destroy_workqueue(pchg->irqthread);
-	kfree(pchg);
 	return 0;
 }
 
-- 
1.7.9.5


Best Regards,
Milo

