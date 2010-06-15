Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab0FOP4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 11:56:51 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34497 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab0FOP4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 11:56:50 -0400
Date: Tue, 15 Jun 2010 16:56:32 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 08/12] vmscan: Setup pagevec as late as possible in
	shrink_inactive_list()
Message-ID: <20100615155631.GQ26788@csn.ul.ie>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie> <1276514273-27693-9-git-send-email-mel@csn.ul.ie> <20100615104701.GA31051@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100615104701.GA31051@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 06:47:01AM -0400, Christoph Hellwig wrote:
> On Mon, Jun 14, 2010 at 12:17:49PM +0100, Mel Gorman wrote:
> >  /*
> > + * TODO: Try merging with migrations version of putback_lru_pages
> > + */
> > +static noinline_for_stack void putback_lru_pages(struct zone *zone,
> > +				struct zone_reclaim_stat *reclaim_stat,
> > +				unsigned long nr_anon, unsigned long nr_file,
> > + 				struct list_head *page_list)
> > +{
> 
> I hate to nitpick on this, but with noinline_for_stack a prototype
> really is unreadbale unless the function identifier goes to the next
> line.  Compare the one above with:
> 
> static noinline_for_stack void
> putback_lru_pages(struct zone *zone, struct zone_reclaim_stat *reclaim_stat,
> 		unsigned long nr_anon, unsigned long nr_file,
> 		struct list_head *page_list)
> 
> > -static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
> > +static noinline_for_stack unsigned long shrink_inactive_list(unsigned long nr_to_scan,
> >  			struct zone *zone, struct scan_control *sc,
> >  			int priority, int file)
> 
> Same here, just even worse due to the spill over ove 80 characters.
> 

It's a fair nitpick and so is cleaned up.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
