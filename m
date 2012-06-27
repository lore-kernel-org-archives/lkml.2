Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab2F0OMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:12:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34621 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756948Ab2F0OML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:12:11 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/5] regulator: arizona-ldo1: Implement GPIO enable support
Date: Wed, 27 Jun 2012 15:12:06 +0100
Message-Id: <1340806326-30525-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340806326-30525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1340806326-30525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-ldo1.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index 51f02ca..c8f95c0 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -57,6 +57,9 @@ static const struct regulator_desc arizona_ldo1 = {
 };
 
 static const struct regulator_init_data arizona_ldo1_default = {
+	.constraints = {
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	},
 	.num_consumer_supplies = 1,
 };
 
@@ -88,6 +91,7 @@ static __devinit int arizona_ldo1_probe(struct platform_device *pdev)
 	config.dev = arizona->dev;
 	config.driver_data = ldo1;
 	config.regmap = arizona->regmap;
+	config.ena_gpio = arizona->pdata.ldoena;
 
 	if (arizona->pdata.ldo1)
 		config.init_data = arizona->pdata.ldo1;
-- 
1.7.10

