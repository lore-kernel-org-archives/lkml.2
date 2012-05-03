Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab2ECGlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:41:09 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:62341 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab2ECGlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:41:08 -0400
X-AuditID: 9c930197-b7badae000000cfd-d0-4fa2287bcb4d
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 2/4] zsmalloc: add/fix function comment
Date: Thu,  3 May 2012 15:40:40 +0900
Message-Id: <1336027242-372-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336027242-372-1-git-send-email-minchan@kernel.org>
References: <1336027242-372-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add/fix the comment.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zsmalloc/zsmalloc-main.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 8642800..4496737 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -566,13 +566,9 @@ EXPORT_SYMBOL_GPL(zs_destroy_pool);
  * zs_malloc - Allocate block of given size from pool.
  * @pool: pool to allocate from
  * @size: size of block to allocate
- * @page: page no. that holds the object
- * @offset: location of object within page
- *
- * On success, <page, offset> identifies block allocated
- * and 0 is returned. On failure, <page, offset> is set to
- * 0 and -ENOMEM is returned.
  *
+ * On success, handle to the allocated object is returned,
+ * otherwise NULL.
  * Allocation requests with size > ZS_MAX_ALLOC_SIZE will fail.
  */
 void *zs_malloc(struct zs_pool *pool, size_t size)
@@ -667,6 +663,15 @@ void zs_free(struct zs_pool *pool, void *obj)
 }
 EXPORT_SYMBOL_GPL(zs_free);
 
+/**
+ * zs_map_object - get address of allocated object from handle.
+ * @pool: pool from which the object was allocated
+ * @handle: handle returned from zs_malloc
+ *
+ * Before using an object allocated from zs_malloc, it must be mapped using
+ * this function. When done with the object, it must be unmapped using
+ * zs_unmap_object
+*/
 void *zs_map_object(struct zs_pool *pool, void *handle)
 {
 	struct page *page;
-- 
1.7.9.5

