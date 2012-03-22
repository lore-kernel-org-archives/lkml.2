Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133Ab2CVXKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 19:10:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61204 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760105Ab2CVXKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 19:10:36 -0400
Message-ID: <1332457828.9382.0.camel@phoenix>
Subject: [PATCH 1/2] regulator: Convert tps6524x to set_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Cyril Chemparathy <cyril@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 23 Mar 2012 07:10:28 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6524x-regulator.c |   18 +++---------------
 1 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 4a421be..3a4a1d5 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -458,12 +458,10 @@ static int list_voltage(struct regulator_dev *rdev, unsigned selector)
 		info->voltages[selector] : -EINVAL);
 }
 
-static int set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
-		       unsigned *selector)
+static int set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
 {
 	const struct supply_info *info;
 	struct tps6524x *hw;
-	unsigned i;
 
 	hw	= rdev_get_drvdata(rdev);
 	info	= &supply_info[rdev_get_id(rdev)];
@@ -471,17 +469,7 @@ static int set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 	if (info->flags & FIXED_VOLTAGE)
 		return -EINVAL;
 
-	for (i = 0; i < info->n_voltages; i++)
-		if (min_uV <= info->voltages[i] &&
-		    max_uV >= info->voltages[i])
-			break;
-
-	if (i >= info->n_voltages)
-		i = info->n_voltages - 1;
-
-	*selector = i;
-
-	return write_field(hw, &info->voltage, i);
+	return write_field(hw, &info->voltage, selector);
 }
 
 static int get_voltage(struct regulator_dev *rdev)
@@ -588,7 +576,7 @@ static struct regulator_ops regulator_ops = {
 	.enable			= enable_supply,
 	.disable		= disable_supply,
 	.get_voltage		= get_voltage,
-	.set_voltage		= set_voltage,
+	.set_voltage_sel	= set_voltage_sel,
 	.list_voltage		= list_voltage,
 	.set_current_limit	= set_current_limit,
 	.get_current_limit	= get_current_limit,
-- 
1.7.5.4



