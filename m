Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab2BVNxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:53:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51410 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585Ab2BVNxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:53:42 -0500
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] regmap: Append device name in the root debugfs dir
Date: Wed, 22 Feb 2012 13:53:03 +0000
Message-Id: <1329918783-22610-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index b3b4b8f..f396246 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -179,8 +179,12 @@ static const struct file_operations regmap_access_fops = {
 
 void regmap_debugfs_init(struct regmap *map)
 {
-	map->debugfs = debugfs_create_dir(dev_name(map->dev),
-					  regmap_debugfs_root);
+	char name[64];
+
+	snprintf(name, sizeof(name), "%s-%s",
+		 dev_name(map->dev), map->dev->driver->name);
+
+	map->debugfs = debugfs_create_dir(name, regmap_debugfs_root);
 	if (!map->debugfs) {
 		dev_warn(map->dev, "Failed to create debugfs directory\n");
 		return;
-- 
1.7.9.1

