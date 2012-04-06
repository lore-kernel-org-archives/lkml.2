Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab2DFVRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:17:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37072 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab2DFVRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:17:41 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/2] regmap: mmio: convert some error returns to BUG()
Date: Fri,  6 Apr 2012 15:17:32 -0600
Message-Id: <1333747053-6846-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Some of the error conditions detected by regmap_mmio_*() are pure internal
errors, rather than user-/client-triggerable conditions. Convert these to
BUG().

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/base/regmap/regmap-mmio.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/base/regmap/regmap-mmio.c b/drivers/base/regmap/regmap-mmio.c
index 1a7b5ee..ffa0e85 100644
--- a/drivers/base/regmap/regmap-mmio.c
+++ b/drivers/base/regmap/regmap-mmio.c
@@ -35,8 +35,8 @@ static int regmap_mmio_gather_write(void *context,
 	struct regmap_mmio_context *ctx = context;
 	u32 offset;
 
-	if (reg_size != 4)
-		return -EIO;
+	BUG_ON(reg_size != 4);
+
 	if (val_size % ctx->val_bytes)
 		return -EIO;
 
@@ -60,7 +60,7 @@ static int regmap_mmio_gather_write(void *context,
 #endif
 		default:
 			/* Should be caught by regmap_mmio_check_config */
-			return -EIO;
+			BUG();
 		}
 		val_size -= ctx->val_bytes;
 		val += ctx->val_bytes;
@@ -72,8 +72,8 @@ static int regmap_mmio_gather_write(void *context,
 
 static int regmap_mmio_write(void *context, const void *data, size_t count)
 {
-	if (count < 4)
-		return -EIO;
+	BUG_ON(count < 4);
+
 	return regmap_mmio_gather_write(context, data, 4, data + 4, count - 4);
 }
 
@@ -84,8 +84,8 @@ static int regmap_mmio_read(void *context,
 	struct regmap_mmio_context *ctx = context;
 	u32 offset;
 
-	if (reg_size != 4)
-		return -EIO;
+	BUG_ON(reg_size != 4);
+
 	if (val_size % ctx->val_bytes)
 		return -EIO;
 
@@ -109,7 +109,7 @@ static int regmap_mmio_read(void *context,
 #endif
 		default:
 			/* Should be caught by regmap_mmio_check_config */
-			return -EIO;
+			BUG();
 		}
 		val_size -= ctx->val_bytes;
 		val += ctx->val_bytes;
-- 
1.7.0.4

