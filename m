Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375Ab2CBIXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 03:23:46 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41940 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab2CBIXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 03:23:45 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.220.196 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330676619.31023.3.camel@phoenix>
Subject: [PATCH 3/3] regulator: max8660: Use DIV_ROUND_UP macro to calculate
 selector
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 02 Mar 2012 16:23:39 +0800
In-Reply-To: <1330676454.31023.0.camel@phoenix>
References: <1330676454.31023.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8660.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index a838e66..4c5b053 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -153,14 +153,15 @@ static int max8660_dcdc_set(struct regulator_dev *rdev, int min_uV, int max_uV,
 	if (max_uV < MAX8660_DCDC_MIN_UV || max_uV > MAX8660_DCDC_MAX_UV)
 		return -EINVAL;
 
-	selector = (min_uV - (MAX8660_DCDC_MIN_UV - MAX8660_DCDC_STEP + 1))
-			/ MAX8660_DCDC_STEP;
-	*s = selector;
+	selector = DIV_ROUND_UP(min_uV - MAX8660_DCDC_MIN_UV,
+				MAX8660_DCDC_STEP);
 
 	ret = max8660_dcdc_list(rdev, selector);
 	if (ret < 0 || ret > max_uV)
 		return -EINVAL;
 
+	*s = selector;
+
 	reg = (rdev_get_id(rdev) == MAX8660_V3) ? MAX8660_ADTV2 : MAX8660_SDTV2;
 	ret = max8660_write(max8660, reg, 0, selector);
 	if (ret)
@@ -210,8 +211,9 @@ static int max8660_ldo5_set(struct regulator_dev *rdev, int min_uV, int max_uV,
 	if (max_uV < MAX8660_LDO5_MIN_UV || max_uV > MAX8660_LDO5_MAX_UV)
 		return -EINVAL;
 
-	selector = (min_uV - (MAX8660_LDO5_MIN_UV - MAX8660_LDO5_STEP + 1))
-			/ MAX8660_LDO5_STEP;
+	selector = DIV_ROUND_UP(min_uV - MAX8660_LDO5_MIN_UV,
+				MAX8660_LDO5_STEP);
+
 	ret = max8660_ldo5_list(rdev, selector);
 	if (ret < 0 || ret > max_uV)
 		return -EINVAL;
@@ -287,8 +289,8 @@ static int max8660_ldo67_set(struct regulator_dev *rdev, int min_uV,
 	if (max_uV < MAX8660_LDO67_MIN_UV || max_uV > MAX8660_LDO67_MAX_UV)
 		return -EINVAL;
 
-	selector = (min_uV - (MAX8660_LDO67_MIN_UV - MAX8660_LDO67_STEP + 1))
-			/ MAX8660_LDO67_STEP;
+	selector = DIV_ROUND_UP(min_uV - MAX8660_LDO67_MIN_UV,
+				MAX8660_LDO67_STEP);
 
 	ret = max8660_ldo67_list(rdev, selector);
 	if (ret < 0 || ret > max_uV)
-- 
1.7.5.4



