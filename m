Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab2IIDmq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 23:42:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56916 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab2IIDmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 23:42:40 -0400
Date: Sat, 8 Sep 2012 20:42:03 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Pekka Enberg <penberg@kernel.org>
cc: Christoph Lameter <cl@linux.com>, Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org
Subject: [PATCH mmotm] slub: zero page to fix boot crashes
Message-ID: <alpine.LSU.2.00.1209082032100.2213@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest mmotm rarely boots if SLUB is enabled: earlyprintk=vga shows
it crashing with various backtraces.  The memset has now been removed
from kmem_cache_open(), so kmem_cache_init() needs to zero its page.
This gets SLUB booting reliably again.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm/mm/slub.c	2012-09-07 12:39:38.136019730 -0700
+++ fixed/mm/slub.c	2012-09-08 19:37:38.608993123 -0700
@@ -3712,7 +3712,7 @@ void __init kmem_cache_init(void)
 	/* Allocate two kmem_caches from the page allocator */
 	kmalloc_size = ALIGN(kmem_size, cache_line_size());
 	order = get_order(2 * kmalloc_size);
-	kmem_cache = (void *)__get_free_pages(GFP_NOWAIT, order);
+	kmem_cache = (void *)__get_free_pages(GFP_NOWAIT | __GFP_ZERO, order);
 
 	/*
 	 * Must first have the slab cache available for the allocations of the
