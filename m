Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab2C1CG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 22:06:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64356 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab2C1CG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 22:06:58 -0400
Message-ID: <1332900405.7846.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: Remove unused name and client fields from
 struct tps62360_chip
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 28 Mar 2012 10:06:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The client field of struct tps62360_chip is not used after converting to regmap.
The name field of struct tps62360_chip is not used in this driver.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps62360-regulator.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index e2ec730..b18b7ca 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -56,10 +56,8 @@ enum chips {TPS62360, TPS62361};
 
 /* tps 62360 chip information */
 struct tps62360_chip {
-	const char *name;
 	struct device *dev;
 	struct regulator_desc desc;
-	struct i2c_client *client;
 	struct regulator_dev *rdev;
 	struct regmap *regmap;
 	int chip_id;
@@ -297,9 +295,7 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 	tps->en_internal_pulldn = pdata->en_internal_pulldn;
 	tps->vsel0_gpio = pdata->vsel0_gpio;
 	tps->vsel1_gpio = pdata->vsel1_gpio;
-	tps->client = client;
 	tps->dev = &client->dev;
-	tps->name = id->name;
 	tps->voltage_base = (id->driver_data == TPS62360) ?
 				TPS62360_BASE_VOLTAGE : TPS62361_BASE_VOLTAGE;
 	tps->voltage_reg_mask = (id->driver_data == TPS62360) ? 0x3F : 0x7F;
-- 
1.7.5.4



