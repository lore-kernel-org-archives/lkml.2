Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab0KQEST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:18:19 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:26675 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754245Ab0KQESS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:18:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0DALPj4kx5LdurgWdsb2JhbACiQRYBARYiIsBThUsE
Date: Wed, 17 Nov 2010 15:18:12 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Nick Piggin <npiggin@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101117041812.GD3302@amd>
References: <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
 <1289319698.2774.16.camel@edumazet-laptop>
 <AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
 <20101109220506.GE3246@amd>
 <AANLkTi=H5ZZ3b5F=Z-PM6FX84FJNzdSh4_HbeeU666ts@mail.gmail.com>
 <20101115010027.GC22876@dastard>
 <20101115042059.GB3320@amd>
 <20101116030242.GI22876@dastard>
 <20101116034906.GA4596@amd>
 <20101117011254.GJ22876@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117011254.GJ22876@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 12:12:54PM +1100, Dave Chinner wrote:
> On Tue, Nov 16, 2010 at 02:49:06PM +1100, Nick Piggin wrote:
> > On Tue, Nov 16, 2010 at 02:02:43PM +1100, Dave Chinner wrote:
> > > On Mon, Nov 15, 2010 at 03:21:00PM +1100, Nick Piggin wrote:
> > > > This is 30K inodes per second per CPU, versus nearly 800K per second
> > > > number that I measured the 12% slowdown with. About 25x slower.
> > > 
> > > Hi Nick, the ramfs (800k/12%) numbers are not the context I was
> > > responding to - you're comparing apples to oranges. I was responding to
> > > the "XFS [on a ramdisk] is about 4.9% slower" result.
> > 
> > Well xfs on ramdisk was (85k/4.9%).
> 
> How many threads? On a 2.26GHz nehalem-class Xeon CPU, I'm seeing:
> 
> threads		files/s
>  1		 45k
>  2		 70k
>  4		130k
>  8		230k
> 
> With scalability mainly limited by the dcache_lock. I'm not sure
> what you 85k number relates to in the above chart. Is it a single

Yes, a single thread. 86385 inodes created and destroyed per second.
upstream kernel.


> thread number, or something else? If it is a single thread, can you
> run you numbers again with a thread per CPU?

I don't have my inode scalability series in one piece at the moment,
so that would be pointless. Why don't you run RCU numbers?

 
> > A a lower number, like 30k, I would
> > expect that should be around 1-2% perhaps. And when in the context of a
> > real workload that is not 100% CPU bound on creating and destroying a
> > single inode, I expect that to be well under 1%.
> 
> I don't think we are comparing apples to apples. I cannot see how you
> can get mainline XFS to sustain 85kfiles/s/cpu across any number of
> CPUs, so lets make sure we are comparing the same thing....

What do you mean? You are not comparing anything. I am giving you
numbers that I got, comparing RCU and non-RCU inode freeing and holding
everything else constant, and it most certainly is apples to apples.

> 
> > Like I said, I never disputed a potential regression, but I have looked
> > for workloads that have a detectable regression and have not found any.
> > And I have extrapolated microbenchmark numbers to show that it's not
> > going to be a _big_ problem even in a worst case scenario.
> 
> How did you extrapolate the numbers?

I've covered that several times, including in this thread. So I'll go
out on a limb and assume you've read that. So let me ask you, what do
you disagree about what I've written? And what workloads have you been
using to measure inode work with? If it's not a setup that I can
replicate here, then perhaps you could run RCU numbers there.

