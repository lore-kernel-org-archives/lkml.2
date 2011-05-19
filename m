Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1ESMRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:17:51 -0400
Received: from home.kolivas.org ([59.167.196.135]:56831 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014Ab1ESMRu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:17:50 -0400
X-Greylist: delayed 1585 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 May 2011 08:17:49 EDT
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.39-ck1
Date: Thu, 19 May 2011 21:51:23 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.39-ck1; KDE/4.6.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105192151.23215.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are patches designed to improve system responsiveness and interactivity 
with specific emphasis on the desktop, but suitable to any commodity hardware 
workload.


Apply to 2.6.39:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.39/2.6.39-
ck1/patch-2.6.39-ck1.bz2

Broken out tarball:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.39/2.6.39-
ck1/2.6.39-ck1-broken-out.tar.bz2

Discrete patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.39/2.6.39-
ck1/patches/

All -ck patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/

BFS by itself:
http://ck.kolivas.org/patches/bfs/

Web:
http://kernel.kolivas.org

Code blog when I feel like it:
http://ck-hack.blogspot.com/

Each discrete patch contains a brief description of what it does at the top of 
the patch itself.


The most substantial change since the last public release is a major version 
upgrade to the BFS CPU scheduler version 0.404. 

Full details of the most substantial changes, which went into version 0.400, 
are in my blog here:
http://ck-hack.blogspot.com/2011/04/bfs-0400.html

This version exhibits better throughput, better latencies, better behaviour 
with scaling cpu frequency governors (e.g. ondemand), better use of turbo 
modes in newer CPUs, and addresses a long-standing bug that affected all 
configurations, but was only demonstrable on lower Hz configurations (i.e. 
100Hz) that caused fluctuating performance and latencies. Thus mobile 
configurations (e.g. Android on 100Hz) also perform better.  The tuning for 
default round robin interval on all hardware is now set to 6ms (i.e. tuned 
primarily for latency). This can be easily modified with the rr_interval sysctl 
in BFS for special configurations (e.g. increase  to 300 for encoding / folding 
machines).

Performance of BFS has been tested on lower power single core machines through 
various configuration SMP hardware, both threaded and multicore, up to 24x AMD. 
The 24x machine exhibited better throughput on optimally loaded kbuild 
performance (from make -j1 up to make -j24). Performance beyond this level of 
load did not match mainline. On folding benchmarks at 24x, BFS was 
consistently faster for the unbound (no cpu affinity in use) multi-threaded 
version. On 6x hardware, performance at all levels of load in kbuild and x264 
encoding benchmarks was better than mainline in both throughput and latency in 
the presence of the workloads.

For 6 core results and graphs, see:
http://depni.sinp.msu.ru/~belyshev/.../benchmarks/20110516/
(desktop = 1000Hz + preempt, server = 100Hz + no preempt):

This is not by any means a comprehensive performance analysis, nor is it meant 
to claim that BFS is better under all workloads and hardware than mainline. 
They are simply easily demonstrable advantages on some very common workloads 
on commodity hardware, and constitute a regular part of my regression testing. 
Thanks to Serge Belyshev for 6x results, statistical analysis and graphs.


Other changes in this patch release include an updated version of 
lru_cache_add_lru_tail as the previous version did not work entirely as 
planned, dropping the dirty ratio to the extreme value of 1 by default in 
decrease_default_dirty_ratio, and dropping of the cpufreq ondemand tweaks 
since BFS detects scaling CPUs internally now and works with them.


Full patchlist:

2.6.39-sched-bfs-404.patch
sched-add-above-background-load-function.patch
mm-zero_swappiness.patch
mm-enable_swaptoken_only_when_swap_full.patch
mm-drop_swap_cache_aggressively.patch
mm-kswapd_inherit_prio-1.patch
mm-background_scan.patch
mm-idleprio_prio-1.patch
mm-lru_cache_add_lru_tail-1.patch
mm-decrease_default_dirty_ratio.patch
kconfig-expose_vmsplit_option.patch
hz-default_1000.patch
hz-no_default_250.patch
hz-raise_max.patch
preempt-desktop-tune.patch
ck1-version.patch


Please enjoy!
お楽しみください
-- 
-ck
