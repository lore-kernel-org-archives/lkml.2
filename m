Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab1FTPdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 11:33:03 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:34280 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752167Ab1FTPdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 11:33:01 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 4tb9zxMVM1l7OU5qjzcHQqG3CvZUoEWFNvhzJiTw8FlsB9S
 JuwIltgCQ1BT4_k2QNQKVY6AqpTySSo6RrYQYVEtiV_1dWZBdnkXes9ThEXq
 LCPvVInoDrvEjHY6105NiB9T3cuD6xrVJa91VTgN3E4GAFUn_uf.08cusScb
 vnDqe7UUhZmZZ7amztSN6fadRc4LdjskYK9MthwkhJpS6YS0fxcW.ClEsei2
 EkGoC9wBFYiq.bBluKGRJQxNTSo8w5goJQsEftQLpnk.nT5ygfsjWmerndpO
 pfaGx2hOzbpOcekZBDt76Euf.sHre8TUZftF3_KaSXstqtoVUzpvbIJ7kzc5
 zsvltv6RX0aoTR2CvBkbfTt7p
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Message-Id: <20110620153258.817879095@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 20 Jun 2011 10:32:45 -0500
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
Subject: [slub p2 1/4] slub: Prepare inuse field in new_slab()
References: <20110620153244.214038140@linux.com>
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
--- linux-2.6.orig/mm/slub.c	2011-06-14 11:43:54.864072250 -0500
+++ linux-2.6/mm/slub.c	2011-06-14 12:33:15.887854446 -0500
@@ -1341,7 +1341,7 @@ static struct page *new_slab(struct kmem
 	set_freepointer(s, last, NULL);
 
 	page->freelist = start;
-	page->inuse = 0;
+	page->inuse = page->objects;
 	page->frozen = 1;
 out:
 	return page;
@@ -2036,7 +2036,6 @@ new_slab:
 		 */
 		object = page->freelist;
 		page->freelist = NULL;
-		page->inuse = page->objects;
 
 		stat(s, ALLOC_SLAB);
 		c->node = page_to_nid(page);
@@ -2574,7 +2573,7 @@ static void early_kmem_cache_node_alloc(
 	n = page->freelist;
 	BUG_ON(!n);
 	page->freelist = get_freepointer(kmem_cache_node, n);
-	page->inuse++;
+	page->inuse = 1;
 	page->frozen = 0;
 	kmem_cache_node->node[node] = n;
 #ifdef CONFIG_SLUB_DEBUG

