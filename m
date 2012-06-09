Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab2FIFgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 01:36:25 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45097 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2FIFfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 01:35:46 -0400
From: Fabio Estevam <festevam@gmail.com>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        u.kleine-koenig@pengutronix.de,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 1/2] mfd: mc13xxx-i2c: Convert to devm_regmap_init_i2c()
Date: Sat,  9 Jun 2012 02:35:30 -0300
Message-Id: <1339220131-24189-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Current code misses a "regmap_exit(mc13xxx->regmap)" in the error and remove paths.

Converting to devm_regmap_init_i2c() makes the regmap_exit unnecessary.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/mfd/mc13xxx-i2c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/mc13xxx-i2c.c b/drivers/mfd/mc13xxx-i2c.c
index d22501d..0e38672 100644
--- a/drivers/mfd/mc13xxx-i2c.c
+++ b/drivers/mfd/mc13xxx-i2c.c
@@ -72,7 +72,7 @@ static int mc13xxx_i2c_probe(struct i2c_client *client,
 	mc13xxx->dev = &client->dev;
 	mutex_init(&mc13xxx->lock);
 
-	mc13xxx->regmap = regmap_init_i2c(client, &mc13xxx_regmap_i2c_config);
+	mc13xxx->regmap = devm_regmap_init_i2c(client, &mc13xxx_regmap_i2c_config);
 	if (IS_ERR(mc13xxx->regmap)) {
 		ret = PTR_ERR(mc13xxx->regmap);
 		dev_err(mc13xxx->dev, "Failed to initialize register map: %d\n",
-- 
1.7.1

