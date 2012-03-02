Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab2CBKHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 05:07:32 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48274 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab2CBKHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 05:07:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.224.9 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330682841.4191.1.camel@phoenix>
Subject: [PATCH RFC/RFT] regulator: Fix mask parameter in da9052_reg_update
 calls
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Fri, 02 Mar 2012 18:07:21 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the mask parameter is 0, info->activate_bit bit won't be set by
calling da9052_reg_update.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi,
I cannot find the datasheet, but current code looks does not make sense.
Can someone confirm if this is a correct fix?

Regards,
Axel

 drivers/regulator/da9052-regulator.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 3767364..ea4d8f5 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -260,8 +260,8 @@ static int da9052_set_ldo5_6_voltage(struct regulator_dev *rdev,
 	 * the LDO activate bit to implment the changes on the
 	 * LDO output.
 	*/
-	return da9052_reg_update(regulator->da9052, DA9052_SUPPLY_REG, 0,
-				 info->activate_bit);
+	return da9052_reg_update(regulator->da9052, DA9052_SUPPLY_REG,
+				 info->activate_bit, info->activate_bit);
 }
 
 static int da9052_set_dcdc_voltage(struct regulator_dev *rdev,
@@ -280,8 +280,8 @@ static int da9052_set_dcdc_voltage(struct regulator_dev *rdev,
 	 * the DCDC activate bit to implment the changes on the
 	 * DCDC output.
 	*/
-	return da9052_reg_update(regulator->da9052, DA9052_SUPPLY_REG, 0,
-				 info->activate_bit);
+	return da9052_reg_update(regulator->da9052, DA9052_SUPPLY_REG,
+				 info->activate_bit, info->activate_bit);
 }
 
 static int da9052_get_regulator_voltage_sel(struct regulator_dev *rdev)
-- 
1.7.5.4



