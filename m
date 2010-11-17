Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab0KQBNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:13:01 -0500
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:42926 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754186Ab0KQBNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:13:00 -0500
Date: Wed, 17 Nov 2010 12:12:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Nick Piggin <npiggin@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101117011254.GJ22876@dastard>
References: <20101109124610.GB11477@amd>
 <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
 <1289319698.2774.16.camel@edumazet-laptop>
 <AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
 <20101109220506.GE3246@amd>
 <AANLkTi=H5ZZ3b5F=Z-PM6FX84FJNzdSh4_HbeeU666ts@mail.gmail.com>
 <20101115010027.GC22876@dastard>
 <20101115042059.GB3320@amd>
 <20101116030242.GI22876@dastard>
 <20101116034906.GA4596@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116034906.GA4596@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 02:49:06PM +1100, Nick Piggin wrote:
> On Tue, Nov 16, 2010 at 02:02:43PM +1100, Dave Chinner wrote:
> > On Mon, Nov 15, 2010 at 03:21:00PM +1100, Nick Piggin wrote:
> > > This is 30K inodes per second per CPU, versus nearly 800K per second
> > > number that I measured the 12% slowdown with. About 25x slower.
> > 
> > Hi Nick, the ramfs (800k/12%) numbers are not the context I was
> > responding to - you're comparing apples to oranges. I was responding to
> > the "XFS [on a ramdisk] is about 4.9% slower" result.
> 
> Well xfs on ramdisk was (85k/4.9%).

How many threads? On a 2.26GHz nehalem-class Xeon CPU, I'm seeing:

threads		files/s
 1		 45k
 2		 70k
 4		130k
 8		230k

With scalability mainly limited by the dcache_lock. I'm not sure
what you 85k number relates to in the above chart. Is it a single
thread number, or something else? If it is a single thread, can you
run you numbers again with a thread per CPU?

> A a lower number, like 30k, I would
> expect that should be around 1-2% perhaps. And when in the context of a
> real workload that is not 100% CPU bound on creating and destroying a
> single inode, I expect that to be well under 1%.

I don't think we are comparing apples to apples. I cannot see how you
can get mainline XFS to sustain 85kfiles/s/cpu across any number of
CPUs, so lets make sure we are comparing the same thing....

> Like I said, I never disputed a potential regression, but I have looked
> for workloads that have a detectable regression and have not found any.
> And I have extrapolated microbenchmark numbers to show that it's not
> going to be a _big_ problem even in a worst case scenario.

How did you extrapolate the numbers?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
