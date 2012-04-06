Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab2DFABr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 20:01:47 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:36376 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab2DFABp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 20:01:45 -0400
Message-ID: <1333670496.2777.0.camel@phoenix>
Subject: [PATCH] regulator: rc5t583: Simplify RC5T583_REG macro
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 06 Apr 2012 08:01:36 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify RC5T583_REG macro by removing _vout_reg and _ds_reg parameters.

The naming for vout_reg and deepsleep_reg can be replaced by:
.vout_reg       = RC5T583_REG_##_id##DAC,
.deepsleep_reg  = RC5T583_REG_##_id##DAC_DS,

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/rc5t583-regulator.c |   50 ++++++++++++---------------------
 1 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/drivers/regulator/rc5t583-regulator.c b/drivers/regulator/rc5t583-regulator.c
index 578bd5d..fcb9cc7 100644
--- a/drivers/regulator/rc5t583-regulator.c
+++ b/drivers/regulator/rc5t583-regulator.c
@@ -196,16 +196,16 @@ static struct regulator_ops rc5t583_ops = {
 	.set_voltage_time_sel	= rc5t583_set_voltage_time_sel,
 };
 
-#define RC5T583_REG(_id, _en_reg, _en_bit, _disc_reg, _disc_bit, _vout_reg,  \
-		_vout_mask, _ds_reg, _min_mv, _max_mv, _step_uV, _enable_mv) \
+#define RC5T583_REG(_id, _en_reg, _en_bit, _disc_reg, _disc_bit, \
+		_vout_mask, _min_mv, _max_mv, _step_uV, _enable_mv) \
 {								\
 	.reg_en_reg	= RC5T583_REG_##_en_reg,		\
 	.en_bit		= _en_bit,				\
 	.reg_disc_reg	= RC5T583_REG_##_disc_reg,		\
 	.disc_bit	= _disc_bit,				\
-	.vout_reg	= RC5T583_REG_##_vout_reg,		\
+	.vout_reg	= RC5T583_REG_##_id##DAC,		\
 	.vout_mask	= _vout_mask,				\
-	.deepsleep_reg	= RC5T583_REG_##_ds_reg,		\
+	.deepsleep_reg	= RC5T583_REG_##_id##DAC_DS,		\
 	.min_uV		= _min_mv * 1000,			\
 	.max_uV		= _max_mv * 1000,			\
 	.step_uV	= _step_uV,				\
@@ -223,34 +223,20 @@ static struct regulator_ops rc5t583_ops = {
 }
 
 static struct rc5t583_regulator_info rc5t583_reg_info[RC5T583_REGULATOR_MAX] = {
-	RC5T583_REG(DC0, DC0CTL, 0, DC0CTL, 1, DC0DAC, 0x7F, DC0DAC_DS,
-			700, 1500, 12500, 4),
-	RC5T583_REG(DC1, DC1CTL, 0, DC1CTL, 1, DC1DAC, 0x7F, DC1DAC_DS,
-			700, 1500, 12500, 14),
-	RC5T583_REG(DC2, DC2CTL, 0, DC2CTL, 1, DC2DAC, 0x7F, DC2DAC_DS,
-			900, 2400, 12500, 14),
-	RC5T583_REG(DC3, DC3CTL, 0, DC3CTL, 1, DC3DAC, 0x7F, DC3DAC_DS,
-			900, 2400, 12500, 14),
-	RC5T583_REG(LDO0, LDOEN2, 0, LDODIS2, 0, LDO0DAC, 0x7F, LDO0DAC_DS,
-			900, 3400, 25000, 160),
-	RC5T583_REG(LDO1, LDOEN2, 1, LDODIS2, 1, LDO1DAC, 0x7F, LDO1DAC_DS,
-			900, 3400, 25000, 160),
-	RC5T583_REG(LDO2, LDOEN2, 2, LDODIS2, 2, LDO2DAC, 0x7F, LDO2DAC_DS,
-			900, 3400, 25000, 160),
-	RC5T583_REG(LDO3, LDOEN2, 3, LDODIS2, 3, LDO3DAC, 0x7F, LDO3DAC_DS,
-			900, 3400, 25000, 160),
-	RC5T583_REG(LDO4, LDOEN2, 4, LDODIS2, 4, LDO4DAC, 0x3F, LDO4DAC_DS,
-			750, 1500, 12500, 133),
-	RC5T583_REG(LDO5, LDOEN2, 5, LDODIS2, 5, LDO5DAC, 0x7F, LDO5DAC_DS,
-			900, 3400, 25000, 267),
-	RC5T583_REG(LDO6, LDOEN2, 6, LDODIS2, 6, LDO6DAC, 0x7F, LDO6DAC_DS,
-			900, 3400, 25000, 133),
-	RC5T583_REG(LDO7, LDOEN2, 7, LDODIS2, 7, LDO7DAC, 0x7F, LDO7DAC_DS,
-			900, 3400, 25000, 233),
-	RC5T583_REG(LDO8, LDOEN1, 0, LDODIS1, 0, LDO8DAC, 0x7F, LDO8DAC_DS,
-			900, 3400, 25000, 233),
-	RC5T583_REG(LDO9, LDOEN1, 1, LDODIS1, 1, LDO9DAC, 0x7F, LDO9DAC_DS,
-			900, 3400, 25000, 133),
+	RC5T583_REG(DC0, DC0CTL, 0, DC0CTL, 1, 0x7F, 700, 1500, 12500, 4),
+	RC5T583_REG(DC1, DC1CTL, 0, DC1CTL, 1, 0x7F, 700, 1500, 12500, 14),
+	RC5T583_REG(DC2, DC2CTL, 0, DC2CTL, 1, 0x7F, 900, 2400, 12500, 14),
+	RC5T583_REG(DC3, DC3CTL, 0, DC3CTL, 1, 0x7F, 900, 2400, 12500, 14),
+	RC5T583_REG(LDO0, LDOEN2, 0, LDODIS2, 0, 0x7F, 900, 3400, 25000, 160),
+	RC5T583_REG(LDO1, LDOEN2, 1, LDODIS2, 1, 0x7F, 900, 3400, 25000, 160),
+	RC5T583_REG(LDO2, LDOEN2, 2, LDODIS2, 2, 0x7F, 900, 3400, 25000, 160),
+	RC5T583_REG(LDO3, LDOEN2, 3, LDODIS2, 3, 0x7F, 900, 3400, 25000, 160),
+	RC5T583_REG(LDO4, LDOEN2, 4, LDODIS2, 4, 0x3F, 750, 1500, 12500, 133),
+	RC5T583_REG(LDO5, LDOEN2, 5, LDODIS2, 5, 0x7F, 900, 3400, 25000, 267),
+	RC5T583_REG(LDO6, LDOEN2, 6, LDODIS2, 6, 0x7F, 900, 3400, 25000, 133),
+	RC5T583_REG(LDO7, LDOEN2, 7, LDODIS2, 7, 0x7F, 900, 3400, 25000, 233),
+	RC5T583_REG(LDO8, LDOEN1, 0, LDODIS1, 0, 0x7F, 900, 3400, 25000, 233),
+	RC5T583_REG(LDO9, LDOEN1, 1, LDODIS1, 1, 0x7F, 900, 3400, 25000, 133),
 };
 
 static int __devinit rc5t583_regulator_probe(struct platform_device *pdev)
-- 
1.7.5.4



