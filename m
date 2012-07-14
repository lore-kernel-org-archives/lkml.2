Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab2GNFlb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 01:41:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50277 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab2GNFl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 01:41:29 -0400
Message-ID: <1342244483.4207.4.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: twl: Convert twlsmps_ops to
 get_voltage_sel and map_voltage
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rajendra Nayak <rnayak@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Sat, 14 Jul 2012 13:41:23 +0800
In-Reply-To: <1342244233.4207.1.camel@phoenix>
References: <1342244233.4207.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/twl-regulator.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 03d0bea..8dae1e3 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -755,12 +755,11 @@ static int twl6030smps_list_voltage(struct regulator_dev *rdev, unsigned index)
 	return voltage;
 }
 
-static int
-twl6030smps_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
-			unsigned int *selector)
+static int twl6030smps_map_voltage(struct regulator_dev *rdev, int min_uV,
+				   int max_uV)
 {
-	struct twlreg_info	*info = rdev_get_drvdata(rdev);
-	int vsel = 0, calc_uV;
+	struct twlreg_info *info = rdev_get_drvdata(rdev);
+	int vsel = 0;
 
 	switch (info->flags) {
 	case 0:
@@ -827,14 +826,16 @@ twl6030smps_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 		break;
 	}
 
-	calc_uV = twl6030smps_list_voltage(rdev, vsel);
-	if (calc_uV > max_uV)
-		return -EINVAL;
+	return vsel;
+}
 
-	*selector = vsel;
+static int twl6030smps_set_voltage_sel(struct regulator_dev *rdev,
+				       unsigned int selector)
+{
+	struct twlreg_info *info = rdev_get_drvdata(rdev);
 
 	return twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_VOLTAGE_SMPS,
-							vsel);
+			    selector);
 }
 
 static int twl6030smps_get_voltage_sel(struct regulator_dev *rdev)
@@ -846,8 +847,9 @@ static int twl6030smps_get_voltage_sel(struct regulator_dev *rdev)
 
 static struct regulator_ops twlsmps_ops = {
 	.list_voltage		= twl6030smps_list_voltage,
+	.map_voltage		= twl6030smps_map_voltage,
 
-	.set_voltage		= twl6030smps_set_voltage,
+	.set_voltage_sel	= twl6030smps_set_voltage_sel,
 	.get_voltage_sel	= twl6030smps_get_voltage_sel,
 
 	.enable			= twl6030reg_enable,
-- 
1.7.9.5



