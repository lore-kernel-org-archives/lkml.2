Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab2H0E27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 00:28:59 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39898 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab2H0E25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 00:28:57 -0400
MIME-Version: 1.0
Date: Mon, 27 Aug 2012 12:28:57 +0800
Message-ID: <CAPgLHd8UfKzk+7s7h63vz5NNCWDmySZ5JBf7KmjfvQJk0HJ9hA@mail.gmail.com>
Subject: [PATCH] xen/blkback: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
From: Wei Yongjun <weiyj.lk@gmail.com>
To: konrad.wilk@oracle.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using kmem_cache_zalloc() instead of kmem_cache_alloc() and memset().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/block/xen-blkback/xenbus.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 4f66171..c0bbc46 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -105,11 +105,10 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 {
 	struct xen_blkif *blkif;
 
-	blkif = kmem_cache_alloc(xen_blkif_cachep, GFP_KERNEL);
+	blkif = kmem_cache_zalloc(xen_blkif_cachep, GFP_KERNEL);
 	if (!blkif)
 		return ERR_PTR(-ENOMEM);
 
-	memset(blkif, 0, sizeof(*blkif));
 	blkif->domid = domid;
 	spin_lock_init(&blkif->blk_ring_lock);
 	atomic_set(&blkif->refcnt, 1);


