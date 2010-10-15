Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab0JONOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 09:14:30 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:64156 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754404Ab0JONO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 09:14:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKbtt0x5Ld+3/2dsb2JhbAChIHK+DoVJBI9K
Date: Sat, 16 Oct 2010 00:14:24 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101015131424.GB3207@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-18-git-send-email-david@fromorbit.com>
 <20101013072058.GA3121@amd>
 <20101013112552.GB16422@infradead.org>
 <20101013123008.GA6067@amd>
 <20101013232319.GZ4681@dastard>
 <20101014090609.GB3144@amd>
 <20101014144159.GA11972@infradead.org>
 <20101015040406.GA6930@amd>
 <20101015113336.GH4681@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015113336.GH4681@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 10:33:36PM +1100, Dave Chinner wrote:
> On Fri, Oct 15, 2010 at 03:04:06PM +1100, Nick Piggin wrote:
> > On Thu, Oct 14, 2010 at 10:41:59AM -0400, Christoph Hellwig wrote:
> > > > Things
> > > > like path walks are nearly 50% faster single threaded, and perfectly
> > > > scalable. Linus actually wants the store-free path walk stuff
> > > > _before_ any of the other things, if that gives you an idea of where
> > > > other people are putting the priority of the patches.
> > > 
> > > Different people have different priorities.  In the end the person
> > > doing the work of actually getting it in a mergeable shape is setting
> > > the pace.  If you had started splitting out the RCU pathwalk bits half a
> > > year ago there's we already have it in now.  But that's now how it
> > > worked.
> > 
> > Also, I appreciate that you have run into some lock scaling on these XFS
> > workloads. But the right way to do it is not to quickly solve your own
> > issues and then sort out the rest, leaving my tree in wreckage.
> 
> I think you're misrepresenting both my motives and intentions with
> the work I've been doing.  I've already told you that I have no
> intention of just breaking up the inode_lock, but that I intend to
> work towards getting all of your work merged into mainline.  That
> is, I do not intend to leave your tree in a stage of wreckage - I
> intend to make it redundant.

I think you're misunderstanding my intentions. I have an "end result"
tree. And I plan to continue maintaining it and I'm getting it updated
and planning to ask for reviews to start merging things.

Yes it needs some tweaks and some reviews, but I have agreement in
principle from the vfs maintainer, we hashed out the high level changes
to inode locking at LSF.

And I have had the kernel maintainer look over the series and ack it
in principle too.

You're acting like I'm ignoring everybody. Actually I have replied
to everybody and every comment until a few weeks ago. I often didn't
agree with you, but I explained why in every step.

 
> > So rather than taking a few bits that you particularly want solved right
> > now and not bothering to look at the rest because you claim they're
> > weird or not needed or controversial is really not helping the way I
> > want to merge this.
> 
> "the way I want to merge this"
> 
> This process is not about how you want to merge the code - it's
> about how the VFS maintainers want to review and merge the code. You
> want the code merged - you jump through their hoops and _you like
> it_.  I _had_ been enjoying jumping through those hoops over the past
> few weeks. I don't enjoy writing emails likes this.

I have a say in it too, actually. And it would seem I have a much better
overview of the series than you or Christoph, given your replies in the
last couple of days.

I definitely will accept directions from Al and Linus and suggestions
from everyone else about the series. I will also try to procede how I
have structured the series which I think is the right way to go.

You haven't answered my basic question whether it is better to have
agreement on all lock order changes; have a reviewable and testable
end-goal on locking; and merge the changes in large chunks so there
is minimal locking churn over released trees? This is "the way I want
to merge it".


> > _I_ have actually been talking to people, running tests on big machines,
> > working with -rt guys, socket/networking people, etc. I've worked
> > through the store-free lookup design with Linus, we've agreed on RCU
> > inodes and contingency to manage unexpected regressions.
> 
> Yes, that's all great work and everyone recognises that you deserve
> the credit for it.  You've blasted a path through the wilds and
> demonstrated to us how to fix this longstanding problem. Nobody can

It's not a demonstration or a prototype, it is a (pretty damn stable,
considering the scale of it, and demonstratably performant) design and
implementation for a scalable vfs.


> take that from you - all I ever hear about is "Nick Piggin's VFS
> scalability patch set" and I don't want to change that.  Nobody
> cares that it's you or me or Christoph or someone else that is doing
> the grunt work to get it merged - it is still your work and
> inspiration that has got us to this point and that is what people
> will remember.

It's not about that. It is about I don't agree with the way you're
going and I question your understanding of the bigger picture, and
that I'm still happy to maintain the tree and I am planning to get
it merged as soon as possible. I've gone as far as walking over each
step of the inode series with Al and asking Linus if he agrees with
the overall design of the series and the end results.

I would welcome help sending patches or suggesting different ways
to do things, definitely.


> Still, you've done everything _except_ what the VFS maintainers have
> asked you to do to get it reviewed and merged. From the start
> they've been asking you to split up the patch series into smaller
> chunks for review and stage the inclusion over a couple of kernel
> releases, and you have not yet shown any sign you are willing to do
> that.

Bullshit David. I'm quite willing to do that, and I started doing
that before I got a bit side tracked with changing jobs and going
on vacation for a few weeks. I got as far as files lock and vfsmount
lock and didn't want to post my inode batch then disappear.

