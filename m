Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab1I2JjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:39:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56966 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756178Ab1I2JjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:39:18 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 4/8] regmap: Guard regcache_sync() with map->lock
Date: Thu, 29 Sep 2011 10:39:09 +0100
Message-Id: <1317289153-21123-4-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317289153-21123-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1317289153-21123-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index b6efde7..674da82 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -230,6 +230,7 @@ int regcache_sync(struct regmap *map)
 
 	BUG_ON(!map->cache_ops);
 
+	mutex_lock(&map->lock);
 	dev_dbg(map->dev, "Syncing %s cache\n",
 		map->cache_ops->name);
 	name = map->cache_ops->name;
@@ -254,6 +255,7 @@ int regcache_sync(struct regmap *map)
 	}
 out:
 	trace_regcache_sync(map->dev, name, "stop");
+	mutex_unlock(&map->lock);
 
 	return ret;
 }
-- 
1.7.6.4

