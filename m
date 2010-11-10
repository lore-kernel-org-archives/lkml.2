Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab0KJGjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 01:39:24 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:10541 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406Ab0KJGjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 01:39:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAGzL2Ux5LcZK/2dsb2JhbACiOnK7PYVKBA
Date: Wed, 10 Nov 2010 17:39:18 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] mm: vmscan implement per-zone shrinkers
Message-ID: <20101110063918.GA5782@amd>
References: <20101109123246.GA11477@amd>
 <20101110051813.GS2715@dastard>
 <20101110063229.GA5700@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110063229.GA5700@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 05:32:29PM +1100, Nick Piggin wrote:
> On Wed, Nov 10, 2010 at 04:18:13PM +1100, Dave Chinner wrote:
> > On Tue, Nov 09, 2010 at 11:32:46PM +1100, Nick Piggin wrote:
> > > Hi,
> > > 
> > > I'm doing some works that require per-zone shrinkers, I'd like to get
> > > the vmscan part signed off and merged by interested mm people, please.
> > > 
> > 
> > There are still plenty of unresolved issues with this general
> > approach to scaling object caches that I'd like to see sorted out
> > before we merge any significant shrinker API changes. Some things of
> 
> No changes, it just adds new APIs.

I might add that you've previously brought up and I answered every
single issue below and you've not followed up on my answers. So just
going back to the start and bringing them all up again is ridiculous.
Please stop it.

> > 	- it has been pointed out that slab caches are generally
> > 	  allocated out of a single zone per node, so per-zone
> > 	  shrinker granularity seems unnecessary.
> 
> No they are not, that's just total FUD. Where was that "pointed out"?
> 
> Slabs are generally allocated from every zone except for highmem and
> movable, and moreover there is nothing to prevent a shrinker
> implementation from needing to shrink highmem and movable pages as
> well.

Perhaps you meant here that many nodes have only one populated zone.
If that is _really_ a huge problem to add a couple of list heads per
zone per node (which it isn't), then the subsystem can do per-node
shrinking and just do zone_to_nid(zone) in the shrinker callback (but
that would be retarded so it shouldn't).

I answered Christoph's thread here, and I showed how a node based
callback can result in significant imbalances between zones in a node,
so it won't fly.

If you think that nodes are sufficient, then you can get patches through
mm to make pagecache reclaim per-node based, and changes to the
shirnker API will naturally propogate through.

