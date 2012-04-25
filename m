Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab2DYGWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 02:22:47 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48168 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758911Ab2DYGWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 02:22:45 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-0a-4f979832e947
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 4/6] zsmalloc: add/fix function comment
Date: Wed, 25 Apr 2012 15:23:12 +0900
Message-Id: <1335334994-22138-5-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1335334994-22138-1-git-send-email-minchan@kernel.org>
References: <1335334994-22138-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add/fix the comment.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zsmalloc/zsmalloc-main.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 0fe4cbb..b7d31cc 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -565,12 +565,9 @@ EXPORT_SYMBOL_GPL(zs_destroy_pool);
  * zs_malloc - Allocate block of given size from pool.
  * @pool: pool to allocate from
  * @size: size of block to allocate
- * @page: page no. that holds the object
- * @offset: location of object within page
  *
  * On success, <page, offset> identifies block allocated
- * and 0 is returned. On failure, <page, offset> is set to
- * 0 and -ENOMEM is returned.
+ * and <page, offset> is returned. On failure, NULL is returned.
  *
  * Allocation requests with size > ZS_MAX_ALLOC_SIZE will fail.
  */
@@ -666,6 +663,16 @@ void zs_free(struct zs_pool *pool, void *obj)
 }
 EXPORT_SYMBOL_GPL(zs_free);
 
+/**
+ * zs_map_object - get address of allocated object from handle.
+ * @pool: object allocated pool
+ * @handle: handle returned from zs_malloc
+ *
+ * Before using object allocated from zs_malloc, object
+ * should be mapped to page table by this function.
+ * After using object,  call zs_unmap_object to unmap page
+ * table.
+ */
 void *zs_map_object(struct zs_pool *pool, void *handle)
 {
 	struct page *page;
-- 
1.7.9.5

