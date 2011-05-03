Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab1ECUxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:53:37 -0400
Received: from trent.utfs.org ([194.246.123.103]:59497 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab1ECUxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:53:36 -0400
Date: Tue, 3 May 2011 13:53:31 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Dave Chinner <david@fromorbit.com>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        minchan.kim@gmail.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110503005114.GE2978@dastard>
Message-ID: <alpine.DEB.2.01.1105031345090.18728@trent.utfs.org>
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
> 100,000 inodes is sufficient (i.e. kill the find once the xfs inode
> cache slab reaches 100k inodes. While still running the event trace,
> can you then drop the caches (echo 3 > /proc/sys/vm/drop_caches) and
> check that the xfs inode cache is emptied? If it isn't emptied, drop
> caches again to see if that empties it. If you coul dthen post the
> event trace, I might be able to see what is going strange with the
> shrinker and/or reclaim.

OK, I've done something. Not sure if I got everything right:

  https://trent.utfs.org/p/bits/2.6.39-rc4/oom/trace/
  (new URL, the other one ran out of webspace. Omit the s in https
   if you don't have the CAcert.org root cert imported)

* I've started 'trace-cmd record -e xfs /usr/bin/find /mnt/backup'
  in one (screen-)window, which produced trace-14.dat.bz2

* I've started my oom-debug.sh script in another, which produced
  slabinfo-14.txt.bz2

* In another window, I was dropping the caches and looked at
  /proc/slabinfo again, see drop_caches-14.txt

Somehow "trace-cmd report" segfaults here, but I hope "trace-14.report" 
contains enough details already. If not, I can do this again.

Thanks,
Christian.
-- 
BOFH excuse #314:

You need to upgrade your VESA local bus to a MasterCard local bus.
