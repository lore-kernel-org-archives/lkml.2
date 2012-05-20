Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab2ETQYQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 12:24:16 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16331 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab2ETQYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 12:24:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 20 May 2012 09:24:10 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: tps62360: dt: initialize of_node param for regulator register.
Date: Sun, 20 May 2012 21:48:47 +0530
Message-ID: <1337530730-16605-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize config.of_node for regulator before registering.
This is needed for DT based regulator support.
Regulator stores this of_node value in rdev->dev.of_node
and used for lookup when client ask for regulator_get().

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps62360-regulator.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index b5be0d0..e534269 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -490,6 +490,7 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 	config.dev = &client->dev;
 	config.init_data = pdata->reg_init_data;
 	config.driver_data = tps;
+	config.of_node = client->dev.of_node;
 
 	/* Register the regulators */
 	rdev = regulator_register(&tps->desc, &config);
-- 
1.7.1.1

