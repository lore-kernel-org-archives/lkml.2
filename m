Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab2KSUna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 15:43:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2KSUn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 15:43:29 -0500
Date: Mon, 19 Nov 2012 12:43:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] mm: cma: allocate pages from CMA if NR_FREE_PAGES
 approaches low water mark
Message-Id: <20121119124327.20e008a0.akpm@linux-foundation.org>
In-Reply-To: <50AA526A.7080505@samsung.com>
References: <1352710782-25425-1-git-send-email-m.szyprowski@samsung.com>
	<20121114145848.8224e8b0.akpm@linux-foundation.org>
	<50AA526A.7080505@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2012 16:38:18 +0100
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> Hello,
> 
> On 11/14/2012 11:58 PM, Andrew Morton wrote:
> > On Mon, 12 Nov 2012 09:59:42 +0100
> > Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> >
> > > It has been observed that system tends to keep a lot of CMA free pages
> > > even in very high memory pressure use cases. The CMA fallback for movable
> > > pages is used very rarely, only when system is completely pruned from
> > > MOVABLE pages, what usually means that the out-of-memory even will be
> > > triggered very soon. To avoid such situation and make better use of CMA
> > > pages, a heuristics is introduced which turns on CMA fallback for movable
> > > pages when the real number of free pages (excluding CMA free pages)
> > > approaches low water mark.
>
> ...
>
> > erk, this is right on the page allocator hotpath.  Bad.
> 
> Yes, I know that it adds an overhead to allocation hot path, but I found 
> no other
> place for such change. Do You have any suggestion where such change can 
> be applied
> to avoid additional load on hot path?

Do the work somewhere else, not on a hot path?  Somewhere on the page
reclaim path sounds appropriate.  How messy would it be to perform some
sort of balancing at reclaim time?


