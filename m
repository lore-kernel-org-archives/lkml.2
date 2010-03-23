Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab0CWSQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:16:00 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38341 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab0CWSP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:15:59 -0400
Date: Tue, 23 Mar 2010 18:15:40 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 07/11] Memory compaction core
Message-ID: <20100323181540.GD5870@csn.ul.ie>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie> <1269347146-7461-8-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1003231253180.10178@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003231253180.10178@router.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 12:56:30PM -0500, Christoph Lameter wrote:
> On Tue, 23 Mar 2010, Mel Gorman wrote:
> 
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 1f59d93..cf8bba7 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -238,6 +239,11 @@ static inline void lru_cache_add_active_file(struct page *page)
> >  	__lru_cache_add(page, LRU_ACTIVE_FILE);
> >  }
> >
> > +/* LRU Isolation modes. */
> > +#define ISOLATE_INACTIVE 0	/* Isolate inactive pages. */
> > +#define ISOLATE_ACTIVE 1	/* Isolate active pages. */
> > +#define ISOLATE_BOTH 2		/* Isolate both active and inactive pages. */
> > +
> >  /* linux/mm/vmscan.c */
> >  extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
> >  					gfp_t gfp_mask, nodemask_t *mask);
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 79c8098..ef89600 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -839,11 +839,6 @@ keep:
> >  	return nr_reclaimed;
> >  }
> >
> > -/* LRU Isolation modes. */
> > -#define ISOLATE_INACTIVE 0	/* Isolate inactive pages. */
> > -#define ISOLATE_ACTIVE 1	/* Isolate active pages. */
> > -#define ISOLATE_BOTH 2		/* Isolate both active and inactive pages. */
> > -
> >  /*
> >   * Attempt to remove the specified page from its LRU.  Only take this page
> >   * if it is of the appropriate PageActive status.  Pages which are being
> 
> Put the above in a separate patch?
> 

I can if you prefer but it's so small, I didn't think it obscured the
clarity of the patch anyway. I would have somewhat expected the two
patches to be merged together before going upstream.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
