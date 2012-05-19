Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760412Ab2ESOja (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 10:39:30 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13022 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760378Ab2ESOj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 10:39:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sat, 19 May 2012 07:38:12 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/5] regulator: tps65910:  use self device for regulator registration
Date: Sat, 19 May 2012 20:04:08 +0530
Message-ID: <1337438050-3707-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1337438050-3707-1-git-send-email-ldewangan@nvidia.com>
References: <1337438050-3707-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use self device for regulator registration instead of parent
device.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps65910-regulator.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index dd0e2cb..72942c2 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1111,7 +1111,7 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 		return NULL;
 	}
 
-	ret = of_regulator_match(pdev->dev.parent, regulators, matches, count);
+	ret = of_regulator_match(&pdev->dev, regulators, matches, count);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n",
 			ret);
@@ -1260,7 +1260,7 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		pmic->desc[i].enable_reg = pmic->get_ctrl_reg(i);
 		pmic->desc[i].enable_mask = TPS65910_SUPPLY_STATE_ENABLED;
 
-		config.dev = tps65910->dev;
+		config.dev = &pdev->dev;
 		config.init_data = reg_data;
 		config.driver_data = pmic;
 		config.regmap = tps65910->regmap;
-- 
1.7.1.1

