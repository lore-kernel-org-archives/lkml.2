Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab0G3FeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 01:34:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:36475 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab0G3FeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 01:34:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,285,1278313200"; 
   d="scan'208";a="643173823"
Date: Fri, 30 Jul 2010 13:34:06 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
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
Message-ID: <20100730053406.GC8811@localhost>
References: <20100729115142.102255590@intel.com>
 <20100729160947.GE12690@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729160947.GE12690@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 12:09:47AM +0800, Jan Kara wrote:
> On Thu 29-07-10 19:51:42, Wu Fengguang wrote:
> > Andrew,
> > 
> > It's possible to transfer ASYNC vmscan writeback IOs to the flusher threads.
> > This simple patchset shows the basic idea. Since it's a big behavior change,
> > there are inevitably lots of details to sort out. I don't know where it will
> > go after tests and discussions, so the patches are intentionally kept simple.
> > 
> > sync livelock avoidance (need more to be complete, but this is minimal required for the last two patches)
> > 	[PATCH 1/5] writeback: introduce wbc.for_sync to cover the two sync stages
> > 	[PATCH 2/5] writeback: stop periodic/background work on seeing sync works
> > 	[PATCH 3/5] writeback: prevent sync livelock with the sync_after timestamp
>   Well, essentially any WB_SYNC_NONE writeback is still livelockable if you
> just grow a file constantly. So your changes are a step in the right
> direction but won't fix the issue completely.

Right. We have complementary patches to prevent livelocks both inside
file and among files.

> But what we could do to fix
> the issue completely would be to just set wbc->nr_to_write to LONG_MAX
> before writing inode for sync use my livelock avoidance using page-tagging
> for this case (it wouldn't have the possible performance issue because we
> are going to write all the inode anyway).

Yeah your patches are good to avoid livelocking in one single busy file.
I didn't forgot them :)

>   I can write the patch but frankly there are so many patches floating
> around that I'm not sure what I should base it on...

Me confused too. It may take some time to quiet down..

Thanks,
Fengguang
