Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab0G2XZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 19:25:20 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:34732 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758100Ab0G2XZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 19:25:18 -0400
Date: Fri, 30 Jul 2010 09:23:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 0/5]  [RFC] transfer ASYNC vmscan writeback IO to the
 flusher threads
Message-ID: <20100729232330.GO655@dastard>
References: <20100729115142.102255590@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729115142.102255590@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 07:51:42PM +0800, Wu Fengguang wrote:
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
> 
> let the flusher threads do ASYNC writeback for pageout()
> 	[PATCH 4/5] writeback: introduce bdi_start_inode_writeback()
> 	[PATCH 5/5] vmscan: transfer async file writeback to the flusher

I really do not like this - all it does is transfer random page writeback
from vmscan to the flusher threads rather than avoiding random page
writeback altogether. Random page writeback is nasty - just say no.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
