Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934961Ab0GSO0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 10:26:40 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34003 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933554Ab0GSO0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 10:26:38 -0400
Date: Mon, 19 Jul 2010 15:26:22 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 4/8] vmscan: Do not writeback filesystem pages in
	direct reclaim
Message-ID: <20100719142621.GP13117@csn.ul.ie>
References: <1279545090-19169-1-git-send-email-mel@csn.ul.ie> <1279545090-19169-5-git-send-email-mel@csn.ul.ie> <20100719141934.GB12510@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100719141934.GB12510@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 10:19:34AM -0400, Christoph Hellwig wrote:
> On Mon, Jul 19, 2010 at 02:11:26PM +0100, Mel Gorman wrote:
> > As the call-chain for writing anonymous pages is not expected to be deep
> > and they are not cleaned by flusher threads, anonymous pages are still
> > written back in direct reclaim.
> 
> While it is not quite as deep as it skips the filesystem allocator and
> extent mapping code it can still be quite deep for swap given that it
> still has to traverse the whole I/O stack.  Probably not worth worrying
> about now, but we need to keep an eye on it.
> 

Agreed that we need to keep an eye on it. If this ever becomes a
problem, we're going to need to consider a flusher for anonymous pages.
If you look at the figures, we are still doing a lot of writeback of
anonymous pages. Granted, the layout of swap sucks anyway but it's
something to keep at the back of the mind.

> The patch looks fine to me anyway.
> 

Thanks.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
