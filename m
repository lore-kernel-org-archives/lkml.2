Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab2E1K6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 06:58:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37434 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2E1K57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 06:57:59 -0400
MIME-Version: 1.0
In-Reply-To: <CANQmPXi=E5TiODjK8_yhUw3_qgynwNYngaveA2afKi_8nz=NcQ@mail.gmail.com>
References: <CANQmPXhyAavikU=861nVA3WjPsMjBt+XOTUJ08VAoinZ1gCRzQ@mail.gmail.com>
	<CAJd=RBDN7q0C+ktY29B66d9coyy1BGESOHCHFmFQVboOfNXq5w@mail.gmail.com>
	<CANQmPXi+O-bHFzbi1q5g0GuKgXmeyEYp+UB_61YDDd2uE475GA@mail.gmail.com>
	<CANQmPXipw9QPEc9xMuCLDW14W3w5VeUYZP1GJnvR+D57xCWksA@mail.gmail.com>
	<CAJd=RBC5=JHEUD7N4cQc87AkkgYc-VS+TBEza6QMomA1DsOL1g@mail.gmail.com>
	<CANQmPXg5YCZYYGoBbK+EACgzDkKO7Cfgm24iOB-1pJnKW4owrA@mail.gmail.com>
	<CAJd=RBAKswg6j7wC0g7bYRWkAW4duxwMOs+4G3_nhA9hY1SHtA@mail.gmail.com>
	<CANQmPXg_MAyub=OQ9ZQ9VtLy6jiXZKhU+XrPSg-fSzYXw_h6Bg@mail.gmail.com>
	<CAJd=RBBAxdO0xFm+1VfvrTbUkBu6SvFTuNEvesM-H1gzywzpCA@mail.gmail.com>
	<CANQmPXi=E5TiODjK8_yhUw3_qgynwNYngaveA2afKi_8nz=NcQ@mail.gmail.com>
Date: Mon, 28 May 2012 18:57:58 +0800
Message-ID: <CANQmPXgtyq6e-FLsO3EU8p1E+cjSzZa8sMWaoUykbkiXcczGvA@mail.gmail.com>
Subject: Re: [ANNOUNCE][PATCH 5/26]Rotary Interactivity Favor Scheduler
 Version 3(Brain-Eating) Update.
