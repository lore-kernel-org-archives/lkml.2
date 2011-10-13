Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1JMGGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 02:06:31 -0400
Received: from mail2.nsc.com ([12.238.8.132]:53332 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751491Ab1JMGGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 02:06:19 -0400
X-WSS-ID: 0LSZQAE-0A-2HK-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Anton Vorontsov" <cbouatmailru@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Date: Wed, 12 Oct 2011 23:06:07 -0700
Subject: RE: [PATCH 2/3] power: Add LP8727 charger driver
Thread-Topic: [PATCH 2/3] power: Add LP8727 charger driver
Thread-Index: AcyJGBXAdUB8oJDGSj+lwhRWFSM0rwAVaYXw
Message-ID: <B567DBAB974C0544994013492B949F8E380FB92911@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E380F619DE2@EXMAIL03.scwf.nsc.com>
 <20111012194927.GA9239@oksana.dev.rtsoft.ru>
In-Reply-To: <20111012194927.GA9239@oksana.dev.rtsoft.ru>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 6288A0591LS7421716-01-01
Content-Type: text/plain;
 charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9D66iSk009570

Hi, Anton Vorontsov

Thank you for your comments.
I send the revised patch.

Signed-off-by: Woogyom Kim <milo.kim@ti.com>

>From 0a7658fe57ca196db6e22d1a394c3286bec19951 Mon Sep 17 00:00:00 2001
From: Milo(Woogyom) Kim <milo.kim@ti.com>
Date: Thu, 13 Oct 2011 14:53:27 +0900
Subject: [PATCH] power: lp8727 coding style changes

1. Useless braces were omitted
2. Useless void casts were omitted
3. module exit name changed
   lp8727_chg_exit -> lp8727_exit
4. Pointer coding style changes
   no space between pointer('*') and pointer name
   ex) u8 * data -> u8 *data
5. Author information change : email and additional author
---
 drivers/power/lp8727_charger.c |   50 ++++++++++++++++++++--------------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 2a649e0..6d13f83 100755
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -91,7 +91,7 @@ struct lp8727_chg {
 	enum lp8727_dev_id devid;
 };
 
-static int lp8727_i2c_read(struct lp8727_chg *pchg, u8 reg, u8 * data, u8 len)
+static int lp8727_i2c_read(struct lp8727_chg *pchg, u8 reg, u8 *data, u8 len)
 {
 	s32 ret;
 
@@ -102,7 +102,7 @@ static int lp8727_i2c_read(struct lp8727_chg *pchg, u8 reg, u8 * data, u8 len)
 	return (ret != len) ? -EIO : 0;
 }
 
-static int lp8727_i2c_write(struct lp8727_chg *pchg, u8 reg, u8 * data, u8 len)
+static int lp8727_i2c_write(struct lp8727_chg *pchg, u8 reg, u8 *data, u8 len)
 {
 	s32 ret;
 
@@ -114,13 +114,13 @@ static int lp8727_i2c_write(struct lp8727_chg *pchg, u8 reg, u8 * data, u8 len)
 }
 
 static inline int lp8727_i2c_read_byte(struct lp8727_chg *pchg, u8 reg,
-				       u8 * data)
+				       u8 *data)
 {
 	return lp8727_i2c_read(pchg, reg, data, 1);
 }
 
 static inline int lp8727_i2c_write_byte(struct lp8727_chg *pchg, u8 reg,
-					u8 * data)
+					u8 *data)
 {
 	return lp8727_i2c_write(pchg, reg, data, 1);
 }
@@ -153,21 +153,21 @@ static void lp8727_init_device(struct lp8727_chg *pchg)
 static int lp8727_is_dedicated_charger(struct lp8727_chg *pchg)
 {
 	u8 val;
-	(void)lp8727_i2c_read_byte(pchg, STATUS1, &val);
+	lp8727_i2c_read_byte(pchg, STATUS1, &val);
 	return (val & DCPORT);
 }
 
 static int lp8727_is_usb_charger(struct lp8727_chg *pchg)
 {
 	u8 val;
-	(void)lp8727_i2c_read_byte(pchg, STATUS1, &val);
+	lp8727_i2c_read_byte(pchg, STATUS1, &val);
 	return (val & CHPORT);
 }
 
 static void lp8727_ctrl_switch(struct lp8727_chg *pchg, u8 sw)
 {
 	u8 val = sw;
-	(void)lp8727_i2c_write_byte(pchg, SWCTRL, &val);
+	lp8727_i2c_write_byte(pchg, SWCTRL, &val);
 }
 
 static void lp8727_id_detection(struct lp8727_chg *pchg, u8 id, int vbusin)
