Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab2IJMKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:10:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54493 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565Ab2IJMKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 08:10:34 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: NeilBrown <neilb@suse.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mfd: twl: Replace twl_has_*() macros by IS_ENABLED()
Date: Mon, 10 Sep 2012 14:10:19 +0200
Message-Id: <1347279020-15596-2-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347279020-15596-1-git-send-email-thierry.reding@avionic-design.de>
References: <1347279020-15596-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:mE8b8UElqzRhPa6ILY1VNRFZ8MAxRZWEevit8ixyPme
 JxIdRIlXnvUpsujxnWy+PBtPjFfwjL7S5J2MbAd47Sr6i3cR/Z
 tJfJ4mp5uNDUjzuJJ/JmZ1fd2JzWapMFen6zt3lUuDNYnL3BlK
 6xaKXQ8mRpkyLEvqupnBLIWMqykHWqzcw0pmOIXO+l3tZ6Qomu
 cDgbA+fxHCwA4HOeo6g+7e+W9e7JFznJuheYbkGxRlkzPq9KdF
 mnaS+ZtQvEJ0iK7gvEjKXXKdskG4paJ9tgMSquaEudo+2Cu5bs
 QC3rN6KkP1pmCkZqDhoCyrp7+mDYa6K9evMyxpfNPlmAfd0Yz/
 QHPZ22t25nTrSdNFD6D7kWghC81lawqsXQaoUW73GS6S6Uok/9
 ynm+1JlVsPq0dCmeOn3iP2EwagxFTMP7AM0p7P+djkN0gkbmuP
 3zJxE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of reinventing macros for the same purpose, use the standard
macros.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/mfd/twl-core.c | 117 +++++++++++--------------------------------------
 1 file changed, 25 insertions(+), 92 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 1c32afe..5fbb2a6 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -63,70 +63,6 @@
 
 #define DRIVER_NAME			"twl"
 
-#if defined(CONFIG_KEYBOARD_TWL4030) || defined(CONFIG_KEYBOARD_TWL4030_MODULE)
-#define twl_has_keypad()	true
-#else
-#define twl_has_keypad()	false
-#endif
-
-#if defined(CONFIG_GPIO_TWL4030) || defined(CONFIG_GPIO_TWL4030_MODULE)
-#define twl_has_gpio()	true
-#else
-#define twl_has_gpio()	false
-#endif
-
-#if defined(CONFIG_REGULATOR_TWL4030) \
-	|| defined(CONFIG_REGULATOR_TWL4030_MODULE)
-#define twl_has_regulator()	true
-#else
-#define twl_has_regulator()	false
-#endif
-
-#if defined(CONFIG_TWL4030_MADC) || defined(CONFIG_TWL4030_MADC_MODULE)
-#define twl_has_madc()	true
-#else
-#define twl_has_madc()	false
-#endif
-
-#ifdef CONFIG_TWL4030_POWER
-#define twl_has_power()        true
-#else
-#define twl_has_power()        false
-#endif
-
-#if defined(CONFIG_RTC_DRV_TWL4030) || defined(CONFIG_RTC_DRV_TWL4030_MODULE)
-#define twl_has_rtc()	true
-#else
-#define twl_has_rtc()	false
-#endif
-
-#if defined(CONFIG_TWL4030_USB) || defined(CONFIG_TWL4030_USB_MODULE) ||\
-	defined(CONFIG_TWL6030_USB) || defined(CONFIG_TWL6030_USB_MODULE)
-#define twl_has_usb()	true
-#else
-#define twl_has_usb()	false
-#endif
-
-#if defined(CONFIG_TWL4030_WATCHDOG) || \
-	defined(CONFIG_TWL4030_WATCHDOG_MODULE)
-#define twl_has_watchdog()        true
-#else
-#define twl_has_watchdog()        false
-#endif
-
-#if defined(CONFIG_MFD_TWL4030_AUDIO) || \
-	defined(CONFIG_MFD_TWL4030_AUDIO_MODULE)
-#define twl_has_codec()	true
-#else
-#define twl_has_codec()	false
-#endif
-
-#if defined(CONFIG_CHARGER_TWL4030) || defined(CONFIG_CHARGER_TWL4030_MODULE)
-#define twl_has_bci()	true
-#else
-#define twl_has_bci()	false
-#endif
-
 /* Triton Core internal information (BEGIN) */
 
 /* Last - for index max*/
