Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1HNKuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 06:50:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36360 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753115Ab1HNKuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 06:50:35 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] regmap: Share some of the debugfs infrastructure ready for more files
Date: Sun, 14 Aug 2011 19:50:24 +0900
Message-Id: <1313319025-5514-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313319025-5514-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1313319025-5514-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index fff8e83..e541d7f4 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -20,7 +20,14 @@
 
 static struct dentry *regmap_debugfs_root;
 
-static int regmap_map_open_file(struct inode *inode, struct file *file)
+/* Calculate the length of a fixed format  */
+static size_t regmap_calc_reg_len(int max_val, char *buf, size_t buf_size)
+{
+	snprintf(buf, buf_size, "%x", max_val);
+	return strlen(buf);
+}
+
+static int regmap_open_file(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
 	return 0;
@@ -46,8 +53,7 @@ static ssize_t regmap_map_read_file(struct file *file, char __user *user_buf,
 		return -ENOMEM;
 
 	/* Calculate the length of a fixed format  */
-	snprintf(buf, count, "%x", map->max_register);
-	reg_len = strlen(buf);
+	reg_len = regmap_calc_reg_len(map->max_register, buf, count);
 	val_len = 2 * map->format.val_bytes;
 	tot_len = reg_len + val_len + 3;      /* : \n */
 
@@ -98,7 +104,7 @@ out:
 }
 
 static const struct file_operations regmap_map_fops = {
-	.open = regmap_map_open_file,
+	.open = regmap_open_file,
 	.read = regmap_map_read_file,
 	.llseek = default_llseek,
 };
-- 
1.7.5.4

