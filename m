Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab1KVIYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 03:24:25 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45714 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab1KVIYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 03:24:24 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: kernel@pengutronix.de, Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Fix build failure with CONFIG_DEBUG_FS=n
Date: Tue, 22 Nov 2011 09:24:20 +0100
Message-Id: <1321950260-22193-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes:

	drivers/base/regmap/regcache-rbtree.c: In function 'regcache_rbtree_init':
	drivers/base/regmap/regcache-rbtree.c:197: error: 'struct regmap' has no member named 'debugfs'
	drivers/base/regmap/regcache-rbtree.c:197: error: 'rbtree_fops' undeclared (first use in this function)
	drivers/base/regmap/regcache-rbtree.c:197: error: (Each undeclared identifier is reported only once
	drivers/base/regmap/regcache-rbtree.c:197: error: for each function it appears in.)

which was introduced by commit

	bad2ab4 (regmap: Provide debugfs dump of the rbtree cache data)

currently in next-20111122.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/base/regmap/regcache-rbtree.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 7767cbb..270ad65 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -194,7 +194,9 @@ static int regcache_rbtree_init(struct regmap *map)
 			goto err;
 	}
 
+#ifdef CONFIG_DEBUG_FS
 	debugfs_create_file("rbtree", 0400, map->debugfs, map, &rbtree_fops);
+#endif
 
 	return 0;
 
-- 
1.7.7.2

