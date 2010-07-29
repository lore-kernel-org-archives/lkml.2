Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab0G2PDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:03:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab0G2PDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:03:11 -0400
Date: Thu, 29 Jul 2010 17:02:41 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/5] writeback: prevent sync livelock with the
 sync_after timestamp
Message-ID: <20100729150241.GC12690@quack.suse.cz>
References: <20100729115142.102255590@intel.com>
 <20100729121423.471866750@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729121423.471866750@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Fengguang,

On Thu 29-07-10 19:51:45, Wu Fengguang wrote:
> The start time in writeback_inodes_wb() is not very useful because it
> slips at each invocation time. Preferrably one _constant_ time shall be
> used at the beginning to cover the whole sync() work.
> 
> The newly dirtied inodes are now guarded at the queue_io() time instead
> of the b_io walk time. This is more natural: non-empty b_io/b_more_io
> means "more work pending".
> 
> The timestamp is now grabbed the sync work submission time, and may be
> further optimized to the initial sync() call time.
  The patch seems to have some issues...

> +	if (wbc->for_sync) {
  For example this is never set. You only set wb->for_sync.

> +		expire_interval = 1;
> +		older_than_this = wbc->sync_after;
  And sync_after is never set either???

> -	if (!(wbc->for_kupdate || wbc->for_background) || list_empty(&wb->b_io))
> +	if (list_empty(&wb->b_io))
>  		queue_io(wb, wbc);
  And what is the purpose of this? It looks as an unrelated change to me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
