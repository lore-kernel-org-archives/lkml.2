Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab0JQGeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 02:34:18 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:16556 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751015Ab0JQGeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 02:34:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApYEAMY0ukx5LcB2gWdsb2JhbAChKhYBARYiIsJ/hUkE
Date: Sun, 17 Oct 2010 17:34:11 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Inode Lock Scalability V4
Message-ID: <20101017063411.GA23596@amd>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <20101016175515.GA6868@amd>
 <20101017024759.GI32255@dastard>
 <20101017025533.GA6482@amd>
 <20101017061042.GK32255@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017061042.GK32255@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 05:10:42PM +1100, Dave Chinner wrote:
> On Sun, Oct 17, 2010 at 01:55:33PM +1100, Nick Piggin wrote:
> > On Sun, Oct 17, 2010 at 01:47:59PM +1100, Dave Chinner wrote:
> > > On Sun, Oct 17, 2010 at 04:55:15AM +1100, Nick Piggin wrote:
> > > > On Sat, Oct 16, 2010 at 07:13:54PM +1100, Dave Chinner wrote:
> > > > > This patch set is just the basic inode_lock breakup patches plus a
> > > > > few more simple changes to the inode code. It stops short of
> > > > > introducing RCU inode freeing because those changes are not
> > > > > completely baked yet.
> > > > 
> > > > It also doesn't contain per-zone locking and lrus, or scalability of
> > > > superblock list locking.
> > > 
> > > Sure - that's all explained in the description of what the series
> > > actually contains later on. 
> > > 
> > > > And while the rcu-walk path walking is not fully baked, it has been
> > > > reviewed by Linus and is in pretty good shape. So I prefer to utilise
> > > > RCU locking here too, seeing as we know it will go in.
> > > 
> > > I deliberately left out the RCU changes as we know that the version
> > > that is in your tree causes siginificant performance regressions for
> > > single threaded and some parallel workloads on small (<=8p)
> > > machines.
> > 
> > The worst-case microbenchmark is not a "significant performance
> > regression". It is a worst case demonstration. With the parallel
> > workloads, are you referring to your postmark xfs workload? It was
> > actually due to lazy LRU, IIRC.
> 
> Actually, I wasn't refering to the regressions I reported from
> fs_mark runs on XFS - I was refering to your "worse case
> demonstration" numbers and the comments made during the discussion
> that followed.  It wasn't clear to me what the plan was to use

OK, so why do you keep saying RCU changes aren't agreed on? There was a
lot of discussion about this an we reached agreement.  Really, you blame
me for delaying things and keep obstructing things yourself about things
that have already been discussed and you haven't followed.

And Christoph with his endless rubbish about not doing scalability
changes because he has "ideas" about changing the global hashes, and
then telling me I'm deliberately delaying things.  Of course never
actually offering up any real substance or trying to address my points
that I reply with _every_ single time he drops this "oh let's wait and I
have some ideas about the hash" into the argument.

It's really rude.


> SLAB_DESTROY_BY_RCU or not and the commit messages didn't help,
> so I left it out because I was not about to bite off more than I
> could chew for .37.

I don't understand. It's already bitten off. It's already there.
Linus was ready to pull the whole thing in fact, but I wanted
to wait to get more people on board.

I've also raised a lot of concerns about how your series is structured,
how you want to merge it, the locking design, and how it will delay
things further and just require all the same testing from the same
people I have been asking.


> As it is, the lazy LRU code doesn't appear to cause any fs_mark
> performance regressions in the testing I've done of my series on
> either ext4 or XFS.

I think it does, with the double movement of the inodes in that
reclaim path. I wasn't able to reproduce your results exactly,
however I did see some slowdowns with that in inode intensive
workloads.


> Hence I don't think that was the cause of any of
> the performance problems I originally measured using fs_mark.
> 
> And you are right that it wasn't RCU overhead, because....

Yep.

