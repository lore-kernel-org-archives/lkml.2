Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1GZSGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:06:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54060 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751620Ab1GZSGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:06:23 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/5] mfd: Provide regmap register readback info from wm831x driver
Date: Tue, 26 Jul 2011 19:06:16 +0100
Message-Id: <1311703576-7955-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311703576-7955-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1311703576-7955-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets us see the register map in debugfs.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c |  182 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 182 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 578e0c2..dbc0520 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -161,6 +161,185 @@ int wm831x_reg_unlock(struct wm831x *wm831x)
 }
 EXPORT_SYMBOL_GPL(wm831x_reg_unlock);
 
+static bool wm831x_reg_readable(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case WM831X_RESET_ID:
+	case WM831X_REVISION:
+	case WM831X_PARENT_ID:
+	case WM831X_SYSVDD_CONTROL:
+	case WM831X_THERMAL_MONITORING:
+	case WM831X_POWER_STATE:
+	case WM831X_WATCHDOG:
+	case WM831X_ON_PIN_CONTROL:
+	case WM831X_RESET_CONTROL:
+	case WM831X_CONTROL_INTERFACE:
+	case WM831X_SECURITY_KEY:
+	case WM831X_SOFTWARE_SCRATCH:
+	case WM831X_OTP_CONTROL:
+	case WM831X_GPIO_LEVEL:
+	case WM831X_SYSTEM_STATUS:
+	case WM831X_ON_SOURCE:
+	case WM831X_OFF_SOURCE:
+	case WM831X_SYSTEM_INTERRUPTS:
+	case WM831X_INTERRUPT_STATUS_1:
+	case WM831X_INTERRUPT_STATUS_2:
+	case WM831X_INTERRUPT_STATUS_3:
+	case WM831X_INTERRUPT_STATUS_4:
+	case WM831X_INTERRUPT_STATUS_5:
+	case WM831X_IRQ_CONFIG:
+	case WM831X_SYSTEM_INTERRUPTS_MASK:
+	case WM831X_INTERRUPT_STATUS_1_MASK:
+	case WM831X_INTERRUPT_STATUS_2_MASK:
+	case WM831X_INTERRUPT_STATUS_3_MASK:
+	case WM831X_INTERRUPT_STATUS_4_MASK:
+	case WM831X_INTERRUPT_STATUS_5_MASK:
+	case WM831X_RTC_WRITE_COUNTER:
+	case WM831X_RTC_TIME_1:
+	case WM831X_RTC_TIME_2:
+	case WM831X_RTC_ALARM_1:
+	case WM831X_RTC_ALARM_2:
+	case WM831X_RTC_CONTROL:
+	case WM831X_RTC_TRIM:
+	case WM831X_TOUCH_CONTROL_1:
+	case WM831X_TOUCH_CONTROL_2:
+	case WM831X_TOUCH_DATA_X:
+	case WM831X_TOUCH_DATA_Y:
+	case WM831X_TOUCH_DATA_Z:
+	case WM831X_AUXADC_DATA:
+	case WM831X_AUXADC_CONTROL:
+	case WM831X_AUXADC_SOURCE:
+	case WM831X_COMPARATOR_CONTROL:
+	case WM831X_COMPARATOR_1:
+	case WM831X_COMPARATOR_2:
+	case WM831X_COMPARATOR_3:
+	case WM831X_COMPARATOR_4:
+	case WM831X_GPIO1_CONTROL:
+	case WM831X_GPIO2_CONTROL:
+	case WM831X_GPIO3_CONTROL:
+	case WM831X_GPIO4_CONTROL:
+	case WM831X_GPIO5_CONTROL:
+	case WM831X_GPIO6_CONTROL:
+	case WM831X_GPIO7_CONTROL:
+	case WM831X_GPIO8_CONTROL:
+	case WM831X_GPIO9_CONTROL:
+	case WM831X_GPIO10_CONTROL:
+	case WM831X_GPIO11_CONTROL:
+	case WM831X_GPIO12_CONTROL:
+	case WM831X_GPIO13_CONTROL:
+	case WM831X_GPIO14_CONTROL:
+	case WM831X_GPIO15_CONTROL:
+	case WM831X_GPIO16_CONTROL:
+	case WM831X_CHARGER_CONTROL_1:
+	case WM831X_CHARGER_CONTROL_2:
+	case WM831X_CHARGER_STATUS:
+	case WM831X_BACKUP_CHARGER_CONTROL:
+	case WM831X_STATUS_LED_1:
+	case WM831X_STATUS_LED_2:
+	case WM831X_CURRENT_SINK_1:
+	case WM831X_CURRENT_SINK_2:
+	case WM831X_DCDC_ENABLE:
+	case WM831X_LDO_ENABLE:
+	case WM831X_DCDC_STATUS:
+	case WM831X_LDO_STATUS:
+	case WM831X_DCDC_UV_STATUS:
+	case WM831X_LDO_UV_STATUS:
+	case WM831X_DC1_CONTROL_1:
+	case WM831X_DC1_CONTROL_2:
+	case WM831X_DC1_ON_CONFIG:
+	case WM831X_DC1_SLEEP_CONTROL:
+	case WM831X_DC1_DVS_CONTROL:
+	case WM831X_DC2_CONTROL_1:
+	case WM831X_DC2_CONTROL_2:
+	case WM831X_DC2_ON_CONFIG:
+	case WM831X_DC2_SLEEP_CONTROL:
+	case WM831X_DC2_DVS_CONTROL:
+	case WM831X_DC3_CONTROL_1:
+	case WM831X_DC3_CONTROL_2:
+	case WM831X_DC3_ON_CONFIG:
+	case WM831X_DC3_SLEEP_CONTROL:
+	case WM831X_DC4_CONTROL:
+	case WM831X_DC4_SLEEP_CONTROL:
+	case WM831X_EPE1_CONTROL:
+	case WM831X_EPE2_CONTROL:
+	case WM831X_LDO1_CONTROL:
+	case WM831X_LDO1_ON_CONTROL:
+	case WM831X_LDO1_SLEEP_CONTROL:
+	case WM831X_LDO2_CONTROL:
+	case WM831X_LDO2_ON_CONTROL:
+	case WM831X_LDO2_SLEEP_CONTROL:
+	case WM831X_LDO3_CONTROL:
+	case WM831X_LDO3_ON_CONTROL:
+	case WM831X_LDO3_SLEEP_CONTROL:
+	case WM831X_LDO4_CONTROL:
+	case WM831X_LDO4_ON_CONTROL:
+	case WM831X_LDO4_SLEEP_CONTROL:
+	case WM831X_LDO5_CONTROL:
+	case WM831X_LDO5_ON_CONTROL:
+	case WM831X_LDO5_SLEEP_CONTROL:
+	case WM831X_LDO6_CONTROL:
+	case WM831X_LDO6_ON_CONTROL:
+	case WM831X_LDO6_SLEEP_CONTROL:
+	case WM831X_LDO7_CONTROL:
+	case WM831X_LDO7_ON_CONTROL:
+	case WM831X_LDO7_SLEEP_CONTROL:
+	case WM831X_LDO8_CONTROL:
+	case WM831X_LDO8_ON_CONTROL:
+	case WM831X_LDO8_SLEEP_CONTROL:
+	case WM831X_LDO9_CONTROL:
+	case WM831X_LDO9_ON_CONTROL:
+	case WM831X_LDO9_SLEEP_CONTROL:
+	case WM831X_LDO10_CONTROL:
+	case WM831X_LDO10_ON_CONTROL:
+	case WM831X_LDO10_SLEEP_CONTROL:
+	case WM831X_LDO11_ON_CONTROL:
+	case WM831X_LDO11_SLEEP_CONTROL:
+	case WM831X_POWER_GOOD_SOURCE_1:
+	case WM831X_POWER_GOOD_SOURCE_2:
+	case WM831X_CLOCK_CONTROL_1:
+	case WM831X_CLOCK_CONTROL_2:
+	case WM831X_FLL_CONTROL_1:
+	case WM831X_FLL_CONTROL_2:
+	case WM831X_FLL_CONTROL_3:
+	case WM831X_FLL_CONTROL_4:
+	case WM831X_FLL_CONTROL_5:
+	case WM831X_UNIQUE_ID_1:
+	case WM831X_UNIQUE_ID_2:
+	case WM831X_UNIQUE_ID_3:
+	case WM831X_UNIQUE_ID_4:
+	case WM831X_UNIQUE_ID_5:
+	case WM831X_UNIQUE_ID_6:
+	case WM831X_UNIQUE_ID_7:
+	case WM831X_UNIQUE_ID_8:
+	case WM831X_FACTORY_OTP_ID:
+	case WM831X_FACTORY_OTP_1:
+	case WM831X_FACTORY_OTP_2:
+	case WM831X_FACTORY_OTP_3:
+	case WM831X_FACTORY_OTP_4:
+	case WM831X_FACTORY_OTP_5:
+	case WM831X_CUSTOMER_OTP_ID:
+	case WM831X_DC1_OTP_CONTROL:
+	case WM831X_DC2_OTP_CONTROL:
+	case WM831X_DC3_OTP_CONTROL:
+	case WM831X_LDO1_2_OTP_CONTROL:
+	case WM831X_LDO3_4_OTP_CONTROL:
+	case WM831X_LDO5_6_OTP_CONTROL:
+	case WM831X_LDO7_8_OTP_CONTROL:
+	case WM831X_LDO9_10_OTP_CONTROL:
+	case WM831X_LDO11_EPE_CONTROL:
+	case WM831X_GPIO1_OTP_CONTROL:
+	case WM831X_GPIO2_OTP_CONTROL:
+	case WM831X_GPIO3_OTP_CONTROL:
+	case WM831X_GPIO4_OTP_CONTROL:
+	case WM831X_GPIO5_OTP_CONTROL:
+	case WM831X_GPIO6_OTP_CONTROL:
+	case WM831X_DBE_CHECK_DATA:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /**
  * wm831x_reg_read: Read a single WM831x register.
  *
@@ -1254,6 +1433,9 @@ static struct mfd_cell backlight_devs[] = {
 struct regmap_config wm831x_regmap_config = {
 	.reg_bits = 16,
 	.val_bits = 16,
+
+	.max_register = WM831X_DBE_CHECK_DATA,
+	.readable_reg = wm831x_reg_readable,
 };
 EXPORT_SYMBOL_GPL(wm831x_regmap_config);
 
-- 
1.7.5.4

