Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab2DFVRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:17:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38423 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758098Ab2DFVRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:17:41 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 2/2] regmap: mmio: remove some error checks now in the core
Date: Fri,  6 Apr 2012 15:17:33 -0600
Message-Id: <1333747053-6846-2-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1333747053-6846-1-git-send-email-swarren@wwwdotorg.org>
References: <1333747053-6846-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

These error checks are implemented in regmap core. Remove the duplicate
code from regmap-mmio.c

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
This logically slight depends on "regmap: validate regmap_raw_read/write
val_len" that I just sent, but its not really a big deal.

 drivers/base/regmap/regmap-mmio.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/base/regmap/regmap-mmio.c b/drivers/base/regmap/regmap-mmio.c
index ffa0e85..bdf4dc8 100644
--- a/drivers/base/regmap/regmap-mmio.c
+++ b/drivers/base/regmap/regmap-mmio.c
@@ -37,9 +37,6 @@ static int regmap_mmio_gather_write(void *context,
 
 	BUG_ON(reg_size != 4);
 
-	if (val_size % ctx->val_bytes)
-		return -EIO;
-
 	offset = be32_to_cpup(reg);
 
 	while (val_size) {
@@ -86,9 +83,6 @@ static int regmap_mmio_read(void *context,
 
 	BUG_ON(reg_size != 4);
 
-	if (val_size % ctx->val_bytes)
-		return -EIO;
-
 	offset = be32_to_cpup(reg);
 
 	while (val_size) {
-- 
1.7.0.4

