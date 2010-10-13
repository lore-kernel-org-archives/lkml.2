Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab0JMMDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 08:03:13 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:3688 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988Ab0JMMDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 08:03:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOI7tUx5Lc/f/2dsb2JhbAChS3K6b4J2glIEj0A
Date: Wed, 13 Oct 2010 23:03:07 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101013120307.GA5883@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-18-git-send-email-david@fromorbit.com>
 <20101013072058.GA3121@amd>
 <20101013072701.GB3121@amd>
 <20101013112827.GC16422@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013112827.GC16422@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 07:28:27AM -0400, Christoph Hellwig wrote:
> On Wed, Oct 13, 2010 at 06:27:01PM +1100, Nick Piggin wrote:
> > I'm happy to help to port the top of the patch set onto changes in
> > earlier parts of it, but I would like the chance to do this really. I'm
> > back in action now, so I can spend a lot of time catching up.
> 
> That's all good and fine, but it's really no reason for delaying getting
> the most important bits in.

Really? I *really* think I can be given the chance to review what's
happened, catch up, and make sure it's foward compatible with the
rest of my tree. The most important bits are, in fact, mostly my
patches anyway unless there is a fundamentally different approach to
take. And so either way I don't think it is ready for 2.6.37 if it
hasn't been in vfs for testing and review by fs people -- that's what
we agreed I thought for the inode and dcache lock splitups.


>  RCU path walk is all good and fine, and
> I'm really looking forward to eventually see it.  But the basic
> inode_lock and dcache_lock splits are fundamental work we need rather
> sooner than later.

Sure, and I'm glad you're agreeing with that now, I'm just saying I
need to catch up with it after taking a few weeks off. OK?


>  Additional candy ontop of that is fine but we'll
> need a solid base.  Also note that having the locking split up, and
> proper exported APIs instead of growling into dcache internals in

It's not really additional candy, but very fundamental work to the
whole series. Linus agreed with that, so I need to ensure everything
will work properly.


> various filesystems means that we can start to look into replacing
> the global inode and dcache hashes much more easily, and having
> global data structures at least for the dcache is almost as bad
> as having global locks.

As I've repeated, I don't know if your assertion is true, and
definitely any fine grained type of data structure will need to
show it is competitive with a fine grained locked hash.

I would be very interested if there is a better data structure,
but it is hard to know actually. I think it is a topic best
explored after the vfs-scale series goes in, but I think any kind
of per-directory tree might suffer too many cache misses on large
directory lookups, I don't know if marginal locality improvements
in dir-local workloads would outweigh it. A per-directory hash would
have to be resized a lot. Any other ideas?

