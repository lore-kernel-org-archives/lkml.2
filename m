Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475Ab2FUDfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 23:35:07 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:62635 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758387Ab2FUDfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 23:35:06 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm-cc@laptop.org, ngupta@vflare.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 1/2] staging: zram: Remove some dead code
Date: Thu, 21 Jun 2012 00:32:44 -0300
Message-Id: <1340249565-29404-2-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340249565-29404-1-git-send-email-marcos.souza.org@gmail.com>
References: <1340249565-29404-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes code that is never executed by zram.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/zram/zram_drv.c |    9 ---------
 drivers/staging/zram/zram_drv.h |    3 ---
 2 files changed, 12 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 685d612..5216ee1 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -415,15 +415,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	cmem = zs_map_object(zram->mem_pool, handle);
 
 memstore:
-#if 0
-	/* Back-reference needed for memory defragmentation */
-	if (!zram_test_flag(zram, index, ZRAM_UNCOMPRESSED)) {
-		zheader = (struct zobj_header *)cmem;
-		zheader->table_idx = index;
-		cmem += sizeof(*zheader);
-	}
-#endif
-
 	memcpy(cmem, src, clen);
 
 	if (unlikely(zram_test_flag(zram, index, ZRAM_UNCOMPRESSED))) {
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index fbe8ac9..fe3f8fe 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -33,9 +33,6 @@ static const unsigned max_num_devices = 32;
  * object. This is required to support memory defragmentation.
  */
 struct zobj_header {
-#if 0
-	u32 table_idx;
-#endif
 };
 
 /*-- Configurable parameters */
-- 
1.7.10.2

