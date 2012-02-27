Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab2B0Ras (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 12:30:48 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52318 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab2B0Rar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 12:30:47 -0500
Date: Mon, 27 Feb 2012 09:22:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, nab@linux-iscsi.org,
        jkosina@suse.cz, jj@chaosbits.net, davem@davemloft.net,
        linville@tuxdriver.com, johannes@sipsolutions.net,
        josh@joshtriplett.org, a.p.zijlstra@chello.nl, dhowells@redhat.com,
        Julia.Lawall@lip6.fr, deepthi@linux.vnet.ibm.com,
        neven.m.abou.gazala@intel.com, hughd@google.com
Subject: [GIT PULL rcu/next] RCU commits for 3.4
Message-ID: <20120227172248.GA5338@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022717-7182-0000-0000-000000E50015
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

The major features of this series are making RCU more aggressive about
entering dyntick-idle mode in order to improve energy efficiency,
converting a few more call_rcu()s to kfree_rcu()s, applying a number
of rcutree fixes and cleanups to rcutiny, removing CONFIG_SMP #ifdefs
from treercu, allowing RCU CPU stall times to be set via sysfs, adding
CPU-stall capability to rcutorture, adding more RCU-abuse diagnostics,
updating documentation, and fixing yet more issue located in the
still-ongoing top-to-bottom inspection of RCU, this time with a special
focus on the CPU-hotplug code path.

Three of the kfree_rcu() conversions have not yet received acks (s390,
tcm_fc, and mac80211), but the maintainers have been CCed on multiple
LKML postings and -next testing has not shown any problems.

These commits have been posted to LKML (https://lkml.org/lkml/2012/2/3/459
and https://lkml.org/lkml/2012/2/21/228) and have received -next testing.
They are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next

								Thanx, Paul

----------------------->

Frederic Weisbecker (1):
      rcu: Improve synchronize_rcu() diagnostics

Heiko Carstens (1):
      rcu: Convert WARN_ON_ONCE() in rcu_lock_acquire() to lockdep

Hugh Dickins (1):
      rcu: Stop spurious warnings from synchronize_sched_expedited

Julia Lawall (1):
      PTR_ERR should be called before its argument is cleared.

Paul E. McKenney (44):
      rcu: Bring RTFP.txt up to date.
      rcu: Add lockdep-RCU checks for simple self-deadlock
      rcu: Add diagnostic for misaligned rcu_head structures
      rcu: Avoid waking up CPUs having only kfree_rcu() callbacks
      rcu: Move RCU_TRACE to lib/Kconfig.debug
      s390: Convert call_rcu() to kfree_rcu(), drop ext_int_hash_update()
      tcm_fc: Convert call_rcu() to kfree_rcu(), drop ft_tport_rcu_free()
      ipv4: Convert call_rcu() to kfree_rcu(), drop opt_kfree_rcu()
      ipv4: Convert call_rcu() to kfree_rcu(), drop opt_kfree_rcu
      mac80211: Convert call_rcu() to kfree_rcu(), drop mesh_gate_node_reclaim()
      rcu: Simplify offline processing
      rcu: Make rcutorture flag online/offline failures
      rcu: Limit lazy-callback duration
      rcu: Check for callback invocation from offline CPUs
      rcu: Don't make callbacks go through second full grace period
      rcu: Remove single-rcu_node optimization in rcu_start_gp()
      rcu: Protect __rcu_read_unlock() against scheduler-using irq handlers
      rcu: Streamline code produced by __rcu_read_unlock()
      rcu: Prevent RCU callbacks from executing before scheduler initialized
      rcu: Inform RCU of irq_exit() activity
      rcu: Simplify unboosting checks
      rcu: Clean up straggling rcu_preempt_needs_cpu() name
      rcu: Check for idle-loop entry while in RCU read-side critical section
      rcu: Make rcu_sleep_check() also check rcu_lock_map
      rcu: Note that rcu_access_pointer() can be used for teardown
      rcu: Remove #ifdef CONFIG_SMP from TREE_RCU
      rcu: Set RCU CPU stall times via sysfs
      rcu: Print scheduling-clock information on RCU CPU stall-warning messages
      rcutorture: Permit holding off CPU-hotplug operations during boot
      rcu: Make documentation give more realistic rcutorture duration
      rcu: Add CPU-stall capability to rcutorture
      rcu: Update stall-warning documentation
      rcu: Check for illegal use of RCU from offlined CPUs
      rcu: Move synchronize_sched_expedited() to rcutree.c
      rcu: No interrupt disabling for rcu_prepare_for_idle()
      lockdep: Add CPU-idle/offline warning to lockdep-RCU splat
      rcu: Rework detection of use of RCU by offline CPUs
      rcu: Call out dangers of expedited RCU primitives
      rcu: Trace only after NULL-pointer check
      rcu: Remove redundant check for rcu_head misalignment
      rcu: Allow nesting of rcu_idle_enter() and rcu_idle_exit()
      rcu: Add RCU_NONIDLE() for idle-loop RCU read-side critical sections
      rcu: Eliminate softirq-mediated RCU_FAST_NO_HZ idle-entry loop
      rcu: Hold off RCU_FAST_NO_HZ after timer posted

 Documentation/RCU/RTFP.txt       | 1902 ++++++++++++++++++++++++++++++++++----
 Documentation/RCU/checklist.txt  |   14 +
 Documentation/RCU/stallwarn.txt  |   87 ++-
 Documentation/RCU/torture.txt    |   33 +-
 Documentation/RCU/trace.txt      |   36 +-
 arch/s390/kernel/irq.c           |    9 +-
 drivers/target/tcm_fc/tfc_sess.c |   12 +-
 include/linux/rcupdate.h         |   83 ++-
 include/linux/rcutiny.h          |   10 +-
 include/linux/rcutree.h          |   19 +
 include/linux/sched.h            |    3 +-
 include/linux/srcu.h             |   15 +-
 include/trace/events/rcu.h       |   63 +-
 init/Kconfig                     |    9 -
 kernel/lockdep.c                 |    8 +-
 kernel/rcu.h                     |   26 +-
 kernel/rcupdate.c                |    5 +
 kernel/rcutiny.c                 |   26 +-
 kernel/rcutiny_plugin.h          |   77 ++-
 kernel/rcutorture.c              |   91 ++-
 kernel/rcutree.c                 |  507 ++++++++---
 kernel/rcutree.h                 |   27 +-
 kernel/rcutree_plugin.h          |  450 ++++++----
 kernel/rcutree_trace.c           |   12 +-
 kernel/srcu.c                    |   33 +-
 lib/Kconfig.debug                |   24 +
 net/ipv4/cipso_ipv4.c            |   11 +-
 net/ipv4/ip_sockglue.c           |    7 +-
 net/mac80211/mesh_pathtbl.c      |    8 +-
 29 files changed, 2965 insertions(+), 642 deletions(-)

