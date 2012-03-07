Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab2CGNSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:18:47 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10943 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab2CGNSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:18:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 07 Mar 2012 05:18:45 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        jedu@slimlogic.co.uk, lrg@ti.com
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        ldewangan@nvidia.com
Subject: [PATCH V1 1/2] mfd: tps65910: Use correct variable name for regmap config
Date: Wed,  7 Mar 2012 18:46:05 +0530
Message-Id: <1331126166-3908-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was the copy-paste issue in reg cache support code where
variable name for regmap config was not really starting from
the device name, it was starting from some other device name.
Fixing this so that variable name contains actual device name.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This is just variable name change.

 drivers/mfd/tps65910.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 1c4f53e..bf2b25e 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -81,7 +81,7 @@ static bool is_volatile_reg(struct device *dev, unsigned int reg)
 	return true;
 }
 
-static const struct regmap_config rc5t583_regmap_config = {
+static const struct regmap_config tps65910_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 	.volatile_reg = is_volatile_reg,
@@ -120,7 +120,7 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	tps65910->write = tps65910_i2c_write;
 	mutex_init(&tps65910->io_mutex);
 
-	tps65910->regmap = regmap_init_i2c(i2c, &rc5t583_regmap_config);
+	tps65910->regmap = regmap_init_i2c(i2c, &tps65910_regmap_config);
 	if (IS_ERR(tps65910->regmap)) {
 		ret = PTR_ERR(tps65910->regmap);
 		dev_err(&i2c->dev, "regmap initialization failed: %d\n", ret);
-- 
1.7.1.1

