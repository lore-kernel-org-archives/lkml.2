Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1HIVNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 17:13:11 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:41526 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752656Ab1HIVND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 17:13:03 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8wE4b8AVM1mr6vWzJxPDwycUdRW3VLBsNU9gN4UYMfACJCn
 44r5JbOjJbujg4evczLT0zM80WbxatvAKR3VXwas4brTEsRPGnrHBrRAtcbQ
 KOeYJ2pxj0_YtcFJkY4ootmA5fItSaHTyuzvKOo6LeFOpIdei_FybKJa3BTv
 gJAXk8Pdyo79a6v4zO4FgM09IDeNjG_.Wc59xJx.hE5jJy7EbdaYNH.dTA59
 XiLg7kMzILSF82wBFA0015cn1eyuGiRMp9u9KGksxkEGKVzMd9ORqf0WmVPR
 rTMd3vCj6e4tqaIuKnng9WanZly7VOQM6vDb0Z4dOQWkbeKd6q_528euDX6L
 Rn3KU8bleqrl7uK0besyDutj12xZFxku8T_2NvWVkMI70z8jB5CyP9ZXzn4c
 u6_.k.DqSsguZ8yHUA.cVrg--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Message-Id: <20110809211300.388362487@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 09 Aug 2011 16:12:24 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: tj@kernel.org
Cc: Metathronius Galabant <m.galabant@googlemail.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Adrian Drzewiecki <z@drze.net>
Cc: linux-kernel@vger.kernel.org
Subject: [slub p4 3/7] slub: Prepare inuse field in new_slab()
References: <20110809211221.831975979@linux.com>
Content-Disposition: inline; filename=new_slab
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inuse will always be set to page->objects. There is no point in
initializing the field to zero in new_slab() and then overwriting
the value in __slab_alloc().

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 mm/slub.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-08-09 13:05:06.211582007 -0500
+++ linux-2.6/mm/slub.c	2011-08-09 13:05:07.091582007 -0500
@@ -1447,7 +1447,7 @@ static struct page *new_slab(struct kmem
 	set_freepointer(s, last, NULL);
 
 	page->freelist = start;
-	page->inuse = 0;
+	page->inuse = page->objects;
 	page->frozen = 1;
 out:
 	return page;
@@ -2139,7 +2139,6 @@ new_slab:
 		 */
 		object = page->freelist;
 		page->freelist = NULL;
-		page->inuse = page->objects;
 
 		stat(s, ALLOC_SLAB);
 		c->node = page_to_nid(page);
@@ -2681,7 +2680,7 @@ static void early_kmem_cache_node_alloc(
 	n = page->freelist;
 	BUG_ON(!n);
 	page->freelist = get_freepointer(kmem_cache_node, n);
-	page->inuse++;
+	page->inuse = 1;
 	page->frozen = 0;
 	kmem_cache_node->node[node] = n;
 #ifdef CONFIG_SLUB_DEBUG

