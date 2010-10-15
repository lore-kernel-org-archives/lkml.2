Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751058Ab0JOEEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 00:04:13 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:34573 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811Ab0JOEEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 00:04:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAGJut0x5Ld+3/2dsb2JhbAChIXK/bYVIBI9F
Date: Fri, 15 Oct 2010 15:04:06 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101015040406.GA6930@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-18-git-send-email-david@fromorbit.com>
 <20101013072058.GA3121@amd>
 <20101013112552.GB16422@infradead.org>
 <20101013123008.GA6067@amd>
 <20101013232319.GZ4681@dastard>
 <20101014090609.GB3144@amd>
 <20101014144159.GA11972@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014144159.GA11972@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 10:41:59AM -0400, Christoph Hellwig wrote:
> > Things
> > like path walks are nearly 50% faster single threaded, and perfectly
> > scalable. Linus actually wants the store-free path walk stuff
> > _before_ any of the other things, if that gives you an idea of where
> > other people are putting the priority of the patches.
> 
> Different people have different priorities.  In the end the person
> doing the work of actually getting it in a mergeable shape is setting
> the pace.  If you had started splitting out the RCU pathwalk bits half a
> year ago there's we already have it in now.  But that's now how it
> worked.

Also, I appreciate that you have run into some lock scaling on these XFS
workloads. But the right way to do it is not to quickly solve your own
issues and then sort out the rest, leaving my tree in wreckage.

Yes it will take a bit longer to actually solve *everyone*'s problems
(that is most definitely including NUMA reclaim, and path walk ping pong
and performance). But we can do it in a coherent way and we can do so
looking at and testing the _end_ result.

Once everyone is happy with where we want to go, it is a matter of
making nice mergable pieces, I agree my patchset still has some work to
do here. But this process is not going to "drag out", by doing it this
way. It can probably be done in 2 releases (first inode, then dcache).
In fact on the contrary I think it is much better to get the whole
group of changes merged at once.

If it drags out and we sqabble and don't agree on what locking is
required _before_ we start merging things, then it will end up with a
half finished mess of slowly changing locking over many kernel releases.

So rather than taking a few bits that you particularly want solved right
now and not bothering to look at the rest because you claim they're
weird or not needed or controversial is really not helping the way I
want to merge this.

And really, blaming me for a few weeks vacation and a few other weeks
on work related stuff for causing all these delays is ridiculous. I've
been posting bits and pieces and ideas and rfcs for a long time without
any real interest from vfs people at all.  The only real time I heard
from you about anything is a couple of times when I actually posted the
full patchset, you'd whinge about it was unreviewable (disregarding that
it was split into individually reviewable pieces and provided an overall
view of where I was going).

_I_ have actually been talking to people, running tests on big machines,
working with -rt guys, socket/networking people, etc. I've worked
through the store-free lookup design with Linus, we've agreed on RCU
inodes and contingency to manage unexpected regressions.

So when you just handwave away "little problems" like proper per-zone
reclaim, rcu-walk path lookup, or scaling the hash manipulations as
"controversial, weird, I'm not sold" it's really frustrating. Especially
when you turn around and accuse me of continually delaying things in the
same email.

