Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334Ab2HHVTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:19:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35184 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab2HHVTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:19:05 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 2/3] regulator: add regulator_get_voltage_fixed helper op
Date: Wed,  8 Aug 2012 15:18:46 -0600
Message-Id: <1344460727-6243-2-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1344460727-6243-1-git-send-email-swarren@wwwdotorg.org>
References: <1344460727-6243-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Fixed regulators always output desc->min_uV. Add a helper get_voltage
op to save duplicating this code in drivers.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: New patch

 drivers/regulator/core.c         |   14 ++++++++++++++
 include/linux/regulator/driver.h |    1 +
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 457be22..c0129bf 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1973,6 +1973,20 @@ int regulator_is_supported_voltage(struct regulator *regulator,
 EXPORT_SYMBOL_GPL(regulator_is_supported_voltage);
 
 /**
+ * regulator_get_voltage_fixed - standard get_voltage for fixed regulators
+ *
+ * @rdev: regulator to operate on
+ *
+ * Fixed regulators can use this as their get_voltage operation, saving
+ * some code.
+ */
+int regulator_get_voltage_fixed(struct regulator_dev *rdev)
+{
+	return rdev->desc->min_uV;
+}
+EXPORT_SYMBOL_GPL(regulator_get_voltage_fixed);
+
+/**
  * regulator_get_voltage_sel_regmap - standard get_voltage_sel for regmap users
  *
  * @rdev: regulator to operate on
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 2c40c86..aa0145a 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -306,6 +306,7 @@ int regulator_map_voltage_linear(struct regulator_dev *rdev,
 				  int min_uV, int max_uV);
 int regulator_map_voltage_iterate(struct regulator_dev *rdev,
 				  int min_uV, int max_uV);
+int regulator_get_voltage_fixed(struct regulator_dev *rdev);
 int regulator_get_voltage_sel_regmap(struct regulator_dev *rdev);
 int regulator_set_voltage_sel_regmap(struct regulator_dev *rdev, unsigned sel);
 int regulator_is_enabled_regmap(struct regulator_dev *rdev);
-- 
1.7.0.4

