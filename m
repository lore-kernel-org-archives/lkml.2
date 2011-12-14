Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab1LNQaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:30:20 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62314 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab1LNQaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:30:16 -0500
Date: Wed, 14 Dec 2011 17:30:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, tglx@linutronix.de,
        josh@joshtriplett.org, keescook@chromium.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.3
Message-ID: <20111214163007.GD10791@somewhere.redhat.com>
References: <20111213230243.GA15127@linux.vnet.ibm.com>
 <20111214154736.GA2419@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214154736.GA2419@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 04:47:36PM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Hello, Ingo,
> > 
> > The major features of this series are RCU infrastructure in 
> > support of Frederic Weisbecker's tickless userspace work and a 
> > reworked RCU_FAST_NO_HZ that improves energy efficiency on 
> > large lightly loaded SMP systems by allowing the 
> > scheduler-clock tick to be turned off more quickly upon entry 
> > to idle, even when RCU callbacks are queued on the newly idle 
> > CPU.  In addition, RCU_FAST_NO_HZ may now be used on systems 
> > running TREE_PREEMPT_RCU, where earlier it was restricted to 
> > TREE_RCU.
> > 
> > In addition, this series provides additional event tracing, 
> > rcutorture changes that improve automated KVM-based testing of 
> > RCU, introduces an srcu_read_lock_raw() needed by uprobes, and 
> > ports a couple of patches from -rt to mainline.  Finally, this 
> > series updates documentation, improves diagnostics, and fixes 
> > a number of bugs, including a nasty use of RCU from the idle 
> > task spotted and fixed by Frederic Weisbecker.
> > 
> > These commits have been posted to LKML and updated based on 
> > feedback:
> > 
> > 	https://lkml.org/lkml/2011/11/2/363
> > 	https://lkml.org/lkml/2011/11/15/302
> > 	https://lkml.org/lkml/2011/11/28/588
> > 	https://lkml.org/lkml/2011/12/3/77
> > 	https://lkml.org/lkml/2011/12/12/625
> > 
> > They have also been exposed to -next testing.
> > 
> > These changes are based off of 3.2-rc5 and are available at 
> > the git repository at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next
> > 
> > Could you please pull them into -tip for additional testing?
> > 
> > 							Thanx, Paul
> > 
> > ------------------>
> > Frederic Weisbecker (11):
> >       rcu: Detect illegal rcu dereference in extended quiescent state
> >       rcu: Inform the user about extended quiescent state on PROVE_RCU warning
> >       rcu: Warn when rcu_read_lock() is used in extended quiescent state
> >       nohz: Separate out irq exit and idle loop dyntick logic
> >       nohz: Allow rcu extended quiescent state handling seperately from tick stop
> >       x86: Enter rcu extended qs after idle notifier call
> >       x86: Call idle notifier after irq_enter()
> >       rcu: Fix early call to rcu_idle_enter()
> >       nohz: Remove tick_nohz_idle_enter_norcu() / tick_nohz_idle_exit_norcu()
> >       rcu: Don't check irq nesting from rcu idle entry/exit
> >       rcu: Irq nesting is always 0 on rcu_enter_idle_common
> > 
> > Josh Triplett (1):
> >       driver-core/cpu: Expose hotpluggability to the rest of the kernel
> > 
> > Kees Cook (1):
> >       docs: Additional LWN links to RCU API
> > 
> > Paul E. McKenney (49):
> >       rcu: ->signaled better named ->fqs_state
> >       rcu: Avoid RCU-preempt expedited grace-period botch
> >       rcu: Make synchronize_sched_expedited() better at work sharing
> >       lockdep: Update documentation for lock-class leak detection
> >       rcu: Track idleness independent of idle tasks
> >       trace: Allow ftrace_dump() to be called from modules
> >       rcu: Add failure tracing to rcutorture
> >       rcu: Document failing tick as cause of RCU CPU stall warning
> >       rcu: Disable preemption in rcu_is_cpu_idle()
> >       rcu: Remove one layer of abstraction from PROVE_RCU checking
> >       rcu: Warn when srcu_read_lock() is used in an extended quiescent state
> >       rcu: Make srcu_read_lock_held() call common lockdep-enabled function
> >       powerpc: Tell RCU about idle after hcall tracing
> >       rcu: Introduce raw SRCU read-side primitives
> >       rcu: Add documentation for raw SRCU read-side primitives
> >       rcu: Deconfuse dynticks entry-exit tracing
> >       rcu: Add more information to the wrong-idle-task complaint
> >       rcu: Allow dyntick-idle mode for CPUs with callbacks
> >       rcu: Fix idle-task checks
> >       rcu: Permit RCU_FAST_NO_HZ to be used by TREE_PREEMPT_RCU
> >       rcu: Add rcutorture system-shutdown capability
> >       rcu: Control rcutorture startup from kernel boot parameters
> >       sched: Add is_idle_task() to handle invalidated uses of idle_cpu()
> >       rcu: Make RCU use the new is_idle_task() API
> >       sparc: Make SPARC use the new is_idle_task() API
> >       kdb: Make KDB use the new is_idle_task() API
> >       events: Make events use the new is_idle_task() API
> >       tile: Make tile use the new is_idle_task() API
> >       rcu: Add rcutorture CPU-hotplug capability
> >       doc: Add load/store guarantees to Documentation/atomic-ops.txt
> >       rcu: Update trace_rcu_dyntick() header comment
> >       rcu: Add tracing for RCU_FAST_NO_HZ
> >       rcu: Go dyntick-idle more quickly if CPU has serviced current grace period
> >       rcu: Avoid needlessly IPIing CPUs at GP end
> >       rcu: Eliminate RCU_FAST_NO_HZ grace-period hang
> >       rcu: Reduce latency of rcu_prepare_for_idle()
> >       rcu: Remove dynticks false positives and RCU failures
> >       rcu: Identify dyntick-idle CPUs on first force_quiescent_state() pass
> >       rcu: Document same-context read-side constraints
> >       rcu: Permit dyntick-idle with callbacks pending
> >       rcu: Keep invoking callbacks if CPU otherwise idle
> >       rcu: Adaptive dyntick-idle preparation
> >       rcu: Remove redundant rcu_cpu_stall_suppress declaration
> >       rcu: Make rcutorture test for hotpluggability before offlining CPUs
> >       rcu: Add rcutorture tests for srcu_read_lock_raw()
> >       rcu: Augment rcu_batch_end tracing for idle and callback state
> >       Revert "rcu: Permit rt_mutex_unlock() with irqs disabled"
> >       rcu: Apply ACCESS_ONCE() to rcu_boost() return value
> >       cpu: Export cpu_up()
> > 
> > Thomas Gleixner (2):
> >       rcu: Omit self-awaken when setting up expedited grace period
> >       rcu: Remove redundant return from rcu_report_exp_rnp()
> > 
> >  Documentation/RCU/checklist.txt          |    6 +
> >  Documentation/RCU/rcu.txt                |   10 +-
> >  Documentation/RCU/stallwarn.txt          |   16 +-
> >  Documentation/RCU/torture.txt            |   13 ++
> >  Documentation/RCU/trace.txt              |    4 -
> >  Documentation/RCU/whatisRCU.txt          |   19 ++-
> >  Documentation/atomic_ops.txt             |   87 +++++++++
> >  Documentation/lockdep-design.txt         |   63 +++++++
> >  arch/arm/kernel/process.c                |    6 +-
> >  arch/avr32/kernel/process.c              |    6 +-
> >  arch/blackfin/kernel/process.c           |    6 +-
> >  arch/microblaze/kernel/process.c         |    6 +-
> >  arch/mips/kernel/process.c               |    6 +-
> >  arch/openrisc/kernel/idle.c              |    6 +-
> >  arch/powerpc/kernel/idle.c               |   15 ++-
> >  arch/powerpc/platforms/iseries/setup.c   |   12 +-
> >  arch/powerpc/platforms/pseries/lpar.c    |    4 +
> >  arch/s390/kernel/process.c               |    6 +-
> >  arch/sh/kernel/idle.c                    |    6 +-
> >  arch/sparc/kernel/process_64.c           |    6 +-
> >  arch/sparc/kernel/setup_32.c             |    2 +-
> >  arch/tile/kernel/process.c               |    6 +-
> >  arch/tile/mm/fault.c                     |    4 +-
> >  arch/um/kernel/process.c                 |    6 +-
> >  arch/unicore32/kernel/process.c          |    6 +-
> >  arch/x86/kernel/apic/apic.c              |    6 +-
> >  arch/x86/kernel/apic/io_apic.c           |    2 +-
> >  arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
> >  arch/x86/kernel/cpu/mcheck/threshold.c   |    2 +-
> >  arch/x86/kernel/irq.c                    |    6 +-
> >  arch/x86/kernel/process_32.c             |    6 +-
> >  arch/x86/kernel/process_64.c             |   10 +-
> >  drivers/base/cpu.c                       |    7 +
> >  include/linux/cpu.h                      |    1 +
> >  include/linux/hardirq.h                  |   21 ---
> >  include/linux/rcupdate.h                 |  115 ++++++++-----
> >  include/linux/sched.h                    |    8 +
> >  include/linux/srcu.h                     |   87 ++++++++--
> >  include/linux/tick.h                     |   11 +-
> >  include/trace/events/rcu.h               |  122 +++++++++++--
> >  init/Kconfig                             |   10 +-
> >  kernel/cpu.c                             |    1 +
> >  kernel/debug/kdb/kdb_support.c           |    2 +-
> >  kernel/events/core.c                     |    2 +-
> >  kernel/lockdep.c                         |   22 +++
> >  kernel/rcu.h                             |    7 +
> >  kernel/rcupdate.c                        |   12 ++
> >  kernel/rcutiny.c                         |  149 +++++++++++++--
> >  kernel/rcutiny_plugin.h                  |   29 +++-
> >  kernel/rcutorture.c                      |  225 ++++++++++++++++++++++-
> >  kernel/rcutree.c                         |  290 +++++++++++++++++++++---------
> >  kernel/rcutree.h                         |   26 ++--
> >  kernel/rcutree_plugin.h                  |  289 ++++++++++++++++++++++++------
> >  kernel/rcutree_trace.c                   |   12 +-
> >  kernel/rtmutex.c                         |    8 -
> >  kernel/softirq.c                         |    4 +-
> >  kernel/time/tick-sched.c                 |   97 ++++++----
> >  kernel/trace/trace.c                     |    1 +
> >  58 files changed, 1512 insertions(+), 407 deletions(-)
> 
> Pulled into tip:core/rcu, thanks a lot Paul!
> 
> Note that this commit from Frederic:
> 
>   69e1e811dcc4: sched, nohz: Track nr_busy_cpus in the sched_group_power
> 
> conflicted with this commit from Suresh in sched/core:
> 
>   69e1e811dcc4: sched, nohz: Track nr_busy_cpus in the sched_group_power
> 
> I resolved it by making the set_cpu_sd_state_idle() call 
> unconditional within the newly decoupled 
> tick_nohz_stop_sched_tick() function - please double check that 
> it's the right resolution.

After a quick look, I believe this should rather be under tick_nohz_idle_enter(),
(This is the equivalent of the old tick_nohz_stop_sched_tick(1))
This wants to be set only once we enter idle, not everytime we have an idle
interrupt.
