Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab2GRDsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 23:48:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46741 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab2GRDsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 23:48:15 -0400
Message-ID: <1342583289.12515.4.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: palmas: Fix regmap offsets for
 PALMAS_REG_SMPS10 vsel_reg
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Date: Wed, 18 Jul 2012 11:48:09 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/palmas-regulator.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 0fcf355..9e3e7f3 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -679,7 +679,9 @@ static __devinit int palmas_probe(struct platform_device *pdev)
 		case PALMAS_REG_SMPS10:
 			pmic->desc[id].n_voltages = PALMAS_SMPS10_NUM_VOLTAGES;
 			pmic->desc[id].ops = &palmas_ops_smps10;
-			pmic->desc[id].vsel_reg = PALMAS_SMPS10_CTRL;
+			pmic->desc[id].vsel_reg =
+					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
+							PALMAS_SMPS10_CTRL);
 			pmic->desc[id].vsel_mask = SMPS10_VSEL;
 			pmic->desc[id].enable_reg =
 					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-- 
1.7.9.5



