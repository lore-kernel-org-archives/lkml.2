Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096Ab0D3SOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:14:17 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:52454 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758997Ab0D3SNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:13:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eJuohhbE4kbu0oZUXUkB0SSDLHNmQfMbFyI1qti1LYq1UaN7eco/VkCkHk22KhbnfK
         rUmixGzJvCxoGfRdVDqq4psS1HGSETXP4yvNMZAYxCElJnBde0xRqZ8mE0pTaXD9mqA4
         5mCth/qq3iOosv4lAQ2M6sajP41pgPZL5TbaY=
Date: Fri, 30 Apr 2010 22:13:49 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Marek Vasut <marek.vasut@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Remove tosa_battery driver (was: Re: [PATCH] tosa_battery:
 fix FTBFS bug due to driver_data access)
Message-ID: <20100430181349.GA1015@oksana.dev.rtsoft.ru>
References: <1272374302-9506-1-git-send-email-dbaryshkov@gmail.com>
 <20100427154835.27bdc233.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100427154835.27bdc233.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 03:48:35PM -0700, Andrew Morton wrote:
> On Tue, 27 Apr 2010 17:18:22 +0400
> Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> wrote:
> 
> > Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> > ---
> >  drivers/power/tosa_battery.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> Please don't send unchangelogged patches.
> 
> Please don't send patches which require recipients to go googling
> acronyms to work out wtf you're up to.
> 
> <googles the acronym>
> 
> Ah, it appears to be a build fix.

