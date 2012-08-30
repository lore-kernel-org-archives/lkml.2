Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab2H3LlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 07:41:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40914 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab2H3Lk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 07:40:58 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: [PATCH 7/8] lp8727_charger: cleanup definitions
Thread-Topic: [PATCH 7/8] lp8727_charger: cleanup definitions
Thread-Index: Ac2GpE0mi7iz3I8iSzCnuqPIeLC/0Q==
Date: Thu, 30 Aug 2012 11:40:49 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1CCF@DQHE02.ent.ti.com>
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

(a) add prefix LP8727_ for definitions
(b) replace lp8727_dev_id with lp8727_charger_type
(c) use one LP8727_STAT_EOC definition rather than enum type lp8727_chg_stat
   : charger status definitions are not used except EOC status
(d) use LP8727_ICHG_SHIFT rather than magic number

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c       |  184 ++++++++++++++++------------------
 include/linux/platform_data/lp8727.h |   34 +++----
 2 files changed, 106 insertions(+), 112 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 78cec53..610d286 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -17,63 +17,57 @@
 #include <linux/power_supply.h>
 #include <linux/platform_data/lp8727.h>
 
-/* Registers */
-#define CTRL1		0x1
-#define CTRL2		0x2
-#define	SWCTRL		0x3
-#define INT1		0x4
-#define INT2		0x5
-#define STATUS1		0x6
-#define STATUS2		0x7
-#define CHGCTRL2	0x9
-
-/* CTRL1 register */
-#define CP_EN		(1 << 0)
-#define ADC_EN		(1 << 1)
-#define ID200_EN	(1 << 4)
-
-/* CTRL2 register */
-#define CHGDET_EN	(1 << 1)
-#define INT_EN		(1 << 6)
-
-/* SWCTRL register */
-#define SW_DM1_DM	(0x0 << 0)
-#define SW_DM1_U1	(0x1 << 0)
-#define SW_DM1_HiZ	(0x7 << 0)
-#define SW_DP2_DP	(0x0 << 3)
-#define SW_DP2_U2	(0x1 << 3)
-#define SW_DP2_HiZ	(0x7 << 3)
-
-/* INT1 register */
-#define IDNO		(0xF << 0)
-#define VBUS		(1 << 4)
-
-/* STATUS1 register */
-#define CHGSTAT		(3 << 4)
-#define CHPORT		(1 << 6)
-#define DCPORT		(1 << 7)
-
-/* STATUS2 register */
-#define TEMP_STAT	(3 << 5)
-#define TEMP_SHIFT	5
+/* Register Address */
+#define LP8727_CTRL1			0x1
+#define LP8727_CTRL2			0x2
+#define LP8727_SWCTRL			0x3
+#define LP8727_INT1			0x4
+#define LP8727_STATUS1			0x6
+#define LP8727_STATUS2			0x7
+#define LP8727_CHGCTRL2			0x9
+
+/* LP8727_CTRL1 register */
+#define LP8727_CP_EN			BIT(0)
+#define LP8727_ADC_EN			BIT(1)
+#define LP8727_ID200_EN			BIT(4)
+
+/* LP8727_CTRL2 register */
+#define LP8727_CHGDET_EN		BIT(1)
+#define LP8727_INT_EN			BIT(6)
+
+/* LP8727_SWCTRL register */
+#define LP8727_SW_DM1_DM		(0x0 << 0)
+#define LP8727_SW_DM1_HiZ		(0x7 << 0)
+#define LP8727_SW_DP2_DP		(0x0 << 3)
+#define LP8727_SW_DP2_HiZ		(0x7 << 3)
+
+/* LP8727_INT1 register */
+#define LP8727_IDNO			(0xF << 0)
+#define LP8727_VBUS			BIT(4)
+
+/* LP8727_STATUS1 register */
+#define LP8727_CHGSTAT			(3 << 4)
+#define LP8727_CHPORT			BIT(6)
+#define LP8727_DCPORT			BIT(7)
+#define LP8727_STAT_EOC			0x30
+
+/* LP8727_STATUS2 register */
+#define LP8727_TEMP_STAT		(3 << 5)
+#define LP8727_TEMP_SHIFT		5
+
+/* LP8727_CHGCTRL2 register */
+#define LP8727_ICHG_SHIFT		4
 
 #define LP8788_NUM_INTREGS		2
 #define DEFAULT_DEBOUNCE_MSEC		270
 
