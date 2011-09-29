Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab1I2JkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:40:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56964 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755330Ab1I2JjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:39:18 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 5/8] regmap: Save/restore the bypass state upon syncing
Date: Thu, 29 Sep 2011 10:39:10 +0100
Message-Id: <1317289153-21123-5-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317289153-21123-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1317289153-21123-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 674da82..5362578 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -227,10 +227,13 @@ int regcache_sync(struct regmap *map)
 	unsigned int val;
 	unsigned int i;
 	const char *name;
+	unsigned int bypass;
 
 	BUG_ON(!map->cache_ops);
 
 	mutex_lock(&map->lock);
+	/* Remember the initial bypass state */
+	bypass = map->cache_bypass;
 	dev_dbg(map->dev, "Syncing %s cache\n",
 		map->cache_ops->name);
 	name = map->cache_ops->name;
@@ -255,6 +258,8 @@ int regcache_sync(struct regmap *map)
 	}
 out:
 	trace_regcache_sync(map->dev, name, "stop");
+	/* Restore the bypass state */
+	map->cache_bypass = bypass;
 	mutex_unlock(&map->lock);
 
 	return ret;
-- 
1.7.6.4

