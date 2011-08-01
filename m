Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab1HAQ3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:29:43 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:43682 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753305Ab1HAQ2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:28:53 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 4m6aUKMVM1kuJ56xlNzcQ7nLnGg7f44tnOZJJgsqWX3u5OE
 aBFkeYGDICfeSBRdrUkpMRVrZkjGaPogAN0lshZu1DEaueN3wOTbTsiMf.mQ
 .HXmtJTI7_Xw0zdmpm85ZOWw3BjegSW5PNQEYpyZHju2XJrF0gHVaHB2_.MZ
 jRXwe2Sjhnm3.ivJlGyC1mVlhADwdnMXWOr4.iKW.nrxRCAgJBII_Gbx0T0S
 BUDx2vJ4wcNTOGysffEQsTB5ObeTlKrCN8MgDDd9p7y_2YcnuMHehpmuVOgK
 zUH_MWE8D2VRNmUsr.V70d3law4AKHrWBKuJiFUYR49wFPu5q.JjT7ZbQlAE
 7PMJUOOm2Evfh7baO4lUQxQiOA9qEXVSovAG3HZg-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Message-Id: <20110801162849.986427111@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 01 Aug 2011 11:28:25 -0500
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
Subject: [slub p3 2/7] slub: Remove useless statements in __slab_alloc
References: <20110801162823.755182213@linux.com>
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

