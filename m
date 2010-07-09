Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab0GITNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:13:53 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:34374 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab0GITMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:12:24 -0400
Message-Id: <20100709190859.677969075@quilx.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Jul 2010 14:07:23 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Cc: David Rientjes <rientjes@google.com>
Subject: [S+Q2 17/19] SLUB: Get rid of useless function count_free()
References: <20100709190706.938177313@quilx.com>
Content-Disposition: inline; filename=sled_drop_count_free
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

count_free() == available()

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-07-07 10:54:29.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-07-07 10:54:33.000000000 -0500
@@ -1652,11 +1652,6 @@ static inline int node_match(struct kmem
 	return 1;
 }
 
-static int count_free(struct page *page)
-{
-	return available(page);
-}
-
 static unsigned long count_partial(struct kmem_cache_node *n,
 					int (*get_count)(struct page *))
 {
@@ -1705,7 +1700,7 @@ slab_out_of_memory(struct kmem_cache *s,
 		if (!n)
 			continue;
 
-		nr_free  = count_partial(n, count_free);
+		nr_free  = count_partial(n, available);
 		nr_slabs = node_nr_slabs(n);
 		nr_objs  = node_nr_objs(n);
 
@@ -3835,7 +3830,7 @@ static ssize_t show_slab_objects(struct 
 			x = atomic_long_read(&n->total_objects);
 		else if (flags & SO_OBJECTS)
 			x = atomic_long_read(&n->total_objects) -
-				count_partial(n, count_free);
+				count_partial(n, available);
 
 			else
 				x = atomic_long_read(&n->nr_slabs);
@@ -4717,7 +4712,7 @@ static int s_show(struct seq_file *m, vo
 		nr_partials += n->nr_partial;
 		nr_slabs += atomic_long_read(&n->nr_slabs);
 		nr_objs += atomic_long_read(&n->total_objects);
-		nr_free += count_partial(n, count_free);
+		nr_free += count_partial(n, available);
 	}
 
 	nr_inuse = nr_objs - nr_free;

