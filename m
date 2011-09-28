Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1I1KoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 06:44:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50439 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752492Ab1I1Kn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 06:43:57 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 5/7] regmap: Grab the lock in regcache_cache_only()
Date: Wed, 28 Sep 2011 11:43:45 +0100
Message-Id: <1317206627-6673-5-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317206627-6673-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1317206627-6673-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 695802c..8900897 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -282,7 +282,9 @@ EXPORT_SYMBOL_GPL(regcache_sync);
  */
 void regcache_cache_only(struct regmap *map, bool enable)
 {
+	mutex_lock(&map->sync_lock);
 	map->cache_only = enable;
+	mutex_unlock(&map->sync_lock);
 }
 EXPORT_SYMBOL_GPL(regcache_cache_only);
 
-- 
1.7.6.4

