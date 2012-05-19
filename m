Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760456Ab2ESOjf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 10:39:35 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16527 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760378Ab2ESOjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 10:39:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sat, 19 May 2012 07:39:28 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 5/5] regulator: tps65910: add error message in case of failure
Date: Sat, 19 May 2012 20:04:10 +0530
Message-ID: <1337438050-3707-6-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1337438050-3707-1-git-send-email-ldewangan@nvidia.com>
References: <1337438050-3707-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prints error message whenever there is failure on allocating
resource. Also used the dev_* to print messages instead of pr_*

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps65910-regulator.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 5a8ad4e..560282c 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1107,7 +1107,7 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 		matches = tps65911_matches;
 		break;
 	default:
-		pr_err("Invalid tps chip version\n");
+		dev_err(&pdev->dev, "Invalid tps chip version\n");
 		return NULL;
 	}
 
@@ -1158,12 +1158,16 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 	if (!pmic_plat_data && tps65910->dev->of_node)
 		pmic_plat_data = tps65910_parse_dt_reg_data(pdev, &reg_node);
 
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
@@ -1187,7 +1191,7 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		info = tps65911_regs;
 		break;
 	default:
-		pr_err("Invalid tps chip version\n");
+		dev_err(&pdev->dev, "Invalid tps chip version\n");
 		return -ENODEV;
 	}
 
-- 
1.7.1.1

