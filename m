Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab1JINi5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 09:38:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50320 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903Ab1JINi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 09:38:56 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: dp@opensource.wolfsonmicro.com
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Warn on raw I/O as well as bulk reads that bypass cache
Date: Sun,  9 Oct 2011 14:38:54 +0100
Message-Id: <1318167534-16479-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As with the bulk reads we really should be able to make these play
nicely with the cache but warn for now.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index d786ddc..85bffdd 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -377,6 +377,8 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 {
 	int ret;
 
+	WARN_ON(map->cache_type != REGCACHE_NONE);
+
 	mutex_lock(&map->lock);
 
 	ret = _regmap_raw_write(map, reg, val, val_len);
@@ -481,6 +483,8 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 {
 	int ret;
 
+	WARN_ON(map->cache_type != REGCACHE_NONE);
+
 	mutex_lock(&map->lock);
 
 	ret = _regmap_raw_read(map, reg, val, val_len);
-- 
1.7.6.3