From: Chen <hi3766691@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/12, Chen <hi3766691@gmail.com> wrote:
> --- 3.3-sched-bfs-420.patch
> +++ rifs-v3-kernel3.3.x
> @@ -1,61 +1,7 @@
> -The Brain Fuck Scheduler v0.420 AKA smoking by Con Kolivas.
> -
> -A single shared runqueue O(n) strict fairness earliest deadline first
> design.
> -
> -Excellent throughput and latency for 1 to many CPUs on desktop and server
> -commodity hardware.
> -Not recommended for 4096 cpus.
> -
> -Scalability is optimal when your workload is equal to the number of CPUs
> on
> -bfs. ie you should ONLY do make -j4 on quad core, -j2 on dual core and so
> on.
> -
> -Features SCHED_IDLEPRIO and SCHED_ISO scheduling policies as well.
> -You do NOT need to use these policies for good performance, they are
> purely
> -optional for even better performance in extreme conditions.
> -
> -To run something idleprio, use schedtool like so:
> -
> -schedtool -D -e make -j4
> -
> -To run something isoprio, use schedtool like so:
> -
> -schedtool -I -e amarok
> -
> -Includes accurate sub-tick accounting of tasks so userspace reported
> -cpu usage may be very different if you have very short lived tasks.
> -
> --ck
> -
> -
> ----
> - Documentation/scheduler/sched-BFS.txt     |  347 +
> - Documentation/sysctl/kernel.txt           |   26
> - arch/powerpc/platforms/cell/spufs/sched.c |    5
> - arch/x86/Kconfig                          |   10
> - drivers/cpufreq/cpufreq.c                 |    7
> - drivers/cpufreq/cpufreq_conservative.c    |    4
> - drivers/cpufreq/cpufreq_ondemand.c        |    8
> - fs/proc/base.c                            |    2
> - include/linux/init_task.h                 |   64
> - include/linux/ioprio.h                    |    2
> - include/linux/jiffies.h                   |    2
> - include/linux/sched.h                     |  110
> - init/Kconfig                              |   16
> - init/main.c                               |    1
> - kernel/delayacct.c                        |    2
> - kernel/exit.c                             |    2
> - kernel/posix-cpu-timers.c                 |   12
> - kernel/sched/Makefile                     |    8
> - kernel/sched/bfs.c                        | 7251
> ++++++++++++++++++++++++++++++
> - kernel/sysctl.c                           |   31
> - lib/Kconfig.debug                         |    2
> - 21 files changed, 7865 insertions(+), 47 deletions(-)
> -
> -Index: linux-3.3-ck1/arch/powerpc/platforms/cell/spufs/sched.c
> -===================================================================
> ----
> linux-3.3-ck1.orig/arch/powerpc/platforms/cell/spufs/sched.c	2012-03-24
> 19:30:00.013420381 +1100
> -+++ linux-3.3-ck1/arch/powerpc/platforms/cell/spufs/sched.c	2012-03-24
> 19:30:29.038925740 +1100
> -@@ -63,11 +63,6 @@ static struct timer_list spusched_timer;
> +diff -ruN linux-3.3.5/arch/powerpc/platforms/cell/spufs/sched.c
> linux-3.3.5-RIFS-RC3-BRAIN-EATING/arch/powerpc/platforms/cell/spufs/sched.c
> +--- linux-3.3.5/arch/powerpc/platforms/cell/spufs/sched.c	2012-05-07
> 23:55:30.000000000 +0800
> ++++
> linux-3.3.5-RIFS-RC3-BRAIN-EATING/arch/powerpc/platforms/cell/spufs/sched.c	2012-05-19
> 22:04:37.000000000 +0800
> +@@ -63,11 +63,6 @@
>   static struct timer_list spuloadavg_timer;
>
>   /*
> @@ -67,363 +13,90 @@
>    * Frequency of the spu scheduler tick.  By default we do one SPU
> scheduler
>    * tick for every 10 CPU scheduler ticks.
>    */
> -Index: linux-3.3-ck1/Documentation/scheduler/sched-BFS.txt
> -===================================================================
> ---- /dev/null	1970-01-01 00:00:00.000000000 +0000
> -+++ linux-3.3-ck1/Documentation/scheduler/sched-BFS.txt	2012-03-24
> 19:30:29.038925740 +1100
> -@@ -0,0 +1,347 @@
> -+BFS - The Brain Fuck Scheduler by Con Kolivas.
> -+
> -+Goals.
> -+
> -+The goal of the Brain Fuck Scheduler, referred to as BFS from here on, is
> to
> -+completely do away with the complex designs of the past for the cpu
> process
> -+scheduler and instead implement one that is very simple in basic design.
> -+The main focus of BFS is to achieve excellent desktop interactivity and
> -+responsiveness without heuristics and tuning knobs that are difficult to
> -+understand, impossible to model and predict the effect of, and when tuned
> to
> -+one workload cause massive detriment to another.
> -+
> -+
> -+Design summary.
> -+
> -+BFS is best described as a single runqueue, O(n) lookup, earliest
> effective
> -+virtual deadline first design, loosely based on EEVDF (earliest
> eligible virtual
> -+deadline first) and my previous Staircase Deadline scheduler. Each
> component
> -+shall be described in order to understand the significance of, and
> reasoning for
> -+it. The codebase when the first stable version was released was
> approximately
> -+9000 lines less code than the existing mainline linux kernel scheduler
> (in
> -+2.6.31). This does not even take into account the removal of documentation
> and
> -+the cgroups code that is not used.
> -+
> -+Design reasoning.
> -+
> -+The single runqueue refers to the queued but not running processes for
> the
> -+entire system, regardless of the number of CPUs. The reason for going back
> to
> -+a single runqueue design is that once multiple runqueues are introduced,
> -+per-CPU or otherwise, there will be complex interactions as each runqueue
> will
> -+be responsible for the scheduling latency and fairness of the tasks
> only on its
> -+own runqueue, and to achieve fairness and low latency across
> multiple CPUs, any
> -+advantage in throughput of having CPU local tasks causes other
> disadvantages.
> -+This is due to requiring a very complex balancing system to at best
> achieve some
> -+semblance of fairness across CPUs and can only maintain relatively low
> latency
> -+for tasks bound to the same CPUs, not across them. To increase said
> fairness
> -+and latency across CPUs, the advantage of local runqueue locking, which
> makes
> -+for better scalability, is lost due to having to grab multiple locks.
> -+
> -+A significant feature of BFS is that all accounting is done purely
> based on CPU
> -+used and nowhere is sleep time used in any way to determine entitlement
> or
> -+interactivity. Interactivity "estimators" that use some kind of sleep/run
> -+algorithm are doomed to fail to detect all interactive tasks, and to
> falsely tag
> -+tasks that aren't interactive as being so. The reason for this is that it
> is
> -+close to impossible to determine that when a task is sleeping, whether it
> is
> -+doing it voluntarily, as in a userspace application waiting for input in
> the
> -+form of a mouse click or otherwise, or involuntarily, because it is
> waiting for
> -+another thread, process, I/O, kernel activity or whatever. Thus, such an
> -+estimator will introduce corner cases, and more heuristics will be
> required to
> -+cope with those corner cases, introducing more corner cases and failed
> -+interactivity detection and so on. Interactivity in BFS is built
> into the design
> -+by virtue of the fact that tasks that are waking up have not used up
> their quota
> -+of CPU time, and have earlier effective deadlines, thereby making it
> very likely
> -+they will preempt any CPU bound task of equivalent nice level. See below
> for
> -+more information on the virtual deadline mechanism. Even if they do
> not preempt
> -+a running task, because the rr interval is guaranteed to have a bound
> upper
> -+limit on how long a task will wait for, it will be scheduled within
> a timeframe
> -+that will not cause visible interface jitter.
> -+
> -+
> -+Design details.
> -+
> -+Task insertion.
> -+
> -+BFS inserts tasks into each relevant queue as an O(1) insertion into a
> double
> -+linked list. On insertion, *every* running queue is checked to see
> if the newly
> -+queued task can run on any idle queue, or preempt the lowest running
> task on the
> -+system. This is how the cross-CPU scheduling of BFS achieves
> significantly lower
> -+latency per extra CPU the system has. In this case the lookup is, in the
> worst
> -+case scenario, O(n) where n is the number of CPUs on the system.
> -+
> -+Data protection.
> -+
> -+BFS has one single lock protecting the process local data of every task in
> the
> -+global queue. Thus every insertion, removal and modification of task
> data in the
> -+global runqueue needs to grab the global lock. However, once a task
> is taken by
> -+a CPU, the CPU has its own local data copy of the running process'
> account
>
