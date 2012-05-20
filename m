Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab2ETQYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 12:24:22 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16342 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab2ETQYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 12:24:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 20 May 2012 09:24:16 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/3] regulator: tps65910: add error message in case of failure
Date: Sun, 20 May 2012 21:48:48 +0530
Message-ID: <1337530730-16605-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1337530730-16605-1-git-send-email-ldewangan@nvidia.com>
References: <1337530730-16605-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prints error message whenever there is failure on resource
allocation.
Also used dev_* to print messages instead of pr_*

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Resend: This was sent earlier on other series as 5/5 and it
was ok but due to discussion on other patches it did not apply.
Making the changes as first of this series.

 drivers/regulator/tps65910-regulator.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 57d3993..94c1801 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1101,7 +1101,7 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 		matches = tps65911_matches;
 		break;
 	default:
-		pr_err("Invalid tps chip version\n");
+		dev_err(&pdev->dev, "Invalid tps chip version\n");
 		return NULL;
 	}
 
@@ -1150,12 +1150,16 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 	if (!pmic_plat_data && tps65910->dev->of_node)
 		pmic_plat_data = tps65910_parse_dt_reg_data(pdev);
 
-	if (!pmic_plat_data)
+	if (!pmic_plat_data) {
+		dev_err(&pdev->dev, "Platform data not found\n");
 		return -EINVAL;
+	}
 
 	pmic = devm_kzalloc(&pdev->dev, sizeof(*pmic), GFP_KERNEL);
-	if (!pmic)
+	if (!pmic) {
+		dev_err(&pdev->dev, "Memory allocation failed for pmic\n");
 		return -ENOMEM;
+	}
 
 	mutex_init(&pmic->mutex);
 	pmic->mfd = tps65910;
@@ -1179,7 +1183,7 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		info = tps65911_regs;
 		break;
 	default:
-		pr_err("Invalid tps chip version\n");
+		dev_err(&pdev->dev, "Invalid tps chip version\n");
 		return -ENODEV;
 	}
 
-- 
1.7.1.1

