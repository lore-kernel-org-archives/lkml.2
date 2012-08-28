Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab2H1Ebn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 00:31:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56782 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855Ab2H1Ebl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 00:31:41 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/4] regulator: core: Provide regmap get/set bypass operations
Date: Mon, 27 Aug 2012 21:31:32 -0700
Message-Id: <1346128294-26652-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346128294-26652-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1346128294-26652-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index d06a82e..e6bb1f9 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2708,6 +2708,47 @@ out:
 EXPORT_SYMBOL_GPL(regulator_set_optimum_mode);
 
 /**
+ * regulator_set_bypass_regmap - Default set_bypass() using regmap
+ *
+ * @rdev: device to operate on.
+ * @enable: state to set.
+ */
+int regulator_set_bypass_regmap(struct regulator_dev *rdev, bool enable)
+{
+	unsigned int val;
+
+	if (enable)
+		val = rdev->desc->bypass_mask;
+	else
+		val = 0;
+
+	return regmap_update_bits(rdev->regmap, rdev->desc->bypass_reg,
+				  rdev->desc->bypass_mask, val);
+}
+EXPORT_SYMBOL_GPL(regulator_set_bypass_regmap);
+
+/**
+ * regulator_get_bypass_regmap - Default get_bypass() using regmap
+ *
+ * @rdev: device to operate on.
+ * @enable: current state.
+ */
+int regulator_get_bypass_regmap(struct regulator_dev *rdev, bool *enable)
+{
+	unsigned int val;
+	int ret;
+
+	ret = regmap_read(rdev->regmap, rdev->desc->bypass_reg, &val);
+	if (ret != 0)
+		return ret;
+
+	*enable = val & rdev->desc->bypass_mask;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(regulator_get_bypass_regmap);
+
+/**
  * regulator_allow_bypass - allow the regulator to go into bypass mode
  *
  * @regulator: Regulator to configure
-- 
1.7.10.4

