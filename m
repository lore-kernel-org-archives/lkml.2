Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab0KSKtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 05:49:13 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34879 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab0KSKtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 05:49:12 -0500
Date: Fri, 19 Nov 2010 10:48:56 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Use memory compaction instead of lumpy reclaim
	during high-order allocations
Message-ID: <20101119104856.GB28613@csn.ul.ie>
References: <1290010969-26721-1-git-send-email-mel@csn.ul.ie> <20101117154641.51fd7ce5.akpm@linux-foundation.org> <20101118081254.GB8135@csn.ul.ie> <20101118172627.cf25b83a.kamezawa.hiroyu@jp.fujitsu.com> <20101118083828.GA24635@cmpxchg.org> <20101118092044.GE8135@csn.ul.ie> <20101118114928.ecb2d6b0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101118114928.ecb2d6b0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 11:49:28AM -0800, Andrew Morton wrote:
> On Thu, 18 Nov 2010 09:20:44 +0000
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > > It's because migration depends on MMU.  But we should be able to make
> > > a NOMMU version of migration that just does page cache, which is all
> > > that is reclaimable on NOMMU anyway.
> > > 
> > 
> > Conceivably, but I see little problem leaving them with lumpy reclaim.
> 
> I see a really big problem: we'll need to maintain lumpy reclaim for
> ever!
> 

At least as long as !CONFIG_COMPACTION exists. That will be a while because
bear in mind CONFIG_COMPACTION is disabled by default (although I believe
some distros are enabling it at least). Maybe we should choose to deprecate
it in 2.6.40 and delete it at the infamous time of 2.6.42? That would give
ample time to iron out any issues that crop up with reclaim/compaction
(what this series has turned into).

Bear in mind that lumpy reclaim is heavily isolated these days. The logic
is almost entirely contained in isolate_lru_pages() in the block starting
with the comment "Attempt to take all pages in the order aligned region
surrounding the tag page". As disruptive as lumpy reclaim is, it's basically
just a linear scanner at the end of the day and there are a few examples of
that in the kernel. If we break it, it'll be obvious.

> We keep on piling in more and more stuff, we're getting less sure that
> the old stuff is still effective. It's becoming more and more
> important to move some of our attention over to simplification, and
> to rejustification of earlier decisions.
> 

I'm open to its ultimate deletion but think it's rash to do on day 1 of
reclaim/compaction. I do recognise that I might be entirely on my own with
this opinion though :)

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
