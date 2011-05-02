Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab1EBE7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 00:59:43 -0400
Received: from trent.utfs.org ([194.246.123.103]:34278 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab1EBE7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 00:59:40 -0400
Date: Sun, 1 May 2011 21:59:35 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Dave Chinner <david@fromorbit.com>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        minchan.kim@gmail.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110501080149.GD13542@dastard>
Message-ID: <alpine.DEB.2.01.1105012135260.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org> <alpine.DEB.2.01.1104250015480.18728@trent.utfs.org> <20110427022655.GE12436@dastard> <alpine.DEB.2.01.1104270042510.18728@trent.utfs.org> <20110427102824.GI12436@dastard>
 <alpine.DEB.2.01.1104281008320.18728@trent.utfs.org> <20110428233751.GR12436@dastard> <alpine.DEB.2.01.1104291250480.18728@trent.utfs.org> <20110429201701.GA13166@x4.trippels.de> <alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
 <20110501080149.GD13542@dastard>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 May 2011 at 18:01, Dave Chinner wrote:
> I really don't know why the xfs inode cache is not being trimmed. I
> really, really need to know if the XFS inode cache shrinker is
> getting blocked or not running - do you have those sysrq-w traces
> when near OOM I asked for a while back?

I tried to generate those via /proc/sysrq-trigger (don't have a F13/Print 
Screen key), but the OOM killer kicks in prett fast - so fast thay my 
debug script, trying to generate sysrq-w every second was too late and the 
machine was already dead:

   http://nerdbynature.de/bits/2.6.39-rc4/oom/
   * messages-10.txt.gz
   * slabinfo-10.txt.bz2

Timeline:
  - du(1) started at 12:25:16 (and immediately listed
    as "blocked" task)
  - the last sysrq-w succeeded at 12:38:05, listing kswapd0
  - du invoked oom-killer at 12:38:06

I'll keep trying...

> scan only scanned 516 pages. I can't see it freeing many inodes
> (there's >600,000 of them in memory) based on such a low page scan
> number.

Not sure if this is related...this XFS filesytem I'm running du(1) on is 
~1 TB in size, with 918K allocated inodes, if df(1) is correct:

# df -hi /mnt/backup/
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/mapper/wdc1         37M    918K     36M    3% /mnt/backup

> Maybe you should tweak /proc/sys/vm/vfs_cache_pressure to make it
> reclaim vfs structures more rapidly. It might help

/proc/sys/vm/vfs_cache_pressure is currently set to '100'. You mean I 
should increase it? To..150? 200? 1000?

Thanks,
Christian.
-- 
BOFH excuse #347:

The rubber band broke
