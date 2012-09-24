Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120Ab2IXVkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 17:40:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39325 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab2IXVkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 17:40:09 -0400
Date: Mon, 24 Sep 2012 22:39:54 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Load averages?
Message-ID: <20120924213954.GB30735@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have here a cubox running v3.5, and I've been watching top while it's
playing back an mpeg stream from NFS using vlc.  rootfs on SD card, and
it's uniprocessor.

Top reports the following:

top - 20:38:35 up 44 min,  3 users,  load average: 1.26, 1.10, 1.10
Tasks: 125 total,   1 running, 124 sleeping,   0 stopped,   0 zombie
Cpu(s): 55.0%us,  3.5%sy,  0.0%ni, 40.8%id,  0.0%wa,  0.7%hi,  0.0%si,  0.0%st
Mem:    768892k total,   757900k used,    10992k free,    37080k buffers
Swap:        0k total,        0k used,        0k free,   505940k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 4270 cubox     20   0  244m  68m  38m S 51.3  9.2  18:33.32 vlc                
 3659 root      20   0 57652  40m  35m S  6.5  5.4   3:06.79 Xorg               

and it stays fairly constant like that - around 55-60% user ticks
around 2-4% system, 40% idle, 0% wait, and around a total of 1%
interrupt (combined hardware/software).  Here's another snapshot:

top - 20:41:58 up 47 min,  3 users,  load average: 0.93, 1.04, 1.07
Tasks: 125 total,   1 running, 124 sleeping,   0 stopped,   0 zombie
Cpu(s): 59.8%us,  1.0%sy,  0.0%ni, 38.5%id,  0.0%wa,  0.3%hi,  0.3%si,  0.0%st
Mem:    768892k total,   755296k used,    13596k free,    37080k buffers
Swap:        0k total,        0k used,        0k free,   503856k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 4270 cubox     20   0  243m  68m  38m S 53.6  9.1  20:19.74 vlc                
 3659 root      20   0 57652  40m  35m S  6.5  5.4   3:20.50 Xorg               

Now, for this capture, I've set top's interval to be 60 seconds:

top - 20:49:52 up 55 min,  3 users,  load average: 0.99, 0.96, 1.01
Tasks: 125 total,   1 running, 124 sleeping,   0 stopped,   0 zombie
Cpu(s): 60.4%us,  1.6%sy,  0.0%ni, 36.6%id,  0.1%wa,  0.5%hi,  0.8%si,  0.0%st
Mem:    768892k total,   759816k used,     9076k free,    37076k buffers
Swap:        0k total,        0k used,        0k free,   508340k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 4270 cubox     20   0  244m  68m  38m S 54.7  9.2  24:23.46 vlc                
 3659 root      20   0 57652  40m  35m S  4.6  5.4   4:02.80 Xorg               

And finally, here's what vmstat 5 looks like:

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0  13788  37164 503380    0    0    62    13  472  444 52  5 33  9
 0  0      0  13416  37164 504340    0    0     0     0  354  344 62  2 37  0
 1  0      0  12424  37164 505300    0    0     0     0  356  374 61  3 36  0
 4  0      0  11556  37164 506260    0    0     0     0  357  360 63  2 35  0
 1  0      0  10564  37164 507220    0    0     0     1  359  358 56  4 41  0
 0  0      0   9572  37164 508180    0    0     0     0  349  369 57  3 41  0
 0  0      0  11628  37164 505368    0    0     0     0  356  350 56  4 41  0
 2  0      0  11432  37164 506328    0    0     0     0  350  372 57  3 40  0
 0  0      0  10440  37164 507288    0    0     0     0  351  379 57  3 40  0
 0  0      0   9448  37164 508248    0    0     0     0  342  348 57  2 41  0
 0  0      0  12248  37156 504804    0    0     0     0  356  381 60  3 37  0
 0  0      0  12052  37156 505764    0    0     0     0  354  365 61  3 36  0
 1  0      0  12052  37156 505764    0    0     0     0  226  326 56  2 42  0
 0  0      0  11060  37156 506724    0    0     0     0  352  355 54  5 42  0
 0  0      0  10068  37156 507684    0    0     0     0  357  356 58  3 38  0
 0  0      0   9076  37156 508644    0    0     0     0  351  356 64  3 33  0

Yet, for some reason, the load average sits around 0.9-1.3.  I don't
understand this - if processes are only running for around 65% of the
time and there's very little waiting for IO, why should the load
average be saying that the system load is equivalent to 1 process
running for 1minute/5minutes/15minutes?

I've also seen a situation where vlc has been using close to 90%
CPU, plays flawlessly, yet the load average reports as 1.5 - if the
load average is more than 1, then that should mean there is
insufficient system bandwidth to sustain the running jobs in real
time (because its saying that there's 1.5 processes running
continuously over 1 minute, and as there's only one CPU...)

The behaviour I'm seeing from the kernel's load average calculation
just seems wrong.

Config which may be related:

CONFIG_HZ=100
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y, 
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_SCHED_AUTOGROUP is not set

Reading the comments before get_avenrun(), I've tried disabling NO_HZ,
and I wouldn't say it's had too much effect.  The following top is with
NO_HZ disabled:

top - 22:11:00 up 16 min,  2 users,  load average: 0.84, 1.04, 0.91
Tasks: 120 total,   1 running, 119 sleeping,   0 stopped,   0 zombie
Cpu(s): 52.8%us,  0.3%sy,  0.0%ni, 42.7%id,  3.3%wa,  0.7%hi,  0.3%si,  0.0%st
Mem:    768900k total,   622984k used,   145916k free,    29196k buffers
Swap:        0k total,        0k used,        0k free,   399248k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 4332 cubox     20   0  235m  52m  34m S 48.9  7.0   4:38.32 vlc
 3667 root      20   0 56000  35m  31m S  6.8  4.8   0:43.32 Xorg
 4347 root      20   0  2276 1144  764 R  1.0  0.1   0:05.36 top

What I do notice with NO_HZ=n is that the 1min load average seems to be
a little more responsive to load changes.

Any ideas or explanations about the apparantly higher than real load
average figures?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
