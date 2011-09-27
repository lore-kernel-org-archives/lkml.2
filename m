Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab1I0KZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:25:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33299 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984Ab1I0KZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:25:20 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH 5/5] regmap: Ensure we scream if we enable cache bypass/only at the same time
Date: Tue, 27 Sep 2011 11:25:08 +0100
Message-Id: <1317119108-15338-6-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317119108-15338-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1317119108-15338-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 2628e42..9f445bd 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -273,6 +273,8 @@ EXPORT_SYMBOL_GPL(regcache_sync);
  */
 void regcache_cache_only(struct regmap *map, bool enable)
 {
+	BUG_ON(map->cache_bypass && enable);
+
 	map->cache_only = enable;
 }
 EXPORT_SYMBOL_GPL(regcache_cache_only);
@@ -290,6 +292,8 @@ EXPORT_SYMBOL_GPL(regcache_cache_only);
  */
 void regcache_cache_bypass(struct regmap *map, bool enable)
 {
+	BUG_ON(map->cache_only && enable);
+
 	map->cache_bypass = enable;
 }
 EXPORT_SYMBOL_GPL(regcache_cache_bypass);
-- 
1.7.6.4

