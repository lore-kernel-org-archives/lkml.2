Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab2GROeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 10:34:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38796 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab2GROeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 10:34:09 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>, Bryan Wu <bryan.wu@canonical.com>
Subject: [PATCH 3/6] power_supply: add new lp8788 charger driver
Thread-Topic: [PATCH 3/6] power_supply: add new lp8788 charger driver
Thread-Index: Ac1k8j1YCAHIIHxxRHatCbpyySKAXg==
Date: Wed, 18 Jul 2012 14:33:20 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FD7BF@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: UPI= P0vq YkZc alPL b54D iZSx kTtS mEvo zAlJ 4F98 4OlM
 ABzZJQ== ACPGNg== ADvBCQ== AEixkw==
 AHgvqA==;9;YQAuAHoAdQBtAG0AbwBAAHQAbwB3AGUAcgB0AGUAYwBoAC4AaQB0ADsAYQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGIAcgBvAG8AbgBpAGUAQABvAHAAZQBuAHMAbwB1AHIAYwBlAC4AdwBvAGwAZgBzAG8AbgBtAGkAYwByAG8ALgBjAG8AbQA7AGIAcgB5AGEAbgAuAHcAdQBAAGMAYQBuAG8AbgBpAGMAYQBsAC4AYwBvAG0AOwBjAGIAbwB1AGEAdABtAGEAaQBsAHIAdQBAAGcAbQBhAGkAbAAuAGMAbwBtADsAZAB3AG0AdwAyAEAAaQBuAGYAcgBhAGQAZQBhAGQALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwByAHAAdQByAGQAaQBlAEAAcgBwAHMAeQBzAC4AbgBlAHQAOwBzAGEAbQBlAG8AQABsAGkAbgB1AHgALgBpAG4AdABlAGwALgBjAG8AbQA=;Sosha1_v1;7;{89FC3CE3-FD7C-471A-A607-EC01D95C66EB};bQBpAGwAbwAuAGsAaQBtAEAAdABpAC4AYwBvAG0A;Wed,
 18 Jul 2012 14:33:03
 GMT;WwBQAEEAVABDAEgAIAAzAC8ANgBdACAAcABvAHcAZQByAF8AcwB1AHAAcABsAHkAOgAgAGEAZABkACAAbgBlAHcAIABsAHAAOAA3ADgAOAAgAGMAaABhAHIAZwBlAHIAIABkAHIAaQB2AGUAcgA=
x-cr-puzzleid: {89FC3CE3-FD7C-471A-A607-EC01D95C66EB}
x-originating-ip: [157.87.177.86]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI LP8788 PMU has the battery charger function.
Configurable charging parameters can be defined in the platform data.
And charging parameters can be read via the sysfs.
Charging interrupts are passed from lp8788 irq thread and
each interrupt can be handled in the charger driver.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/Kconfig          |    6 +
 drivers/power/Makefile         |    1 +
 drivers/power/lp8788-charger.c |  719 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 726 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/lp8788-charger.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index c1892f3..effbb72 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -255,6 +255,12 @@ config CHARGER_LP8727
 	help
 	  Say Y here to enable support for LP8727 Charger Driver.
 
+config CHARGER_LP8788
+	tristate "TI LP8788 charger driver"
+	depends on MFD_LP8788
+	help
+	  Say Y to enable support for the LP8788 linear charger.
+
 config CHARGER_GPIO
 	tristate "GPIO charger"
 	depends on GPIOLIB
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index ee58afb..587c5f1 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_CHARGER_ISP1704)	+= isp1704_charger.o
 obj-$(CONFIG_CHARGER_MAX8903)	+= max8903_charger.o
 obj-$(CONFIG_CHARGER_TWL4030)	+= twl4030_charger.o
 obj-$(CONFIG_CHARGER_LP8727)	+= lp8727_charger.o
+obj-$(CONFIG_CHARGER_LP8788)	+= lp8788-charger.o
 obj-$(CONFIG_CHARGER_GPIO)	+= gpio-charger.o
 obj-$(CONFIG_CHARGER_MANAGER)	+= charger-manager.o
 obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
