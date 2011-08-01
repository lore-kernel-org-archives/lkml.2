Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab1HAQ3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:29:32 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:42416 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753309Ab1HAQ2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:28:53 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: te6e9xoVM1l..5XrO.YiVMeZI1ntJgro5LbKwDPRMcAfPCj
 QiU5AkR77qUTe5K1l1vYxi324YCbd7RbYpZKvckbpXJ3Mh3U2DmvHXpaZTfN
 9nNWKrTl7n9C3R4nYutXpxQJnBVYuhgX5gUCG0sYB1gbC1FVFz5MMJ27Q6sp
 JtYBPx0F3XkRJHWhCgIBNqWGVe6rtsUWIp3vP1aIHFOjA4v47aZ13EBMXsj4
 LkOYYFnxQgFHa9isJrikMhw2cd_reSr0.zcLD8Rxee653BHO6G4WnTQWMhTb
 4dG8qpx1ynQ2RK8fhs9QEv0qfU11rZHi8E3RPhx.acxO4KIhMseSh087EMU5
 OZurZ2P.IrzcXkhxO1JIAehdo
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Message-Id: <20110801162850.585692117@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 01 Aug 2011 11:28:26 -0500
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
Subject: [slub p3 3/7] slub: Prepare inuse field in new_slab()
References: <20110801162823.755182213@linux.com>
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
--- linux-2.6.orig/mm/slub.c	2011-08-01 11:04:06.385859038 -0500
+++ linux-2.6/mm/slub.c	2011-08-01 11:04:26.025858912 -0500
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
@@ -2679,7 +2678,7 @@ static void early_kmem_cache_node_alloc(
 	n = page->freelist;
 	BUG_ON(!n);
 	page->freelist = get_freepointer(kmem_cache_node, n);
-	page->inuse++;
+	page->inuse = 1;
 	page->frozen = 0;
 	kmem_cache_node->node[node] = n;
 #ifdef CONFIG_SLUB_DEBUG

