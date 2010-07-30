Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab0G3FKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 01:10:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:17059 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab0G3FKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 01:10:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,284,1278313200"; 
   d="scan'208";a="823167089"
Date: Fri, 30 Jul 2010 13:10:05 +0800
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
Subject: Re: [PATCH 1/5] writeback: introduce wbc.for_sync to cover the two
 sync stages
Message-ID: <20100730051005.GA8811@localhost>
References: <20100729115142.102255590@intel.com>
 <20100729121423.184456417@intel.com>
 <20100729150413.GD12690@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729150413.GD12690@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 11:04:13PM +0800, Jan Kara wrote:
> On Thu 29-07-10 19:51:43, Wu Fengguang wrote:
> > The sync() is performed in two stages: the WB_SYNC_NONE sync and
> > the WB_SYNC_ALL sync. It is necessary to tag both stages with
> > wbc.for_sync, so as to prevent either of them being livelocked.
> > 
> > The basic livelock scheme will be based on the sync_after timestamp.
> > Inodes dirtied after that won't be queued for IO. The timestamp could be
> > recorded as early as the sync() time, this patch lazily sets it in
> > writeback_inodes_sb()/sync_inodes_sb(). This will stop livelock, but
> > may do more work than necessary.
> > 
> > Note that writeback_inodes_sb() is called by not only sync(), they
> > are treated the same because the other callers need the same livelock
> > prevention.

>   OK, but the patch does nothing, doesn't it? I'd prefer if the fields
> you introduce were actually used in this patch.

OK, I'll merge it with the third patch.

Thanks,
Fengguang
