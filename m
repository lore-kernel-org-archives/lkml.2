Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1I1Kn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 06:43:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50437 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894Ab1I1Kny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 06:43:54 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/7] regmap: Modify map->cache_bypass directly
Date: Wed, 28 Sep 2011 11:43:42 +0100
Message-Id: <1317206627-6673-2-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317206627-6673-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1317206627-6673-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preperation for the upcoming patches, modify map->cache_bypass
directly.  The helper functions will grab an exclusive lock.  Because
we'll have acquired the same lock we need to avoid a deadlock.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 5364dde..f46e247 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -241,9 +241,9 @@ int regcache_sync(struct regmap *map)
 			ret = regcache_read(map, i, &val);
 			if (ret < 0)
 				goto out;
-			regcache_cache_bypass(map, true);
+			map->cache_bypass = 1;
 			ret = regmap_write(map, i, val);
-			regcache_cache_bypass(map, false);
+			map->cache_bypass = 0;
 			if (ret < 0)
 				goto out;
 			dev_dbg(map->dev, "Synced register %#x, value %#x\n",
-- 
1.7.6.4

