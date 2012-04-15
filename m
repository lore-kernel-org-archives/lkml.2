Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab2DOLtn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 07:49:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44642 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845Ab2DOLtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 07:49:42 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/8] regulator: core: Allow drivers to pass in a regmap
Date: Sun, 15 Apr 2012 12:49:18 +0100
Message-Id: <1334490565-19808-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since many regulators use regmap for register I/O and since there's quite
a few very common patterns in the code allow drivers to pass in a regmap
to the core for use in generic code.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c         |    2 ++
 include/linux/regulator/driver.h |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 1bd71a8..10ba8d3 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -24,6 +24,7 @@
 #include <linux/suspend.h>
 #include <linux/delay.h>
 #include <linux/of.h>
+#include <linux/regmap.h>
 #include <linux/regulator/of_regulator.h>
 #include <linux/regulator/consumer.h>
 #include <linux/regulator/driver.h>
@@ -2895,6 +2896,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	rdev->reg_data = config->driver_data;
 	rdev->owner = regulator_desc->owner;
 	rdev->desc = regulator_desc;
+	rdev->regmap = config->regmap;
 	INIT_LIST_HEAD(&rdev->consumer_list);
 	INIT_LIST_HEAD(&rdev->list);
 	BLOCKING_INIT_NOTIFIER_HEAD(&rdev->notifier);
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 4f529ed..2e75373 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -19,6 +19,7 @@
 #include <linux/notifier.h>
 #include <linux/regulator/consumer.h>
 
+struct regmap;
 struct regulator_dev;
 struct regulator_init_data;
 
@@ -187,12 +188,14 @@ struct regulator_desc {
  * @driver_data: private regulator data
  * @of_node: OpenFirmware node to parse for device tree bindings (may be
  *           NULL).
+ * @regmap: regmap to use for core regmap helpers
  */
 struct regulator_config {
 	struct device *dev;
 	const struct regulator_init_data *init_data;
 	void *driver_data;
 	struct device_node *of_node;
+	struct regmap *regmap;
 };
 
 /*
@@ -223,6 +226,7 @@ struct regulator_dev {
 	struct device dev;
 	struct regulation_constraints *constraints;
 	struct regulator *supply;	/* for tree */
+	struct regmap *regmap;
 
 	struct delayed_work disable_work;
 	int deferred_disables;
-- 
1.7.9.1

