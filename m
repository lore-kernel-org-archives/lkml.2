Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab0HDCyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:54:52 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:39605 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758208Ab0HDCwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:52:15 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: qqYMVJkVM1krO0ZLnUyLD_E3a2JQjzv6iDd6k4tTlpwkZwc
 cI6gAftVb3abWu8U8uGPnjPyEvOxXHBwyV5dDrZIT0eJBo4UEOvbhV5eJJnR
 IDZIzVIx.lzxyhiV3KnhfvtJ3UzXEvo_jbA6u5uRY1w_PNqfsAUIHAhTNygK
 DaFPR2dJ16oR36mn1OgZ27uNfabYXX61TjniPtI1z7ffuIRtpTnP_RtaD_0b
 STwwgMjfEd3iY4cV6UlGBPkaYa4LEXvhc.iXSH6v381ONLULlo_riZpT3PRp
 hGMtCxdudFx5GpP6d
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20100804024533.069345035@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 Aug 2010 21:45:30 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Cc: David Rientjes <rientjes@google.com>
Subject: [S+Q3 16/23] slub: Get rid of useless function count_free()
References: <20100804024514.139976032@linux.com>
Content-Disposition: inline; filename=unified_drop_count_free
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
--- linux-2.6.orig/mm/slub.c	2010-07-30 18:44:54.767739966 -0500
+++ linux-2.6/mm/slub.c	2010-07-30 18:45:24.248349179 -0500
@@ -1697,11 +1697,6 @@
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
@@ -1750,7 +1745,7 @@
 		if (!n)
 			continue;
 
-		nr_free  = count_partial(n, count_free);
+		nr_free  = count_partial(n, available);
 		nr_slabs = node_nr_slabs(n);
 		nr_objs  = node_nr_objs(n);
 
@@ -3906,7 +3901,7 @@
 			x = atomic_long_read(&n->total_objects);
 		else if (flags & SO_OBJECTS)
 			x = atomic_long_read(&n->total_objects) -
-				count_partial(n, count_free);
+				count_partial(n, available);
 
 			else
 				x = atomic_long_read(&n->nr_slabs);
@@ -4792,7 +4787,7 @@
 		nr_partials += n->nr_partial;
 		nr_slabs += atomic_long_read(&n->nr_slabs);
 		nr_objs += atomic_long_read(&n->total_objects);
-		nr_free += count_partial(n, count_free);
+		nr_free += count_partial(n, available);
 	}
 
 	nr_inuse = nr_objs - nr_free;

