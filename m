Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab3AGTSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 14:18:55 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:49066 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab3AGTSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 14:18:54 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: lm-sensors@lm-sensors.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: [PATCH] hwmon: (sht15) avoid CamelCase
Date: Mon,  7 Jan 2013 14:18:38 -0500
Message-Id: <1357586319-2089-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames the supply_uV* variables to supply_uv* to avoid
CamelCase as warned by the checkpatch.pl script.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 drivers/hwmon/sht15.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index 1c85d39..9a594e6 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -139,12 +139,12 @@ static const u8 sht15_crc8_table[] = {
  * @reg:		associated regulator (if specified).
  * @nb:			notifier block to handle notifications of voltage
  *                      changes.
- * @supply_uV:		local copy of supply voltage used to allow use of
+ * @supply_uv:		local copy of supply voltage used to allow use of
  *                      regulator consumer if available.
- * @supply_uV_valid:	indicates that an updated value has not yet been
+ * @supply_uv_valid:	indicates that an updated value has not yet been
  *			obtained from the regulator and so any calculations
  *			based upon it will be invalid.
- * @update_supply_work:	work struct that is used to update the supply_uV.
+ * @update_supply_work:	work struct that is used to update the supply_uv.
  * @interrupt_handled:	flag used to indicate a handler has been scheduled.
  */
 struct sht15_data {
@@ -166,8 +166,8 @@ struct sht15_data {
 	struct device			*hwmon_dev;
 	struct regulator		*reg;
 	struct notifier_block		nb;
-	int				supply_uV;
-	bool				supply_uV_valid;
+	int				supply_uv;
+	bool				supply_uv_valid;
 	struct work_struct		update_supply_work;
 	atomic_t			interrupt_handled;
 };
@@ -598,8 +598,8 @@ static inline int sht15_calc_temp(struct sht15_data *data)
 
 	for (i = ARRAY_SIZE(temppoints) - 1; i > 0; i--)
 		/* Find pointer to interpolate */
-		if (data->supply_uV > temppoints[i - 1].vdd) {
-			d1 = (data->supply_uV - temppoints[i - 1].vdd)
+		if (data->supply_uv > temppoints[i - 1].vdd) {
+			d1 = (data->supply_uv - temppoints[i - 1].vdd)
 				* (temppoints[i].d1 - temppoints[i - 1].d1)
 				/ (temppoints[i].vdd - temppoints[i - 1].vdd)
 				+ temppoints[i - 1].d1;
@@ -859,7 +859,7 @@ static void sht15_update_voltage(struct work_struct *work_s)
 	struct sht15_data *data
 		= container_of(work_s, struct sht15_data,
 			       update_supply_work);
-	data->supply_uV = regulator_get_voltage(data->reg);
+	data->supply_uv = regulator_get_voltage(data->reg);
 }
 
 /**
@@ -878,7 +878,7 @@ static int sht15_invalidate_voltage(struct notifier_block *nb,
 	struct sht15_data *data = container_of(nb, struct sht15_data, nb);
 
 	if (event == REGULATOR_EVENT_VOLTAGE_CHANGE)
-		data->supply_uV_valid = false;
+		data->supply_uv_valid = false;
 	schedule_work(&data->update_supply_work);
 
 	return NOTIFY_OK;
@@ -906,7 +906,7 @@ static int sht15_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 	data->pdata = pdev->dev.platform_data;
-	data->supply_uV = data->pdata->supply_mv * 1000;
+	data->supply_uv = data->pdata->supply_mv * 1000;
 	if (data->pdata->checksum)
 		data->checksumming = true;
 	if (data->pdata->no_otp_reload)
@@ -924,7 +924,7 @@ static int sht15_probe(struct platform_device *pdev)
 
 		voltage = regulator_get_voltage(data->reg);
 		if (voltage)
-			data->supply_uV = voltage;
+			data->supply_uv = voltage;
 
 		regulator_enable(data->reg);
 		/*
-- 
1.8.1

