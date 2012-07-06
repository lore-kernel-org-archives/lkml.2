Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab2GFORx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 10:17:53 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54016 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab2GFORl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 10:17:41 -0400
Date: Fri, 6 Jul 2012 16:17:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        heiko.carstens@de.ibm.com, pascal.chapperon@wanadoo.fr,
        wfg@linux.intel.com, C.Emde@osadl.org, mathieu.desnoyers@efficios.com,
        dhowells@redhat.com, efault@gmx.de, levinsasha928@gmail.com
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.6
Message-ID: <20120706141736.GB23400@gmail.com>
References: <20120706140116.GA17758@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120706140116.GA17758@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> The major features of this series are:
> 
> 1.	Preventing latency spikes of more than 200 microseconds for
> 	kernels built with NR_CPUS=4096, which is reportedly becoming
> 	the default for some distros.  This is a first step, as it does
> 	not help with systems that actually -have- 4096 CPUs (work on
> 	this case is in progress, but is not yet ready for mainline).
> 	This category also includes improving concurrency of rcu_barrier(),
> 	placed here due to conflicts.  Posted to LKML at:
> 	https://lkml.org/lkml/2012/6/22/381.  Note that patches 18-22
> 	of that series have been defered to 3.7, as they have not yet
> 	proven themselves to be mainline-ready (and yes, these are the
> 	ones intended to get rid of RCU's latency spikes for systems
> 	that actually have 4096 CPUs).
> 2.	Updates to documentation and rcutorture fixes, the latter category
> 	including improvements to rcu_barrier() testing.  Posted to LKML at:
> 	http://lkml.indiana.edu/hypermail/linux/kernel/1206.1/04094.html.
> 3.	Miscellaneous fixes posted to LKML at:
> 	https://lkml.org/lkml/2012/6/22/500, with the exception of the
> 	last commit, which was posted here:
> 	http://www.gossamer-threads.com/lists/linux/kernel/1561830
> 4.	RCU_FAST_NO_HZ fixes and improvements.  Posted to LKML at:
> 	http://lkml.indiana.edu/hypermail/linux/kernel/1206.1/00006.html
> 	and http://www.gossamer-threads.com/lists/linux/kernel/1561833.
> 	The first four patches of the first series went into 3.5 to fix
> 	a regression.
> 5.	Code-style fixes.  These were posted to LKML at
> 	http://lkml.indiana.edu/hypermail/linux/kernel/1205.2/01180.html and
> 	http://lkml.indiana.edu/hypermail/linux/kernel/1205.2/01181.html.
> 
> All of this code has been exposed to -next testing.
> 
> These changes are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next
> 
> 								Thanx, Paul
> 
> -------------------->
> Carsten Emde (1):
>       rcu: Prevent uninitialized string in RCU CPU stall info
> 
> Paul E. McKenney (48):
>       rcu: Control RCU_FANOUT_LEAF from boot-time parameter
>       rcu: Four-level hierarchy is no longer experimental
>       rcu: Size rcu_node tree from nr_cpu_ids rather than NR_CPUS
>       rcu: Prevent excessive line length in RCU_STATE_INITIALIZER()
>       rcu: Place pointer to call_rcu() in rcu_data structure
>       rcu: Move _rcu_barrier()'s rcu_head structures to rcu_data structures
>       rcu: Move rcu_barrier_cpu_count to rcu_state structure
>       rcu: Move rcu_barrier_completion to rcu_state structure
>       rcu: Move rcu_barrier_mutex to rcu_state structure
>       rcu: Remove needless initialization
>       rcu: Increase rcu_barrier() concurrency
>       rcu: Add tracing for _rcu_barrier()
>       rcu: Add rcu_barrier() statistics to debugfs tracing
>       rcu: Remove unneeded __rcu_process_callbacks() argument
>       rcu: Introduce for_each_rcu_flavor() and use it
>       rcu: Use for_each_rcu_flavor() in TREE_RCU tracing
>       rcu: RCU_SAVE_DYNTICK code no longer ever dead
>       rcu: Update documentation to cover call_srcu() and srcu_barrier().
>       rcu: Rationalize ordering of torture_ops list
>       rcu: Test srcu_barrier() from rcutorture test suite
>       rcu: Fix bug in rcu_barrier() torture test
>       rcu: Fix diagnostic-printk typo in rcutorture
>       rcu: Make rcutorture fakewriters invoke rcu_barrier()
>       rcu: Fix detection of abruptly-ending stall
>       rcu: Consolidate duplicate callback-list initialization
>       rcu: Add ACCESS_ONCE() to ->qlen accesses
>       rcu: Add a gcc-style structure initializer for RCU pointers
>       rcu: Use new RCU_POINTER_INITIALIZER for gcc-style initializations
>       rcu: Remove return value from RCU_INIT_POINTER()
>       key: Remove extraneous parentheses from rcu_assign_keypointer()
>       rcu: Remove return value from rcu_assign_pointer()
>       rcu: Consolidate tree/tiny __rcu_read_{,un}lock() implementations
>       rcu: Remove function versions of __kfree_rcu and __is_kfree_rcu_offset
>       rcu: Make __call_rcu() handle invocation from idle
>       rcu: Prevent __call_rcu() from invoking RCU core on offline CPUs
>       rcu: Split RCU core processing out of __call_rcu()
>       rcu: Fix rcu_is_cpu_idle() #ifdef in TINY_RCU
>       rcu: Disable preemption in rcu_blocking_is_gp()
>       rcu: Add check for CPUs going offline with callbacks queued
>       rcu: Dump only the current CPU's buffers for idle-entry/exit warnings
>       rcu: The rcu_needs_cpu() function is not a quiescent state
>       rcu: Round FAST_NO_HZ lazy timeout to nearest second
>       rcu: Fix qlen_lazy breakage
>       rcu: Make RCU_FAST_NO_HZ respect nohz= boot parameter
>       rcu: Introduce check for callback list/count mismatch
>       Merge branches 'bigrtm.2012.07.04a', 'doctorture.2012.07.02a', 'fixes.2012.07.06a' and 'fnh.2012.07.02a' into HEAD
>       rcu: Fix code-style issues involving "else"
>       rcu: Fix broken strings in RCU's source code.
> 
>  Documentation/RCU/checklist.txt     |   39 ++--
>  Documentation/RCU/rcubarrier.txt    |   15 +-
>  Documentation/RCU/torture.txt       |    9 +
>  Documentation/RCU/whatisRCU.txt     |    6 +-
>  Documentation/kernel-parameters.txt |    5 +
>  include/linux/init_task.h           |    4 +-
>  include/linux/key.h                 |    4 +-
>  include/linux/rcupdate.h            |   53 ++---
>  include/trace/events/rcu.h          |   45 ++++
>  kernel/rcupdate.c                   |   44 ++++
>  kernel/rcutiny.c                    |    4 +-
>  kernel/rcutiny_plugin.h             |   56 +----
>  kernel/rcutorture.c                 |   72 ++++--
>  kernel/rcutree.c                    |  478 ++++++++++++++++++++++------------
>  kernel/rcutree.h                    |   46 ++--
>  kernel/rcutree_plugin.h             |  223 ++++-------------
>  kernel/rcutree_trace.c              |  148 ++++++-----
>  kernel/time/tick-sched.c            |    2 +-
>  lib/list_debug.c                    |    6 +-
>  19 files changed, 669 insertions(+), 590 deletions(-)

Pulled, thanks a lot Paul!

	Ingo
