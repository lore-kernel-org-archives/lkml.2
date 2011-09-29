Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab1I2Jj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:39:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56973 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756224Ab1I2JjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:39:21 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 8/8] regmap: Ensure we scream if we enable cache bypass/only at the same time
Date: Thu, 29 Sep 2011 10:39:13 +0100
Message-Id: <1317289153-21123-8-git-send-email-dp@opensource.wolfsonmicro.com>
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
index eaa2e20..82e619e 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -280,6 +280,7 @@ EXPORT_SYMBOL_GPL(regcache_sync);
  */
 void regcache_cache_only(struct regmap *map, bool enable)
 {
+	BUG_ON(map->cache_bypass && enable);
 	mutex_lock(&map->lock);
 	map->cache_only = enable;
 	mutex_unlock(&map->lock);
@@ -299,6 +300,7 @@ EXPORT_SYMBOL_GPL(regcache_cache_only);
  */
 void regcache_cache_bypass(struct regmap *map, bool enable)
 {
+	BUG_ON(map->cache_only && enable);
 	mutex_lock(&map->lock);
 	map->cache_bypass = enable;
 	mutex_unlock(&map->lock);
-- 
1.7.6.4