@@ -134,13 +70,6 @@
 
 #define TWL_NUM_SLAVES		4
 
-#if defined(CONFIG_INPUT_TWL4030_PWRBUTTON) \
-	|| defined(CONFIG_INPUT_TWL4030_PWRBUTTON_MODULE)
-#define twl_has_pwrbutton()	true
-#else
-#define twl_has_pwrbutton()	false
-#endif
-
 #define SUB_CHIP_ID0 0
 #define SUB_CHIP_ID1 1
 #define SUB_CHIP_ID2 2
@@ -669,7 +598,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 	struct device	*child;
 	unsigned sub_chip_id;
 
-	if (twl_has_gpio() && pdata->gpio) {
+	if (IS_ENABLED(CONFIG_GPIO_TWL4030) && pdata->gpio) {
 		child = add_child(SUB_CHIP_ID1, "twl4030_gpio",
 				pdata->gpio, sizeof(*pdata->gpio),
 				false, irq_base + GPIO_INTR_OFFSET, 0);
@@ -677,7 +606,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 			return PTR_ERR(child);
 	}
 
-	if (twl_has_keypad() && pdata->keypad) {
+	if (IS_ENABLED(CONFIG_KEYBOARD_TWL4030) && pdata->keypad) {
 		child = add_child(SUB_CHIP_ID2, "twl4030_keypad",
 				pdata->keypad, sizeof(*pdata->keypad),
 				true, irq_base + KEYPAD_INTR_OFFSET, 0);
@@ -685,7 +614,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 			return PTR_ERR(child);
 	}
 
-	if (twl_has_madc() && pdata->madc) {
+	if (IS_ENABLED(CONFIG_TWL4030_MADC) && pdata->madc) {
 		child = add_child(2, "twl4030_madc",
 				pdata->madc, sizeof(*pdata->madc),
 				true, irq_base + MADC_INTR_OFFSET, 0);
@@ -693,7 +622,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 			return PTR_ERR(child);
 	}
 
-	if (twl_has_rtc()) {
+	if (IS_ENABLED(CONFIG_RTC_DRV_TWL4030)) {
 		/*
 		 * REVISIT platform_data here currently might expose the
 		 * "msecure" line ... but for now we just expect board
@@ -709,7 +638,8 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 			return PTR_ERR(child);
 	}
 
-	if (twl_has_usb() && pdata->usb && twl_class_is_4030()) {
+	if (IS_ENABLED(CONFIG_TWL4030_USB) && pdata->usb &&
+	    twl_class_is_4030()) {
 
 		static struct regulator_consumer_supply usb1v5 = {
 			.supply =	"usb1v5",
@@ -723,7 +653,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 		};
 
 	/* First add the regulators so that they can be used by transceiver */
-		if (twl_has_regulator()) {
+		if (IS_ENABLED(CONFIG_REGULATOR_TWL4030)) {
 			/* this is a template that gets copied */
 			struct regulator_init_data usb_fixed = {
 				.constraints.valid_modes_mask =
@@ -765,18 +695,19 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 			return PTR_ERR(child);
 
 		/* we need to connect regulators to this transceiver */
-		if (twl_has_regulator() && child) {
+		if (IS_ENABLED(CONFIG_REGULATOR_TWL4030) && child) {
 			usb1v5.dev_name = dev_name(child);
 			usb1v8.dev_name = dev_name(child);
 			usb3v1[0].dev_name = dev_name(child);
 		}
 	}
-	if (twl_has_usb() && pdata->usb && twl_class_is_6030()) {
+	if (IS_ENABLED(CONFIG_TWL6030_USB) && pdata->usb &&
+	    twl_class_is_6030()) {
 
 		static struct regulator_consumer_supply usb3v3;
 		int regulator;
 
-		if (twl_has_regulator()) {
+		if (IS_ENABLED(CONFIG_REGULATOR_TWL4030)) {
 			/* this is a template that gets copied */
 			struct regulator_init_data usb_fixed = {
 				.constraints.valid_modes_mask =
@@ -813,9 +744,10 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 		/* we need to connect regulators to this transceiver */
-		if (twl_has_regulator() && child)
+		if (IS_ENABLED(CONFIG_REGULATOR_TWL4030) && child)
 			usb3v3.dev_name = dev_name(child);
-	} else if (twl_has_regulator() && twl_class_is_6030()) {
+	} else if (IS_ENABLED(CONFIG_REGULATOR_TWL4030) &&
+		   twl_class_is_6030()) {
 		if (features & TWL6025_SUBCLASS)
 			child = add_regulator(TWL6025_REG_LDOUSB,
 						pdata->ldousb, features);
@@ -827,20 +759,21 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 					return PTR_ERR(child);
 	}
 
-	if (twl_has_watchdog() && twl_class_is_4030()) {
+	if (IS_ENABLED(CONFIG_TWL4030_WATCHDOG) && twl_class_is_4030()) {
 		child = add_child(0, "twl4030_wdt", NULL, 0, false, 0, 0);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 	}
 
-	if (twl_has_pwrbutton() && twl_class_is_4030()) {
+	if (IS_ENABLED(CONFIG_INPUT_TWL4030_PWRBUTTON) && twl_class_is_4030()) {
 		child = add_child(1, "twl4030_pwrbutton",
 				NULL, 0, true, irq_base + 8 + 0, 0);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 	}
 
-	if (twl_has_codec() && pdata->audio && twl_class_is_4030()) {
+	if (IS_ENABLED(CONFIG_MFD_TWL4030_AUDIO) && pdata->audio &&
+	    twl_class_is_4030()) {
 		sub_chip_id = twl_map[TWL_MODULE_AUDIO_VOICE].sid;
 		child = add_child(sub_chip_id, "twl4030-audio",
 				pdata->audio, sizeof(*pdata->audio),
@@ -850,7 +783,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 	}
 
 	/* twl4030 regulators */
-	if (twl_has_regulator() && twl_class_is_4030()) {
+	if (IS_ENABLED(CONFIG_REGULATOR_TWL4030) && twl_class_is_4030()) {
 		child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1,
 					features);
 		if (IS_ERR(child))
@@ -905,7 +838,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 	}
 
 	/* maybe add LDOs that are omitted on cost-reduced parts */
-	if (twl_has_regulator() && !(features & TPS_SUBSET)
+	if (IS_ENABLED(CONFIG_REGULATOR_TWL4030) && !(features & TPS_SUBSET)
 	  && twl_class_is_4030()) {
 		child = add_regulator(TWL4030_REG_VPLL2, pdata->vpll2,
 					features);
@@ -939,7 +872,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 	}
 
 	/* twl6030 regulators */
-	if (twl_has_regulator() && twl_class_is_6030() &&
+	if (IS_ENABLED(CONFIG_REGULATOR_TWL4030) && twl_class_is_6030() &&
 			!(features & TWL6025_SUBCLASS)) {
 		child = add_regulator(TWL6030_REG_VDD1, pdata->vdd1,
 					features);
@@ -1013,7 +946,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 	}
 
 	/* 6030 and 6025 share this regulator */
-	if (twl_has_regulator() && twl_class_is_6030()) {
+	if (IS_ENABLED(CONFIG_REGULATOR_TWL4030) && twl_class_is_6030()) {
 		child = add_regulator(TWL6030_REG_VANA, pdata->vana,
 					features);
 		if (IS_ERR(child))
@@ -1021,7 +954,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 	}
 
 	/* twl6025 regulators */
-	if (twl_has_regulator() && twl_class_is_6030() &&
+	if (IS_ENABLED(CONFIG_REGULATOR_TWL4030) && twl_class_is_6030() &&
 			(features & TWL6025_SUBCLASS)) {
 		child = add_regulator(TWL6025_REG_LDO5, pdata->ldo5,
 					features);
@@ -1080,7 +1013,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 
 	}
 
-	if (twl_has_bci() && pdata->bci &&
+	if (IS_ENABLED(CONFIG_CHARGER_TWL4030) && pdata->bci &&
 			!(features & (TPS_SUBSET | TWL5031))) {
 		child = add_child(3, "twl4030_bci",
 				pdata->bci, sizeof(*pdata->bci), false,
@@ -1292,7 +1225,7 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	/* load power event scripts */
-	if (twl_has_power() && pdata->power)
+	if (IS_ENABLED(CONFIG_TWL4030_POWER) && pdata->power)
 		twl4030_power_init(pdata->power);
 
 	/* Maybe init the T2 Interrupt subsystem */
-- 
1.7.12

