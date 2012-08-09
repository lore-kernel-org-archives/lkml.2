Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab2HIIjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 04:39:37 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58381 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab2HIIje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 04:39:34 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-f0-50237744a561
Date: Thu, 9 Aug 2012 17:41:10 +0900
From: Minchan Kim <minchan@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Jim Schutt <jaschut@sandia.gov>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] mm: compaction: Capture a suitable high-order page
 immediately when it is made available
Message-ID: <20120809084110.GA21033@bbox>
References: <1344452924-24438-1-git-send-email-mgorman@suse.de>
 <1344452924-24438-4-git-send-email-mgorman@suse.de>
 <20120809013358.GA18106@bbox>
 <20120809081120.GB12690@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120809081120.GB12690@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 09:11:20AM +0100, Mel Gorman wrote:
> On Thu, Aug 09, 2012 at 10:33:58AM +0900, Minchan Kim wrote:
> > Hi Mel,
> > 
> > Just one questoin below.
> > 
> 
> Sure! Your questions usually get me thinking about the right part of the
> series, this series in particular :)
> 
> > > <SNIP>
> > > @@ -708,6 +750,10 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
> > >  				goto out;
> > >  			}
> > >  		}
> > > +
> > > +		/* Capture a page now if it is a suitable size */
> > 
> > Why do we capture only when we migrate MIGRATE_MOVABLE type?
> > If you have a reasone, it should have been added as comment.
> > 
> 
> Good question and there is an answer. However, I also spotted a problem when
> thinking about this more where !MIGRATE_MOVABLE allocations are forced to
> do a full compaction. The simple solution would be to only set cc->page for
> MIGRATE_MOVABLE but there is a better approach that I've implemented in the
> patch below. It includes a comment that should answer your question. Does
> this make sense to you?

It does make sense.
I will add my Reviewed-by in your next spin which includes below patch.

Thanks, Mel.

> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 63af8d2..384164e 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -53,13 +53,31 @@ static inline bool migrate_async_suitable(int migratetype)
>  static void compact_capture_page(struct compact_control *cc)
>  {
>  	unsigned long flags;
> -	int mtype;
> +	int mtype, mtype_low, mtype_high;
>  
>  	if (!cc->page || *cc->page)
>  		return;
>  
> +	/*
> +	 * For MIGRATE_MOVABLE allocations we capture a suitable page ASAP
> +	 * regardless of the migratetype of the freelist is is captured from.
                                                         ^  ^
                                                         typo?
-- 
Kind regards,
Minchan Kim
