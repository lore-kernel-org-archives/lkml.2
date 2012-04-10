Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab2DJGNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 02:13:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63499 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab2DJGNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 02:13:09 -0400
Message-ID: <1334038367.15859.12.camel@phoenix>
Subject: [linux-next][PATCH] regmap: fix build error if !CONFIG_DEBUG_FS
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stephen Warren <swarren@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 10 Apr 2012 14:12:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build error introduced by commit 9eba4d
"regmap: fix compilation when !CONFIG_DEBUG_FS".

  CC      drivers/base/regmap/regmap.o
drivers/base/regmap/regmap.c: In function 'regmap_init':
drivers/base/regmap/regmap.c:323: error: too few arguments to function 'regmap_debugfs_init'
drivers/base/regmap/regmap.c: In function 'regmap_reinit_cache':
drivers/base/regmap/regmap.c:408: error: too few arguments to function 'regmap_debugfs_init'
make[3]: *** [drivers/base/regmap/regmap.o] Error 1
make[2]: *** [drivers/base/regmap] Error 2
make[1]: *** [drivers/base] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
In current code (linux-next 20120410), regmap_debugfs_init only takes one parameter.

 drivers/base/regmap/internal.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 32c2947..e46c279 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -112,7 +112,7 @@ extern void regmap_debugfs_init(struct regmap *map);
 extern void regmap_debugfs_exit(struct regmap *map);
 #else
 static inline void regmap_debugfs_initcall(void) { }
-static inline void regmap_debugfs_init(struct regmap *map, const char *name) { }
+static inline void regmap_debugfs_init(struct regmap *map) { }
 static inline void regmap_debugfs_exit(struct regmap *map) { }
 #endif
 
-- 
1.7.5.4



