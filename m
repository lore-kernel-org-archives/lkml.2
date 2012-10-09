Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab2JIKXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 06:23:15 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1752 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab2JIKXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 06:23:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 09 Oct 2012 03:23:06 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>
CC: <sameo@linux.intel.com>, <vbyravarasu@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 3/4] regulator: tps65090: Add support for LDO regulators
Date: Tue, 9 Oct 2012 15:19:01 +0530
Message-ID: <1349776142-6409-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1349776142-6409-1-git-send-email-ldewangan@nvidia.com>
References: <1349776142-6409-1-git-send-email-ldewangan@nvidia.com>
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
Changes from V1:
No change from older patch.

 drivers/regulator/tps65090-regulator.c |    5 +++++
 include/linux/mfd/tps65090.h           |    2 ++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 584a185..0732d9b 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -37,6 +37,9 @@ static struct regulator_ops tps65090_ops = {
 	.is_enabled = regulator_is_enabled_regmap,
 };
 
+static struct regulator_ops tps65090_ldo_ops = {
+};
+
 #define tps65090_REG_DESC(_id, _sname, _en_reg, _ops)	\
 {							\
 	.name = "TPS65090_RAILS"#_id,			\
@@ -60,6 +63,8 @@ static struct regulator_desc tps65090_regulator_desc[] = {
 	tps65090_REG_DESC(FET5,  "infet5",  0x13, tps65090_ops),
 	tps65090_REG_DESC(FET6,  "infet6",  0x14, tps65090_ops),
 	tps65090_REG_DESC(FET7,  "infet7",  0x15, tps65090_ops),
+	tps65090_REG_DESC(LDO1,  "vsys_l1", 0,    tps65090_ldo_ops),
+	tps65090_REG_DESC(LDO2,  "vsys_l2", 0,    tps65090_ldo_ops),
 };
 
 static inline bool is_dcdc(int id)
diff --git a/include/linux/mfd/tps65090.h b/include/linux/mfd/tps65090.h
index 958bf15..5989212 100644
--- a/include/linux/mfd/tps65090.h
+++ b/include/linux/mfd/tps65090.h
@@ -36,6 +36,8 @@ enum {
 	TPS65090_REGULATOR_FET5,
 	TPS65090_REGULATOR_FET6,
 	TPS65090_REGULATOR_FET7,
+	TPS65090_REGULATOR_LDO1,
+	TPS65090_REGULATOR_LDO2,
 
 	/* Last entry for maximum ID */
 	TPS65090_REGULATOR_MAX,
-- 
1.7.1.1

