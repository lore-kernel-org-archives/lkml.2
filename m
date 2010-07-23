Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138Ab0GWMVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:21:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:39211 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759605Ab0GWMUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:20:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,247,1278313200"; 
   d="scan'208";a="589048374"
Date: Fri, 23 Jul 2010 20:20:15 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andreas Mohr <andi@lisas.de>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 7/8] writeback: sync old inodes first in background
 writeback
Message-ID: <20100723122015.GA8210@localhost>
References: <1279545090-19169-1-git-send-email-mel@csn.ul.ie>
 <1279545090-19169-8-git-send-email-mel@csn.ul.ie>
 <20100719142145.GD12510@infradead.org>
 <20100719144046.GR13117@csn.ul.ie>
 <20100722085210.GA26714@localhost>
 <20100722092155.GA28425@localhost>
 <20100722104823.GF13117@csn.ul.ie>
 <20100723094515.GD5043@localhost>
 <20100723105719.GE5300@csn.ul.ie>
 <20100723114915.GA5125@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100723114915.GA5125@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For the case of of a heavy dirtier (dd) and concurrent light dirtiers
> (some random processes), the light dirtiers won't be easily throttled.
> task_dirty_limit() handles that case well. It will give light dirtiers
> higher threshold than heavy dirtiers so that only the latter will be
> dirty throttled.

The caveat is, the real dirty throttling threshold is not exactly the
value specified by vm.dirty_ratio or vm.dirty_bytes. Instead it's some
value slightly lower than it. That real value differs for each process,
which is a nice trick to throttle heavy dirtiers first. If I remember
it right, that's invented by Peter and Andrew.

Thanks,
Fengguang
