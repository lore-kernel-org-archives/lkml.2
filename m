Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab0LAUif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 15:38:35 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19582 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab0LAUi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 15:38:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 01 Dec 2010 12:32:52 -0800
From: Stephen Warren <swarren@nvidia.com>
To: <linux-kernel@vger.kernel.org>
CC: <lrg@slimlogic.co.uk>, <broonie@opensource.wolfsonmicro.com>,
        <dahuang@nvidia.com>, <olofj@chromium.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 2/4] regulator: tps6586x: Fix TPS6586X_DVM to store goreg/bit
Date: Wed, 1 Dec 2010 13:37:29 -0700
Message-ID: <1291235851-29523-3-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291235851-29523-1-git-send-email-swarren@nvidia.com>
References: <1291235851-29523-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Huang <dahuang@nvidia.com>

Change-Id: Idacf5e1e51dbbbcd5ea93f310a4e907977e7359e
Signed-off-by: Danny Huang <dahuang@nvidia.com>
Signed-off-by: Olof Johansson <olofj@chromium.org>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
  (Split into separate patches)
  (Minor formatting fixes)
---
 drivers/regulator/tps6586x-regulator.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index 0e59e81..effa677 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -231,8 +231,7 @@ static int tps6586x_dvm_voltages[] = {
 };
 
 #define TPS6586X_REGULATOR(_id, vdata, _ops, vreg, shift, nbits,	\
-			   ereg0, ebit0, ereg1, ebit1, goreg, gobit)	\
-{									\
+			   ereg0, ebit0, ereg1, ebit1)			\
 	.desc	= {							\
 		.name	= "REG-" #_id,					\
 		.ops	= &tps6586x_regulator_##_ops,			\
@@ -248,18 +247,26 @@ static int tps6586x_dvm_voltages[] = {
 	.enable_bit[0]	= (ebit0),					\
 	.enable_reg[1]	= TPS6586X_SUPPLY##ereg1,			\
 	.enable_bit[1]	= (ebit1),					\
-	.voltages	= tps6586x_##vdata##_voltages,			\
-}
+	.voltages	= tps6586x_##vdata##_voltages,
+
+#define TPS6586X_REGULATOR_DVM_GOREG(goreg, gobit)			\
+	.go_reg = TPS6586X_##goreg,					\
+	.go_bit = (gobit),
 
 #define TPS6586X_LDO(_id, vdata, vreg, shift, nbits,			\
 		     ereg0, ebit0, ereg1, ebit1)			\
+{									\
 	TPS6586X_REGULATOR(_id, vdata, ldo_ops, vreg, shift, nbits,	\
-			   ereg0, ebit0, ereg1, ebit1, 0, 0)
+			   ereg0, ebit0, ereg1, ebit1)			\
+}
 
 #define TPS6586X_DVM(_id, vdata, vreg, shift, nbits,			\
 		     ereg0, ebit0, ereg1, ebit1, goreg, gobit)		\
+{									\
 	TPS6586X_REGULATOR(_id, vdata, dvm_ops, vreg, shift, nbits,	\
-			   ereg0, ebit0, ereg1, ebit1, goreg, gobit)
+			   ereg0, ebit0, ereg1, ebit1)			\
+	TPS6586X_REGULATOR_DVM_GOREG(goreg, gobit)			\
+}
 
 static struct tps6586x_regulator tps6586x_regulator[] = {
 	TPS6586X_LDO(LDO_0, ldo, SUPPLYV1, 5, 3, ENC, 0, END, 0),
-- 
1.7.0.4
nvpublic

