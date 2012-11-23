Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab2KWB0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 20:26:08 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44147 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab2KWB0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 20:26:07 -0500
Message-ID: <1353633954.7586.1.camel@phoenix>
Subject: [PATCH] regulator: tps80031: Implement list_voltage and set
 n_voltages = 1 for fixed regulators
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 23 Nov 2012 09:25:54 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement list_voltage for fixed regulators, otherwise
regulator_is_supported_voltage() returns 0.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps80031-regulator.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/tps80031-regulator.c b/drivers/regulator/tps80031-regulator.c
index 6d5f203..50f89b0 100644
--- a/drivers/regulator/tps80031-regulator.c
+++ b/drivers/regulator/tps80031-regulator.c
@@ -407,15 +407,18 @@ static struct regulator_ops tps80031_ldo_ops = {
 };
 
 static struct regulator_ops tps80031_vbus_sw_ops = {
+	.list_voltage	= regulator_list_voltage_linear,
 	.enable		= tps80031_vbus_enable,
 	.disable	= tps80031_vbus_disable,
 	.is_enabled	= tps80031_vbus_is_enabled,
 };
 
 static struct regulator_ops tps80031_vbus_hw_ops = {
+	.list_voltage	= regulator_list_voltage_linear,
 };
 
 static struct regulator_ops tps80031_ext_reg_ops = {
+	.list_voltage	= regulator_list_voltage_linear,
 	.enable		= tps80031_reg_enable,
 	.disable	= tps80031_reg_disable,
 	.is_enabled	= tps80031_reg_is_enabled,
@@ -477,7 +480,8 @@ static struct regulator_ops tps80031_ext_reg_ops = {
 	.desc = {						\
 		.name = "tps80031_"#_id,			\
 		.id = TPS80031_REGULATOR_##_id,			\
-		.n_voltages = 2,				\
+		.min_uV = max_mV * 1000,			\
+		.n_voltages = 1,				\
 		.ops = &_ops,					\
 		.type = REGULATOR_VOLTAGE,			\
 		.owner = THIS_MODULE,				\
-- 
1.7.9.5



