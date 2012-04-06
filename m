Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab2DFFJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 01:09:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49375 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab2DFFJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 01:09:26 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        linux-next@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] regmap: fix compilation when !CONFIG_DEBUG_FS
Date: Thu,  5 Apr 2012 23:09:20 -0600
Message-Id: <1333688960-24402-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.5.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Commit 79c64d5 "regmap: allow regmap instances to be named" changed the
prototype of regmap_debugfs_init, but didn't update the dummy inline used
when !CONFIG_DEBUGFS. Fix this.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/base/regmap/internal.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 9bc1d27..99b28ff 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -116,7 +116,7 @@ extern void regmap_debugfs_init(struct regmap *map, const char *name);
 extern void regmap_debugfs_exit(struct regmap *map);
 #else
 static inline void regmap_debugfs_initcall(void) { }
-static inline void regmap_debugfs_init(struct regmap *map) { }
+static inline void regmap_debugfs_init(struct regmap *map, const char *name) { }
 static inline void regmap_debugfs_exit(struct regmap *map) { }
 #endif
 
-- 
1.7.5.4

