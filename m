Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab2JCLMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:12:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46071 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755680Ab2JCLMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:12:34 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Rename n_ranges to num_ranges
Date: Wed,  3 Oct 2012 12:12:32 +0100
Message-Id: <1349262752-2926-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes things consistent with the rest of the API and is actually what
the documentation says. We don't currently have any in tree users so low
cost.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |    4 ++--
 include/linux/regmap.h       |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 52069d2..ea9d6eb 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -519,7 +519,7 @@ struct regmap *regmap_init(struct device *dev,
 	}
 
 	map->range_tree = RB_ROOT;
-	for (i = 0; i < config->n_ranges; i++) {
+	for (i = 0; i < config->num_ranges; i++) {
 		const struct regmap_range_cfg *range_cfg = &config->ranges[i];
 		struct regmap_range_node *new;
 
@@ -532,7 +532,7 @@ struct regmap *regmap_init(struct device *dev,
 
 		/* Make sure, that this register range has no selector
 		   or data window within its boundary */
-		for (j = 0; j < config->n_ranges; j++) {
+		for (j = 0; j < config->num_ranges; j++) {
 			unsigned sel_reg = config->ranges[j].selector_reg;
 			unsigned win_min = config->ranges[j].window_start;
 			unsigned win_max = win_min +
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index e3bcc3f..afc8e1a 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -133,7 +133,7 @@ struct regmap_config {
 	enum regmap_endian val_format_endian;
 
 	const struct regmap_range_cfg *ranges;
-	unsigned int n_ranges;
+	unsigned int num_ranges;
 };
 
 /**
-- 
1.7.10.4

