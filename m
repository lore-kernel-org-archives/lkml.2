Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab0ENT37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:29:59 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51394 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759330Ab0ENT34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:29:56 -0400
Date: Fri, 14 May 2010 21:29:51 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/10] drivers/message/i2o/memory.c: Use kstrdup
Message-ID: <Pine.LNX.4.64.1005142129290.28935@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kstrdup when the goal of an allocation is copy a string into the
allocated region.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to;
expression flag,E1,E2;
statement S;
@@

-  to = kmalloc(strlen(from) + 1,flag);
+  to = kstrdup(from, flag);
   ... when != \(from = E1 \| to = E1 \)
   if (to==NULL || ...) S
   ... when != \(from = E2 \| to = E2 \)
-  strcpy(to, from);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/message/i2o/memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/drivers/message/i2o/memory.c b/drivers/message/i2o/memory.c
--- a/drivers/message/i2o/memory.c
+++ b/drivers/message/i2o/memory.c
@@ -270,10 +270,9 @@ EXPORT_SYMBOL_GPL(i2o_dma_realloc);
 int i2o_pool_alloc(struct i2o_pool *pool, const char *name,
 				 size_t size, int min_nr)
 {
-	pool->name = kmalloc(strlen(name) + 1, GFP_KERNEL);
+	pool->name = kstrdup(name, GFP_KERNEL);
 	if (!pool->name)
 		goto exit;
-	strcpy(pool->name, name);
 
 	pool->slab =
 	    kmem_cache_create(pool->name, size, 0, SLAB_HWCACHE_ALIGN, NULL);
