Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab1HIOf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:35:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36545 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751239Ab1HIOfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:35:24 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regmap: Use int rather than size_t for lengths when logging blocks
Date: Tue,  9 Aug 2011 17:00:04 +0900
Message-Id: <1312876805-460-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 warns as size_t is not an int.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/trace/events/regmap.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/trace/events/regmap.h b/include/trace/events/regmap.h
index 1c76f40..e35e37c 100644
--- a/include/trace/events/regmap.h
+++ b/include/trace/events/regmap.h
@@ -57,14 +57,14 @@ DEFINE_EVENT(regmap_reg, regmap_reg_read,
 
 DECLARE_EVENT_CLASS(regmap_block,
 
-	TP_PROTO(struct device *dev, unsigned int reg, size_t count),
+	TP_PROTO(struct device *dev, unsigned int reg, int count),
 
 	TP_ARGS(dev, reg, count),
 
 	TP_STRUCT__entry(
 		__string(	name,		dev_name(dev)	)
 		__field(	unsigned int,	reg		)
-		__field(	size_t,		count		)
+		__field(	int,		count		)
 	),
 
 	TP_fast_assign(
@@ -75,33 +75,33 @@ DECLARE_EVENT_CLASS(regmap_block,
 
 	TP_printk("%s reg=%x count=%d", __get_str(name),
 		  (unsigned int)__entry->reg,
-		  (size_t)__entry->count)
+		  (int)__entry->count)
 );
 
 DEFINE_EVENT(regmap_block, regmap_hw_read_start,
 
-	TP_PROTO(struct device *dev, unsigned int reg, size_t count),
+	TP_PROTO(struct device *dev, unsigned int reg, int count),
 
 	TP_ARGS(dev, reg, count)
 );
 
 DEFINE_EVENT(regmap_block, regmap_hw_read_done,
 
-	TP_PROTO(struct device *dev, unsigned int reg, size_t count),
+	TP_PROTO(struct device *dev, unsigned int reg, int count),
 
 	TP_ARGS(dev, reg, count)
 );
 
 DEFINE_EVENT(regmap_block, regmap_hw_write_start,
 
-	TP_PROTO(struct device *dev, unsigned int reg, size_t count),
+	TP_PROTO(struct device *dev, unsigned int reg, int count),
 
 	TP_ARGS(dev, reg, count)
 );
 
 DEFINE_EVENT(regmap_block, regmap_hw_write_done,
 
-	TP_PROTO(struct device *dev, unsigned int reg, size_t count),
+	TP_PROTO(struct device *dev, unsigned int reg, int count),
 
 	TP_ARGS(dev, reg, count)
 );
-- 
1.7.5.4

