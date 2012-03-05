Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab2CEWyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 17:54:52 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:49881 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab2CEWyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:54:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.73.234 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330988080.5328.1.camel@phoenix>
Subject: [PATCH] regulator: da903x: Use DIV_ROUND_UP macro to calculate
 selector
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Mike Rapoport <mike@compulab.co.il>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 06 Mar 2012 06:54:40 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/da903x.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 8dbc54d..1851f09 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -119,7 +119,7 @@ static int da903x_set_ldo_voltage(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	val = (min_uV - info->min_uV + info->step_uV - 1) / info->step_uV;
+	val = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
 	*selector = val;
 	val <<= info->vol_shift;
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
@@ -202,7 +202,7 @@ static int da9030_set_ldo1_15_voltage(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	val = (min_uV - info->min_uV + info->step_uV - 1) / info->step_uV;
+	val = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
 	*selector = val;
 	val <<= info->vol_shift;
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
@@ -233,10 +233,10 @@ static int da9030_set_ldo14_voltage(struct regulator_dev *rdev,
 
 	thresh = (info->max_uV + info->min_uV) / 2;
 	if (min_uV < thresh) {
-		val = (thresh - min_uV + info->step_uV - 1) / info->step_uV;
+		val = DIV_ROUND_UP(thresh - min_uV, info->step_uV);
 		val |= 0x4;
 	} else {
-		val = (min_uV - thresh + info->step_uV - 1) / info->step_uV;
+		val = DIV_ROUND_UP(min_uV - thresh, info->step_uV);
 	}
 
 	*selector = val;
@@ -281,7 +281,7 @@ static int da9034_set_dvc_voltage(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	val = (min_uV - info->min_uV + info->step_uV - 1) / info->step_uV;
+	val = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
 	*selector = val;
 	val <<= info->vol_shift;
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
@@ -307,7 +307,7 @@ static int da9034_set_ldo12_voltage(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	val = (min_uV - info->min_uV + info->step_uV - 1) / info->step_uV;
+	val = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
 	val = (val >= 20) ? val - 12 : ((val > 7) ? 8 : val);
 	*selector = val;
 	val <<= info->vol_shift;
-- 
1.7.5.4



