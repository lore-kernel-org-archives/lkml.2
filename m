Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab1GTNPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:15:12 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56740 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab1GTNPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:15:10 -0400
Date: Wed, 20 Jul 2011 16:14:51 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        mgorman@suse.de
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
In-Reply-To: <20110720121612.28888.38970.stgit@localhost6>
Message-ID: <alpine.DEB.2.00.1107201611010.3528@tiger>
References: <20110720121612.28888.38970.stgit@localhost6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011, Konstantin Khlebnikov wrote:
> Order of sizeof(struct kmem_cache) can be bigger than PAGE_ALLOC_COSTLY_ORDER,
> thus there is a good chance of unsuccessful allocation.
> With __GFP_REPEAT buddy-allocator will reclaim/compact memory more aggressively.
>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> ---
> mm/slab.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/mm/slab.c b/mm/slab.c
> index d96e223..53bddc8 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2304,7 +2304,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
> 		gfp = GFP_NOWAIT;
>
> 	/* Get cache's description obj. */
> -	cachep = kmem_cache_zalloc(&cache_cache, gfp);
> +	cachep = kmem_cache_zalloc(&cache_cache, gfp | __GFP_REPEAT);
> 	if (!cachep)
> 		goto oops;

The changelog isn't that convincing, really. This is kmem_cache_create() 
so I'm surprised we'd ever get NULL here in practice. Does this fix some 
problem you're seeing? If this is really an issue, I'd blame the page 
allocator as GFP_KERNEL should just work.

 			Pekka
