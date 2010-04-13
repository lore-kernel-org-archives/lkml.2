Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab0DMUzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:55:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753616Ab0DMUzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:55:11 -0400
Date: Tue, 13 Apr 2010 13:54:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Frank Ren" <frankrq2009@gmx.com>
Cc: "mingo" <mingo@elte.hu>, "a.p.zijlstra" <a.p.zijlstra@chello.nl>,
       "jens.axboe" <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, dm-devel@redhat.com,
       Alasdair G Kergon <agk@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: high iowait problem(Bug 12309 on bugzilla.kernel.org)
Message-Id: <20100413135416.b537eee8.akpm@linux-foundation.org>
In-Reply-To: <20100331124834.192500@gmx.com>
References: <20100331124834.192500@gmx.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010 08:48:24 -0400
"Frank Ren" <frankrq2009@gmx.com> wrote:

> Gentlemen,
>  I have suffered the high iowait problem for almost 4 years, and I have
> watching the bug report(Bug 12309) on bugzilla.kernel.org for 1 year,
> and yesterday I finally managed to get out of this trouble by switching from CentOS 5.4

What you describe here is an utter catastrophe.

Strangely, your email appears to not have come out on the linux-kernel
list.  Perhaps the vger spam filters made a mistake.

> (with kernel 2.6.18) to zenwalk 6.2(with a snapshot kernel 2.6.32.2). 
>  The computer is used to collect signal data from 4 gas turbines in a power 
> plant. The project started from 2004,and we used mandrake 9 and zenwalk, both are
> 2.4.x kernel,and there was no high iowait problems. Since 2006 we switched to fedore
> 6(kernel 2.6.18) and then centos 5, and the iowait began to make trouble, the system's
> response of mouse and keyboard became very slow, new applications needed a long time
> to be launched. During these years, I always thought the main reason of this was because
> the computer's hardware was not good enough. But early this month, the plant
> has upgraded the computer to a new Lenovo server with two Xeon E5504 CPUs(total 8 cores),
> and 4GB memory,but the iowait is still very very high, the following is the output of
> "top" command on that machine:
> 
> Tasks: 215 total, 1 running, 213 sleeping, 0 stopped, 1 zombie
> Cpu0 : 1.0%us, 0.3%sy, 0.0%ni, 65.9%id, 32.8%wa, 0.0%hi, 0.0%si, 0.0%st
> Cpu1 : 1.0%us, 3.6%sy, 0.0%ni, 45.0%id, 50.3%wa, 0.0%hi, 0.0%si, 0.0%st
> Cpu2 : 1.0%us, 4.0%sy, 0.0%ni, 94.7%id, 0.0%wa, 0.0%hi, 0.3%si, 0.0%st
> Cpu3 : 1.3%us, 3.3%sy, 0.0%ni, 56.3%id, 38.3%wa, 0.0%hi, 0.7%si, 0.0%st
> Cpu4 : 1.3%us, 6.7%sy, 0.0%ni, 0.0%id, 89.7%wa, 0.7%hi, 1.7%si, 0.0%st
> Cpu5 : 0.3%us, 3.3%sy, 0.0%ni, 91.7%id, 0.0%wa, 0.7%hi, 4.0%si, 0.0%st
> Cpu6 : 10.3%us, 30.2%sy, 0.0%ni, 50.2%id, 2.3%wa, 1.0%hi, 6.0%si, 0.0%st
> Cpu7 : 1.3%us, 8.6%sy, 0.0%ni, 83.1%id, 4.0%wa, 1.0%hi, 2.0%si, 0.0%st
> Mem: 4078540k total, 3872720k used, 205820k free, 182344k buffers
> Swap: 4192956k total, 0k used, 4192956k free, 2815596k cached
> 
>  PID USER PR NI VIRT RES SHR S %CPU %MEM TIME+ COMMAND 
>  3841 markv 15 0 72172 12m 8380 S 42.2 0.3 1984:24 lvinf 
>  8573 markv 15 0 60232 12m 8876 S 11.6 0.3 0:17.22 mark 
>  4067 markv 15 0 19056 3224 2336 S 10.6 0.1 759:52.00 dms 
>  3548 mysql 21 0 656m 617m 9292 S 9.0 15.5 764:42.05 mysqld 
> 27042 markv 15 0 69404 12m 8756 S 4.3 0.3 290:36.14 walin 
>  3810 root 15 0 39772 15m 8224 S 1.3 0.4 3:59.76 Xorg 
>  1 root 15 0 2068 620 532 S 0.0 0.0 0:01.19 init 
>  2 root RT -5 0 0 0 S 0.0 0.0 0:00.04 migration/0 
>  3 root 34 19 0 0 0 S 0.0 0.0 0:00.00 ksoftirqd/0 
>  4 root RT -5 0 0 0 S 0.0 0.0 0:00.00 watchdog/0 
>  5 root RT -5 0 0 0 S 0.0 0.0 0:00.02 migration/1 
>  6 root 34 19 0 0 0 S 0.0 0.0 0:00.00 ksoftirqd/1 
>  7 root RT -5 0 0 0 S 0.0 0.0 0:00.00 watchdog/1 
>  8 root RT -5 0 0 0 S 0.0 0.0 0:00.01 migration/2 
>  9 root 34 19 0 0 0 S 0.0 0.0 0:00.01 ksoftirqd/2 
>  10 root RT -5 0 0 0 S 0.0 0.0 0:00.00 watchdog/2 
>  11 root RT -5 0 0 0 S 0.0 0.0 0:00.00 migration/3 
>  12 root 34 19 0 0 0 S 0.0 0.0 0:00.00 ksoftirqd/3 
>  13 root RT -5 0 0 0 S 0.0 0.0 0:00.00 watchdog/3 
>  14 root RT -5 0 0 0 S 0.0 0.0 0:00.09 migration/4 
>  15 root 34 19 0 0 0 S 0.0 0.0 0:00.00 ksoftirqd/4 
>  16 root RT -5 0 0 0 S 0.0 0.0 0:00.00 watchdog/4 
>  17 root RT -5 0 0 0 S 0.0 0.0 0:00.03 migration/5 
>  18 root 36 19 0 0 0 S 0.0 0.0 0:00.00 ksoftirqd/5 
> [markv@markgt ~]$ 
> 
>  All our application's job is to insert 16 records per second into a
> mysql database, the storage is a LVM consisted of two 750GB seagate 
> SATA 7200RPM disks. I am sure this high iowait was not caused by other things
> like network cards or video card, because I have experimented to comment out 
> only the mysql inserting lines from our source code, and the system iowait would
> drop to 0, GUI would become very responsive.
>  It also has nothing to do with the io scheduler,because I had tested deadline and
> noop on CentOS 5.4 and iowait could not be reduced. I also tried to enlarge the 
> /sys/block/sda/queue/nr_requests, and it does not work. 
>  I got information from the bugzilla report that kernel 2.6.32 has fixed this high 
> iowait problem, and I tested the snapshot kernel 2.6.32.2 of zenwalk on my notebook,
> and found the high iowait is gone, so yesterday I installed the zenwalk 6.2 with the
> 2.6.32.2 kernel on that server, although the kernel only detected/used one Xeon CPU
> and 2GB memory, the iowait is very low and the whole system became very fast, only 
> several seconds iowait would reach to 30%-40%, and then dropped back to 0 very soon. 
> By the way, the io scheduler is cfq. The following is "top" output of it:
> 
> Tasks: 157 total, 2 running, 155 sleeping, 0 stopped, 0 zombie
> Cpu0 : 12.3%us, 7.8%sy, 0.0%ni, 77.3%id, 0.0%wa, 0.0%hi, 2.6%si, 0.0%st
> Cpu1 : 11.3%us, 8.4%sy, 0.0%ni, 76.1%id, 0.0%wa, 0.0%hi, 4.2%si, 0.0%st
> Cpu2 : 5.2%us, 7.2%sy, 0.0%ni, 84.0%id, 0.0%wa, 0.3%hi, 3.3%si, 0.0%st
> Cpu3 : 8.1%us, 7.7%sy, 0.0%ni, 81.3%id, 0.0%wa, 0.0%hi, 2.9%si, 0.0%st
> Mem: 2272368k total, 1153508k used, 1118860k free, 79384k buffers
> Swap: 4192956k total, 0k used, 4192956k free, 797568k cached
> 
>  PID USER PR NI VIRT RES SHR S %CPU %MEM TIME+ COMMAND 
> 3085 mysql 40 0 453m 68m 4864 S 35 3.1 12:25.12 mysqld 
> 3203 markv 40 0 77852 17m 11m S 24 0.8 7:53.75 mark 
> 2684 root 40 0 16440 2896 2144 S 9 0.1 11:03.99 dms 
> 3879 markv 40 0 42256 12m 9336 S 4 0.6 1:43.26 walin 
> 1520 root 40 0 4156 1232 972 S 0 0.1 0:00.06 ntpd 
> 3235 root 40 0 64164 29m 9m S 0 1.3 0:50.78 X 
> 3885 markv 40 0 2452 1180 892 R 0 0.1 0:02.08 top 
>  1 root 40 0 804 332 292 S 0 0.0 0:00.90 init 
>  2 root 40 0 0 0 0 S 0 0.0 0:00.00 kthreadd 
>  3 root RT 0 0 0 0 S 0 0.0 0:00.00 migration/0 
>  4 root 20 0 0 0 0 S 0 0.0 0:00.05 ksoftirqd/0 
> 
>  I found in kernel 2.6.32.8 the high iowait is back. How do I know
> that? When I copy a 700MB avi file from my notebook disk to a 3.5" usb
> mobile disk, I found the reading side disk LED start to falsh quickly and immediately,
> but the writing side disk LED will keep still for a long time(like 25-30 seconds), 
> and then start to flash slowly,and the course is abnormal long and low responsive. The 
> kernel 2.6.32.2 is the only 2.6 kernel(since 2.6.18) on which I found both of the reading 
> and writing side disk LED will start to falsh quickly and immediately.There must be 
> somthing wrong with the write cache behavior which will cause the high iowait, and 
> it has been fixed in 2.6.32.2 and brought back in 2.6.32.8.
>  So by copying a big file to an usb disk and watching the disk LED, it can be used as a 
> method for your kernel developers to reproduce and observe this bug. I hope this may be helpful.
> 

So something between 2.6.32.3 and 2.6.32.8 inclusive rebroke the
kernel.  That's useful info.

Looking at the changelogs, the only thing I can immediately see in the
block-core area is

: commit cb723ba5d03bf719dbc7409b4d67572d4472ef8b
: Author: Dmitry Monakhov <dmonakhov@openvz.org>
: Date:   Wed Jan 27 22:44:36 2010 +0300
: 
:     block: fix bio_add_page for non trivial merge_bvec_fn case

which seems unlikely.

I'm seeing just one device-mapper change whcih went in over that
timeframe:

: commit e0f5cfa7c18b411634e73923841eccd3a4c0ce7f
: Author: Martin K. Petersen <martin.petersen@oracle.com>
: Date:   Mon Jan 11 03:21:50 2010 -0500
: 
:     DM: Fix device mapper topology stacking


Which filesystem are you using there?
