Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582Ab1KVLx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:53:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34615 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758469Ab1KVLxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:53:55 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Fix rbtreee build when not using debugfs
Date: Tue, 22 Nov 2011 11:53:33 +0000
Message-Id: <1321962813-18106-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The debugfs functions don't stub themselves out quite so well as might
be desirable so provide functions which do do this stubbing.

Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-rbtree.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 7767cbb..32620c4 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -170,6 +170,15 @@ static const struct file_operations rbtree_fops = {
 	.llseek		= seq_lseek,
 	.release	= single_release,
 };
+
+static void rbtree_debugfs_init(struct regmap *map)
+{
+	debugfs_create_file("rbtree", 0400, map->debugfs, map, &rbtree_fops);
+}
+#else
+static void rbtree_debugfs_init(struct regmap *map)
+{
+}
 #endif
 
 static int regcache_rbtree_init(struct regmap *map)
@@ -194,7 +203,7 @@ static int regcache_rbtree_init(struct regmap *map)
 			goto err;
 	}
 
-	debugfs_create_file("rbtree", 0400, map->debugfs, map, &rbtree_fops);
+	rbtree_debugfs_init(map);
 
 	return 0;
 
-- 
1.7.7.3