@@ -207,9 +207,9 @@ static void lp8727_enable_chgdet(struct lp8727_chg *pchg)
 {
 	u8 val;
 
-	(void)lp8727_i2c_read_byte(pchg, CTRL2, &val);
+	lp8727_i2c_read_byte(pchg, CTRL2, &val);
 	val |= CHGDET_EN;
-	(void)lp8727_i2c_write_byte(pchg, CTRL2, &val);
+	lp8727_i2c_write_byte(pchg, CTRL2, &val);
 }
 
 static void lp8727_delayed_func(struct work_struct *_work)
@@ -283,10 +283,9 @@ static int lp8727_charger_get_property(struct power_supply *psy,
 {
 	struct lp8727_chg *pchg = dev_get_drvdata(psy->dev->parent);
 
-	if (psp == POWER_SUPPLY_PROP_ONLINE) {
+	if (psp == POWER_SUPPLY_PROP_ONLINE)
 		val->intval = lp8727_is_charger_attached(psy->name,
 							 pchg->devid);
-	}
 
 	return 0;
 }
@@ -301,7 +300,7 @@ static int lp8727_battery_get_property(struct power_supply *psy,
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
 		if (lp8727_is_charger_attached(psy->name, pchg->devid)) {
-			(void)lp8727_i2c_read_byte(pchg, STATUS1, &read);
+			lp8727_i2c_read_byte(pchg, STATUS1, &read);
 			if (((read & CHGSTAT) >> 4) == EOC)
 				val->intval = POWER_SUPPLY_STATUS_FULL;
 			else
@@ -311,7 +310,7 @@ static int lp8727_battery_get_property(struct power_supply *psy,
 		}
 		break;
 	case POWER_SUPPLY_PROP_HEALTH:
-		(void)lp8727_i2c_read_byte(pchg, STATUS2, &read);
+		lp8727_i2c_read_byte(pchg, STATUS2, &read);
 		read = (read & TEMP_STAT) >> 5;
 		if (read >= 0x1 && read <= 0x3)
 			val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
@@ -352,7 +351,7 @@ static void lp8727_charger_changed(struct power_supply *psy)
 			eoc_level = pchg->chg_parm->eoc_level;
 			ichg = pchg->chg_parm->ichg;
 			val = (ichg << 4) | eoc_level;
-			(void)lp8727_i2c_write_byte(pchg, CHGCTRL2, &val);
+			lp8727_i2c_write_byte(pchg, CHGCTRL2, &val);
 		}
 	}
 }
@@ -412,12 +411,13 @@ static void lp8727_unregister_psy(struct lp8727_chg *pchg)
 {
 	struct lp8727_psy *psy = pchg->psy;
 
-	if (psy) {
-		power_supply_unregister(&psy->ac);
-		power_supply_unregister(&psy->usb);
-		power_supply_unregister(&psy->batt);
-		kfree(psy);
-	}
+	if (!psy)
+		return;
+
+	power_supply_unregister(&psy->ac);
+	power_supply_unregister(&psy->usb);
+	power_supply_unregister(&psy->batt);
+	kfree(psy);
 }
 
 static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
@@ -440,10 +440,9 @@ static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	lp8727_intr_config(pchg);
 
 	ret = lp8727_register_psy(pchg);
-	if (ret) {
+	if (ret)
 		dev_err(pchg->dev,
 			"can not register power supplies. err=%d", ret);
-	}
 
 	return 0;
 }
@@ -478,14 +477,15 @@ static int __init lp8727_init(void)
 	return i2c_add_driver(&lp8727_driver);
 }
 
-static void __exit lp8727_chg_exit(void)
+static void __exit lp8727_exit(void)
 {
 	i2c_del_driver(&lp8727_driver);
 }
 
 module_init(lp8727_init);
-module_exit(lp8727_chg_exit);
+module_exit(lp8727_exit);
 
 MODULE_DESCRIPTION("National Semiconductor LP8727 charger driver");
-MODULE_AUTHOR("Woogyom Kim <milo.kim@nsc.com>");
+MODULE_AUTHOR
+    ("Woogyom Kim <milo.kim@ti.com>, Daniel Jeong <daniel.jeong@ti.com>");
 MODULE_LICENSE("GPL");
