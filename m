Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab1I2JjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:39:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56960 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755091Ab1I2JjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:39:16 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/8] Revert "regmap: Grab the lock in regcache_cache_only()"
Date: Thu, 29 Sep 2011 10:39:06 +0100
Message-Id: <1317289153-21123-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 38f6916976f9e964748f097be3688e334fb60f3d.
---
 drivers/base/regmap/regcache.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 744ed145..f46e247 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -273,9 +273,7 @@ EXPORT_SYMBOL_GPL(regcache_sync);
  */
 void regcache_cache_only(struct regmap *map, bool enable)
 {
-	mutex_lock(&map->sync_lock);
 	map->cache_only = enable;
-	mutex_unlock(&map->sync_lock);
 }
 EXPORT_SYMBOL_GPL(regcache_cache_only);
 
-- 
1.7.6.4

