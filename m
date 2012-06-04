Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab2FDEoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 00:44:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51662 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab2FDEoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 00:44:23 -0400
Message-ID: <1338785055.3589.1.camel@phoenix>
Subject: [PATCH] regulator: twl: Convert twl6030ldo_ops to use
 regulator_list_voltage_linear
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 04 Jun 2012 12:44:15 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/twl-regulator.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index c739071..a1d07e5 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -577,13 +577,6 @@ static struct regulator_ops twl6030coresmps_ops = {
 	.get_voltage	= twl6030coresmps_get_voltage,
 };
 
-static int twl6030ldo_list_voltage(struct regulator_dev *rdev, unsigned index)
-{
-	struct twlreg_info	*info = rdev_get_drvdata(rdev);
-
-	return ((info->min_mV + (index * 100)) * 1000);
-}
-
 static int
 twl6030ldo_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 		       unsigned *selector)
@@ -621,7 +614,7 @@ static int twl6030ldo_get_voltage(struct regulator_dev *rdev)
 }
 
 static struct regulator_ops twl6030ldo_ops = {
-	.list_voltage	= twl6030ldo_list_voltage,
+	.list_voltage	= regulator_list_voltage_linear,
 
 	.set_voltage	= twl6030ldo_set_voltage,
 	.get_voltage	= twl6030ldo_get_voltage,
@@ -959,6 +952,8 @@ static struct twlreg_info TWL6030_INFO_##label = { \
 		.ops = &twl6030ldo_ops, \
 		.type = REGULATOR_VOLTAGE, \
 		.owner = THIS_MODULE, \
+		.min_uV = min_mVolts * 1000, \
+		.uV_step = 100 * 1000, \
 		}, \
 	}
 
@@ -974,6 +969,8 @@ static struct twlreg_info TWL6025_INFO_##label = { \
 		.ops = &twl6030ldo_ops, \
 		.type = REGULATOR_VOLTAGE, \
 		.owner = THIS_MODULE, \
+		.min_uV = min_mVolts * 1000, \
+		.uV_step = 100 * 1000, \
 		}, \
 	}
 
-- 
1.7.5.4