-- 
1.7.4.1

Thanks & BR
Milo (Woogyom) Kim
milo.kim@ti.com

-----Original Message-----
From: Anton Vorontsov [mailto:cbouatmailru@gmail.com] 
Sent: Thursday, October 13, 2011 4:49 AM
To: Kim, Milo
Cc: linux-kernel@vger.kernel.org; dwmw2@infradead.org
Subject: Re: [PATCH 2/3] power: Add LP8727 charger driver

Hello Kim,

Sorry for the delay.

On Wed, Sep 07, 2011 at 01:55:27AM -0700, Kim, Milo wrote:
> 
> diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
> new file mode 100755
> index 0000000..2a649e0

Note that each patch should have commit message (ideally), and a
Signed-off-by: line.

Though, I would fixup all the issues myself, if the patch had at
least Signed-off-by. :-)

But while you're at it, you might also want to fix some cosmetic
issues:

[...]
> +static int lp8727_is_dedicated_charger(struct lp8727_chg *pchg)
> +{
> +	u8 val;
> +	(void)lp8727_i2c_read_byte(pchg, STATUS1, &val);

No need for these casts, please.

> +	return (val & DCPORT);
> +}
[...]
> +static int lp8727_charger_get_property(struct power_supply *psy,
> +				       enum power_supply_property psp,
> +				       union power_supply_propval *val)
> +{
> +	struct lp8727_chg *pchg = dev_get_drvdata(psy->dev->parent);
> +
> +	if (psp == POWER_SUPPLY_PROP_ONLINE) {
> +		val->intval = lp8727_is_charger_attached(psy->name,
> +							 pchg->devid);
> +	}

No need for brackets here.

> +
> +	return 0;
> +}
> +
[...]
> +static void lp8727_unregister_psy(struct lp8727_chg *pchg)
> +{
> +	struct lp8727_psy *psy = pchg->psy;
> +
> +	if (psy) {

if (!psy)
	return;

> +		power_supply_unregister(&psy->ac);
> +		power_supply_unregister(&psy->usb);
> +		power_supply_unregister(&psy->batt);
> +		kfree(psy);
> +	}
> +}
> +
> +static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
> +{
> +	struct lp8727_chg *pchg;
> +	int ret;
> +
> +	pchg = kzalloc(sizeof(*pchg), GFP_KERNEL);
> +	if (!pchg)
> +		return -ENOMEM;
> +
> +	pchg->client = cl;
> +	pchg->dev = &cl->dev;
> +	pchg->pdata = cl->dev.platform_data;
> +	i2c_set_clientdata(cl, pchg);
> +
> +	mutex_init(&pchg->xfer_lock);
> +
> +	lp8727_init_device(pchg);
> +	lp8727_intr_config(pchg);
> +
> +	ret = lp8727_register_psy(pchg);
> +	if (ret) {
> +		dev_err(pchg->dev,
> +			"can not register power supplies. err=%d", ret);

No need for brackets.

> +	}
> +
> +	return 0;
> +}
> +
> +static int __devexit lp8727_remove(struct i2c_client *cl)
> +{
> +	struct lp8727_chg *pchg = i2c_get_clientdata(cl);
> +
> +	lp8727_unregister_psy(pchg);
> +	free_irq(pchg->client->irq, pchg);
> +	flush_workqueue(pchg->irqthread);
> +	destroy_workqueue(pchg->irqthread);
> +	kfree(pchg);
> +	return 0;
> +}
> +
> +static const struct i2c_device_id lp8727_ids[] = {
> +	{"lp8727", 0},
> +};
> +
> +static struct i2c_driver lp8727_driver = {
> +	.driver = {
> +		   .name = "lp8727",
> +		   },
> +	.probe = lp8727_probe,
> +	.remove = __devexit_p(lp8727_remove),
> +	.id_table = lp8727_ids,
> +};
> +
> +static int __init lp8727_init(void)
> +{
> +	return i2c_add_driver(&lp8727_driver);
> +}
> +
> +static void __exit lp8727_chg_exit(void)
> +{
> +	i2c_del_driver(&lp8727_driver);
> +}
> +
> +module_init(lp8727_init);
> +module_exit(lp8727_chg_exit);
> +
> +MODULE_DESCRIPTION("National Semiconductor LP8727 charger driver");
> +MODULE_AUTHOR("Woogyom Kim <milo.kim@nsc.com>");
> +MODULE_LICENSE("GPL");
> 

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
