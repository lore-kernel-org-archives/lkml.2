Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab1GYUhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:37:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:26964 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab1GYUhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:37:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,264,1309762800"; 
   d="scan'208";a="31301224"
Date: Mon, 25 Jul 2011 13:37:05 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 4/5] mm: writeback: throttle __GFP_WRITE on per-zone
 dirty limits
Message-ID: <20110725203705.GA21691@tassilo.jf.intel.com>
References: <1311625159-13771-1-git-send-email-jweiner@redhat.com>
 <1311625159-13771-5-git-send-email-jweiner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311625159-13771-5-git-send-email-jweiner@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The global dirty limits are put in proportion to the respective zone's
> amount of dirtyable memory and the allocation denied when the limit of
> that zone is reached.
> 
> Before the allocation fails, the allocator slowpath has a stage before
> compaction and reclaim, where the flusher threads are kicked and the
> allocator ultimately has to wait for writeback if still none of the
> zones has become eligible for allocation again in the meantime.
> 

I don't really like this. It seems wrong to make memory
placement depend on dirtyness.

Just try to explain it to some system administrator or tuner: her 
head will explode and for good reasons.

On the other hand I like doing round-robin in filemap by default
(I think that is what your patch essentially does)
We should have made  this default long ago. It avoids most of the
"IO fills up local node" problems people run into all the time.

So I would rather just change the default in filemap allocation.

That's also easy to explain.

BTW the original argument why this wasn't done was that it may
be a problem on extremly large systems, but I think it's reasonable
to let these oddballs change their defaults instead of letting
everyone else handle them.

-Andi
