Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab2JFPv1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 11:51:27 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3273 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341Ab2JFPvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 11:51:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 06 Oct 2012 08:51:18 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        <sameo@linux.intel.com>
CC: <vbyravarasu@nvidia.com>, <axel.lin@gmail.com>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/5] regulator: tps65090: Add support for LDO regulators
Date: Sat, 6 Oct 2012 20:47:49 +0530
Message-ID: <1349536671-31714-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1349536671-31714-1-git-send-email-ldewangan@nvidia.com>
References: <1349536671-31714-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TPS65090 supports the two LDOs, LDO1 and LDO2. These are
always ON regulators. The output on these LDOs are available
once the input voltage available for these LDOs.
Add support for these LDOs regulators.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps65090-regulator.c       |    5 +++++
 include/linux/regulator/tps65090-regulator.h |    2 ++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index f825fc9..254ee66 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -38,6 +38,9 @@ static struct regulator_ops tps65090_ops = {
 	.is_enabled = regulator_is_enabled_regmap,
 };
 
+static struct regulator_ops tps65090_ldo_ops = {
+};
+
 #define tps65090_REG_DESC(_id, _sname, _en_reg, _ops)	\
 {							\
 	.name = tps65090_rails(_id),		\
@@ -61,6 +64,8 @@ static struct regulator_desc tps65090_regulator_desc[] = {
 	tps65090_REG_DESC(FET5,  "infet5",  0x13, tps65090_ops),
 	tps65090_REG_DESC(FET6,  "infet6",  0x14, tps65090_ops),
 	tps65090_REG_DESC(FET7,  "infet7",  0x15, tps65090_ops),
+	tps65090_REG_DESC(LDO1,  "vsys_l1", 0,    tps65090_ldo_ops),
+	tps65090_REG_DESC(LDO2,  "vsys_l2", 0,    tps65090_ldo_ops),
 };
 
 static int __devinit tps65090_regulator_probe(struct platform_device *pdev)
diff --git a/include/linux/regulator/tps65090-regulator.h b/include/linux/regulator/tps65090-regulator.h
index 3572557..48e3db1 100644
--- a/include/linux/regulator/tps65090-regulator.h
+++ b/include/linux/regulator/tps65090-regulator.h
@@ -34,6 +34,8 @@ enum {
 	TPS65090_REGULATOR_FET5,
 	TPS65090_REGULATOR_FET6,
 	TPS65090_REGULATOR_FET7,
+	TPS65090_REGULATOR_LDO1,
+	TPS65090_REGULATOR_LDO2,
 
 	/* Last entry */
 	TPS65090_REGULATOR_MAX,
-- 
1.7.1.1

