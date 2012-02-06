Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab2BFSCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:02:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43581 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130Ab2BFSCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:02:30 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regmap: Don't use bitfields for booleans
Date: Mon,  6 Feb 2012 18:02:27 +0000
Message-Id: <1328551348-7662-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was a cut'n'paste from some older code.

Since we're about to add debugfs support don't do the obvious thing and
use bool, use u32 instead (which debugfs has been using since time
immemorial).

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 9ec8d8f..abd7667 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -66,16 +66,16 @@ struct regmap {
 	unsigned int num_reg_defaults_raw;
 
 	/* if set, only the cache is modified not the HW */
-	unsigned int cache_only:1;
+	u32 cache_only;
 	/* if set, only the HW is modified not the cache */
-	unsigned int cache_bypass:1;
+	u32 cache_bypass;
 	/* if set, remember to free reg_defaults_raw */
-	unsigned int cache_free:1;
+	bool cache_free;
 
 	struct reg_default *reg_defaults;
 	const void *reg_defaults_raw;
 	void *cache;
-	bool cache_dirty;
+	u32 cache_dirty;
 
 	struct reg_default *patch;
 	int patch_regs;
-- 
1.7.9.rc1

