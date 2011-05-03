Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750924Ab1ECEEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 00:04:55 -0400
Received: from trent.utfs.org ([194.246.123.103]:45948 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab1ECEEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 00:04:54 -0400
Date: Mon, 2 May 2011 21:04:40 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Dave Chinner <david@fromorbit.com>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        minchan.kim@gmail.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110503005114.GE2978@dastard>
Message-ID: <alpine.DEB.2.01.1105022053210.18728@trent.utfs.org>
References: <20110427102824.GI12436@dastard> <alpine.DEB.2.01.1104281008320.18728@trent.utfs.org> <20110428233751.GR12436@dastard> <alpine.DEB.2.01.1104291250480.18728@trent.utfs.org> <20110429201701.GA13166@x4.trippels.de> <alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
 <20110501080149.GD13542@dastard> <alpine.DEB.2.01.1105012135260.18728@trent.utfs.org> <20110502121958.GA2978@dastard> <alpine.DEB.2.01.1105021247410.18728@trent.utfs.org> <20110503005114.GE2978@dastard>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 May 2011 at 10:51, Dave Chinner wrote:
> Can you run an event trace of all the XFS events during a find for
> me? Don't do it over the entire subset of the filesystem - only

You mean "event tracing", as in Documentation/trace/events.txt. For 
that I will have to enable CONFIG_FTRACE and CONFIG_FUNCTION_TRACER and 
probably others, right?

Looking at http://lwn.net/Articles/341899, I see CONFIG_EVENT_TRACING 
and the way to enable event tracing for "all events in fs/xfs" would be:

  echo 1 > /sys/kernel/debug/tracing/events/xfs/enable

> 100,000 inodes is sufficient (i.e. kill the find once the xfs inode
> cache slab reaches 100k inodes. While still running the event trace,
> can you then drop the caches (echo 3 > /proc/sys/vm/drop_caches) and
> check that the xfs inode cache is emptied? If it isn't emptied, drop
> caches again to see if that empties it. If you coul dthen post the
> event trace, I might be able to see what is going strange with the
> shrinker and/or reclaim.

Will try to do all that.

I wonder why nobody else is affected by this. Because nobody else runs 
powerpc or UP any more? I'm sure other people's filesystems are way bigger 
than mine, with much more inodes to cache...

Thanks for your time,
Christian. 
-- 
BOFH excuse #136:

Daemons loose in system.
