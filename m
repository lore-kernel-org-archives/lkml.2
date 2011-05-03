Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1ECGhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 02:37:04 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:13425 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751666Ab1ECGhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 02:37:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAShv015LBza/2dsb2JhbACmDniIcrtlDoVyBJ0z
Date: Tue, 3 May 2011 16:36:58 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        minchan.kim@gmail.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110503063657.GB9114@dastard>
References: <20110428233751.GR12436@dastard>
 <alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
 <20110429201701.GA13166@x4.trippels.de>
 <alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
 <20110501080149.GD13542@dastard>
 <alpine.DEB.2.01.1105012135260.18728@trent.utfs.org>
 <20110502121958.GA2978@dastard>
 <alpine.DEB.2.01.1105021247410.18728@trent.utfs.org>
 <20110503005114.GE2978@dastard>
 <alpine.DEB.2.01.1105022053210.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1105022053210.18728@trent.utfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 09:04:40PM -0700, Christian Kujau wrote:
> On Tue, 3 May 2011 at 10:51, Dave Chinner wrote:
> > Can you run an event trace of all the XFS events during a find for
> > me? Don't do it over the entire subset of the filesystem - only
> 
> You mean "event tracing", as in Documentation/trace/events.txt. For 
> that I will have to enable CONFIG_FTRACE and CONFIG_FUNCTION_TRACER and 
> probably others, right?
> 
> Looking at http://lwn.net/Articles/341899, I see CONFIG_EVENT_TRACING 
> and the way to enable event tracing for "all events in fs/xfs" would be:
> 
>   echo 1 > /sys/kernel/debug/tracing/events/xfs/enable

Download trace-cmd and use that - more efficient and easier to
specify the events to record...

> > 100,000 inodes is sufficient (i.e. kill the find once the xfs inode
> > cache slab reaches 100k inodes. While still running the event trace,
> > can you then drop the caches (echo 3 > /proc/sys/vm/drop_caches) and
> > check that the xfs inode cache is emptied? If it isn't emptied, drop
> > caches again to see if that empties it. If you coul dthen post the
> > event trace, I might be able to see what is going strange with the
> > shrinker and/or reclaim.
> 
> Will try to do all that.
> 
> I wonder why nobody else is affected by this. Because nobody else runs 
> powerpc or UP any more? I'm sure other people's filesystems are way bigger 
> than mine, with much more inodes to cache...

XFS on uniprocessor, 32 bit, highmem system is pretty rare. Let
alone on an old powerpc platform. It's so far out in left field that
I'd expect the only test coverage we get is your laptop....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
