Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab1KUTq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:46:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40662 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753095Ab1KUTqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:46:24 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regmap: Do debugfs init before cache init
Date: Mon, 21 Nov 2011 19:46:16 +0000
Message-Id: <1321904777-3077-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows caches to add custom debugfs files.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 10ecbba3..a862090 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -241,12 +241,12 @@ struct regmap *regmap_init(struct device *dev,
 		goto err_map;
 	}
 
+	regmap_debugfs_init(map);
+
 	ret = regcache_init(map, config);
 	if (ret < 0)
 		goto err_free_workbuf;
 
-	regmap_debugfs_init(map);
-
 	return map;
 
 err_free_workbuf:
-- 
1.7.7.3

