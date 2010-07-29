Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab0G2QKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 12:10:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:52017 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab0G2QKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 12:10:18 -0400
Date: Thu, 29 Jul 2010 18:09:47 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
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
Subject: Re: [PATCH 0/5]  [RFC] transfer ASYNC vmscan writeback IO to the
 flusher threads
Message-ID: <20100729160947.GE12690@quack.suse.cz>
References: <20100729115142.102255590@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729115142.102255590@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 29-07-10 19:51:42, Wu Fengguang wrote:
> Andrew,
> 
> It's possible to transfer ASYNC vmscan writeback IOs to the flusher threads.
> This simple patchset shows the basic idea. Since it's a big behavior change,
> there are inevitably lots of details to sort out. I don't know where it will
> go after tests and discussions, so the patches are intentionally kept simple.
> 
> sync livelock avoidance (need more to be complete, but this is minimal required for the last two patches)
> 	[PATCH 1/5] writeback: introduce wbc.for_sync to cover the two sync stages
> 	[PATCH 2/5] writeback: stop periodic/background work on seeing sync works
> 	[PATCH 3/5] writeback: prevent sync livelock with the sync_after timestamp
  Well, essentially any WB_SYNC_NONE writeback is still livelockable if you
just grow a file constantly. So your changes are a step in the right
direction but won't fix the issue completely. But what we could do to fix
the issue completely would be to just set wbc->nr_to_write to LONG_MAX
before writing inode for sync use my livelock avoidance using page-tagging
for this case (it wouldn't have the possible performance issue because we
are going to write all the inode anyway).
  I can write the patch but frankly there are so many patches floating
around that I'm not sure what I should base it on...

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
