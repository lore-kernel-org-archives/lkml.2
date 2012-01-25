Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab2AYVHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 16:07:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33223 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055Ab2AYVHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 16:07:07 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Unexport regcache_write() and regcache_read()
Date: Wed, 25 Jan 2012 21:07:04 +0000
Message-Id: <1327525625-32213-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They have no current users which is fortunate as they don't take the lock
and therefore aren't safe to use externally. We'll need to add new
operations if direct cache access is needed.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index ce2034c..0d54668 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -211,7 +211,6 @@ int regcache_read(struct regmap *map,
 
 	return -EINVAL;
 }
-EXPORT_SYMBOL_GPL(regcache_read);
 
 /**
  * regcache_write: Set the value of a given register in the cache.
@@ -238,7 +237,6 @@ int regcache_write(struct regmap *map,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(regcache_write);
 
 /**
  * regcache_sync: Sync the register cache with the hardware.
-- 
1.7.9.rc1

