Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab1IFPjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:39:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024Ab1IFPjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:39:07 -0400
Date: Tue, 6 Sep 2011 16:39:03 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] vmscan: Do reclaim stall in case of mlocked page.
Message-ID: <20110906153903.GU14369@suse.de>
References: <1321285043-3470-1-git-send-email-minchan.kim@gmail.com>
 <20110831173031.GA21571@redhat.com>
 <CAEwNFnDcNqLvo=oyXXkxgFxs8wNc+WTLwot0qeru1VfQKmUYDQ@mail.gmail.com>
 <20110905083321.GA15935@redhat.com>
 <20110906151140.GA1589@barrios-fedora.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110906151140.GA1589@barrios-fedora.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 12:11:40AM +0900, Minchan Kim wrote:
> > > <SNIP>
> > > If we consider that, we have to fix other reset_reclaim_mode cases as
> > > well as mlocked pages.
> > > Or
> > > fix isolataion logic for the lumpy? (When we find the page isn't able
> > > to isolate, rollback the pages in the lumpy block to the LRU)
> > > Or
> > > Nothing and wait to remove lumpy completely.
> > > 
> > > What do you think about it?
> > 
> > The rollback may be overkill and we already abort clustering the
> > isolation when one of the pages fails.
> 
> I think abort isn't enough
> Because we know the chace to make a bigger page is gone when we isolate page.
> But we still try to reclaim pages to make bigger space in a vain.
> It causes unnecessary unmap operation by try_to_unmap which is costly operation
> , evict some working set pages and make reclaim latency long.
> 
> As a matter of fact, I though as follows patch to solve this problem(Totally, untested)
> 

I confess I haven't read this patch carefully or given it much
thought. I agree with you in principal that it would be preferred if
lumpy reclaim disrupted the LRU lists as little as possible but I'm
wary about making lumpy reclaim more complex when it is preferred that
compaction is used and we expect lumpy reclaim to go away eventually.

> > <SNIP{>
> > 
> > I would go with the last option.  Lumpy reclaim is on its way out and
> > already disabled for a rather common configuration, so I would defer
> > non-obvious fixes like these until actual bug reports show up.
> 
> It's hard to report above problem as it might not make big difference on normal worklaod.

I doubt it makes a noticable difference as lumpy reclaim disrupts
the system quite heavily.

> But I agree last option, too. Then, when does we suppose to remove lumpy?
> Mel, Could you have a any plan?
> 

I think it should be removed after all the major distributions release
with a kernel with compaction enabled. At that point,  we'll know
that lumpy reclaim is not being depended upon.

-- 
Mel Gorman
SUSE Labs
