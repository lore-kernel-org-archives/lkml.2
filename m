Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab2FTLo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 07:44:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932103Ab2FTLoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 07:44:54 -0400
Date: Wed, 20 Jun 2012 12:44:50 +0100
From: Mel Gorman <mgorman@suse.de>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 01/17] mm: sl[au]b: Add knowledge of PFMEMALLOC reserve
 pages
Message-ID: <20120620114450.GF4011@suse.de>
References: <1340184920-22288-1-git-send-email-mgorman@suse.de>
 <1340184920-22288-2-git-send-email-mgorman@suse.de>
 <20120620110512.GA4208@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120620110512.GA4208@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 01:05:13PM +0200, Sebastian Andrzej Siewior wrote:
> On Wed, Jun 20, 2012 at 10:35:04AM +0100, Mel Gorman wrote:
> > [a.p.zijlstra@chello.nl: Original implementation]
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > ---
> > diff --git a/mm/slab.c b/mm/slab.c
> > index e901a36..b190cac 100644
> > --- a/mm/slab.c
> > +++ b/mm/slab.c
> > @@ -1851,6 +1984,7 @@ static void kmem_freepages(struct kmem_cache *cachep, void *addr)
> >  	while (i--) {
> >  		BUG_ON(!PageSlab(page));
> >  		__ClearPageSlab(page);
> > +		__ClearPageSlabPfmemalloc(page);
> >  		page++;
> >  	}
> >  	if (current->reclaim_state)
> > @@ -3120,16 +3254,19 @@ bad:
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 8c691fa..43738c9 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -1414,6 +1418,7 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
> >  		-pages);
> >  
> >  	__ClearPageSlab(page);
> > +	__ClearPageSlabPfmemalloc(page);
> >  	reset_page_mapcount(page);
> >  	if (current->reclaim_state)
> >  		current->reclaim_state->reclaimed_slab += pages;
> 
> So you mention a change here in v11's changelog but I don't see it.
> 

Because I'm an idiot and send out the wrong branch and then was rude
enough to not include you on the CC. I have resent the series, correctly
this time I hope. Sorry about that.

-- 
Mel Gorman
SUSE Labs
