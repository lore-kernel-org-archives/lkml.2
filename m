Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0GGBPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 21:15:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58744 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0GGBPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 21:15:40 -0400
Date: Tue, 6 Jul 2010 21:15:33 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 12/14] vmscan: Do not writeback pages in direct reclaim
Message-ID: <20100707011533.GB3630@infradead.org>
References: <20100702125155.69c02f85.akpm@linux-foundation.org>
 <20100705134949.GC13780@csn.ul.ie>
 <20100706093529.CCD1.A69D9226@jp.fujitsu.com>
 <20100706101235.GE13780@csn.ul.ie>
 <AANLkTin8FotAC1GvjuoYU9XA2eiSr6FWWh6bwypTdhq3@mail.gmail.com>
 <20100706152539.GG13780@csn.ul.ie>
 <20100706202758.GC18210@cmpxchg.org>
 <AANLkTimOkI95ZkJecE3jxRDDGbHvP9tRUluIoJuhqqMz@mail.gmail.com>
 <20100707002458.GI13780@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707002458.GI13780@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 01:24:58AM +0100, Mel Gorman wrote:
> What I have now is direct writeback for anon files. For files be it from
> kswapd or direct reclaim, I kick writeback pre-emptively by an amount based
> on the dirty pages encountered because monitoring from systemtap indicated
> that we were getting a large percentage of the dirty file pages at the end
> of the LRU lists (bad). Initial tests show that page reclaim writeback is
> reduced from kswapd by 97% with this sort of pre-emptive kicking of flusher
> threads based on these figures from sysbench.

That sounds like yet another bad aid to me.  Instead it would be much
better to not have so many file pages at the end of LRU by tuning the
flusher threads and VM better.

