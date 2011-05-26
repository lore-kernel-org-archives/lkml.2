Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab1EZSPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:15:43 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:41237 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758274Ab1EZSPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:15:12 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: daUqnKAVM1kysQz8MXBtYq7A.2gYH0tydjo2vS5e5uWNLlc
 E7nPRqZDBQLPMumt7TIZJuwlC4._e4FNgU3hNh6wppd0zMJBUh9pHh4fqm8g
 VmxbGR.N8vi_UXzego7CRv3MxyoYM4s8MHx_QZ9VwbyM9aOnF5P5URCJjSYL
 bIpiwYQPIbTVXrCWMjMNg7nEBPFVQZyESYdQ.aakCUNwc_jk7_KdN33aJ0Pq
 QLj84H8f8oep.ChWhzCvD2V8krkUMAaJ79Zm_58YzzyQeH._kreYdOvGP.Ic
 5aVCcfY53wjIEZf1vrGXqHt4gJQeG7YxrcrQv8JI9KfzTAtRS
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110526181510.602701212@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 May 2011 13:14:58 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv6 16/17] slub: Not necessary to check for empty slab on load_freelist
References: <20110526181442.789868308@linux.com>
Content-Disposition: inline; filename=goto_load_freelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

load_freelist is now only branched to only if there are objects available.
So no need to check the object variable for NULL.

---
 mm/slub.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-24 09:41:11.294874943 -0500
+++ linux-2.6/mm/slub.c	2011-05-24 09:41:15.454874919 -0500
@@ -1983,9 +1983,6 @@ static void *__slab_alloc(struct kmem_ca
 			NULL, new.counters,
 			"__slab_alloc"));
 
-load_freelist:
-	VM_BUG_ON(!page->frozen);
-
 	if (unlikely(!object)) {
 		c->page = NULL;
 		stat(s, DEACTIVATE_BYPASS);
@@ -1994,6 +1991,8 @@ load_freelist:
 
 	stat(s, ALLOC_REFILL);
 
+load_freelist:
+	VM_BUG_ON(!page->frozen);
 	c->freelist = get_freepointer(s, object);
 	c->tid = next_tid(c->tid);
 	local_irq_restore(flags);

