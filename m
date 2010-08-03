Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab0HCNWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:22:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:51089 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab0HCNWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:22:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,309,1278313200"; 
   d="scan'208";a="592433939"
Date: Tue, 3 Aug 2010 21:22:16 +0800
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
Subject: Re: [PATCH 2/5] writeback: stop periodic/background work on seeing
 sync works
Message-ID: <20100803132216.GA31893@localhost>
References: <20100729115142.102255590@intel.com>
 <20100729121423.332557547@intel.com>
 <20100729162027.GF12690@quack.suse.cz>
 <20100730040306.GA5694@localhost>
 <20100802205152.GL3278@quack.suse.cz>
 <20100803030125.GA12070@localhost>
 <20100803105520.GA3322@quack.suse.cz>
 <20100803123922.GC3322@quack.suse.cz>
 <20100803125924.GA31827@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100803125924.GA31827@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >   Fengguang, how about merging also the attached simple patch together with
> > my fix? With these two patches, I'm not able to trigger any sync livelock
> > while without one of them I hit them quite easily...
> 
> This looks OK. However note that redirty_tail() can modify
> dirtied_when unexpectedly. So the more we rely on wb_start, the more
> possibility an inode is (wrongly) skipped by sync. I have a bunch of
> patches to remove redirty_tail(). However they may not be good
> candidates for 2.6.36..

It looks that setting wb_start at the beginning of
writeback_inodes_wb() won't be easily affected by redirty_tail().

So

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks,
Fengguang