-enum lp8727_dev_id {
-	ID_NONE,
-	ID_TA,
-	ID_DEDICATED_CHG,
-	ID_USB_CHG,
-	ID_USB_DS,
-	ID_MAX,
-};
-
-enum lp8727_chg_stat {
-	PRECHG,
-	CC,
-	CV,
-	EOC,
+enum lp8727_charger_type {
+	LP8727_CHG_NONE,
+	LP8727_CHG_TA,
+	LP8727_CHG_DEDICATED,
+	LP8727_CHG_USB,
+	LP8727_USB_DS,	/* not charger type */
+	LP8727_CHG_MAX,
 };
 
 enum lp8727_die_temp {
@@ -105,7 +99,7 @@ struct lp8727_chg {
 	/* charging parameters */
 	struct lp8727_platform_data *pdata;
 	struct lp8727_chg_param *chg_param;
-	enum lp8727_dev_id devid;
+	enum lp8727_charger_type chg_type;
 };
 
 static int lp8727_read_bytes(struct lp8727_chg *pchg, u8 reg, u8 *data, u8 len)
@@ -131,12 +125,12 @@ static int lp8727_is_charger_attached(const char *name, int id)
 {
 	if (name) {
 		if (!strcmp(name, "ac"))
-			return (id == ID_TA || id == ID_DEDICATED_CHG) ? 1 : 0;
+			return id == LP8727_CHG_TA || id == LP8727_CHG_DEDICATED;
 		else if (!strcmp(name, "usb"))
-			return (id == ID_USB_CHG) ? 1 : 0;
+			return id == LP8727_CHG_USB;
 	}
 
-	return (id >= ID_TA && id <= ID_USB_CHG) ? 1 : 0;
+	return id >= LP8727_CHG_TA && id <= LP8727_CHG_USB;
 }
 
 static int lp8727_init_device(struct lp8727_chg *pchg)
@@ -146,17 +140,17 @@ static int lp8727_init_device(struct lp8727_chg *pchg)
 	u8 intstat[LP8788_NUM_INTREGS];
 
 	/* clear interrupts */
-	ret = lp8727_read_bytes(pchg, INT1, intstat, LP8788_NUM_INTREGS);
+	ret = lp8727_read_bytes(pchg, LP8727_INT1, intstat, LP8788_NUM_INTREGS);
 	if (ret)
 		return ret;
 
-	val = ID200_EN | ADC_EN | CP_EN;
-	ret = lp8727_write_byte(pchg, CTRL1, val);
+	val = LP8727_ID200_EN | LP8727_ADC_EN | LP8727_CP_EN;
+	ret = lp8727_write_byte(pchg, LP8727_CTRL1, val);
 	if (ret)
 		return ret;
 
-	val = INT_EN | CHGDET_EN;
-	ret = lp8727_write_byte(pchg, CTRL2, val);
+	val = LP8727_INT_EN | LP8727_CHGDET_EN;
+	ret = lp8727_write_byte(pchg, LP8727_CTRL2, val);
 	if (ret)
 		return ret;
 
@@ -166,53 +160,53 @@ static int lp8727_init_device(struct lp8727_chg *pchg)
 static int lp8727_is_dedicated_charger(struct lp8727_chg *pchg)
 {
 	u8 val;
-	lp8727_read_byte(pchg, STATUS1, &val);
-	return val & DCPORT;
+	lp8727_read_byte(pchg, LP8727_STATUS1, &val);
+	return val & LP8727_DCPORT;
 }
 
 static int lp8727_is_usb_charger(struct lp8727_chg *pchg)
 {
 	u8 val;
-	lp8727_read_byte(pchg, STATUS1, &val);
-	return val & CHPORT;
+	lp8727_read_byte(pchg, LP8727_STATUS1, &val);
+	return val & LP8727_CHPORT;
 }
 
 static void lp8727_ctrl_switch(struct lp8727_chg *pchg, u8 sw)
 {
-	lp8727_write_byte(pchg, SWCTRL, sw);
+	lp8727_write_byte(pchg, LP8727_SWCTRL, sw);
 }
 
 static void lp8727_id_detection(struct lp8727_chg *pchg, u8 id, int vbusin)
 {
 	struct lp8727_platform_data *pdata = pchg->pdata;
-	u8 devid = ID_NONE;
-	u8 swctrl = SW_DM1_HiZ | SW_DP2_HiZ;
+	u8 chg_type = LP8727_CHG_NONE;
+	u8 swctrl = LP8727_SW_DM1_HiZ | LP8727_SW_DP2_HiZ;
 
 	switch (id) {
 	case 0x5:
-		devid = ID_TA;
+		chg_type = LP8727_CHG_TA;
 		pchg->chg_param = pdata ? pdata->ac : NULL;
 		break;
 	case 0xB:
 		if (lp8727_is_dedicated_charger(pchg)) {
 			pchg->chg_param = pdata ? pdata->ac : NULL;
-			devid = ID_DEDICATED_CHG;
+			chg_type = LP8727_CHG_DEDICATED;
 		} else if (lp8727_is_usb_charger(pchg)) {
 			pchg->chg_param = pdata ? pdata->usb : NULL;
-			devid = ID_USB_CHG;
-			swctrl = SW_DM1_DM | SW_DP2_DP;
+			chg_type = LP8727_CHG_USB;
+			swctrl = LP8727_SW_DM1_DM | LP8727_SW_DP2_DP;
 		} else if (vbusin) {
-			devid = ID_USB_DS;
-			swctrl = SW_DM1_DM | SW_DP2_DP;
+			chg_type = LP8727_USB_DS;
+			swctrl = LP8727_SW_DM1_DM | LP8727_SW_DP2_DP;
 		}
 		break;
 	default:
-		devid = ID_NONE;
+		chg_type = LP8727_CHG_NONE;
 		pchg->chg_param = NULL;
 		break;
 	}
 
-	pchg->devid = devid;
+	pchg->chg_type = chg_type;
 	lp8727_ctrl_switch(pchg, swctrl);
 }
 
@@ -220,9 +214,9 @@ static void lp8727_enable_chgdet(struct lp8727_chg *pchg)
 {
 	u8 val;
 
-	lp8727_read_byte(pchg, CTRL2, &val);
-	val |= CHGDET_EN;
-	lp8727_write_byte(pchg, CTRL2, val);
+	lp8727_read_byte(pchg, LP8727_CTRL2, &val);
+	val |= LP8727_CHGDET_EN;
+	lp8727_write_byte(pchg, LP8727_CTRL2, val);
 }
 
 static void lp8727_delayed_func(struct work_struct *_work)
@@ -231,13 +225,13 @@ static void lp8727_delayed_func(struct work_struct *_work)
 	struct lp8727_chg *pchg =
 	    container_of(_work, struct lp8727_chg, work.work);
 
-	if (lp8727_read_bytes(pchg, INT1, intstat, 2)) {
+	if (lp8727_read_bytes(pchg, LP8727_INT1, intstat, 2)) {
 		dev_err(pchg->dev, "can not read INT registers\n");
 		return;
 	}
 
-	idno = intstat[0] & IDNO;
-	vbus = intstat[0] & VBUS;
+	idno = intstat[0] & LP8727_IDNO;
+	vbus = intstat[0] & LP8727_VBUS;
 
 	mutex_lock(&pchg->lock);
 	lp8727_id_detection(pchg, idno, vbus);
@@ -316,7 +310,7 @@ static int lp8727_charger_get_property(struct power_supply *psy,
 
 	if (psp == POWER_SUPPLY_PROP_ONLINE)
 		val->intval = lp8727_is_charger_attached(psy->name,
-							 pchg->devid);
+							 pchg->chg_type);
 
 	return 0;
 }
@@ -344,19 +338,19 @@ static int lp8727_battery_get_property(struct power_supply *psy,
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
-		if (lp8727_is_charger_attached(psy->name, pchg->devid)) {
-			lp8727_read_byte(pchg, STATUS1, &read);
-			if (((read & CHGSTAT) >> 4) == EOC)
-				val->intval = POWER_SUPPLY_STATUS_FULL;
-			else
-				val->intval = POWER_SUPPLY_STATUS_CHARGING;
+		if (lp8727_is_charger_attached(psy->name, pchg->chg_type)) {
+			lp8727_read_byte(pchg, LP8727_STATUS1, &read);
+
+			val->intval = (read & LP8727_CHGSTAT) == LP8727_STAT_EOC ?
+				POWER_SUPPLY_STATUS_FULL :
+				POWER_SUPPLY_STATUS_CHARGING;
 		} else {
 			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
 		}
 		break;
 	case POWER_SUPPLY_PROP_HEALTH:
-		lp8727_read_byte(pchg, STATUS2, &read);
-		temp = (read & TEMP_STAT) >> TEMP_SHIFT;
+		lp8727_read_byte(pchg, LP8727_STATUS2, &read);
+		temp = (read & LP8727_TEMP_STAT) >> LP8727_TEMP_SHIFT;
 
 		val->intval = lp8727_is_high_temperature(temp) ?
 			POWER_SUPPLY_HEALTH_OVERHEAT :
@@ -403,12 +397,12 @@ static void lp8727_charger_changed(struct power_supply *psy)
 	u8 val;
 	u8 eoc_level, ichg;
 
-	if (lp8727_is_charger_attached(psy->name, pchg->devid)) {
+	if (lp8727_is_charger_attached(psy->name, pchg->chg_type)) {
 		if (pchg->chg_param) {
 			eoc_level = pchg->chg_param->eoc_level;
 			ichg = pchg->chg_param->ichg;
-			val = (ichg << 4) | eoc_level;
-			lp8727_write_byte(pchg, CHGCTRL2, val);
+			val = (ichg << LP8727_ICHG_SHIFT) | eoc_level;
+			lp8727_write_byte(pchg, LP8727_CHGCTRL2, val);
 		}
 	}
 }
diff --git a/include/linux/platform_data/lp8727.h b/include/linux/platform_data/lp8727.h
index 81edbd6..5b443a1 100644
--- a/include/linux/platform_data/lp8727.h
+++ b/include/linux/platform_data/lp8727.h
@@ -13,26 +13,26 @@
 #define _LP8727_H
 
 enum lp8727_eoc_level {
-	EOC_5P,
-	EOC_10P,
-	EOC_16P,
-	EOC_20P,
-	EOC_25P,
-	EOC_33P,
-	EOC_50P,
+	LP8727_EOC_5P,
+	LP8727_EOC_10P,
+	LP8727_EOC_16P,
+	LP8727_EOC_20P,
+	LP8727_EOC_25P,
+	LP8727_EOC_33P,
+	LP8727_EOC_50P,
 };
 
 enum lp8727_ichg {
-	ICHG_90mA,
-	ICHG_100mA,
-	ICHG_400mA,
-	ICHG_450mA,
-	ICHG_500mA,
-	ICHG_600mA,
-	ICHG_700mA,
-	ICHG_800mA,
-	ICHG_900mA,
-	ICHG_1000mA,
+	LP8727_ICHG_90mA,
+	LP8727_ICHG_100mA,
+	LP8727_ICHG_400mA,
+	LP8727_ICHG_450mA,
+	LP8727_ICHG_500mA,
+	LP8727_ICHG_600mA,
+	LP8727_ICHG_700mA,
+	LP8727_ICHG_800mA,
+	LP8727_ICHG_900mA,
+	LP8727_ICHG_1000mA,
 };
 
 /**
-- 
1.7.9.5


Best Regards,
Milo


