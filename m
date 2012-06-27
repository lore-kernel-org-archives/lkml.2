Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab2F0OKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:10:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57103 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756482Ab2F0OKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:10:18 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/4] regulator: fixed: Set enable enable_time in regulator_desc
Date: Wed, 27 Jun 2012 15:10:10 +0100
Message-Id: <1340806212-30457-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340806212-30457-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1340806212-30457-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/fixed.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 8bda365..f7b2642 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -36,7 +36,6 @@ struct fixed_voltage_data {
 	struct regulator_dev *dev;
 	int microvolts;
 	int gpio;
-	unsigned startup_delay;
 	bool enable_high;
 	bool is_enabled;
 };
@@ -123,13 +122,6 @@ static int fixed_voltage_disable(struct regulator_dev *dev)
 	return 0;
 }
 
-static int fixed_voltage_enable_time(struct regulator_dev *dev)
-{
-	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
-
-	return data->startup_delay;
-}
-
 static int fixed_voltage_get_voltage(struct regulator_dev *dev)
 {
 	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
@@ -155,7 +147,6 @@ static struct regulator_ops fixed_voltage_gpio_ops = {
 	.is_enabled = fixed_voltage_is_enabled,
 	.enable = fixed_voltage_enable,
 	.disable = fixed_voltage_disable,
-	.enable_time = fixed_voltage_enable_time,
 	.get_voltage = fixed_voltage_get_voltage,
 	.list_voltage = fixed_voltage_list_voltage,
 };
@@ -197,12 +188,13 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 	drvdata->desc.type = REGULATOR_VOLTAGE;
 	drvdata->desc.owner = THIS_MODULE;
 
+	drvdata->desc.enable_time = config->startup_delay;
+
 	if (config->microvolts)
 		drvdata->desc.n_voltages = 1;
 
 	drvdata->microvolts = config->microvolts;
 	drvdata->gpio = config->gpio;
-	drvdata->startup_delay = config->startup_delay;
 
 	if (gpio_is_valid(config->gpio)) {
 		int gpio_flag;
-- 
1.7.10