It seems that the driver isn't buildable since 2.6.32
(i.e. commit b4028437 "Driver core: move dev_get/set_drvdata to
drivers/base/dd.c").

Also, IIRC it was deprecated in favor of wm97xx_battery.c
driver.

So, I'm not picking this patch for 2.6.34, it's not a
new regression, and the driver is probably needs to be
removed.

Any objections on the patch down below?

- - - -
>From 464e18bb5c7230daaa741d308f76cf0671be4bf2 Mon Sep 17 00:00:00 2001
From: Anton Vorontsov <cbouatmailru@gmail.com>
Date: Fri, 30 Apr 2010 21:55:58 +0400
Subject: [PATCH] Remove tosa_battery driver

- The driver is broken since commit b4028437 "Driver core: move
  dev_get/set_drvdata to drivers/base/dd.c", i.e. since 2.6.32;

- The driver isn't selected by any ARM defconfig.

- wm97xx_battery is a more generic driver, and should be suitable
  as a replacement;

So, remove the tosa_battery driver.

Signed-off-by: Anton Vorontsov <Anton Vorontsov>
---
 drivers/power/Kconfig        |    7 -
 drivers/power/Makefile       |    1 -
 drivers/power/tosa_battery.c |  486 ------------------------------------------
 3 files changed, 0 insertions(+), 494 deletions(-)
 delete mode 100644 drivers/power/tosa_battery.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index c59bcb7..058347d 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -84,13 +84,6 @@ config BATTERY_OLPC
 	help
 	  Say Y to enable support for the battery on the OLPC laptop.
 
-config BATTERY_TOSA
-	tristate "Sharp SL-6000 (tosa) battery"
-	depends on MACH_TOSA && MFD_TC6393XB && TOUCHSCREEN_WM97XX
-	help
-	  Say Y to enable support for the battery on the Sharp Zaurus
-	  SL-6000 (tosa) models.
-
 config BATTERY_COLLIE
 	tristate "Sharp SL-5500 (collie) battery"
 	depends on SA1100_COLLIE && MCP_UCB1200
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index a82f292..dd4de16 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -25,7 +25,6 @@ obj-$(CONFIG_BATTERY_DS2760)	+= ds2760_battery.o
 obj-$(CONFIG_BATTERY_DS2782)	+= ds2782_battery.o
 obj-$(CONFIG_BATTERY_PMU)	+= pmu_battery.o
 obj-$(CONFIG_BATTERY_OLPC)	+= olpc_battery.o
-obj-$(CONFIG_BATTERY_TOSA)	+= tosa_battery.o
 obj-$(CONFIG_BATTERY_COLLIE)	+= collie_battery.o
 obj-$(CONFIG_BATTERY_WM97XX)	+= wm97xx_battery.o
 obj-$(CONFIG_BATTERY_BQ27x00)	+= bq27x00_battery.o
diff --git a/drivers/power/tosa_battery.c b/drivers/power/tosa_battery.c
deleted file mode 100644
index 2eab35a..0000000
--- a/drivers/power/tosa_battery.c
+++ /dev/null
@@ -1,486 +0,0 @@
-/*
- * Battery and Power Management code for the Sharp SL-6000x
- *
- * Copyright (c) 2005 Dirk Opfer
- * Copyright (c) 2008 Dmitry Baryshkov
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/power_supply.h>
-#include <linux/wm97xx.h>
-#include <linux/delay.h>
-#include <linux/spinlock.h>
-#include <linux/interrupt.h>
-#include <linux/gpio.h>
-
-#include <asm/mach-types.h>
-#include <mach/tosa.h>
-
-static DEFINE_MUTEX(bat_lock); /* protects gpio pins */
-static struct work_struct bat_work;
-
-struct tosa_bat {
-	int status;
-	struct power_supply psy;
-	int full_chrg;
-
-	struct mutex work_lock; /* protects data */
-
-	bool (*is_present)(struct tosa_bat *bat);
-	int gpio_full;
-	int gpio_charge_off;
-
-	int technology;
-
-	int gpio_bat;
-	int adc_bat;
-	int adc_bat_divider;
-	int bat_max;
-	int bat_min;
-
-	int gpio_temp;
-	int adc_temp;
-	int adc_temp_divider;
-};
-
-static struct tosa_bat tosa_bat_main;
-static struct tosa_bat tosa_bat_jacket;
-
-static unsigned long tosa_read_bat(struct tosa_bat *bat)
-{
-	unsigned long value = 0;
-
-	if (bat->gpio_bat < 0 || bat->adc_bat < 0)
-		return 0;
-
-	mutex_lock(&bat_lock);
-	gpio_set_value(bat->gpio_bat, 1);
-	msleep(5);
-	value = wm97xx_read_aux_adc(bat->psy.dev->parent->driver_data,
-			bat->adc_bat);
-	gpio_set_value(bat->gpio_bat, 0);
-	mutex_unlock(&bat_lock);
-
-	value = value * 1000000 / bat->adc_bat_divider;
-
-	return value;
-}
-
-static unsigned long tosa_read_temp(struct tosa_bat *bat)
-{
-	unsigned long value = 0;
-
-	if (bat->gpio_temp < 0 || bat->adc_temp < 0)
-		return 0;
-
-	mutex_lock(&bat_lock);
-	gpio_set_value(bat->gpio_temp, 1);
-	msleep(5);
-	value = wm97xx_read_aux_adc(bat->psy.dev->parent->driver_data,
-			bat->adc_temp);
-	gpio_set_value(bat->gpio_temp, 0);
-	mutex_unlock(&bat_lock);
-
-	value = value * 10000 / bat->adc_temp_divider;
-
-	return value;
-}
-
-static int tosa_bat_get_property(struct power_supply *psy,
-			    enum power_supply_property psp,
-			    union power_supply_propval *val)
-{
-	int ret = 0;
-	struct tosa_bat *bat = container_of(psy, struct tosa_bat, psy);
-
-	if (bat->is_present && !bat->is_present(bat)
-			&& psp != POWER_SUPPLY_PROP_PRESENT) {
-		return -ENODEV;
-	}
-
-	switch (psp) {
-	case POWER_SUPPLY_PROP_STATUS:
-		val->intval = bat->status;
-		break;
-	case POWER_SUPPLY_PROP_TECHNOLOGY:
-		val->intval = bat->technology;
-		break;
-	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		val->intval = tosa_read_bat(bat);
-		break;
-	case POWER_SUPPLY_PROP_VOLTAGE_MAX:
-		if (bat->full_chrg == -1)
-			val->intval = bat->bat_max;
-		else
-			val->intval = bat->full_chrg;
-		break;
-	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
-		val->intval = bat->bat_max;
-		break;
-	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
-		val->intval = bat->bat_min;
-		break;
-	case POWER_SUPPLY_PROP_TEMP:
-		val->intval = tosa_read_temp(bat);
-		break;
-	case POWER_SUPPLY_PROP_PRESENT:
-		val->intval = bat->is_present ? bat->is_present(bat) : 1;
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-	return ret;
-}
-
-static bool tosa_jacket_bat_is_present(struct tosa_bat *bat)
-{
-	return gpio_get_value(TOSA_GPIO_JACKET_DETECT) == 0;
-}
-
-static void tosa_bat_external_power_changed(struct power_supply *psy)
-{
-	schedule_work(&bat_work);
-}
-
-static irqreturn_t tosa_bat_gpio_isr(int irq, void *data)
-{
-	pr_info("tosa_bat_gpio irq: %d\n", gpio_get_value(irq_to_gpio(irq)));
-	schedule_work(&bat_work);
-	return IRQ_HANDLED;
-}
-
-static void tosa_bat_update(struct tosa_bat *bat)
-{
-	int old;
-	struct power_supply *psy = &bat->psy;
-
-	mutex_lock(&bat->work_lock);
-
-	old = bat->status;
-
-	if (bat->is_present && !bat->is_present(bat)) {
-		printk(KERN_NOTICE "%s not present\n", psy->name);
-		bat->status = POWER_SUPPLY_STATUS_UNKNOWN;
-		bat->full_chrg = -1;
-	} else if (power_supply_am_i_supplied(psy)) {
-		if (bat->status == POWER_SUPPLY_STATUS_DISCHARGING) {
-			gpio_set_value(bat->gpio_charge_off, 0);
-			mdelay(15);
-		}
-
-		if (gpio_get_value(bat->gpio_full)) {
-			if (old == POWER_SUPPLY_STATUS_CHARGING ||
-					bat->full_chrg == -1)
-				bat->full_chrg = tosa_read_bat(bat);
-
-			gpio_set_value(bat->gpio_charge_off, 1);
-			bat->status = POWER_SUPPLY_STATUS_FULL;
-		} else {
-			gpio_set_value(bat->gpio_charge_off, 0);
-			bat->status = POWER_SUPPLY_STATUS_CHARGING;
-		}
-	} else {
-		gpio_set_value(bat->gpio_charge_off, 1);
-		bat->status = POWER_SUPPLY_STATUS_DISCHARGING;
-	}
-
-	if (old != bat->status)
-		power_supply_changed(psy);
-
-	mutex_unlock(&bat->work_lock);
-}
-
-static void tosa_bat_work(struct work_struct *work)
-{
-	tosa_bat_update(&tosa_bat_main);
-	tosa_bat_update(&tosa_bat_jacket);
-}
-
-
-static enum power_supply_property tosa_bat_main_props[] = {
-	POWER_SUPPLY_PROP_STATUS,
-	POWER_SUPPLY_PROP_TECHNOLOGY,
-	POWER_SUPPLY_PROP_VOLTAGE_NOW,
-	POWER_SUPPLY_PROP_VOLTAGE_MAX,
-	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
-	POWER_SUPPLY_PROP_TEMP,
-	POWER_SUPPLY_PROP_PRESENT,
-};
-
-static enum power_supply_property tosa_bat_bu_props[] = {
-	POWER_SUPPLY_PROP_STATUS,
-	POWER_SUPPLY_PROP_TECHNOLOGY,
-	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
-	POWER_SUPPLY_PROP_VOLTAGE_NOW,
-	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
-	POWER_SUPPLY_PROP_PRESENT,
-};
-
-static struct tosa_bat tosa_bat_main = {
-	.status = POWER_SUPPLY_STATUS_DISCHARGING,
-	.full_chrg = -1,
-	.psy = {
-		.name		= "main-battery",
-		.type		= POWER_SUPPLY_TYPE_BATTERY,
-		.properties	= tosa_bat_main_props,
-		.num_properties	= ARRAY_SIZE(tosa_bat_main_props),
-		.get_property	= tosa_bat_get_property,
-		.external_power_changed = tosa_bat_external_power_changed,
-		.use_for_apm	= 1,
-	},
-
-	.gpio_full = TOSA_GPIO_BAT0_CRG,
-	.gpio_charge_off = TOSA_GPIO_CHARGE_OFF,
-
-	.technology = POWER_SUPPLY_TECHNOLOGY_LIPO,
-
-	.gpio_bat = TOSA_GPIO_BAT0_V_ON,
-	.adc_bat = WM97XX_AUX_ID3,
-	.adc_bat_divider = 414,
-	.bat_max = 4310000,
-	.bat_min = 1551 * 1000000 / 414,
-
-	.gpio_temp = TOSA_GPIO_BAT1_TH_ON,
-	.adc_temp = WM97XX_AUX_ID2,
-	.adc_temp_divider = 10000,
-};
-
-static struct tosa_bat tosa_bat_jacket = {
-	.status = POWER_SUPPLY_STATUS_DISCHARGING,
-	.full_chrg = -1,
-	.psy = {
-		.name		= "jacket-battery",
-		.type		= POWER_SUPPLY_TYPE_BATTERY,
-		.properties	= tosa_bat_main_props,
-		.num_properties	= ARRAY_SIZE(tosa_bat_main_props),
-		.get_property	= tosa_bat_get_property,
-		.external_power_changed = tosa_bat_external_power_changed,
-	},
-
-	.is_present = tosa_jacket_bat_is_present,
-	.gpio_full = TOSA_GPIO_BAT1_CRG,
-	.gpio_charge_off = TOSA_GPIO_CHARGE_OFF_JC,
-
-	.technology = POWER_SUPPLY_TECHNOLOGY_LIPO,
-
-	.gpio_bat = TOSA_GPIO_BAT1_V_ON,
-	.adc_bat = WM97XX_AUX_ID3,
-	.adc_bat_divider = 414,
-	.bat_max = 4310000,
-	.bat_min = 1551 * 1000000 / 414,
-
-	.gpio_temp = TOSA_GPIO_BAT0_TH_ON,
-	.adc_temp = WM97XX_AUX_ID2,
-	.adc_temp_divider = 10000,
-};
-
-static struct tosa_bat tosa_bat_bu = {
-	.status = POWER_SUPPLY_STATUS_UNKNOWN,
-	.full_chrg = -1,
-
-	.psy = {
-		.name		= "backup-battery",
-		.type		= POWER_SUPPLY_TYPE_BATTERY,
-		.properties	= tosa_bat_bu_props,
-		.num_properties	= ARRAY_SIZE(tosa_bat_bu_props),
-		.get_property	= tosa_bat_get_property,
-		.external_power_changed = tosa_bat_external_power_changed,
-	},
-
-	.gpio_full = -1,
-	.gpio_charge_off = -1,
-
-	.technology = POWER_SUPPLY_TECHNOLOGY_LiMn,
-
-	.gpio_bat = TOSA_GPIO_BU_CHRG_ON,
-	.adc_bat = WM97XX_AUX_ID4,
-	.adc_bat_divider = 1266,
-
-	.gpio_temp = -1,
-	.adc_temp = -1,
-	.adc_temp_divider = -1,
-};
-
-static struct {
-	int gpio;
-	char *name;
-	bool output;
-	int value;
-} gpios[] = {
-	{ TOSA_GPIO_CHARGE_OFF,		"main charge off",	1, 1 },
-	{ TOSA_GPIO_CHARGE_OFF_JC,	"jacket charge off",	1, 1 },
-	{ TOSA_GPIO_BAT_SW_ON,		"battery switch",	1, 0 },
-	{ TOSA_GPIO_BAT0_V_ON,		"main battery",		1, 0 },
-	{ TOSA_GPIO_BAT1_V_ON,		"jacket battery",	1, 0 },
-	{ TOSA_GPIO_BAT1_TH_ON,		"main battery temp",	1, 0 },
-	{ TOSA_GPIO_BAT0_TH_ON,		"jacket battery temp",	1, 0 },
-	{ TOSA_GPIO_BU_CHRG_ON,		"backup battery",	1, 0 },
-	{ TOSA_GPIO_BAT0_CRG,		"main battery full",	0, 0 },
-	{ TOSA_GPIO_BAT1_CRG,		"jacket battery full",	0, 0 },
-	{ TOSA_GPIO_BAT0_LOW,		"main battery low",	0, 0 },
-	{ TOSA_GPIO_BAT1_LOW,		"jacket battery low",	0, 0 },
-	{ TOSA_GPIO_JACKET_DETECT,	"jacket detect",	0, 0 },
-};
-
-#ifdef CONFIG_PM
-static int tosa_bat_suspend(struct platform_device *dev, pm_message_t state)
-{
-	/* flush all pending status updates */
-	flush_scheduled_work();
-	return 0;
-}
-
-static int tosa_bat_resume(struct platform_device *dev)
-{
-	/* things may have changed while we were away */
-	schedule_work(&bat_work);
-	return 0;
-}
-#else
-#define tosa_bat_suspend NULL
-#define tosa_bat_resume NULL
-#endif
-
-static int __devinit tosa_bat_probe(struct platform_device *dev)
-{
-	int ret;
-	int i;
-
-	if (!machine_is_tosa())
-		return -ENODEV;
-
-	for (i = 0; i < ARRAY_SIZE(gpios); i++) {
-		ret = gpio_request(gpios[i].gpio, gpios[i].name);
-		if (ret) {
-			i--;
-			goto err_gpio;
-		}
-
-		if (gpios[i].output)
-			ret = gpio_direction_output(gpios[i].gpio,
-					gpios[i].value);
-		else
-			ret = gpio_direction_input(gpios[i].gpio);
-
-		if (ret)
-			goto err_gpio;
-	}
-
-	mutex_init(&tosa_bat_main.work_lock);
-	mutex_init(&tosa_bat_jacket.work_lock);
-
-	INIT_WORK(&bat_work, tosa_bat_work);
-
-	ret = power_supply_register(&dev->dev, &tosa_bat_main.psy);
-	if (ret)
-		goto err_psy_reg_main;
-	ret = power_supply_register(&dev->dev, &tosa_bat_jacket.psy);
-	if (ret)
-		goto err_psy_reg_jacket;
-	ret = power_supply_register(&dev->dev, &tosa_bat_bu.psy);
-	if (ret)
-		goto err_psy_reg_bu;
-
-	ret = request_irq(gpio_to_irq(TOSA_GPIO_BAT0_CRG),
-				tosa_bat_gpio_isr,
-				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
-				"main full", &tosa_bat_main);
-	if (ret)
-		goto err_req_main;
-
-	ret = request_irq(gpio_to_irq(TOSA_GPIO_BAT1_CRG),
-				tosa_bat_gpio_isr,
-				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
-				"jacket full", &tosa_bat_jacket);
-	if (ret)
-		goto err_req_jacket;
-
-	ret = request_irq(gpio_to_irq(TOSA_GPIO_JACKET_DETECT),
-				tosa_bat_gpio_isr,
-				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
-				"jacket detect", &tosa_bat_jacket);
-	if (!ret) {
-		schedule_work(&bat_work);
-		return 0;
-	}
-
-	free_irq(gpio_to_irq(TOSA_GPIO_BAT1_CRG), &tosa_bat_jacket);
-err_req_jacket:
-	free_irq(gpio_to_irq(TOSA_GPIO_BAT0_CRG), &tosa_bat_main);
-err_req_main:
-	power_supply_unregister(&tosa_bat_bu.psy);
-err_psy_reg_bu:
-	power_supply_unregister(&tosa_bat_jacket.psy);
-err_psy_reg_jacket:
-	power_supply_unregister(&tosa_bat_main.psy);
-err_psy_reg_main:
-
-	/* see comment in tosa_bat_remove */
-	flush_scheduled_work();
-
-	i--;
-err_gpio:
-	for (; i >= 0; i--)
-		gpio_free(gpios[i].gpio);
-
-	return ret;
-}
-
-static int __devexit tosa_bat_remove(struct platform_device *dev)
-{
-	int i;
-
-	free_irq(gpio_to_irq(TOSA_GPIO_JACKET_DETECT), &tosa_bat_jacket);
-	free_irq(gpio_to_irq(TOSA_GPIO_BAT1_CRG), &tosa_bat_jacket);
-	free_irq(gpio_to_irq(TOSA_GPIO_BAT0_CRG), &tosa_bat_main);
-
-	power_supply_unregister(&tosa_bat_bu.psy);
-	power_supply_unregister(&tosa_bat_jacket.psy);
-	power_supply_unregister(&tosa_bat_main.psy);
-
-	/*
-	 * now flush all pending work.
-	 * we won't get any more schedules, since all
-	 * sources (isr and external_power_changed)
-	 * are unregistered now.
-	 */
-	flush_scheduled_work();
-
-	for (i = ARRAY_SIZE(gpios) - 1; i >= 0; i--)
-		gpio_free(gpios[i].gpio);
-
-	return 0;
-}
-
-static struct platform_driver tosa_bat_driver = {
-	.driver.name	= "wm97xx-battery",
-	.driver.owner	= THIS_MODULE,
-	.probe		= tosa_bat_probe,
-	.remove		= __devexit_p(tosa_bat_remove),
-	.suspend	= tosa_bat_suspend,
-	.resume		= tosa_bat_resume,
-};
-
-static int __init tosa_bat_init(void)
-{
-	return platform_driver_register(&tosa_bat_driver);
-}
-
-static void __exit tosa_bat_exit(void)
-{
-	platform_driver_unregister(&tosa_bat_driver);
-}
-
-module_init(tosa_bat_init);
-module_exit(tosa_bat_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Dmitry Baryshkov");
-MODULE_DESCRIPTION("Tosa battery driver");
-MODULE_ALIAS("platform:wm97xx-battery");
-- 
1.7.0.5

