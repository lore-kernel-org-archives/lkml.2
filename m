Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab2JCMnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:43:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56177 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057Ab2JCMnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:43:07 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] regmap: Allow ranges to be named
Date: Wed,  3 Oct 2012 13:42:59 +0100
Message-Id: <1349268182-21804-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For more useful diagnostics.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h |    1 +
 drivers/base/regmap/regmap.c   |    1 +
 include/linux/regmap.h         |    4 ++++
 3 files changed, 6 insertions(+)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 80f9ab9..27e66c3 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -120,6 +120,7 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 
 struct regmap_range_node {
 	struct rb_node node;
+	const char *name;
 
 	unsigned int range_min;
 	unsigned int range_max;
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 0544f63..ce5129d 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -579,6 +579,7 @@ struct regmap *regmap_init(struct device *dev,
 			goto err_range;
 		}
 
+		new->name = range_cfg->name;
 		new->range_min = range_cfg->range_min;
 		new->range_max = range_cfg->range_max;
 		new->selector_reg = range_cfg->selector_reg;
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index afc8e1a..9f228d7 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -142,6 +142,8 @@ struct regmap_config {
  *     1. page selector register update;
  *     2. access through data window registers.
  *
+ * @name: Descriptive name for diagnostics
+ *
  * @range_min: Address of the lowest register address in virtual range.
  * @range_max: Address of the highest register in virtual range.
  *
@@ -153,6 +155,8 @@ struct regmap_config {
  * @window_len: Number of registers in data window.
  */
 struct regmap_range_cfg {
+	const char *name;
+
 	/* Registers of virtual address range */
 	unsigned int range_min;
 	unsigned int range_max;
-- 
1.7.10.4

