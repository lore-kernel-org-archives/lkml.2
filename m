Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab1I1Kny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 06:43:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50435 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282Ab1I1Knx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 06:43:53 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/7] regmap: Fix regcache_sync generic implementation
Date: Wed, 28 Sep 2011 11:43:41 +0100
Message-Id: <1317206627-6673-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to use regmap_write() to actually write anything
to the HW.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 6b9efd9..5364dde 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -242,7 +242,7 @@ int regcache_sync(struct regmap *map)
 			if (ret < 0)
 				goto out;
 			regcache_cache_bypass(map, true);
-			ret = regcache_write(map, i, val);
+			ret = regmap_write(map, i, val);
 			regcache_cache_bypass(map, false);
 			if (ret < 0)
 				goto out;
-- 
1.7.6.4

