Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2AEKFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 05:05:01 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:55285 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab2AEKE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 05:04:57 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-bd-4f0575c75281
From: Donggeun Kim <dg77.kim@samsung.com>
To: linux-input@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        dg77.kim@samsung.com
Subject: [PATCH 1/2] mfd: add platform data for MAX8997 haptic driver
Date: Thu, 05 Jan 2012 19:04:35 +0900
Message-id: <1325757876-17659-2-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1325757876-17659-1-git-send-email-dg77.kim@samsung.com>
References: <1325757876-17659-1-git-send-email-dg77.kim@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX8997 device does not support haptic function of it.
This patch adds platform data for MAX8997 haptic driver.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/mfd/max8997.h |   53 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/include/linux/mfd/max8997.h b/include/linux/mfd/max8997.h
index fff5905..9d8006b 100644
--- a/include/linux/mfd/max8997.h
+++ b/include/linux/mfd/max8997.h
@@ -153,6 +153,55 @@ struct max8997_led_platform_data {
 	u8 brightness[2];
 };
 
+enum max8997_haptic_motor_type {
+	MAX8997_HAPTIC_ERM,
+	MAX8997_HAPTIC_LRA,
+};
+
+enum max8997_haptic_pulse_mode {
+	MAX8997_EXTERNAL_MODE,
+	MAX8997_INTERNAL_MODE,
+};
+
+enum max8997_haptic_pwm_divisor {
+	MAX8997_PWM_DIVISOR_32,
+	MAX8997_PWM_DIVISOR_64,
+	MAX8997_PWM_DIVISOR_128,
+	MAX8997_PWM_DIVISOR_256,
+};
+
+/*
+ * max8997_haptic_platform_data
+ * @pwm_channel_id: channel number of PWM device
+ *		    valid for MAX8997_EXTERNAL_MODE
+ * @pwm_period: period in nano second for PWM device
+ *		valid for MAX8997_EXTERNAL_MODE
+ * @type: motor type
+ * @mode: pulse mode
+ *     MAX8997_EXTERNAL_MODE: external PWM device is used to control motor
+ *     MAX8997_INTERNAL_MODE: internal pulse generator is used to control motor
+ * @pwm_divisor: divisor for external PWM device
+ * @internal_mode_pattern: internal mode pattern for internal mode
+ *     [0 - 3]: valid pattern number
+ * @pattern_cycle: the number of cycles of the waveform
+ *		   for the internal mode pattern
+ *     [0 - 15]: available cycles
+ * @pattern_signal_period: period of the waveform for the internal mode pattern
+ *     [0 - 255]: available period
+ */
+struct max8997_haptic_platform_data {
+	int pwm_channel_id;
+	int pwm_period;
+
+	enum max8997_haptic_motor_type type;
+	enum max8997_haptic_pulse_mode mode;
+	enum max8997_haptic_pwm_divisor pwm_divisor;
+
+	int internal_mode_pattern;
+	int pattern_cycle;
+	int pattern_signal_period;
+};
+
 struct max8997_platform_data {
 	/* IRQ */
 	int irq_base;
@@ -192,7 +241,9 @@ struct max8997_platform_data {
 	/* ---- MUIC ---- */
 	struct max8997_muic_platform_data *muic_pdata;
 
-	/* HAPTIC: Not implemented */
+	/* ---- HAPTIC ---- */
+	struct max8997_haptic_platform_data *haptic_pdata;
+
 	/* RTC: Not implemented */
 	/* ---- LED ---- */
 	struct max8997_led_platform_data *led_pdata;
-- 
1.7.4.1

