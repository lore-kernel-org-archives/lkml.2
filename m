Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab1EBT75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 15:59:57 -0400
Received: from trent.utfs.org ([194.246.123.103]:41915 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756999Ab1EBT7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 15:59:53 -0400
Date: Mon, 2 May 2011 12:59:50 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Dave Chinner <david@fromorbit.com>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        minchan.kim@gmail.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110502121958.GA2978@dastard>
Message-ID: <alpine.DEB.2.01.1105021247410.18728@trent.utfs.org>
References: <20110427022655.GE12436@dastard> <alpine.DEB.2.01.1104270042510.18728@trent.utfs.org> <20110427102824.GI12436@dastard> <alpine.DEB.2.01.1104281008320.18728@trent.utfs.org> <20110428233751.GR12436@dastard> <alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
 <20110429201701.GA13166@x4.trippels.de> <alpine.DEB.2.01.1104291710340.18728@trent.utfs.org> <20110501080149.GD13542@dastard> <alpine.DEB.2.01.1105012135260.18728@trent.utfs.org> <20110502121958.GA2978@dastard>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 May 2011 at 22:19, Dave Chinner wrote:
> Yes. Try 2 orders of magnitude as a start. i.e change it to 10000...

I've run the -12 test with vfs_cache_pressure=200 and now the -13 test 
with vfs_cache_pressure=10000. The OOM killer still kicks in, but the 
machine seems to be more usable afterwards and does not get totally stuck:

  http://nerdbynature.de/bits/2.6.39-rc4/oom/
  - messages-12.txt.gz & slabinfo-12.txt.bz2
    * oom-debug.sh invoked oom-killer at 01:27:11
    * sysrq-w works until 01:27:08, but got killed by oom

  - messages-13.txt.gz & slabinfo-13.txt.bz2 
    * find invoked oom-killer at 08:44:07
    * sysrq-w works until 08:45:48 (listing jbd2/hda6-8), then
      my debug script got killed

Thanks,
Christian.
-- 
BOFH excuse #224:

Jan  9 16:41:27 huber su: 'su root' succeeded for .... on /dev/pts/1
