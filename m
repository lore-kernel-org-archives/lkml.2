Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab1EBJ0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 05:26:23 -0400
Received: from trent.utfs.org ([194.246.123.103]:40257 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051Ab1EBJ0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 05:26:20 -0400
Date: Mon, 2 May 2011 02:26:17 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Dave Chinner <david@fromorbit.com>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        minchan.kim@gmail.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110501080149.GD13542@dastard>
Message-ID: <alpine.DEB.2.01.1105020210160.18728@trent.utfs.org>
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

Here's another attempt at getting those:

  http://nerdbynature.de/bits/2.6.39-rc4/oom/
  * messages-11.txt.gz & slabinfo-11.txt.bz2
    - oom-killer at 00:05:04
    - last sysrq-w to succeed at 00:05:03

  * messages-12.txt.gz & slabinfo-12.txt.bz2, along
    with meminfo-post-oom-12.txt & sysrq-w_post-oom-12.jpg could
    be more interesting:
    - last sysrq-w to succeed at 01:27:08
    - oom-killer at 01:27:11

   ...but after the OOM-killer was killing quite a few processes, MemFree
   showed 511236 kB free memory, yet ssh logins were still being killed.
   Finally I got a root shell on the box, issued sysrq-w again and even
   executed /bin/sync, which came back. But looking at the logs now 
   nothing went to the disk (/var/log resides on / which is a ext4 fs).
   See sysrq-w_post-oom-12.jpg for a sysrq-w I took 2381s after boot time,
   or 01:32 - syslog stopped on 01:27.

I shall try again with netconsole loggin or something...

HTH & thanks for looking into this,
Christian.
-- 
BOFH excuse #176:

vapors from evaporating sticky-note adhesives
