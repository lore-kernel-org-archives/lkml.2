Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab2EYNIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:08:30 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:27226 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757042Ab2EYNI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:08:28 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>,
        David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH v3 03/28] slab: rename gfpflags to allocflags
Date: Fri, 25 May 2012 17:03:23 +0400
Message-Id: <1337951028-3427-4-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1337951028-3427-1-git-send-email-glommer@parallels.com>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A consistent name with slub saves us an acessor function.
In both caches, this field represents the same thing. We would
like to use it from the mem_cgroup code.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/slab_def.h |    2 +-
 mm/slab.c                |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index fbd1117..d41effe 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -39,7 +39,7 @@ struct kmem_cache {
 	unsigned int gfporder;
 
 	/* force GFP flags, e.g. GFP_DMA */
-	gfp_t gfpflags;
+	gfp_t allocflags;
 
 	size_t colour;			/* cache colouring range */
 	unsigned int colour_off;	/* colour offset */
diff --git a/mm/slab.c b/mm/slab.c
index 8658d72..1057a32 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1798,7 +1798,7 @@ static void *kmem_getpages(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 	flags |= __GFP_COMP;
 #endif
 
-	flags |= cachep->gfpflags;
+	flags |= cachep->allocflags;
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
 		flags |= __GFP_RECLAIMABLE;
 
@@ -2508,9 +2508,9 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 	cachep->colour = left_over / cachep->colour_off;
 	cachep->slab_size = slab_size;
 	cachep->flags = flags;
-	cachep->gfpflags = 0;
+	cachep->allocflags = 0;
 	if (CONFIG_ZONE_DMA_FLAG && (flags & SLAB_CACHE_DMA))
-		cachep->gfpflags |= GFP_DMA;
+		cachep->allocflags |= GFP_DMA;
 	cachep->buffer_size = size;
 	cachep->reciprocal_buffer_size = reciprocal_value(size);
 
@@ -2857,9 +2857,9 @@ static void kmem_flagcheck(struct kmem_cache *cachep, gfp_t flags)
 {
 	if (CONFIG_ZONE_DMA_FLAG) {
 		if (flags & GFP_DMA)
-			BUG_ON(!(cachep->gfpflags & GFP_DMA));
+			BUG_ON(!(cachep->allocflags & GFP_DMA));
 		else
-			BUG_ON(cachep->gfpflags & GFP_DMA);
+			BUG_ON(cachep->allocflags & GFP_DMA);
 	}
 }
 
-- 
1.7.7.6

