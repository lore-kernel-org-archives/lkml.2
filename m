Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab1GTNns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:43:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab1GTNnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:43:47 -0400
Date: Wed, 20 Jul 2011 14:43:42 +0100
From: Mel Gorman <mgorman@suse.de>
To: Pekka Enberg <penberg@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
Message-ID: <20110720134342.GK5349@suse.de>
References: <20110720121612.28888.38970.stgit@localhost6>
 <alpine.DEB.2.00.1107201611010.3528@tiger>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1107201611010.3528@tiger>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 04:14:51PM +0300, Pekka Enberg wrote:
> On Wed, 20 Jul 2011, Konstantin Khlebnikov wrote:
> >Order of sizeof(struct kmem_cache) can be bigger than PAGE_ALLOC_COSTLY_ORDER,
> >thus there is a good chance of unsuccessful allocation.
> >With __GFP_REPEAT buddy-allocator will reclaim/compact memory more aggressively.
> >
> >Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> >---
> >mm/slab.c |    2 +-
> >1 files changed, 1 insertions(+), 1 deletions(-)
> >
> >diff --git a/mm/slab.c b/mm/slab.c
> >index d96e223..53bddc8 100644
> >--- a/mm/slab.c
> >+++ b/mm/slab.c
> >@@ -2304,7 +2304,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
> >		gfp = GFP_NOWAIT;
> >
> >	/* Get cache's description obj. */
> >-	cachep = kmem_cache_zalloc(&cache_cache, gfp);
> >+	cachep = kmem_cache_zalloc(&cache_cache, gfp | __GFP_REPEAT);
> >	if (!cachep)
> >		goto oops;
> 
> The changelog isn't that convincing, really. This is
> kmem_cache_create() so I'm surprised we'd ever get NULL here in
> practice. Does this fix some problem you're seeing? If this is
> really an issue, I'd blame the page allocator as GFP_KERNEL should
> just work.
> 

Besides, is allocating from cache_cache really a
PAGE_ALLOC_COSTLY_ORDER allocation? On my laptop at least, it's an
order-2 allocation which is supporting up to 512 CPUs and 512 nodes.

-- 
Mel Gorman
SUSE Labs
