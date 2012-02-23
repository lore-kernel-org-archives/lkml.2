Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab2BWWGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:06:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44258 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753170Ab2BWWG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:06:29 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Mark the cache as clean after a successful sync
Date: Thu, 23 Feb 2012 22:06:23 +0000
Message-Id: <1330034783-8023-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously the cache would never be marked clean, meaning syncs would
never be suppressed which isn't the end of the world but could be
inefficient.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 1124abc..938cb1d 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -288,6 +288,9 @@ int regcache_sync(struct regmap *map)
 
 	ret = map->cache_ops->sync(map, 0, map->max_register);
 
+	if (ret == 0)
+		map->cache_dirty = false;
+
 out:
 	trace_regcache_sync(map->dev, name, "stop");
 	/* Restore the bypass state */
-- 
1.7.9.1

