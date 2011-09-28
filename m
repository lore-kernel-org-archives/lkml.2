Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab1I1KoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 06:44:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50441 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752414Ab1I1Kn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 06:43:57 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 4/7] regmap: Save/restore the bypass state upon syncing
Date: Wed, 28 Sep 2011 11:43:44 +0100
Message-Id: <1317206627-6673-4-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317206627-6673-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1317206627-6673-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index b843b5f..695802c 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -229,10 +229,13 @@ int regcache_sync(struct regmap *map)
 	unsigned int val;
 	unsigned int i;
 	const char *name;
+	unsigned int bypass;
 
 	BUG_ON(!map->cache_ops);
 
 	mutex_lock(&map->sync_lock);
+	/* Remember the initial bypass state */
+	bypass = map->cache_bypass;
 	dev_dbg(map->dev, "Syncing %s cache\n",
 		map->cache_ops->name);
 	name = map->cache_ops->name;
@@ -257,6 +260,8 @@ int regcache_sync(struct regmap *map)
 	}
 out:
 	trace_regcache_sync(map->dev, name, "stop");
+	/* Restore the bypass state */
+	map->cache_bypass = bypass;
 	mutex_unlock(&map->sync_lock);
 
 	return ret;
-- 
1.7.6.4

