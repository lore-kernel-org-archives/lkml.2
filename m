Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673Ab2DJX3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 19:29:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46491 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662Ab2DJX3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 19:29:21 -0400
From: Fabio Estevam <festevam@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, gregkh@linuxfoundation.org,
        Fabio Estevam <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] regmap: Fix build by removing extra parameter from regmap_debugfs_init()
Date: Tue, 10 Apr 2012 20:29:06 -0300
Message-Id: <1334100546-2534-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b4eb511 (Merge branches 'regmap-mmio', 'regmap-naming' and 'regmap-linus' into regmap-next)
added an extra paramter to the prototype of regmap_debugfs_init() in the case of !CONFIG_DEBUG_FS.

Remove this extra parameter so that the driver can build again when !CONFIG_DEBUG_FS.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
This applies against linux-next

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
1.7.1

