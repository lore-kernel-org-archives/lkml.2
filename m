Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab2F0OKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:10:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57101 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756393Ab2F0OKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:10:17 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/4] regulator: core: Allow fixed enable_time to be set in the regulator_desc
Date: Wed, 27 Jun 2012 15:10:09 +0100
Message-Id: <1340806212-30457-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many regulators have a fixed specification for their enable time. Allow
this to be set in the regulator_desc as a number to save them having to
implement an explicit operation.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c         |    2 +-
 include/linux/regulator/driver.h |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 43132b6..d19480b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1150,7 +1150,7 @@ overflow_err:
 static int _regulator_get_enable_time(struct regulator_dev *rdev)
 {
 	if (!rdev->desc->ops->enable_time)
-		return 0;
+		return rdev->desc->enable_time;
 	return rdev->desc->ops->enable_time(rdev);
 }
 
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 84f999ed..176bd43 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -180,6 +180,8 @@ enum regulator_type {
  * @vsel_mask: Mask for register bitfield used for selector
  * @enable_reg: Register for control when using regmap enable/disable ops
  * @enable_mask: Mask for control when using regmap enable/disable ops
+ *
+ * @enable_time: Time taken for initial enable of regulator (in uS).
  */
 struct regulator_desc {
 	const char *name;
@@ -201,6 +203,8 @@ struct regulator_desc {
 	unsigned int vsel_mask;
 	unsigned int enable_reg;
 	unsigned int enable_mask;
+
+	unsigned int enable_time;
 };
 
 /**
-- 
1.7.10

