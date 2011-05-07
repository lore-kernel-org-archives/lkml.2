Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab1EGQJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 12:09:49 -0400
Received: from lucidpixels.com ([75.144.35.66]:37444 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709Ab1EGQJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 12:09:47 -0400
Date: Sat, 7 May 2011 12:09:46 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: xfs@oss.sgi.com
cc: linux-kernel@vger.kernel.org
Subject: 2.6.38.4: xfs speed problem?
Message-ID: <alpine.DEB.2.02.1105071042210.20162@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Using 2.6.38.4 on two hosts:

Host 1:
$ /usr/bin/time find geocities.data 1> /dev/null
80.92user 417.93system 2:19:07elapsed 5%CPU (0avgtext+0avgdata 105520maxresident)k
0inputs+0outputs (0major+73373minor)pagefaults 0swaps

# xfs_db -c frag -f /dev/sda1
actual 40203982, ideal 40088075, fragmentation factor 0.29%

meta-data=/dev/sda1              isize=256    agcount=44, agsize=268435455 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=11718704640, imaxpct=5
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

--

Host 2:
$ /usr/bin/time find geocities.data 1>/dev/null
54.60user 337.20system 48:42.71elapsed 13%CPU (0avgtext+0avgdata 105632maxresident)k
0inputs+0outputs (1major+72981minor)pagefaults 0swaps

# xfs_db -c frag -f /dev/sdb1
actual 37998306, ideal 37939331, fragmentation factor 0.16%

meta-data=/dev/sdb1              isize=256    agcount=10, agsize=268435455 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=2441379328, imaxpct=5
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


--

Host 1: RAID-6 (7200 RPM Drives, 18+1 hot spare)
Host 2: RAID-6 (7200 RPM Drives, 12)

Each system uses a 3ware 9750-24i4e controller, same settings.

Any thoughts why one is > 2x faster than the other?

Justin.

