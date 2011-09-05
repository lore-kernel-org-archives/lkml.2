Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1IETaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 15:30:25 -0400
Received: from smtp-out-051.synserver.de ([212.40.185.51]:1082 "HELO
	smtp-out-049.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753401Ab1IETaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 15:30:20 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 6229
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] regmap: Fix regmap compilation with CONFIG_DEBUGFS=n
Date: Mon,  5 Sep 2011 21:29:38 +0200
Message-Id: <1315250978-4242-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_DEBUGFS disabled the regmap compilation fails with the following
errors:

	drivers/base/regmap/regcache.o: In function `regmap_debugfs_initcall':
	drivers/base/regmap/internal.h:96: multiple definition of `regmap_debugfs_initcall'
	drivers/base/regmap/regmap.o:drivers/base/regmap/internal.h:96: first defined here
	drivers/base/regmap/regcache.o: In function `regmap_debugfs_init':
	drivers/base/regmap/internal.h:97: multiple definition of `regmap_debugfs_init'
	drivers/base/regmap/regmap.o:drivers/base/regmap/internal.h:97: first
	defined here drivers/base/regmap/regcache.o: In function `regmap_debugfs_exit':
	...

Make the debugfs stubs static inline to fix this.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/internal.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 5ab3fef..b4acd94 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -58,9 +58,9 @@ extern void regmap_debugfs_initcall(void);
 extern void regmap_debugfs_init(struct regmap *map);
 extern void regmap_debugfs_exit(struct regmap *map);
 #else
-void regmap_debugfs_initcall(void) { }
-void regmap_debugfs_init(struct regmap *map) { }
-void regmap_debugfs_exit(struct regmap *map) { }
+static inline void regmap_debugfs_initcall(void) { }
+static inline void regmap_debugfs_init(struct regmap *map) { }
+static inline void regmap_debugfs_exit(struct regmap *map) { }
 #endif
 
 #endif
-- 
1.7.2.5

