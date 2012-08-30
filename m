Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab2H3Li1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 07:38:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34012 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab2H3Lho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 07:37:44 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: [PATCH 1/8] lp8727_charger: use devm_kzalloc() rather than
 kzalloc()/kfree()
Thread-Topic: [PATCH 1/8] lp8727_charger: use devm_kzalloc() rather than
 kzalloc()/kfree()
Thread-Index: Ac2Go9UOc07DVjP9QHa1BByE2vPAsA==
Date: Thu, 30 Aug 2012 11:37:34 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1C73@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: G2SE Kv+z Mc/5 RjHx UrVl XbEE bkhP dKp7 d9R7 e8nO gOsU
 gyyk hKxF hlbD hvlw
 oTe9;4;YQBuAHQAbwBuAC4AdgBvAHIAbwBuAHQAcwBvAHYAQABsAGkAbgBhAHIAbwAuAG8AcgBnADsAYwBiAG8AdQBhAHQAbQBhAGkAbAByAHUAQABnAG0AYQBpAGwALgBjAG8AbQA7AGQAdwBtAHcAMgBAAGkAbgBmAHIAYQBkAGUAYQBkAC4AbwByAGcAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnAA==;Sosha1_v1;7;{5A4611E7-9D2B-4E1E-AAC2-FF8AE12781A4};bQBpAGwAbwAuAGsAaQBtAEAAdABpAC4AYwBvAG0A;Thu,
 30 Aug 2012 11:37:27
 GMT;WwBQAEEAVABDAEgAIAAxAC8AOABdACAAbABwADgANwAyADcAXwBjAGgAYQByAGcAZQByADoAIAB1AHMAZQAgAGQAZQB2AG0AXwBrAHoAYQBsAGwAbwBjACgAKQAgAHIAYQB0AGgAZQByACAAdABoAGEAbgAgAGsAegBhAGwAbABvAGMAKAApAC8AawBmAHIAZQBlACgAKQA=
x-cr-puzzleid: {5A4611E7-9D2B-4E1E-AAC2-FF8AE12781A4}
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make allocating/freeing the private data simpler

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 4e37b26..fb3d7ac 100644
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


