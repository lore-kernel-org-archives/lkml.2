Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1A1X66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 18:58:58 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:63951 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495Ab1A1X65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 18:58:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuUEAIvnQk15LN5mgWdsb2JhbAClAxYBARYiJLwMDYVCBA
Date: Sat, 29 Jan 2011 10:58:47 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>,
        Justin Piszcz <jpiszcz@lucidpixels.com>,
        Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs: very slow after mount, very slow at umount
Message-ID: <20110128235847.GY21311@dastard>
References: <4D40EB2F.2050809@teksavvy.com>
 <4D418B57.1000501@teksavvy.com>
 <alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>
 <4D419765.4070805@teksavvy.com>
 <4D41CA16.8070001@hardwarefreak.com>
 <4D41EA04.7010506@teksavvy.com>
 <20110128001735.GO21311@dastard>
 <4D421A68.9000607@teksavvy.com>
 <20110128073119.GV21311@dastard>
 <4D42D39E.4080304@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D42D39E.4080304@teksavvy.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 09:33:02AM -0500, Mark Lord wrote:
> On 11-01-28 02:31 AM, Dave Chinner wrote:
> >
> > A simple google search turns up discussions like this:
> > 
> > http://oss.sgi.com/archives/xfs/2009-01/msg01161.html
> 
> "in the long term we still expect fragmentation to degrade the performance of
> XFS file systems"

"so we intend to add an on-line file system defragmentation utility
to optimize the file system in the future"

You are quoting from the wrong link - that's from the 1996
whitepaper.  And sure, at the time that was written, nobody had any
real experience with long term aging of XFS filesystems so it was
still a guess at that point. XFS has had that online defragmentation
utility since 1998, IIRC, even though in most cases it is
unnecessary to use it.

> Other than that, no hints there about how changing agcount affects things.

If the reason given in the whitepaper for multiple AGs (i.e. they
are for increasing the concurrency of allocation) doesn't help you
understand why you'd want to increase the number of AGs in the
filesystem, then you haven't really thought about what you read.

As it is, from the same google search that found the above link
as #1 hit, this was #6:

http://oss.sgi.com/archives/xfs/2010-11/msg00497.html

| > AG count has a
| > direct relationship to the storage hardware, not the number of CPUs
| >  (cores) in the system
|
| Actually, I used 16 AGs because it's twice the number of CPU cores
| and I want to make sure that CPU parallel workloads (e.g. make -j 8)
| don't serialise on AG locks during allocation. IOWs, I laid it out
| that way precisely because of the number of CPUs in the system...
| 
| And to point out the not-so-obvious, this is the _default layout_
| that mkfs.xfs in the debian squeeze installer came up with. IOWs,
| mkfs.xfs did exactly what I wanted without me having to tweak
| _anything_."
| 
[...]
| 
| In that case, you are right. Single spindle SRDs go backwards in
| performance pretty quickly once you go over 4 AGs...

It seems to me that you haven't really done much looking for
information; there's lots of relevant advice in xfs mailing list
archives...

(and before you ask - SRD == Spinning Rust Disk)

> > Configuring XFS filesystems for optimal performance has always been
> > a black art because it requires you to understand your storage, your
> > application workload(s) and XFS from the ground up.  Most people
> > can't even tick one of those boxes, let alone all three....
> 
> Well, I've got 2/3 of those down just fine, thanks.
> But it's the "XFS" part that is still the "black art" part,
> because so little is written about *how* it works
> (as opposed to how it is laid out on disk).

If you want to know exactly how it works, there plenty of code to
read. I know, you're going to call that a cop out, but I've got more
important things to do than document 20,000 lines of allocation
code just for you.

In a world of infinite resources then everything would be documented
just the way you want, but we don't have infinite resources so it
remains documented by the code that implements it.  However, if you
want to go and understand it and document it all for us, then we'll
happily take the patches. :)

Cheers,,

Dave.
-- 
Dave Chinner
david@fromorbit.com
