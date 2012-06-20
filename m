Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab2FTLFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 07:05:40 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50732 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658Ab2FTLFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 07:05:38 -0400
Date: Wed, 20 Jun 2012 13:05:13 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 01/17] mm: sl[au]b: Add knowledge of PFMEMALLOC reserve
 pages
Message-ID: <20120620110512.GA4208@breakpoint.cc>
References: <1340184920-22288-1-git-send-email-mgorman@suse.de>
 <1340184920-22288-2-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340184920-22288-2-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 10:35:04AM +0100, Mel Gorman wrote:
> [a.p.zijlstra@chello.nl: Original implementation]
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
> diff --git a/mm/slab.c b/mm/slab.c
> index e901a36..b190cac 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -1851,6 +1984,7 @@ static void kmem_freepages(struct kmem_cache *cachep, void *addr)
>  	while (i--) {
>  		BUG_ON(!PageSlab(page));
>  		__ClearPageSlab(page);
> +		__ClearPageSlabPfmemalloc(page);
>  		page++;
>  	}
>  	if (current->reclaim_state)
> @@ -3120,16 +3254,19 @@ bad:
> diff --git a/mm/slub.c b/mm/slub.c
> index 8c691fa..43738c9 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1414,6 +1418,7 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
>  		-pages);
>  
>  	__ClearPageSlab(page);
> +	__ClearPageSlabPfmemalloc(page);
>  	reset_page_mapcount(page);
>  	if (current->reclaim_state)
>  		current->reclaim_state->reclaimed_slab += pages;

So you mention a change here in v11's changelog but I don't see it.

Sebastian
