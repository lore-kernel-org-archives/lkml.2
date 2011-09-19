Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab1ISSFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:05:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38797 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756227Ab1ISSEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:04:36 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/5] regmap: A cache type of _NONE behaves like a bypassed cache
Date: Mon, 19 Sep 2011 19:03:40 +0100
Message-Id: <1316455424-11173-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <20110919175948.GD540@opensource.wolfsonmicro.com>
References: <20110919175948.GD540@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid extra special casing by setting the cache_bypass flag when we're
not caching.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index c438498..e0a4a0d 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -82,8 +82,10 @@ int regcache_init(struct regmap *map)
 	int i;
 	void *tmp_buf;
 
-	if (map->cache_type == REGCACHE_NONE)
+	if (map->cache_type == REGCACHE_NONE) {
+		map->cache_bypass = true;
 		return 0;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(cache_types); i++)
 		if (cache_types[i]->type == map->cache_type)
-- 
1.7.6.3

