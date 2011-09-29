Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab1I2JjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:39:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56962 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755330Ab1I2JjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:39:16 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/8] regmap: Make _regmap_write() global
Date: Thu, 29 Sep 2011 10:39:07 +0100
Message-Id: <1317289153-21123-2-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317289153-21123-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1317289153-21123-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h |    3 +++
 drivers/base/regmap/regmap.c   |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 2d51b1b..348ff02 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -91,6 +91,9 @@ bool regmap_readable(struct regmap *map, unsigned int reg);
 bool regmap_volatile(struct regmap *map, unsigned int reg);
 bool regmap_precious(struct regmap *map, unsigned int reg);
 
+int _regmap_write(struct regmap *map, unsigned int reg,
+		  unsigned int val);
+
 #ifdef CONFIG_DEBUG_FS
 extern void regmap_debugfs_initcall(void);
 extern void regmap_debugfs_init(struct regmap *map);
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 3596465..d786ddc 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -296,8 +296,8 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	return ret;
 }
 
-static int _regmap_write(struct regmap *map, unsigned int reg,
-			 unsigned int val)
+int _regmap_write(struct regmap *map, unsigned int reg,
+		  unsigned int val)
 {
 	int ret;
 	BUG_ON(!map->format.format_write && !map->format.format_val);
-- 
1.7.6.4

