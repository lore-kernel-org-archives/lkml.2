Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab2BTVPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:15:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47779 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366Ab2BTVPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:15:06 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>, Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Clean up debugfs error handling a bit
Date: Mon, 20 Feb 2012 21:15:00 +0000
Message-Id: <1329772500-20577-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use IS_ERR_OR_NULL() rather than open coding it and ignore errors from
failure to create the supply map.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index fecda41..d14e433 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2815,7 +2815,7 @@ static void rdev_init_debugfs(struct regulator_dev *rdev)
 {
 #ifdef CONFIG_DEBUG_FS
 	rdev->debugfs = debugfs_create_dir(rdev_get_name(rdev), debugfs_root);
-	if (IS_ERR(rdev->debugfs) || !rdev->debugfs) {
+	if (IS_ERR_OR_NULL(rdev->debugfs)) {
 		rdev_warn(rdev, "Failed to create debugfs directory\n");
 		rdev->debugfs = NULL;
 		return;
@@ -3231,14 +3231,13 @@ static int __init regulator_init(void)
 
 #ifdef CONFIG_DEBUG_FS
 	debugfs_root = debugfs_create_dir("regulator", NULL);
-	if (IS_ERR(debugfs_root) || !debugfs_root) {
+	if (IS_ERR_OR_NULL(debugfs_root)) {
 		pr_warn("regulator: Failed to create debugfs directory\n");
 		debugfs_root = NULL;
 	}
 
-	if (IS_ERR(debugfs_create_file("supply_map", 0444, debugfs_root,
-				       NULL, &supply_map_fops)))
-		pr_warn("regulator: Failed to create supplies debugfs\n");
+	debugfs_create_file("supply_map", 0444, debugfs_root, NULL,
+			    &supply_map_fops);
 #endif
 
 	regulator_dummy_init();
-- 
1.7.9

