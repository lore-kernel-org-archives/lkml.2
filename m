Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab2CZBaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 21:30:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48198 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2CZBaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 21:30:12 -0400
Message-ID: <1332725406.7078.3.camel@phoenix>
Subject: [PATCH RFT] regulator: Convert twl4030ldo_set_voltage to
 set_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 26 Mar 2012 09:30:06 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/twl-regulator.c |   27 ++++-----------------------
 1 files changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 9cdfc38..107a08b 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -473,31 +473,12 @@ static int twl4030ldo_list_voltage(struct regulator_dev *rdev, unsigned index)
 }
 
 static int
-twl4030ldo_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
-		       unsigned *selector)
+twl4030ldo_set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
-	int			vsel;
-
-	for (vsel = 0; vsel < info->table_len; vsel++) {
-		int mV = info->table[vsel];
-		int uV;
-
-		if (IS_UNSUP(mV))
-			continue;
-		uV = LDO_MV(mV) * 1000;
-
-		/* REVISIT for VAUX2, first match may not be best/lowest */
-
-		/* use the first in-range value */
-		if (min_uV <= uV && uV <= max_uV) {
-			*selector = vsel;
-			return twlreg_write(info, TWL_MODULE_PM_RECEIVER,
-							VREG_VOLTAGE, vsel);
-		}
-	}
 
-	return -EDOM;
+	return twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_VOLTAGE,
+			    selector);
 }
 
 static int twl4030ldo_get_voltage(struct regulator_dev *rdev)
@@ -516,7 +497,7 @@ static int twl4030ldo_get_voltage(struct regulator_dev *rdev)
 static struct regulator_ops twl4030ldo_ops = {
 	.list_voltage	= twl4030ldo_list_voltage,
 
-	.set_voltage	= twl4030ldo_set_voltage,
+	.set_voltage_sel = twl4030ldo_set_voltage_sel,
 	.get_voltage	= twl4030ldo_get_voltage,
 
 	.enable		= twl4030reg_enable,
-- 
1.7.5.4



