Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab1EBMUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 08:20:06 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:64274 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754688Ab1EBMUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 08:20:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABGhvk15LBza/2dsb2JhbACmG3jADQ6DEYJhBJ0t
Date: Mon, 2 May 2011 22:19:58 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        minchan.kim@gmail.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110502121958.GA2978@dastard>
References: <20110427022655.GE12436@dastard>
 <alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
 <20110427102824.GI12436@dastard>
 <alpine.DEB.2.01.1104281008320.18728@trent.utfs.org>
 <20110428233751.GR12436@dastard>
 <alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
 <20110429201701.GA13166@x4.trippels.de>
 <alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
 <20110501080149.GD13542@dastard>
 <alpine.DEB.2.01.1105012135260.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1105012135260.18728@trent.utfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 09:59:35PM -0700, Christian Kujau wrote:
> On Sun, 1 May 2011 at 18:01, Dave Chinner wrote:
> > I really don't know why the xfs inode cache is not being trimmed. I
> > really, really need to know if the XFS inode cache shrinker is
> > getting blocked or not running - do you have those sysrq-w traces
> > when near OOM I asked for a while back?
> 
> I tried to generate those via /proc/sysrq-trigger (don't have a F13/Print 
> Screen key), but the OOM killer kicks in prett fast - so fast thay my 
> debug script, trying to generate sysrq-w every second was too late and the 
> machine was already dead:
> 
>    http://nerdbynature.de/bits/2.6.39-rc4/oom/
>    * messages-10.txt.gz
>    * slabinfo-10.txt.bz2
> 
> Timeline:
>   - du(1) started at 12:25:16 (and immediately listed
>     as "blocked" task)
>   - the last sysrq-w succeeded at 12:38:05, listing kswapd0
>   - du invoked oom-killer at 12:38:06
> 
> I'll keep trying...
> 
> > scan only scanned 516 pages. I can't see it freeing many inodes
> > (there's >600,000 of them in memory) based on such a low page scan
> > number.
> 
> Not sure if this is related...this XFS filesytem I'm running du(1) on is 
> ~1 TB in size, with 918K allocated inodes, if df(1) is correct:
> 
> # df -hi /mnt/backup/
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> /dev/mapper/wdc1         37M    918K     36M    3% /mnt/backup
> 
> > Maybe you should tweak /proc/sys/vm/vfs_cache_pressure to make it
> > reclaim vfs structures more rapidly. It might help
> 
> /proc/sys/vm/vfs_cache_pressure is currently set to '100'. You mean I 
> should increase it? To..150? 200? 1000?

Yes. Try 2 orders of magnitude as a start. i.e change it to 10000...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
