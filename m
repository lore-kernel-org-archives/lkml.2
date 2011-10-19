Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab1JSFJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 01:09:32 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19779 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1JSFJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 01:09:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	message-id:user-agent:mime-version:content-type:x-system-of-record;
	b=h0dVMgkYfbV1BInYXwFINN3g05qk8c5QtQsFm6Swyz+aW5EdUOBdDyjFYXN7BcAZc
	T7pDndCSYNV1/GgfX6ZwA==
Date: Tue, 18 Oct 2011 22:09:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch 1/2] slab: rename slab_break_gfp_order to slab_max_order
Message-ID: <alpine.DEB.2.00.1110182207500.5907@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slab_break_gfp_order is more appropriately named slab_max_order since it
enforces the maximum order size of slabs as long as a single object will
still fit.

Also rename BREAK_GFP_ORDER_{LO,HI} accordingly.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slab.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -481,9 +481,9 @@ EXPORT_SYMBOL(slab_buffer_size);
 /*
  * Do not go above this order unless 0 objects fit into the slab.
  */
-#define	BREAK_GFP_ORDER_HI	1
-#define	BREAK_GFP_ORDER_LO	0
-static int slab_break_gfp_order = BREAK_GFP_ORDER_LO;
+#define	SLAB_MAX_ORDER_HI	1
+#define	SLAB_MAX_ORDER_LO	0
+static int slab_max_order = SLAB_MAX_ORDER_LO;
 
 /*
  * Functions for storing/retrieving the cachep and or slab from the page
@@ -1502,7 +1502,7 @@ void __init kmem_cache_init(void)
 	 * page orders on machines with more than 32MB of memory.
 	 */
 	if (totalram_pages > (32 << 20) >> PAGE_SHIFT)
-		slab_break_gfp_order = BREAK_GFP_ORDER_HI;
+		slab_max_order = SLAB_MAX_ORDER_HI;
 
 	/* Bootstrap is tricky, because several objects are allocated
 	 * from caches that do not exist yet:
@@ -2112,7 +2112,7 @@ static size_t calculate_slab_order(struct kmem_cache *cachep,
 		 * Large number of objects is good, but very large slabs are
 		 * currently bad for the gfp()s.
 		 */
-		if (gfporder >= slab_break_gfp_order)
+		if (gfporder >= slab_max_order)
 			break;
 
 		/*
