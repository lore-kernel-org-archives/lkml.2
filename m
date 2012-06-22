Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932Ab2FVMgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 08:36:46 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:60752 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761825Ab2FVMgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 08:36:23 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        s-guiriec@ti.com, Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 3/3] REGULATOR: fix regmap offsets for enable/disable
Date: Fri, 22 Jun 2012 13:36:20 +0100
Message-Id: <1340368581-11882-4-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340368581-11882-1-git-send-email-gg@slimlogic.co.uk>
References: <1340368581-11882-1-git-send-email-gg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to apply the offsets for the regmap helper functions for
enable/disable on SMPS10 and the LDO regulators. This means regulators
will not enable/disable correctly.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
Tested-by: Sebastien Guiriec <s-guiriec@ti.com>
---
 drivers/regulator/palmas-regulator.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 6c48511..7540c95 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -667,7 +667,9 @@ static __devinit int palmas_probe(struct platform_device *pdev)
 			pmic->desc[id].ops = &palmas_ops_smps10;
 			pmic->desc[id].vsel_reg = PALMAS_SMPS10_CTRL;
 			pmic->desc[id].vsel_mask = SMPS10_VSEL;
-			pmic->desc[id].enable_reg = PALMAS_SMPS10_STATUS;
+			pmic->desc[id].enable_reg =
+					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
+							PALMAS_SMPS10_STATUS);
 			pmic->desc[id].enable_mask = SMPS10_BOOST_EN;
 			pmic->desc[id].min_uV = 3750000;
 			pmic->desc[id].uV_step = 1250000;
@@ -739,7 +741,8 @@ static __devinit int palmas_probe(struct platform_device *pdev)
 
 		pmic->desc[id].type = REGULATOR_VOLTAGE;
 		pmic->desc[id].owner = THIS_MODULE;
-		pmic->desc[id].enable_reg = palmas_regs_info[id].ctrl_addr;
+		pmic->desc[id].enable_reg = PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
+						palmas_regs_info[id].ctrl_addr);
 		pmic->desc[id].enable_mask = PALMAS_LDO1_CTRL_MODE_ACTIVE;
 
 		if (pdata && pdata->reg_data)
-- 
1.7.9.5

