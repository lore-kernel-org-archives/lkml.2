Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab2GSHLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 03:11:49 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37984 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2GSHLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 03:11:46 -0400
Message-ID: <1342681899.13385.2.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: mc13892: Convert
 mc13892_sw_regulator_ops to get_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 19 Jul 2012 15:11:39 +0800
In-Reply-To: <1342681831.13385.1.camel@phoenix>
References: <1342681831.13385.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/mc13892-regulator.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 60195b3..662b1d5 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -399,11 +399,11 @@ static struct regulator_ops mc13892_gpo_regulator_ops = {
 	.get_voltage = mc13xxx_fixed_regulator_get_voltage,
 };
 
-static int mc13892_sw_regulator_get_voltage(struct regulator_dev *rdev)
+static int mc13892_sw_regulator_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
 	int ret, id = rdev_get_id(rdev);
-	unsigned int val, hi;
+	unsigned int val;
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
 
@@ -414,17 +414,11 @@ static int mc13892_sw_regulator_get_voltage(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	hi  = val & MC13892_SWITCHERS0_SWxHI;
 	val = (val & mc13892_regulators[id].vsel_mask)
 		>> mc13892_regulators[id].vsel_shift;
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d val: %d\n", __func__, id, val);
 
-	if (hi)
-		val = (25000 * val) + 1100000;
-	else
-		val = (25000 * val) + 600000;
-
 	return val;
 }
 
@@ -459,7 +453,7 @@ static int mc13892_sw_regulator_set_voltage_sel(struct regulator_dev *rdev,
 static struct regulator_ops mc13892_sw_regulator_ops = {
 	.list_voltage = regulator_list_voltage_table,
 	.set_voltage_sel = mc13892_sw_regulator_set_voltage_sel,
-	.get_voltage = mc13892_sw_regulator_get_voltage,
+	.get_voltage_sel = mc13892_sw_regulator_get_voltage_sel,
 };
 
 static int mc13892_vcam_set_mode(struct regulator_dev *rdev, unsigned int mode)
-- 
1.7.9.5



