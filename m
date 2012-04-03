Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2DCW1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 18:27:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58798 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753690Ab2DCW1U (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Tue, 3 Apr 2012 18:27:20 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Vasut <marek.vasut@gmail.com>, Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: isl6271a: Allow missing init_data for diagnostics
Date: Tue,  3 Apr 2012 23:27:16 +0100
Message-Id: <1333492036-15990-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator core supports this to allow the configuration to be inspected
at runtime even if no software mangement is enabled.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/isl6271a-regulator.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/isl6271a-regulator.c b/drivers/regulator/isl6271a-regulator.c
index 775f5fd..a0430aa 100644
--- a/drivers/regulator/isl6271a-regulator.c
+++ b/drivers/regulator/isl6271a-regulator.c
@@ -140,6 +140,7 @@ static struct regulator_desc isl_rd[] = {
 static int __devinit isl6271a_probe(struct i2c_client *i2c,
 				     const struct i2c_device_id *id)
 {
+	struct regulator_config config = { };
 	struct regulator_init_data *init_data	= i2c->dev.platform_data;
 	struct isl_pmic *pmic;
 	int err, i;
@@ -147,11 +148,6 @@ static int __devinit isl6271a_probe(struct i2c_client *i2c,
 	if (!i2c_check_functionality(i2c->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
 
-	if (!init_data) {
-		dev_err(&i2c->dev, "no platform data supplied\n");
-		return -EIO;
-	}
-
 	pmic = kzalloc(sizeof(struct isl_pmic), GFP_KERNEL);
 	if (!pmic)
 		return -ENOMEM;
-- 
1.7.9.1