diff --git a/drivers/power/lp8788-charger.c b/drivers/power/lp8788-charger.c
new file mode 100644
index 0000000..e1a76cd
--- /dev/null
+++ b/drivers/power/lp8788-charger.c
@@ -0,0 +1,719 @@
+/*
+ * TI LP8788 MFD - battery charger driver
+ *
+ * Copyright 2012 Texas Instruments
+ *
+ * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/workqueue.h>
+#include <linux/power_supply.h>
+#include <linux/mfd/lp8788.h>
+
+/* register address */
+#define LP8788_CHG_STATUS		0x07
+#define LP8788_CHG_IDCIN		0x13
+#define LP8788_CHG_IBATT		0x14
+#define LP8788_CHG_VTERM		0x15
+#define LP8788_CHG_EOC			0x16
+
+/* mask/shift bits */
+#define LP8788_CHG_INPUT_STATE_M	0x03	/* Addr 07h */
+#define LP8788_CHG_STATE_M		0x3C
+#define LP8788_CHG_STATE_S		2
+#define LP8788_NO_BATT_M		BIT(6)
+#define LP8788_BAD_BATT_M		BIT(7)
+#define LP8788_CHG_IBATT_M		0x1F	/* Addr 14h */
+#define LP8788_CHG_VTERM_M		0x0F	/* Addr 15h */
+#define LP8788_CHG_EOC_LEVEL_M		0x30	/* Addr 16h */
+#define LP8788_CHG_EOC_LEVEL_S		4
+#define LP8788_CHG_EOC_TIME_M		0x0E
+#define LP8788_CHG_EOC_TIME_S		1
+#define LP8788_CHG_EOC_MODE_M		BIT(0)
+
+#define CHARGER_NAME			"charger"
+#define BATTERY_NAME			"main_batt"
+
+#define LP8788_CHG_START		0x11
+#define LP8788_CHG_END			0x1C
+
+#define BUF_SIZE			40
+#define MAX_BATT_CAPACITY		100
+#define LP8788_ISEL_MAX			23
+#define LP8788_ISEL_STEP		50
+#define LP8788_VTERM_MIN		4100
+#define LP8788_VTERM_STEP		25
+
+/* CHG_STATE */
+enum lp8788_charging_state {
+	OFF,
+	WARM_UP,
+	LOW_INPUT = 0x3,
+	PRECHARGE,
+	CC,
+	CV,
+	MAINTENANCE,
+	BATTERY_FAULT,
+	SYSTEM_SUPPORT = 0xC,
+	HIGH_CURRENT = 0xF,
+	MAX_CHG_STATE,
+};
+
+/* CHG_INPUT_STATE */
+enum lp8788_charger_input_state {
+	SYSTEM_SUPPLY = 1,
+	FULL_FUNCTION,
+};
+
+struct lp8788_charger {
+	struct lp8788 *lp;
+	struct power_supply charger;
+	struct power_supply battery;
+	struct work_struct charger_work;
+};
+
+static char *battery_supplied_to[] = {
+	BATTERY_NAME,
+};
+
+static enum power_supply_property lp8788_charger_prop[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+};
+
+static enum power_supply_property lp8788_battery_prop[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_TEMP,
+};
+
+static bool lp8788_is_charger_detected(struct lp8788 *lp)
+{
+	u8 data;
+
+	lp8788_read_byte(lp, LP8788_CHG_STATUS, &data);
+	data &= LP8788_CHG_INPUT_STATE_M;
+
+	return (data == SYSTEM_SUPPLY || data == FULL_FUNCTION);
+}
+
+static int lp8788_charger_get_property(struct power_supply *psy,
+					enum power_supply_property psp,
+					union power_supply_propval *val)
+{
+	struct lp8788_charger *pchg = dev_get_drvdata(psy->dev->parent);
+	struct lp8788 *lp = pchg->lp;
+
+	if (psp != POWER_SUPPLY_PROP_ONLINE)
+		return -EINVAL;
+
+	val->intval = lp8788_is_charger_detected(lp);
+	return 0;
+}
+
+static int lp8788_get_battery_status(struct lp8788 *lp,
+				union power_supply_propval *val)
+{
+	enum lp8788_charging_state state;
+	u8 data;
+	int ret;
+
+	ret = lp8788_read_byte(lp, LP8788_CHG_STATUS, &data);
+	if (ret)
+		return ret;
+
+	state = (data & LP8788_CHG_STATE_M) >> LP8788_CHG_STATE_S;
+	switch (state) {
+	case OFF:
+		val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+		break;
+	case PRECHARGE:
+	case CC:
+	case CV:
+	case HIGH_CURRENT:
+		val->intval = POWER_SUPPLY_STATUS_CHARGING;
+		break;
+	case MAINTENANCE:
+		val->intval = POWER_SUPPLY_STATUS_FULL;
+		break;
+	default:
+		val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
+		break;
+	}
+
+	return 0;
+}
+
+static int lp8788_get_battery_health(struct lp8788 *lp,
+				union power_supply_propval *val)
+{
+	u8 data;
+	int ret;
+
+	ret = lp8788_read_byte(lp, LP8788_CHG_STATUS, &data);
+	if (ret)
+		return ret;
+
+	if (data & LP8788_NO_BATT_M)
+		val->intval = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
+	else if (data & LP8788_BAD_BATT_M)
+		val->intval = POWER_SUPPLY_HEALTH_DEAD;
+	else
+		val->intval = POWER_SUPPLY_HEALTH_GOOD;
+
+	return 0;
+}
+
+static int lp8788_get_battery_present(struct lp8788 *lp,
+				union power_supply_propval *val)
+{
+	u8 data;
+	int ret;
+
+	ret = lp8788_read_byte(lp, LP8788_CHG_STATUS, &data);
+	if (ret)
+		return ret;
+
+	val->intval = !(data & LP8788_NO_BATT_M);
+	return 0;
+}
+
+static int lp8788_get_vbatt_adc(struct lp8788 *lp, unsigned int *result)
+{
+	struct lp8788_charger_platform_data *pdata;
+	enum lp8788_adc_id id;
+
+	if (!lp->pdata || !lp->pdata->chg_pdata)
+		return -EINVAL;
+
+	pdata = lp->pdata->chg_pdata;
+
+	id = pdata->vbatt_adc;
+	switch (id) {
+	case LPADC_VBATT_5P5:
+	case LPADC_VBATT_6P0:
+	case LPADC_VBATT_5P0:
+		*result = lp8788_get_adc(lp, id, LP8788_ADC_12BIT_RES);
+		*result /= 1000; /* unit: mV */
+		break;
+	default:
+		dev_err(lp->dev, "invalid ADC id: %d\n", id);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int lp8788_get_battery_voltage(struct lp8788 *lp,
+				union power_supply_propval *val)
+{
+	return lp8788_get_vbatt_adc(lp, &val->intval);
+}
+
+static int lp8788_get_battery_capacity(struct lp8788 *lp,
+				union power_supply_propval *val)
+{
+	unsigned int max_vbatt, vbatt;
+	enum lp8788_charging_state state;
+	struct lp8788_charger_platform_data *pdata;
+	u8 data;
+	int ret;
+
+	if (!lp->pdata || !lp->pdata->chg_pdata)
+		return -EINVAL;
+
+	pdata =  lp->pdata->chg_pdata;
+
+	max_vbatt = pdata->max_vbatt_mv;
+	if (max_vbatt == 0)
+		return -EINVAL;
+
+	ret = lp8788_read_byte(lp, LP8788_CHG_STATUS, &data);
+	if (ret)
+		return ret;
+
+	state = (data & LP8788_CHG_STATE_M) >> LP8788_CHG_STATE_S;
+
+	if (state == MAINTENANCE) {
+		val->intval = MAX_BATT_CAPACITY;
+	} else {
+		ret = lp8788_get_vbatt_adc(lp, &vbatt);
+		if (ret)
+			return ret;
+
+		val->intval = (vbatt * MAX_BATT_CAPACITY) / max_vbatt;
+		val->intval = min(val->intval, MAX_BATT_CAPACITY);
+	}
+
+	return 0;
+}
+
+static int lp8788_get_battery_temperature(struct lp8788 *lp,
+				union power_supply_propval *val)
+{
+	struct lp8788_charger_platform_data *pdata;
+	enum lp8788_adc_id id;
+
+	if (!lp->pdata || !lp->pdata->chg_pdata)
+		return -EINVAL;
+
+	pdata =  lp->pdata->chg_pdata;
+
+	id = pdata->batt_temp_adc;
+	switch (id) {
+	case LPADC_ADC1:
+	case LPADC_ADC2:
+	case LPADC_ADC3:
+	case LPADC_ADC4:
+		val->intval = lp8788_get_adc(lp, id, LP8788_ADC_12BIT_RES);
+		val->intval /= 100; /* unit: 0.1 'C */
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int lp8788_battery_get_property(struct power_supply *psy,
+					enum power_supply_property psp,
+					union power_supply_propval *val)
+{
+	struct lp8788_charger *pchg = dev_get_drvdata(psy->dev->parent);
+	struct lp8788 *lp = pchg->lp;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		return lp8788_get_battery_status(lp, val);
+	case POWER_SUPPLY_PROP_HEALTH:
+		return lp8788_get_battery_health(lp, val);
+	case POWER_SUPPLY_PROP_PRESENT:
+		return lp8788_get_battery_present(lp, val);
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		return lp8788_get_battery_voltage(lp, val);
+	case POWER_SUPPLY_PROP_CAPACITY:
+		return lp8788_get_battery_capacity(lp, val);
+	case POWER_SUPPLY_PROP_TEMP:
+		return lp8788_get_battery_temperature(lp, val);
+	default:
+		return -EINVAL;
+	}
+}
+
+static inline bool lp8788_is_valid_charger_register(u8 addr)
+{
+	return (addr >= LP8788_CHG_START && addr <= LP8788_CHG_END);
+}
+
+static int lp8788_update_charger_params(struct lp8788_charger *pchg)
+{
+	struct lp8788 *lp = pchg->lp;
+	struct lp8788_charger_platform_data *pdata;
+	struct lp8788_chg_param *param;
+	int i, ret;
+
+	if (!lp->pdata || !lp->pdata->chg_pdata ||
+		!lp->pdata->chg_pdata->chg_params) {
+		dev_info(lp->dev, "skip updating charger parameters\n");
+		return 0;
+	}
+
+	pdata = lp->pdata->chg_pdata;
+
+	/* settting charging parameters */
+	for (i = 0 ; i < pdata->num_chg_params ; i++) {
+		param = pdata->chg_params + i;
+
+		if (!param)
+			continue;
+
+		if (lp8788_is_valid_charger_register(param->addr)) {
+			ret = lp8788_write_byte(lp, param->addr, param->val);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int lp8788_psy_register(struct platform_device *pdev,
+				struct lp8788_charger *pchg)
+{
+	pchg->charger.name = CHARGER_NAME;
+	pchg->charger.type = POWER_SUPPLY_TYPE_MAINS;
+	pchg->charger.properties = lp8788_charger_prop;
+	pchg->charger.num_properties = ARRAY_SIZE(lp8788_charger_prop);
+	pchg->charger.get_property = lp8788_charger_get_property;
+	pchg->charger.supplied_to = battery_supplied_to;
+	pchg->charger.num_supplicants = ARRAY_SIZE(battery_supplied_to);
+
+	if (power_supply_register(&pdev->dev, &pchg->charger))
+		return -EPERM;
+
+	pchg->battery.name = BATTERY_NAME;
+	pchg->battery.type = POWER_SUPPLY_TYPE_BATTERY;
+	pchg->battery.properties = lp8788_battery_prop;
+	pchg->battery.num_properties = ARRAY_SIZE(lp8788_battery_prop);
+	pchg->battery.get_property = lp8788_battery_get_property;
+
+	if (power_supply_register(&pdev->dev, &pchg->battery))
+		return -EPERM;
+
+	return 0;
+}
+
+static void lp8788_unregister_psy(struct lp8788_charger *pchg)
+{
+	power_supply_unregister(&pchg->battery);
+	power_supply_unregister(&pchg->charger);
+}
+
+static void lp8788_charger_event(struct work_struct *work)
+{
+	struct lp8788_charger *pchg =
+		container_of(work, struct lp8788_charger, charger_work);
+	struct lp8788 *lp = pchg->lp;
+	struct lp8788_charger_platform_data *pdata = lp->pdata->chg_pdata;
+	enum lp8788_charger_event event = lp8788_is_charger_detected(lp);
+
+	pdata->charger_event(lp, event);
+}
+
+static irqreturn_t lp8788_charger_irq_thread(int irq, void *ptr)
+{
+	struct lp8788_charger *pchg = ptr;
+	struct lp8788 *lp = pchg->lp;
+	struct lp8788_charger_platform_data *pdata;
+	enum lp8788_int_id id;
+
+	if (!lp->pdata || !lp->pdata->chg_pdata)
+		goto irq_handled;
+
+	pdata = lp->pdata->chg_pdata;
+	id = irq - lp->pdata->irq_base;
+
+	switch (id) {
+	case LP8788_INT_CHG_INPUT_STATE:
+	case LP8788_INT_CHG_STATE:
+	case LP8788_INT_EOC:
+	case LP8788_INT_BATT_LOW:
+	case LP8788_INT_NO_BATT:
+		power_supply_changed(&pchg->charger);
+		power_supply_changed(&pchg->battery);
+		break;
+	default:
+		break;
+	}
+
+	/* report charger dectection event if used */
+	if (pdata && pdata->charger_event)
+		if (id == LP8788_INT_CHG_INPUT_STATE)
+			schedule_work(&pchg->charger_work);
+
+irq_handled:
+	return IRQ_HANDLED;
+}
+
+static int lp8788_set_irqs(struct platform_device *pdev,
+			struct lp8788_charger *pchg, const char *name)
+{
+	int irq_start, irq_end, ret, i;
+	struct resource *r;
+
+	/* no error even if no irq resource */
+	r = platform_get_resource_byname(pdev, IORESOURCE_IRQ, name);
+	if (!r)
+		return 0;
+
+	irq_start = r->start;
+	irq_end = r->end;
+
+	for (i = irq_start ; i <= irq_end ; i++) {
+		ret = request_threaded_irq(i, NULL, lp8788_charger_irq_thread,
+					0, name, pchg);
+		if (ret)
+			break;
+	}
+
+	if (i <= irq_end)
+		goto err_free_irq;
+
+	return 0;
+
+err_free_irq:
+	while (--i >= irq_start)
+		free_irq(i, pchg);
+	return ret;
+}
+
+static void lp8788_free_irqs(struct platform_device *pdev,
+				struct lp8788_charger *pchg,
+				const char *name)
+{
+	int irq_start, irq_end, i;
+	struct resource *r;
+
+	r = platform_get_resource_byname(pdev, IORESOURCE_IRQ, name);
+	if (!r)
+		return;
+
+	irq_start = r->start;
+	irq_end = r->end;
+
+	for (i = irq_start ; i <= irq_end ; i++)
+		free_irq(i, pchg);
+}
+
+static int lp8788_irq_register(struct platform_device *pdev,
+				struct lp8788_charger *pchg)
+{
+	int ret, i;
+	struct lp8788 *lp = pchg->lp;
+	const char *name[] = {
+		LP8788_CHG_IRQ, LP8788_PRSW_IRQ, LP8788_BATT_IRQ
+	};
+
+	if (!lp->pdata) {
+		dev_warn(lp->dev, "no platform data for charger irq\n");
+		return 0;
+	}
+
+	INIT_WORK(&pchg->charger_work, lp8788_charger_event);
+
+	for (i = 0 ; i < ARRAY_SIZE(name) ; i++) {
+		ret = lp8788_set_irqs(pdev, pchg, name[i]);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static void lp8788_irq_unregister(struct platform_device *pdev,
+				struct lp8788_charger *pchg)
+{
+	int i;
+	struct lp8788 *lp = pchg->lp;
+	const char *name[] = {
+		LP8788_CHG_IRQ, LP8788_PRSW_IRQ, LP8788_BATT_IRQ
+	};
+
+	if (!lp->pdata)
+		return;
+
+	for (i = 0 ; i < ARRAY_SIZE(name) ; i++)
+		lp8788_free_irqs(pdev, pchg, name[i]);
+}
+
+static ssize_t lp8788_show_charger_status(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct lp8788_charger *pchg = dev_get_drvdata(dev);
+	enum lp8788_charging_state state;
+	char *desc[MAX_CHG_STATE] = {
+		[OFF] = "CHARGER OFF",
+		[WARM_UP] = "WARM UP",
+		[LOW_INPUT] = "LOW INPUT STATE",
+		[PRECHARGE] = "CHARGING - PRECHARGE",
+		[CC] = "CHARGING - CC",
+		[CV] = "CHARGING - CV",
+		[MAINTENANCE] = "NO CHARGING - MAINTENANCE",
+		[BATTERY_FAULT] = "BATTERY FAULT",
+		[SYSTEM_SUPPORT] = "SYSTEM SUPPORT",
+		[HIGH_CURRENT] = "HIGH CURRENT",
+	};
+	u8 data;
+
+	lp8788_read_byte(pchg->lp, LP8788_CHG_STATUS, &data);
+	state = (data & LP8788_CHG_STATE_M) >> LP8788_CHG_STATE_S;
+
+	return scnprintf(buf, BUF_SIZE, "%s\n", desc[state]);
+}
+
+static ssize_t lp8788_show_idcin(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct lp8788_charger *pchg = dev_get_drvdata(dev);
+	int isel;
+	u8 val;
+
+	lp8788_read_byte(pchg->lp, LP8788_CHG_IDCIN, &val);
+	isel = LP8788_ISEL_STEP * (min_t(int, val, LP8788_ISEL_MAX) + 1);
+
+	return scnprintf(buf, BUF_SIZE,
+			"Charger Input Current Limit: %dmA\n", isel);
+}
+
+static ssize_t lp8788_show_ibatt(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct lp8788_charger *pchg = dev_get_drvdata(dev);
+	int isel;
+	u8 val;
+
+	lp8788_read_byte(pchg->lp, LP8788_CHG_IBATT, &val);
+	val &= LP8788_CHG_IBATT_M;
+	isel = LP8788_ISEL_STEP * (min_t(int, val, LP8788_ISEL_MAX) + 1);
+
+	return scnprintf(buf, BUF_SIZE,
+			"Battery Charging Current: %dmA\n", isel);
+}
+
+static ssize_t lp8788_show_vterm(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct lp8788_charger *pchg = dev_get_drvdata(dev);
+	int vsel;
+	u8 val;
+
+	lp8788_read_byte(pchg->lp, LP8788_CHG_VTERM, &val);
+	val &= LP8788_CHG_VTERM_M;
+	vsel = LP8788_VTERM_MIN + LP8788_VTERM_STEP * val;
+
+	return scnprintf(buf, BUF_SIZE,
+			"Charger Termination Voltage: %dmV\n", vsel);
+}
+
+static ssize_t lp8788_show_eoc_time(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct lp8788_charger *pchg = dev_get_drvdata(dev);
+	char *stime[] = { "400ms", "5min", "10min", "15min",
+			"20min", "25min", "30min" "No timeout" };
+	u8 val;
+
+	lp8788_read_byte(pchg->lp, LP8788_CHG_EOC, &val);
+	val = (val & LP8788_CHG_EOC_TIME_M) >> LP8788_CHG_EOC_TIME_S;
+
+	return scnprintf(buf, BUF_SIZE, "End Of Charge Time: %s\n", stime[val]);
+}
+
+static ssize_t lp8788_show_eoc_level(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct lp8788_charger *pchg = dev_get_drvdata(dev);
+	char *abs_level[] = { "25mA", "49mA", "75mA", "98mA" };
+	char *relative_level[] = { "5%", "10%", "15%", "20%" };
+	char *level;
+	u8 val, mode;
+
+	lp8788_read_byte(pchg->lp, LP8788_CHG_EOC, &val);
+
+	mode = val & LP8788_CHG_EOC_MODE_M;
+	val = (val & LP8788_CHG_EOC_LEVEL_M) >> LP8788_CHG_EOC_LEVEL_S;
+	level = mode ? abs_level[val] : relative_level[val];
+
+	return scnprintf(buf, BUF_SIZE, "End Of Charge Level: %s\n", level);
+}
+
+static DEVICE_ATTR(charger_status, S_IRUSR, lp8788_show_charger_status, NULL);
+static DEVICE_ATTR(idcin, S_IRUSR, lp8788_show_idcin, NULL);
+static DEVICE_ATTR(ibatt, S_IRUSR, lp8788_show_ibatt, NULL);
+static DEVICE_ATTR(vterm, S_IRUSR, lp8788_show_vterm, NULL);
+static DEVICE_ATTR(eoc_time, S_IRUSR, lp8788_show_eoc_time, NULL);
+static DEVICE_ATTR(eoc_level, S_IRUSR, lp8788_show_eoc_level, NULL);
+
+static struct attribute *lp8788_charger_attr[] = {
+	&dev_attr_charger_status.attr,
+	&dev_attr_idcin.attr,
+	&dev_attr_ibatt.attr,
+	&dev_attr_vterm.attr,
+	&dev_attr_eoc_time.attr,
+	&dev_attr_eoc_level.attr,
+	NULL,
+};
+
+static const struct attribute_group lp8788_attr_group = {
+	.attrs = lp8788_charger_attr,
+};
+
+static __devinit int lp8788_charger_probe(struct platform_device *pdev)
+{
+	struct lp8788 *lp = dev_get_drvdata(pdev->dev.parent);
+	struct lp8788_charger *pchg;
+	int ret;
+
+	pchg = devm_kzalloc(lp->dev, sizeof(struct lp8788_charger), GFP_KERNEL);
+	if (!pchg)
+		return -ENOMEM;
+
+	pchg->lp = lp;
+	platform_set_drvdata(pdev, pchg);
+
+	ret = lp8788_update_charger_params(pchg);
+	if (ret)
+		return ret;
+
+	ret = lp8788_psy_register(pdev, pchg);
+	if (ret)
+		return ret;
+
+	ret = lp8788_irq_register(pdev, pchg);
+	if (ret)
+		dev_warn(lp->dev, "failed to register charger irq: %d\n", ret);
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &lp8788_attr_group);
+	if (ret)
+		goto err_unregister_psy;
+
+	return 0;
+
+err_unregister_psy:
+	lp8788_unregister_psy(pchg);
+	return ret;
+}
+
+static int __devexit lp8788_charger_remove(struct platform_device *pdev)
+{
+	struct lp8788_charger *pchg = platform_get_drvdata(pdev);
+
+	sysfs_remove_group(&pdev->dev.kobj, &lp8788_attr_group);
+	lp8788_irq_unregister(pdev, pchg);
+
+	if (pchg->charger_work.func)
+		cancel_work_sync(&pchg->charger_work);
+
+	lp8788_unregister_psy(pchg);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver lp8788_charger_driver = {
+	.probe = lp8788_charger_probe,
+	.remove = __devexit_p(lp8788_charger_remove),
+	.driver = {
+		.name = LP8788_DEV_CHARGER,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init lp8788_charger_init(void)
+{
+	return platform_driver_register(&lp8788_charger_driver);
+}
+module_init(lp8788_charger_init);
+
+static void __exit lp8788_charger_exit(void)
+{
+	platform_driver_unregister(&lp8788_charger_driver);
+}
+module_exit(lp8788_charger_exit);
+
+MODULE_DESCRIPTION("TI LP8788 Charger Driver");
+MODULE_AUTHOR("Milo Kim");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:lp8788-charger");
-- 
1.7.2.5


Best Regards,
Milo


