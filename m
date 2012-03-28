Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab2C1CHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 22:07:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64976 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab2C1CHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 22:07:45 -0400
Message-ID: <1332900460.7846.2.camel@phoenix>
Subject: [PATCH 2/2] regulator: tps65023: Remove unused client field from
 struct tps_pmic
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 28 Mar 2012 10:07:40 +0800
In-Reply-To: <1332900405.7846.1.camel@phoenix>
References: <1332900405.7846.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The client field of struct tps_pmic is not used after converting to regmap API.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65023-regulator.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 08b3b41..5c9a900 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -139,7 +139,6 @@ struct tps_info {
 /* PMIC details */
 struct tps_pmic {
 	struct regulator_desc desc[TPS65023_NUM_REGULATOR];
-	struct i2c_client *client;
 	struct regulator_dev *rdev[TPS65023_NUM_REGULATOR];
 	const struct tps_info *info[TPS65023_NUM_REGULATOR];
 	struct regmap *regmap;
@@ -407,7 +406,6 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 	}
 
 	/* common for all regulators */
-	tps->client = client;
 	tps->core_regulator = drv_data->core_regulator;
 
 	for (i = 0; i < TPS65023_NUM_REGULATOR; i++, info++, init_data++) {
-- 
1.7.5.4



