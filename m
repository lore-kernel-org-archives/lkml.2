Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab2BFSCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:02:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43582 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158Ab2BFSCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:02:30 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regmap: Add debugfs information for the cache status
Date: Mon,  6 Feb 2012 18:02:28 +0000
Message-Id: <1328551348-7662-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
In-Reply-To: <1328551348-7662-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1328551348-7662-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show all the cache status flags in debugfs if we have a cache.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 6f39747..b3b4b8f 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -192,6 +192,15 @@ void regmap_debugfs_init(struct regmap *map)
 		debugfs_create_file("access", 0400, map->debugfs,
 				    map, &regmap_access_fops);
 	}
+
+	if (map->cache_type) {
+		debugfs_create_bool("cache_only", 0400, map->debugfs,
+				    &map->cache_only);
+		debugfs_create_bool("cache_dirty", 0400, map->debugfs,
+				    &map->cache_dirty);
+		debugfs_create_bool("cache_bypass", 0400, map->debugfs,
+				    &map->cache_bypass);
+	}
 }
 
 void regmap_debugfs_exit(struct regmap *map)
-- 
1.7.9.rc1

