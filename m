Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab1GTMQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 08:16:16 -0400
Received: from relay.parallels.com ([195.214.232.42]:45613 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab1GTMQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 08:16:15 -0400
Subject: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: Pekka Enberg <penberg@kernel.org>, <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>
Date: Wed, 20 Jul 2011 16:16:12 +0400
Message-ID: <20110720121612.28888.38970.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Order of sizeof(struct kmem_cache) can be bigger than PAGE_ALLOC_COSTLY_ORDER,
thus there is a good chance of unsuccessful allocation.
With __GFP_REPEAT buddy-allocator will reclaim/compact memory more aggressively.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/slab.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index d96e223..53bddc8 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2304,7 +2304,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 		gfp = GFP_NOWAIT;
 
 	/* Get cache's description obj. */
-	cachep = kmem_cache_zalloc(&cache_cache, gfp);
+	cachep = kmem_cache_zalloc(&cache_cache, gfp | __GFP_REPEAT);
 	if (!cachep)
 		goto oops;
 

