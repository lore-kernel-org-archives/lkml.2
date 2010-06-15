Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab0FOKrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 06:47:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35519 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab0FOKrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 06:47:07 -0400
Date: Tue, 15 Jun 2010 06:47:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 08/12] vmscan: Setup pagevec as late as possible in
 shrink_inactive_list()
Message-ID: <20100615104701.GA31051@infradead.org>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
 <1276514273-27693-9-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276514273-27693-9-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 12:17:49PM +0100, Mel Gorman wrote:
>  /*
> + * TODO: Try merging with migrations version of putback_lru_pages
> + */
> +static noinline_for_stack void putback_lru_pages(struct zone *zone,
> +				struct zone_reclaim_stat *reclaim_stat,
> +				unsigned long nr_anon, unsigned long nr_file,
> + 				struct list_head *page_list)
> +{

I hate to nitpick on this, but with noinline_for_stack a prototype
really is unreadbale unless the function identifier goes to the next
line.  Compare the one above with:

static noinline_for_stack void
putback_lru_pages(struct zone *zone, struct zone_reclaim_stat *reclaim_stat,
		unsigned long nr_anon, unsigned long nr_file,
		struct list_head *page_list)

> -static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
> +static noinline_for_stack unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  			struct zone *zone, struct scan_control *sc,
>  			int priority, int file)

Same here, just even worse due to the spill over ove 80 characters.

