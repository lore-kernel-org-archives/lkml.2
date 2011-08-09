Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1HIVOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 17:14:31 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:47646 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752384Ab1HIVNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 17:13:02 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Uw9eTCEVM1mE_qCE6NxqvDZGXB29QNWTzxh3aqbqVVXqSzF
 Th5bKpBHct6BRGxcSxRq7dmb14DIydM7yDwPZ8PDGVWrw2GNwZUBuIfRa.Zj
 h1f6HBO5P3Jb5tpa40zjXmm4QWYWF4NFmt9mLcxolylWTfdiI7P4SFj5ZCw.
 Hc8HRFXUeWxOTbtmUe3OZ43g0r7Wx04RR4AaJOi6S_U_PKnY8IztsKgOjwIO
 _YZ_kgwD8uLVVMBuF690LnkxnTbznjiebyGJApq8xa7TM4psH_G_QOiZkQ.b
 K4HSprTT9hvjIljOldeHYpdC9boCEKy.3b3ffdj7ReaxVpMi8ukBopMYkXXP
 3HVqz3lwxg6cct_3lX6myC0mJa7baxk7FmjTEJu5GOPk3Ow7EBwxz1PgU_.a
 hk9nMwAuBHXypMpMTfl6HxulZVkNVrQNsDmXB
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Message-Id: <20110809211259.776343341@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 09 Aug 2011 16:12:23 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>, torvalds@linux-foundation.org
Cc: Andi Kleen <andi@firstfloor.org>
Cc: tj@kernel.org
Cc: Metathronius Galabant <m.galabant@googlemail.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Adrian Drzewiecki <z@drze.net>
Cc: linux-kernel@vger.kernel.org
Subject: [slub p4 2/7] slub: Remove useless statements in __slab_alloc
References: <20110809211221.831975979@linux.com>
Content-Disposition: inline; filename=remove_useless_page_null
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two statements in __slab_alloc() do not have any effect.

1. c->page is already set to NULL by deactivate_slab() called right before.

2. gfpflags are masked in new_slab() before being passed to the page
   allocator. There is no need to mask gfpflags in __slab_alloc in particular
   since most frequent processing in __slab_alloc does not require the use of a
   gfpmask.

Cc: torvalds@linux-foundation.org
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-08-01 11:03:15.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-08-01 11:04:06.385859038 -0500
@@ -2064,9 +2064,6 @@ static void *__slab_alloc(struct kmem_ca
 	c = this_cpu_ptr(s->cpu_slab);
 #endif
 
-	/* We handle __GFP_ZERO in the caller */
-	gfpflags &= ~__GFP_ZERO;
-
 	page = c->page;
 	if (!page)
 		goto new_slab;
@@ -2163,7 +2160,6 @@ debug:
 
 	c->freelist = get_freepointer(s, object);
 	deactivate_slab(s, c);
-	c->page = NULL;
 	c->node = NUMA_NO_NODE;
 	local_irq_restore(flags);
 	return object;

