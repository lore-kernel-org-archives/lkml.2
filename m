Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417Ab1ESXQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:16:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41338 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab1ESXQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:16:13 -0400
Date: Fri, 20 May 2011 01:15:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU changes for v2.6.40
Message-ID: <20110519231540.GA23679@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-rcu-for-linus

 Thanks,

	Ingo

------------------>
Eric Dumazet (1):
      rcu: optimize rcutiny

Gleb Natapov (1):
      rcu: provide rcu_virt_note_context_switch() function.

Lai Jiangshan (40):
      rcu: call __rcu_read_unlock() in exit_rcu for tree RCU
      rcu: introduce kfree_rcu()
      cgroup,rcu: convert call_rcu(free_css_set_rcu) to kfree_rcu()
      cgroup,rcu: convert call_rcu(free_cgroup_rcu) to kfree_rcu()
      cgroup,rcu: convert call_rcu(__free_css_id_cb) to kfree_rcu()
      net,rcu: convert call_rcu(tcf_common_free_rcu) to kfree_rcu()
      net,rcu: convert call_rcu(tcf_police_free_rcu) to kfree_rcu()
      net,rcu: convert call_rcu(in6_dev_finish_destroy_rcu) to kfree_rcu()
      net,rcu: convert call_rcu(inet6_ifa_finish_destroy_rcu) to kfree_rcu()
      net,rcu: convert call_rcu(listeners_free_rcu) to kfree_rcu()
      net,rcu: convert call_rcu(sctp_local_addr_free) to kfree_rcu()
      net,rcu: convert call_rcu(ha_rcu_free) to kfree_rcu()
      net,rcu: convert call_rcu(dn_dev_free_ifa_rcu) to kfree_rcu()
      net,act_police,rcu: remove rcu_barrier()
      security,rcu: convert call_rcu(user_update_rcu_disposal) to kfree_rcu()
      net,rcu: convert call_rcu(fc_rport_free_rcu) to kfree_rcu()
      net,rcu: convert call_rcu(__leaf_info_free_rcu) to kfree_rcu()
      net,rcu: convert call_rcu(__gen_kill_estimator) to kfree_rcu()
      net,rcu: convert call_rcu(ip_mc_list_reclaim) to kfree_rcu()
      net,rcu: convert call_rcu(ip_sf_socklist_reclaim) to kfree_rcu()
      net,rcu: convert call_rcu(ip_mc_socklist_reclaim) to kfree_rcu()
      net,rcu: convert call_rcu(free_dm_hw_stat) to kfree_rcu()
      ixgbe,rcu: convert call_rcu(ring_free_rcu) to kfree_rcu()
      macvlan,rcu: convert call_rcu(macvlan_port_rcu_free) to kfree_rcu()
      net,rcu: convert call_rcu(ipv6_mc_socklist_reclaim) to kfree_rcu()
      net,rcu: convert call_rcu(rps_map_release) to kfree_rcu()
      net,rcu: convert call_rcu(xps_map_release) to kfree_rcu()
      net,rcu: convert call_rcu(xps_dev_maps_release) to kfree_rcu()
      security,rcu: convert call_rcu(sel_netif_free) to kfree_rcu()
      net,rcu: convert call_rcu(netlbl_unlhsh_free_addr4) to kfree_rcu()
      net,rcu: convert call_rcu(netlbl_unlhsh_free_addr6) to kfree_rcu()
      net,rcu: convert call_rcu(net_generic_release) to kfree_rcu()
      net,rcu: convert call_rcu(__nf_ct_ext_free_rcu) to kfree_rcu()
      perf,rcu: convert call_rcu(free_ctx) to kfree_rcu()
      perf,rcu: convert call_rcu(swevent_hlist_release_rcu) to kfree_rcu()
      net,rcu: convert call_rcu(phonet_device_rcu_free) to kfree_rcu()
      net,rcu: convert call_rcu(wq_free_rcu) to kfree_rcu()
      net/mac80211,rcu: convert call_rcu(work_free_rcu) to kfree_rcu()
      net,rcu: convert call_rcu(xt_osf_finger_free_rcu) to kfree_rcu()
      net,rcu: convert call_rcu(kfree_tid_tx) to kfree_rcu()

Mathieu Desnoyers (1):
      rcu: Enable DEBUG_OBJECTS_RCU_HEAD from !PREEMPT

Paul E. McKenney (35):
      rcu: Remove conditional compilation for RCU CPU stall warnings
      rcu: Decrease memory-barrier usage based on semi-formal proof
      rcu: merge TREE_PREEPT_RCU blocked_tasks[] lists
      rcu: move TREE_RCU from softirq to kthread
      rcu: priority boosting for TREE_PREEMPT_RCU
      rcu: Force per-rcu_node kthreads off of the outgoing CPU
      rcu: put per-CPU kthread at non-RT priority during CPU hotplug operations
      rcu: avoid hammering sched with yet another bound RT kthread
      rcu: eliminate unused boosting statistics
      rcu: Add boosting to TREE_PREEMPT_RCU tracing
      rcu: Update RCU's trace.txt documentation for new format
      rcu: add callback-queue information to rcudata output
      rcu: add tracing for RCU's kthread run states.
      rcu: make rcutorture version numbers available through debugfs
      rcu: update tracing documentation for new rcutorture and rcuboost
      rcu: fix tracing bug thinko on boost-balk attribution
      rcu: add grace-period age and more kthread state to tracing
      rcu: Add forward-progress diagnostic for per-CPU kthreads
      rcu: add DEBUG_OBJECTS_RCU_HEAD check for alignment
      rcu: mark rcutorture boosting callback as being on-stack
      rcu: Use WARN_ON_ONCE for DEBUG_OBJECTS_RCU_HEAD warnings
      rcu: Switch to this_cpu() primitives
      rcu: code cleanups in TINY_RCU priority boosting.
      rcu: remove useless ->boosted_this_gp field
      rcu: Converge TINY_RCU expedited and normal boosting
      rcu: fix spelling
      rcu: further lower priority in rcu_yield()
      rcu: prevent call_rcu() from diving into rcu core if irqs disabled
      rcu: get rid of signed overflow in check_cpu_stall()
      rcu: permit rcu_read_unlock() to be called while holding runqueue locks
      batman,rcu: convert call_rcu(gw_node_free_rcu) to kfree_rcu
      batman,rcu: convert call_rcu(neigh_node_free_rcu) to kfree()
      batman,rcu: convert call_rcu(softif_neigh_free_rcu) to kfree_rcu
      net,rcu: convert call_rcu(prl_entry_destroy_rcu) to kfree
      Revert "rcu: Decrease memory-barrier usage based on semi-formal proof"


 Documentation/RCU/00-INDEX          |    2 +-
 Documentation/RCU/stallwarn.txt     |   23 +-
 Documentation/RCU/trace.txt         |  278 ++++++++++++++---
 Documentation/filesystems/proc.txt  |    1 -
 drivers/net/ixgbe/ixgbe_main.c      |    7 +-
 drivers/net/macvlan.c               |   10 +-
 include/linux/interrupt.h           |    1 -
 include/linux/rcupdate.h            |   70 +++++-
 include/linux/rcutiny.h             |    8 +
 include/linux/rcutree.h             |   13 +
 include/net/sctp/sctp.h             |    1 -
 include/trace/events/irq.h          |    3 +-
 init/Kconfig                        |    2 +-
 kernel/cgroup.c                     |   27 +--
 kernel/perf_event.c                 |   20 +--
 kernel/rcupdate.c                   |   32 ++-
 kernel/rcutiny.c                    |   45 ++--
 kernel/rcutiny_plugin.h             |  203 ++++++-------
 kernel/rcutorture.c                 |   26 +-
 kernel/rcutree.c                    |  526 +++++++++++++++++++++++++++++---
 kernel/rcutree.h                    |  104 +++++--
 kernel/rcutree_plugin.h             |  568 +++++++++++++++++++++++++++--------
 kernel/rcutree_trace.c              |  180 ++++++++++-
 kernel/softirq.c                    |    2 +-
 lib/Kconfig.debug                   |   32 +--
 net/batman-adv/gateway_client.c     |   10 +-
 net/batman-adv/originator.c         |   10 +-
 net/batman-adv/soft-interface.c     |   10 +-
 net/core/dev_addr_lists.c           |   12 +-
 net/core/drop_monitor.c             |   12 +-
 net/core/gen_estimator.c            |    9 +-
 net/core/net-sysfs.c                |   34 +--
 net/core/net_namespace.c            |   10 +-
 net/decnet/dn_dev.c                 |    7 +-
 net/ipv4/fib_semantics.c            |   12 +-
 net/ipv4/fib_trie.c                 |    7 +-
 net/ipv4/igmp.c                     |   32 +--
 net/ipv6/addrconf.c                 |   16 +-
 net/ipv6/mcast.c                    |    8 +-
 net/ipv6/sit.c                      |    7 +-
 net/mac80211/agg-tx.c               |   14 +-
 net/mac80211/work.c                 |   10 +-
 net/netfilter/nf_conntrack_extend.c |    8 +-
 net/netfilter/xt_osf.c              |   11 +-
 net/netlabel/netlabel_unlabeled.c   |   42 +---
 net/netlink/af_netlink.c            |    8 +-
 net/phonet/pn_dev.c                 |   10 +-
 net/sched/act_api.c                 |    7 +-
 net/sched/act_police.c              |    8 +-
 net/sctp/bind_addr.c                |    2 +-
 net/sctp/ipv6.c                     |    2 +-
 net/sctp/protocol.c                 |    9 +-
 net/socket.c                        |   11 +-
 security/keys/user_defined.c        |   16 +-
 security/selinux/netif.c            |   18 +-
 tools/perf/util/trace-event-parse.c |    1 -
 56 files changed, 1724 insertions(+), 833 deletions(-)

diff --git a/Documentation/RCU/00-INDEX b/Documentation/RCU/00-INDEX
index 71b6f50..1d7a885 100644
--- a/Documentation/RCU/00-INDEX
+++ b/Documentation/RCU/00-INDEX
@@ -21,7 +21,7 @@ rcu.txt
 RTFP.txt
 	- List of RCU papers (bibliography) going back to 1980.
 stallwarn.txt
-	- RCU CPU stall warnings (CONFIG_RCU_CPU_STALL_DETECTOR)
+	- RCU CPU stall warnings (module parameter rcu_cpu_stall_suppress)
 torture.txt
 	- RCU Torture Test Operation (CONFIG_RCU_TORTURE_TEST)
 trace.txt
diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 862c08e..4e95920 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -1,22 +1,25 @@
 Using RCU's CPU Stall Detector
 
-The CONFIG_RCU_CPU_STALL_DETECTOR kernel config parameter enables
-RCU's CPU stall detector, which detects conditions that unduly delay
-RCU grace periods.  The stall detector's idea of what constitutes
-"unduly delayed" is controlled by a set of C preprocessor macros:
+The rcu_cpu_stall_suppress module parameter enables RCU's CPU stall
+detector, which detects conditions that unduly delay RCU grace periods.
+This module parameter enables CPU stall detection by default, but
+may be overridden via boot-time parameter or at runtime via sysfs.
+The stall detector's idea of what constitutes "unduly delayed" is
+controlled by a set of kernel configuration variables and cpp macros:
 
-RCU_SECONDS_TILL_STALL_CHECK
+CONFIG_RCU_CPU_STALL_TIMEOUT
 
-	This macro defines the period of time that RCU will wait from
-	the beginning of a grace period until it issues an RCU CPU
-	stall warning.	This time period is normally ten seconds.
+	This kernel configuration parameter defines the period of time
+	that RCU will wait from the beginning of a grace period until it
+	issues an RCU CPU stall warning.  This time period is normally
+	ten seconds.
 
 RCU_SECONDS_TILL_STALL_RECHECK
 
 	This macro defines the period of time that RCU will wait after
 	issuing a stall warning until it issues another stall warning
-	for the same stall.  This time period is normally set to thirty
-	seconds.
+	for the same stall.  This time period is normally set to three
+	times the check interval plus thirty seconds.
 
 RCU_STALL_RAT_DELAY
 
diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 6a8c73f..c078ad4 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -10,34 +10,46 @@ for rcutree and next for rcutiny.
 
 CONFIG_TREE_RCU and CONFIG_TREE_PREEMPT_RCU debugfs Files and Formats
 
-These implementations of RCU provides five debugfs files under the
-top-level directory RCU: rcu/rcudata (which displays fields in struct
-rcu_data), rcu/rcudata.csv (which is a .csv spreadsheet version of
-rcu/rcudata), rcu/rcugp (which displays grace-period counters),
-rcu/rcuhier (which displays the struct rcu_node hierarchy), and
-rcu/rcu_pending (which displays counts of the reasons that the
-rcu_pending() function decided that there was core RCU work to do).
+These implementations of RCU provides several debugfs files under the
+top-level directory "rcu":
+
+rcu/rcudata:
+	Displays fields in struct rcu_data.
+rcu/rcudata.csv:
+	Comma-separated values spreadsheet version of rcudata.
+rcu/rcugp:
+	Displays grace-period counters.
+rcu/rcuhier:
+	Displays the struct rcu_node hierarchy.
+rcu/rcu_pending:
+	Displays counts of the reasons rcu_pending() decided that RCU had
+	work to do.
+rcu/rcutorture:
+	Displays rcutorture test progress.
+rcu/rcuboost:
+	Displays RCU boosting statistics.  Only present if
+	CONFIG_RCU_BOOST=y.
 
 The output of "cat rcu/rcudata" looks as follows:
 
 rcu_sched:
-  0 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=10951/1 dn=0 df=1101 of=0 ri=36 ql=0 b=10
-  1 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=16117/1 dn=0 df=1015 of=0 ri=0 ql=0 b=10
-  2 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1445/1 dn=0 df=1839 of=0 ri=0 ql=0 b=10
-  3 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=6681/1 dn=0 df=1545 of=0 ri=0 ql=0 b=10
-  4 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1003/1 dn=0 df=1992 of=0 ri=0 ql=0 b=10
-  5 c=17829 g=17830 pq=1 pqc=17829 qp=1 dt=3887/1 dn=0 df=3331 of=0 ri=4 ql=2 b=10
-  6 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=859/1 dn=0 df=3224 of=0 ri=0 ql=0 b=10
-  7 c=17829 g=17830 pq=0 pqc=17829 qp=1 dt=3761/1 dn=0 df=1818 of=0 ri=0 ql=2 b=10
+  0 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=545/1/0 df=50 of=0 ri=0 ql=163 qs=NRW. kt=0/W/0 ktl=ebc3 b=10 ci=153737 co=0 ca=0
+  1 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=967/1/0 df=58 of=0 ri=0 ql=634 qs=NRW. kt=0/W/1 ktl=58c b=10 ci=191037 co=0 ca=0
+  2 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=1081/1/0 df=175 of=0 ri=0 ql=74 qs=N.W. kt=0/W/2 ktl=da94 b=10 ci=75991 co=0 ca=0
+  3 c=20942 g=20943 pq=1 pqc=20942 qp=1 dt=1846/0/0 df=404 of=0 ri=0 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=72261 co=0 ca=0
+  4 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=369/1/0 df=83 of=0 ri=0 ql=48 qs=N.W. kt=0/W/4 ktl=e0e7 b=10 ci=128365 co=0 ca=0
+  5 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=381/1/0 df=64 of=0 ri=0 ql=169 qs=NRW. kt=0/W/5 ktl=fb2f b=10 ci=164360 co=0 ca=0
+  6 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=1037/1/0 df=183 of=0 ri=0 ql=62 qs=N.W. kt=0/W/6 ktl=d2ad b=10 ci=65663 co=0 ca=0
+  7 c=20897 g=20897 pq=1 pqc=20896 qp=0 dt=1572/0/0 df=382 of=0 ri=0 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=75006 co=0 ca=0
 rcu_bh:
-  0 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=10951/1 dn=0 df=0 of=0 ri=0 ql=0 b=10
-  1 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=16117/1 dn=0 df=13 of=0 ri=0 ql=0 b=10
-  2 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=1445/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
-  3 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=6681/1 dn=0 df=9 of=0 ri=0 ql=0 b=10
-  4 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=1003/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
-  5 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=3887/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
-  6 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=859/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
-  7 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=3761/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
+  0 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=545/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/0 ktl=ebc3 b=10 ci=0 co=0 ca=0
+  1 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=967/1/0 df=3 of=0 ri=1 ql=0 qs=.... kt=0/W/1 ktl=58c b=10 ci=151 co=0 ca=0
+  2 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=1081/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/2 ktl=da94 b=10 ci=0 co=0 ca=0
+  3 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=1846/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=0 co=0 ca=0
+  4 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=369/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/4 ktl=e0e7 b=10 ci=0 co=0 ca=0
+  5 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=381/1/0 df=4 of=0 ri=1 ql=0 qs=.... kt=0/W/5 ktl=fb2f b=10 ci=0 co=0 ca=0
+  6 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=1037/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/6 ktl=d2ad b=10 ci=0 co=0 ca=0
+  7 c=1474 g=1474 pq=1 pqc=1473 qp=0 dt=1572/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=0 co=0 ca=0
 
 The first section lists the rcu_data structures for rcu_sched, the second
 for rcu_bh.  Note that CONFIG_TREE_PREEMPT_RCU kernels will have an
@@ -52,17 +64,18 @@ o	The number at the beginning of each line is the CPU number.
 	substantially larger than the number of actual CPUs.
 
 o	"c" is the count of grace periods that this CPU believes have
-	completed.  CPUs in dynticks idle mode may lag quite a ways
-	behind, for example, CPU 4 under "rcu_sched" above, which has
-	slept through the past 25 RCU grace periods.  It is not unusual
-	to see CPUs lagging by thousands of grace periods.
+	completed.  Offlined CPUs and CPUs in dynticks idle mode may
+	lag quite a ways behind, for example, CPU 6 under "rcu_sched"
+	above, which has been offline through not quite 40,000 RCU grace
+	periods.  It is not unusual to see CPUs lagging by thousands of
+	grace periods.
 
 o	"g" is the count of grace periods that this CPU believes have
-	started.  Again, CPUs in dynticks idle mode may lag behind.
-	If the "c" and "g" values are equal, this CPU has already
-	reported a quiescent state for the last RCU grace period that
-	it is aware of, otherwise, the CPU believes that it owes RCU a
-	quiescent state.
+	started.  Again, offlined CPUs and CPUs in dynticks idle mode
+	may lag behind.  If the "c" and "g" values are equal, this CPU
+	has already reported a quiescent state for the last RCU grace
+	period that it is aware of, otherwise, the CPU believes that it
+	owes RCU a quiescent state.
 
 o	"pq" indicates that this CPU has passed through a quiescent state
 	for the current grace period.  It is possible for "pq" to be
@@ -81,7 +94,8 @@ o	"pqc" indicates which grace period the last-observed quiescent
 	the next grace period!
 
 o	"qp" indicates that RCU still expects a quiescent state from
-	this CPU.
+	this CPU.  Offlined CPUs and CPUs in dyntick idle mode might
+	well have qp=1, which is OK: RCU is still ignoring them.
 
 o	"dt" is the current value of the dyntick counter that is incremented
 	when entering or leaving dynticks idle state, either by the
@@ -108,7 +122,7 @@ o	"df" is the number of times that some other CPU has forced a
 
 o	"of" is the number of times that some other CPU has forced a
 	quiescent state on behalf of this CPU due to this CPU being
-	offline.  In a perfect world, this might neve happen, but it
+	offline.  In a perfect world, this might never happen, but it
 	turns out that offlining and onlining a CPU can take several grace
 	periods, and so there is likely to be an extended period of time
 	when RCU believes that the CPU is online when it really is not.
@@ -125,6 +139,62 @@ o	"ql" is the number of RCU callbacks currently residing on
 	of what state they are in (new, waiting for grace period to
 	start, waiting for grace period to end, ready to invoke).
 
+o	"qs" gives an indication of the state of the callback queue
+	with four characters:
+
+	"N"	Indicates that there are callbacks queued that are not
+		ready to be handled by the next grace period, and thus
+		will be handled by the grace period following the next
+		one.
+
+	"R"	Indicates that there are callbacks queued that are
+		ready to be handled by the next grace period.
+
+	"W"	Indicates that there are callbacks queued that are
+		waiting on the current grace period.
+
+	"D"	Indicates that there are callbacks queued that have
+		already been handled by a prior grace period, and are
+		thus waiting to be invoked.  Note that callbacks in
+		the process of being invoked are not counted here.
+		Callbacks in the process of being invoked are those
+		that have been removed from the rcu_data structures
+		queues by rcu_do_batch(), but which have not yet been
+		invoked.
+
+	If there are no callbacks in a given one of the above states,
+	the corresponding character is replaced by ".".
+
+o	"kt" is the per-CPU kernel-thread state.  The digit preceding
+	the first slash is zero if there is no work pending and 1
+	otherwise.  The character between the first pair of slashes is
+	as follows:
+
+	"S"	The kernel thread is stopped, in other words, all
+		CPUs corresponding to this rcu_node structure are
+		offline.
+
+	"R"	The kernel thread is running.
+
+	"W"	The kernel thread is waiting because there is no work
+		for it to do.
+
+	"O"	The kernel thread is waiting because it has been
+		forced off of its designated CPU or because its
+		->cpus_allowed mask permits it to run on other than
+		its designated CPU.
+
+	"Y"	The kernel thread is yielding to avoid hogging CPU.
+
+	"?"	Unknown value, indicates a bug.
+
+	The number after the final slash is the CPU that the kthread
+	is actually running on.
+
+o	"ktl" is the low-order 16 bits (in hexadecimal) of the count of
+	the number of times that this CPU's per-CPU kthread has gone
+	through its loop servicing invoke_rcu_cpu_kthread() requests.
+
 o	"b" is the batch limit for this CPU.  If more than this number
 	of RCU callbacks is ready to invoke, then the remainder will
 	be deferred.
@@ -174,14 +244,14 @@ o	"gpnum" is the number of grace periods that have started.  It is
 The output of "cat rcu/rcuhier" looks as follows, with very long lines:
 
 c=6902 g=6903 s=2 jfq=3 j=72c7 nfqs=13142/nfqsng=0(13142) fqlh=6
-1/1 .>. 0:127 ^0    
-3/3 .>. 0:35 ^0    0/0 .>. 36:71 ^1    0/0 .>. 72:107 ^2    0/0 .>. 108:127 ^3    
-3/3f .>. 0:5 ^0    2/3 .>. 6:11 ^1    0/0 .>. 12:17 ^2    0/0 .>. 18:23 ^3    0/0 .>. 24:29 ^4    0/0 .>. 30:35 ^5    0/0 .>. 36:41 ^0    0/0 .>. 42:47 ^1    0/0 .>. 48:53 ^2    0/0 .>. 54:59 ^3    0/0 .>. 60:65 ^4    0/0 .>. 66:71 ^5    0/0 .>. 72:77 ^0    0/0 .>. 78:83 ^1    0/0 .>. 84:89 ^2    0/0 .>. 90:95 ^3    0/0 .>. 96:101 ^4    0/0 .>. 102:107 ^5    0/0 .>. 108:113 ^0    0/0 .>. 114:119 ^1    0/0 .>. 120:125 ^2    0/0 .>. 126:127 ^3    
+1/1 ..>. 0:127 ^0
+3/3 ..>. 0:35 ^0    0/0 ..>. 36:71 ^1    0/0 ..>. 72:107 ^2    0/0 ..>. 108:127 ^3
+3/3f ..>. 0:5 ^0    2/3 ..>. 6:11 ^1    0/0 ..>. 12:17 ^2    0/0 ..>. 18:23 ^3    0/0 ..>. 24:29 ^4    0/0 ..>. 30:35 ^5    0/0 ..>. 36:41 ^0    0/0 ..>. 42:47 ^1    0/0 ..>. 48:53 ^2    0/0 ..>. 54:59 ^3    0/0 ..>. 60:65 ^4    0/0 ..>. 66:71 ^5    0/0 ..>. 72:77 ^0    0/0 ..>. 78:83 ^1    0/0 ..>. 84:89 ^2    0/0 ..>. 90:95 ^3    0/0 ..>. 96:101 ^4    0/0 ..>. 102:107 ^5    0/0 ..>. 108:113 ^0    0/0 ..>. 114:119 ^1    0/0 ..>. 120:125 ^2    0/0 ..>. 126:127 ^3
 rcu_bh:
 c=-226 g=-226 s=1 jfq=-5701 j=72c7 nfqs=88/nfqsng=0(88) fqlh=0
-0/1 .>. 0:127 ^0    
-0/3 .>. 0:35 ^0    0/0 .>. 36:71 ^1    0/0 .>. 72:107 ^2    0/0 .>. 108:127 ^3    
-0/3f .>. 0:5 ^0    0/3 .>. 6:11 ^1    0/0 .>. 12:17 ^2    0/0 .>. 18:23 ^3    0/0 .>. 24:29 ^4    0/0 .>. 30:35 ^5    0/0 .>. 36:41 ^0    0/0 .>. 42:47 ^1    0/0 .>. 48:53 ^2    0/0 .>. 54:59 ^3    0/0 .>. 60:65 ^4    0/0 .>. 66:71 ^5    0/0 .>. 72:77 ^0    0/0 .>. 78:83 ^1    0/0 .>. 84:89 ^2    0/0 .>. 90:95 ^3    0/0 .>. 96:101 ^4    0/0 .>. 102:107 ^5    0/0 .>. 108:113 ^0    0/0 .>. 114:119 ^1    0/0 .>. 120:125 ^2    0/0 .>. 126:127 ^3
+0/1 ..>. 0:127 ^0
+0/3 ..>. 0:35 ^0    0/0 ..>. 36:71 ^1    0/0 ..>. 72:107 ^2    0/0 ..>. 108:127 ^3
+0/3f ..>. 0:5 ^0    0/3 ..>. 6:11 ^1    0/0 ..>. 12:17 ^2    0/0 ..>. 18:23 ^3    0/0 ..>. 24:29 ^4    0/0 ..>. 30:35 ^5    0/0 ..>. 36:41 ^0    0/0 ..>. 42:47 ^1    0/0 ..>. 48:53 ^2    0/0 ..>. 54:59 ^3    0/0 ..>. 60:65 ^4    0/0 ..>. 66:71 ^5    0/0 ..>. 72:77 ^0    0/0 ..>. 78:83 ^1    0/0 ..>. 84:89 ^2    0/0 ..>. 90:95 ^3    0/0 ..>. 96:101 ^4    0/0 ..>. 102:107 ^5    0/0 ..>. 108:113 ^0    0/0 ..>. 114:119 ^1    0/0 ..>. 120:125 ^2    0/0 ..>. 126:127 ^3
 
 This is once again split into "rcu_sched" and "rcu_bh" portions,
 and CONFIG_TREE_PREEMPT_RCU kernels will again have an additional
@@ -240,13 +310,20 @@ o	Each element of the form "1/1 0:127 ^0" represents one struct
 		current grace period.
 
 	o	The characters separated by the ">" indicate the state
-		of the blocked-tasks lists.  A "T" preceding the ">"
+		of the blocked-tasks lists.  A "G" preceding the ">"
 		indicates that at least one task blocked in an RCU
 		read-side critical section blocks the current grace
-		period, while a "." preceding the ">" indicates otherwise.
-		The character following the ">" indicates similarly for
-		the next grace period.  A "T" should appear in this
-		field only for rcu-preempt.
+		period, while a "E" preceding the ">" indicates that
+		at least one task blocked in an RCU read-side critical
+		section blocks the current expedited grace period.
+		A "T" character following the ">" indicates that at
+		least one task is blocked within an RCU read-side
+		critical section, regardless of whether any current
+		grace period (expedited or normal) is inconvenienced.
+		A "." character appears if the corresponding condition
+		does not hold, so that "..>." indicates that no tasks
+		are blocked.  In contrast, "GE>T" indicates maximal
+		inconvenience from blocked tasks.
 
 	o	The numbers separated by the ":" are the range of CPUs
 		served by this struct rcu_node.  This can be helpful
@@ -328,6 +405,113 @@ o	"nn" is the number of times that this CPU needed nothing.  Alert
 	is due to short-circuit evaluation in rcu_pending().
 
 
+The output of "cat rcu/rcutorture" looks as follows:
+
+rcutorture test sequence: 0 (test in progress)
+rcutorture update version number: 615
+
+The first line shows the number of rcutorture tests that have completed
+since boot.  If a test is currently running, the "(test in progress)"
+string will appear as shown above.  The second line shows the number of
+update cycles that the current test has started, or zero if there is
+no test in progress.
+
+
+The output of "cat rcu/rcuboost" looks as follows:
+
+0:5 tasks=.... kt=W ntb=0 neb=0 nnb=0 j=2f95 bt=300f
+     balk: nt=0 egt=989 bt=0 nb=0 ny=0 nos=16
+6:7 tasks=.... kt=W ntb=0 neb=0 nnb=0 j=2f95 bt=300f
+     balk: nt=0 egt=225 bt=0 nb=0 ny=0 nos=6
+
+This information is output only for rcu_preempt.  Each two-line entry
+corresponds to a leaf rcu_node strcuture.  The fields are as follows:
+
+o	"n:m" is the CPU-number range for the corresponding two-line
+	entry.  In the sample output above, the first entry covers
+	CPUs zero through five and the second entry covers CPUs 6
+	and 7.
+
+o	"tasks=TNEB" gives the state of the various segments of the
+	rnp->blocked_tasks list:
+
+	"T"	This indicates that there are some tasks that blocked
+		while running on one of the corresponding CPUs while
+		in an RCU read-side critical section.
+
+	"N"	This indicates that some of the blocked tasks are preventing
+		the current normal (non-expedited) grace period from
+		completing.
+
+	"E"	This indicates that some of the blocked tasks are preventing
+		the current expedited grace period from completing.
+
+	"B"	This indicates that some of the blocked tasks are in
+		need of RCU priority boosting.
+
+	Each character is replaced with "." if the corresponding
+	condition does not hold.
+
+o	"kt" is the state of the RCU priority-boosting kernel
+	thread associated with the corresponding rcu_node structure.
+	The state can be one of the following:
+
+	"S"	The kernel thread is stopped, in other words, all
+		CPUs corresponding to this rcu_node structure are
+		offline.
+
+	"R"	The kernel thread is running.
+
+	"W"	The kernel thread is waiting because there is no work
+		for it to do.
+
+	"Y"	The kernel thread is yielding to avoid hogging CPU.
+
+	"?"	Unknown value, indicates a bug.
+
+o	"ntb" is the number of tasks boosted.
+
+o	"neb" is the number of tasks boosted in order to complete an
+	expedited grace period.
+
+o	"nnb" is the number of tasks boosted in order to complete a
+	normal (non-expedited) grace period.  When boosting a task
+	that was blocking both an expedited and a normal grace period,
+	it is counted against the expedited total above.
+
+o	"j" is the low-order 16 bits of the jiffies counter in
+	hexadecimal.
+
+o	"bt" is the low-order 16 bits of the value that the jiffies
+	counter will have when we next start boosting, assuming that
+	the current grace period does not end beforehand.  This is
+	also in hexadecimal.
+
+o	"balk: nt" counts the number of times we didn't boost (in
+	other words, we balked) even though it was time to boost because
+	there were no blocked tasks to boost.  This situation occurs
+	when there is one blocked task on one rcu_node structure and
+	none on some other rcu_node structure.
+
+o	"egt" counts the number of times we balked because although
+	there were blocked tasks, none of them were blocking the
+	current grace period, whether expedited or otherwise.
+
+o	"bt" counts the number of times we balked because boosting
+	had already been initiated for the current grace period.
+
+o	"nb" counts the number of times we balked because there
+	was at least one task blocking the current non-expedited grace
+	period that never had blocked.  If it is already running, it
+	just won't help to boost its priority!
+
+o	"ny" counts the number of times we balked because it was
+	not yet time to start boosting.
+
+o	"nos" counts the number of times we balked for other
+	reasons, e.g., the grace period ended first.
+
+
 CONFIG_TINY_RCU and CONFIG_TINY_PREEMPT_RCU debugfs Files and Formats
 
 These implementations of RCU provides a single debugfs file under the
@@ -394,9 +578,9 @@ o	"neb" is the number of expedited grace periods that have had
 o	"nnb" is the number of normal grace periods that have had
 	to resort to RCU priority boosting since boot.
 
-o	"j" is the low-order 12 bits of the jiffies counter in hexadecimal.
+o	"j" is the low-order 16 bits of the jiffies counter in hexadecimal.
 
-o	"bt" is the low-order 12 bits of the value that the jiffies counter
+o	"bt" is the low-order 16 bits of the value that the jiffies counter
 	will have at the next time that boosting is scheduled to begin.
 
 o	In the line beginning with "normal balk", the fields are as follows:
diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index b0b814d..60740e8 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -836,7 +836,6 @@ Provides counts of softirq handlers serviced since boot time, for each cpu.
  TASKLET:          0          0          0        290
    SCHED:      27035      26983      26971      26746
  HRTIMER:          0          0          0          0
-     RCU:       1678       1769       2178       2250
 
 
 1.3 IDE devices in /proc/ide
diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index 6f8adc7..e145f2c 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -5100,11 +5100,6 @@ err_set_interrupt:
 	return err;
 }
 
-static void ring_free_rcu(struct rcu_head *head)
-{
-	kfree(container_of(head, struct ixgbe_ring, rcu));
-}
-
 /**
  * ixgbe_clear_interrupt_scheme - Clear the current interrupt scheme settings
  * @adapter: board private structure to clear interrupt scheme on
@@ -5126,7 +5121,7 @@ void ixgbe_clear_interrupt_scheme(struct ixgbe_adapter *adapter)
 		/* ixgbe_get_stats64() might access this ring, we must wait
 		 * a grace period before freeing it.
 		 */
-		call_rcu(&ring->rcu, ring_free_rcu);
+		kfree_rcu(ring, rcu);
 		adapter->rx_ring[i] = NULL;
 	}
 
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 78e34e9..d8e4e69 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -603,21 +603,13 @@ static int macvlan_port_create(struct net_device *dev)
 	return err;
 }
 
-static void macvlan_port_rcu_free(struct rcu_head *head)
-{
-	struct macvlan_port *port;
-
-	port = container_of(head, struct macvlan_port, rcu);
-	kfree(port);
-}
-
 static void macvlan_port_destroy(struct net_device *dev)
 {
 	struct macvlan_port *port = macvlan_port_get(dev);
 
 	dev->priv_flags &= ~IFF_MACVLAN_PORT;
 	netdev_rx_handler_unregister(dev);
-	call_rcu(&port->rcu, macvlan_port_rcu_free);
+	kfree_rcu(port, rcu);
 }
 
 static int macvlan_validate(struct nlattr *tb[], struct nlattr *data[])
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index bea0ac7..6c12989 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -414,7 +414,6 @@ enum
 	TASKLET_SOFTIRQ,
 	SCHED_SOFTIRQ,
 	HRTIMER_SOFTIRQ,
-	RCU_SOFTIRQ,	/* Preferable RCU should always be the last softirq */
 
 	NR_SOFTIRQS
 };
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ff422d2..99f9aa7 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -47,6 +47,18 @@
 extern int rcutorture_runnable; /* for sysctl */
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
+#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
+extern void rcutorture_record_test_transition(void);
+extern void rcutorture_record_progress(unsigned long vernum);
+#else
+static inline void rcutorture_record_test_transition(void)
+{
+}
+static inline void rcutorture_record_progress(unsigned long vernum)
+{
+}
+#endif
+
 #define UINT_CMP_GE(a, b)	(UINT_MAX / 2 >= (a) - (b))
 #define UINT_CMP_LT(a, b)	(UINT_MAX / 2 < (a) - (b))
 #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
@@ -68,7 +80,6 @@ extern void call_rcu_sched(struct rcu_head *head,
 extern void synchronize_sched(void);
 extern void rcu_barrier_bh(void);
 extern void rcu_barrier_sched(void);
-extern int sched_expedited_torture_stats(char *page);
 
 static inline void __rcu_read_lock_bh(void)
 {
@@ -774,6 +785,7 @@ extern struct debug_obj_descr rcuhead_debug_descr;
 
 static inline void debug_rcu_head_queue(struct rcu_head *head)
 {
+	WARN_ON_ONCE((unsigned long)head & 0x3);
 	debug_object_activate(head, &rcuhead_debug_descr);
 	debug_object_active_state(head, &rcuhead_debug_descr,
 				  STATE_RCU_HEAD_READY,
@@ -797,4 +809,60 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 }
 #endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
+static __always_inline bool __is_kfree_rcu_offset(unsigned long offset)
+{
+	return offset < 4096;
+}
+
+static __always_inline
+void __kfree_rcu(struct rcu_head *head, unsigned long offset)
+{
+	typedef void (*rcu_callback)(struct rcu_head *);
+
+	BUILD_BUG_ON(!__builtin_constant_p(offset));
+
+	/* See the kfree_rcu() header comment. */
+	BUILD_BUG_ON(!__is_kfree_rcu_offset(offset));
+
+	call_rcu(head, (rcu_callback)offset);
+}
+
+extern void kfree(const void *);
+
+static inline void __rcu_reclaim(struct rcu_head *head)
+{
+	unsigned long offset = (unsigned long)head->func;
+
+	if (__is_kfree_rcu_offset(offset))
+		kfree((void *)head - offset);
+	else
+		head->func(head);
+}
+
+/**
+ * kfree_rcu() - kfree an object after a grace period.
+ * @ptr:	pointer to kfree
+ * @rcu_head:	the name of the struct rcu_head within the type of @ptr.
+ *
+ * Many rcu callbacks functions just call kfree() on the base structure.
+ * These functions are trivial, but their size adds up, and furthermore
+ * when they are used in a kernel module, that module must invoke the
+ * high-latency rcu_barrier() function at module-unload time.
+ *
+ * The kfree_rcu() function handles this issue.  Rather than encoding a
+ * function address in the embedded rcu_head structure, kfree_rcu() instead
+ * encodes the offset of the rcu_head structure within the base structure.
+ * Because the functions are not allowed in the low-order 4096 bytes of
+ * kernel virtual memory, offsets up to 4095 bytes can be accommodated.
+ * If the offset is larger than 4095 bytes, a compile-time error will
+ * be generated in __kfree_rcu().  If this error is triggered, you can
+ * either fall back to use of call_rcu() or rearrange the structure to
+ * position the rcu_head structure into the first 4096 bytes.
+ *
+ * Note that the allowable offset might decrease in the future, for example,
+ * to allow something like kmem_cache_free_rcu().
+ */
+#define kfree_rcu(ptr, rcu_head)					\
+	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
+
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 30ebd7c..52b3e02 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -100,6 +100,14 @@ static inline void rcu_note_context_switch(int cpu)
 }
 
 /*
+ * Take advantage of the fact that there is only one CPU, which
+ * allows us to ignore virtualization-based context switches.
+ */
+static inline void rcu_virt_note_context_switch(int cpu)
+{
+}
+
+/*
  * Return the number of grace periods.
  */
 static inline long rcu_batches_completed(void)
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 3a93348..e65d066 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -35,6 +35,16 @@ extern void rcu_note_context_switch(int cpu);
 extern int rcu_needs_cpu(int cpu);
 extern void rcu_cpu_stall_reset(void);
 
+/*
+ * Note a virtualization-based context switch.  This is simply a
+ * wrapper around rcu_note_context_switch(), which allows TINY_RCU
+ * to save a few bytes.
+ */
+static inline void rcu_virt_note_context_switch(int cpu)
+{
+	rcu_note_context_switch(cpu);
+}
+
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
 extern void exit_rcu(void);
@@ -58,9 +68,12 @@ static inline void synchronize_rcu_bh_expedited(void)
 
 extern void rcu_barrier(void);
 
+extern unsigned long rcutorture_testseq;
+extern unsigned long rcutorture_vernum;
 extern long rcu_batches_completed(void);
 extern long rcu_batches_completed_bh(void);
 extern long rcu_batches_completed_sched(void);
+
 extern void rcu_force_quiescent_state(void);
 extern void rcu_bh_force_quiescent_state(void);
 extern void rcu_sched_force_quiescent_state(void);
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 505845d..01e094c 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -115,7 +115,6 @@
  * sctp/protocol.c
  */
 extern struct sock *sctp_get_ctl_sock(void);
-extern void sctp_local_addr_free(struct rcu_head *head);
 extern int sctp_copy_local_addr_list(struct sctp_bind_addr *,
 				     sctp_scope_t, gfp_t gfp,
 				     int flags);
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 1c09820..ae045ca 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -20,8 +20,7 @@ struct softirq_action;
 			 softirq_name(BLOCK_IOPOLL),	\
 			 softirq_name(TASKLET),		\
 			 softirq_name(SCHED),		\
-			 softirq_name(HRTIMER),		\
-			 softirq_name(RCU))
+			 softirq_name(HRTIMER))
 
 /**
  * irq_handler_entry - called immediately before the irq action handler
diff --git a/init/Kconfig b/init/Kconfig
index d886b1e..2d964fa 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -485,7 +485,7 @@ config TREE_RCU_TRACE
 
 config RCU_BOOST
 	bool "Enable RCU priority boosting"
-	depends on RT_MUTEXES && TINY_PREEMPT_RCU
+	depends on RT_MUTEXES && PREEMPT_RCU
 	default n
 	help
 	  This option boosts the priority of preempted RCU readers that
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 25c7eb5..909a355 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -326,12 +326,6 @@ static struct hlist_head *css_set_hash(struct cgroup_subsys_state *css[])
 	return &css_set_table[index];
 }
 
-static void free_css_set_rcu(struct rcu_head *obj)
-{
-	struct css_set *cg = container_of(obj, struct css_set, rcu_head);
-	kfree(cg);
-}
-
 /* We don't maintain the lists running through each css_set to its
  * task until after the first call to cgroup_iter_start(). This
  * reduces the fork()/exit() overhead for people who have cgroups
@@ -375,7 +369,7 @@ static void __put_css_set(struct css_set *cg, int taskexit)
 	}
 
 	write_unlock(&css_set_lock);
-	call_rcu(&cg->rcu_head, free_css_set_rcu);
+	kfree_rcu(cg, rcu_head);
 }
 
 /*
@@ -812,13 +806,6 @@ static int cgroup_call_pre_destroy(struct cgroup *cgrp)
 	return ret;
 }
 
-static void free_cgroup_rcu(struct rcu_head *obj)
-{
-	struct cgroup *cgrp = container_of(obj, struct cgroup, rcu_head);
-
-	kfree(cgrp);
-}
-
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 {
 	/* is dentry a directory ? if so, kfree() associated cgroup */
@@ -856,7 +843,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		 */
 		BUG_ON(!list_empty(&cgrp->pidlists));
 
-		call_rcu(&cgrp->rcu_head, free_cgroup_rcu);
+		kfree_rcu(cgrp, rcu_head);
 	}
 	iput(inode);
 }
@@ -4623,14 +4610,6 @@ bool css_is_ancestor(struct cgroup_subsys_state *child,
 	return ret;
 }
 
-static void __free_css_id_cb(struct rcu_head *head)
-{
-	struct css_id *id;
-
-	id = container_of(head, struct css_id, rcu_head);
-	kfree(id);
-}
-
 void free_css_id(struct cgroup_subsys *ss, struct cgroup_subsys_state *css)
 {
 	struct css_id *id = css->id;
@@ -4645,7 +4624,7 @@ void free_css_id(struct cgroup_subsys *ss, struct cgroup_subsys_state *css)
 	spin_lock(&ss->id_lock);
 	idr_remove(&ss->idr, id->id);
 	spin_unlock(&ss->id_lock);
-	call_rcu(&id->rcu_head, __free_css_id_cb);
+	kfree_rcu(id, rcu_head);
 }
 EXPORT_SYMBOL_GPL(free_css_id);
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8e81a98..b90d660 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -586,14 +586,6 @@ static void get_ctx(struct perf_event_context *ctx)
 	WARN_ON(!atomic_inc_not_zero(&ctx->refcount));
 }
 
-static void free_ctx(struct rcu_head *head)
-{
-	struct perf_event_context *ctx;
-
-	ctx = container_of(head, struct perf_event_context, rcu_head);
-	kfree(ctx);
-}
-
 static void put_ctx(struct perf_event_context *ctx)
 {
 	if (atomic_dec_and_test(&ctx->refcount)) {
@@ -601,7 +593,7 @@ static void put_ctx(struct perf_event_context *ctx)
 			put_ctx(ctx->parent_ctx);
 		if (ctx->task)
 			put_task_struct(ctx->task);
-		call_rcu(&ctx->rcu_head, free_ctx);
+		kfree_rcu(ctx, rcu_head);
 	}
 }
 
@@ -5331,14 +5323,6 @@ swevent_hlist_deref(struct swevent_htable *swhash)
 					 lockdep_is_held(&swhash->hlist_mutex));
 }
 
-static void swevent_hlist_release_rcu(struct rcu_head *rcu_head)
-{
-	struct swevent_hlist *hlist;
-
-	hlist = container_of(rcu_head, struct swevent_hlist, rcu_head);
-	kfree(hlist);
-}
-
 static void swevent_hlist_release(struct swevent_htable *swhash)
 {
 	struct swevent_hlist *hlist = swevent_hlist_deref(swhash);
@@ -5347,7 +5331,7 @@ static void swevent_hlist_release(struct swevent_htable *swhash)
 		return;
 
 	rcu_assign_pointer(swhash->swevent_hlist, NULL);
-	call_rcu(&hlist->rcu_head, swevent_hlist_release_rcu);
+	kfree_rcu(hlist, rcu_head);
 }
 
 static void swevent_hlist_put_cpu(struct perf_event *event, int cpu)
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index f3240e9..7784bd2 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -142,10 +142,17 @@ static int rcuhead_fixup_init(void *addr, enum debug_obj_state state)
 		 * Ensure that queued callbacks are all executed.
 		 * If we detect that we are nested in a RCU read-side critical
 		 * section, we should simply fail, otherwise we would deadlock.
+		 * In !PREEMPT configurations, there is no way to tell if we are
+		 * in a RCU read-side critical section or not, so we never
+		 * attempt any fixup and just print a warning.
 		 */
+#ifndef CONFIG_PREEMPT
+		WARN_ON_ONCE(1);
+		return 0;
+#endif
 		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
 		    irqs_disabled()) {
-			WARN_ON(1);
+			WARN_ON_ONCE(1);
 			return 0;
 		}
 		rcu_barrier();
@@ -184,10 +191,17 @@ static int rcuhead_fixup_activate(void *addr, enum debug_obj_state state)
 		 * Ensure that queued callbacks are all executed.
 		 * If we detect that we are nested in a RCU read-side critical
 		 * section, we should simply fail, otherwise we would deadlock.
+		 * In !PREEMPT configurations, there is no way to tell if we are
+		 * in a RCU read-side critical section or not, so we never
+		 * attempt any fixup and just print a warning.
 		 */
+#ifndef CONFIG_PREEMPT
+		WARN_ON_ONCE(1);
+		return 0;
+#endif
 		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
 		    irqs_disabled()) {
-			WARN_ON(1);
+			WARN_ON_ONCE(1);
 			return 0;
 		}
 		rcu_barrier();
@@ -214,15 +228,17 @@ static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
 		 * Ensure that queued callbacks are all executed.
 		 * If we detect that we are nested in a RCU read-side critical
 		 * section, we should simply fail, otherwise we would deadlock.
-		 * Note that the machinery to reliably determine whether
-		 * or not we are in an RCU read-side critical section
-		 * exists only in the preemptible RCU implementations
-		 * (TINY_PREEMPT_RCU and TREE_PREEMPT_RCU), which is why
-		 * DEBUG_OBJECTS_RCU_HEAD is disallowed if !PREEMPT.
+		 * In !PREEMPT configurations, there is no way to tell if we are
+		 * in a RCU read-side critical section or not, so we never
+		 * attempt any fixup and just print a warning.
 		 */
+#ifndef CONFIG_PREEMPT
+		WARN_ON_ONCE(1);
+		return 0;
+#endif
 		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
 		    irqs_disabled()) {
-			WARN_ON(1);
+			WARN_ON_ONCE(1);
 			return 0;
 		}
 		rcu_barrier();
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 0c343b9..421abfd 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -40,10 +40,10 @@
 static struct task_struct *rcu_kthread_task;
 static DECLARE_WAIT_QUEUE_HEAD(rcu_kthread_wq);
 static unsigned long have_rcu_kthread_work;
-static void invoke_rcu_kthread(void);
 
 /* Forward declarations for rcutiny_plugin.h. */
 struct rcu_ctrlblk;
+static void invoke_rcu_kthread(void);
 static void rcu_process_callbacks(struct rcu_ctrlblk *rcp);
 static int rcu_kthread(void *arg);
 static void __call_rcu(struct rcu_head *head,
@@ -79,36 +79,45 @@ void rcu_exit_nohz(void)
 #endif /* #ifdef CONFIG_NO_HZ */
 
 /*
- * Helper function for rcu_qsctr_inc() and rcu_bh_qsctr_inc().
- * Also disable irqs to avoid confusion due to interrupt handlers
+ * Helper function for rcu_sched_qs() and rcu_bh_qs().
+ * Also irqs are disabled to avoid confusion due to interrupt handlers
  * invoking call_rcu().
  */
 static int rcu_qsctr_help(struct rcu_ctrlblk *rcp)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
 	if (rcp->rcucblist != NULL &&
 	    rcp->donetail != rcp->curtail) {
 		rcp->donetail = rcp->curtail;
-		local_irq_restore(flags);
 		return 1;
 	}
-	local_irq_restore(flags);
 
 	return 0;
 }
 
 /*
+ * Wake up rcu_kthread() to process callbacks now eligible for invocation
+ * or to boost readers.
+ */
+static void invoke_rcu_kthread(void)
+{
+	have_rcu_kthread_work = 1;
+	wake_up(&rcu_kthread_wq);
+}
+
+/*
  * Record an rcu quiescent state.  And an rcu_bh quiescent state while we
  * are at it, given that any rcu quiescent state is also an rcu_bh
  * quiescent state.  Use "+" instead of "||" to defeat short circuiting.
  */
 void rcu_sched_qs(int cpu)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	if (rcu_qsctr_help(&rcu_sched_ctrlblk) +
 	    rcu_qsctr_help(&rcu_bh_ctrlblk))
 		invoke_rcu_kthread();
+	local_irq_restore(flags);
 }
 
 /*
@@ -116,8 +125,12 @@ void rcu_sched_qs(int cpu)
  */
 void rcu_bh_qs(int cpu)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	if (rcu_qsctr_help(&rcu_bh_ctrlblk))
 		invoke_rcu_kthread();
+	local_irq_restore(flags);
 }
 
 /*
@@ -167,7 +180,7 @@ static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 		prefetch(next);
 		debug_rcu_head_unqueue(list);
 		local_bh_disable();
-		list->func(list);
+		__rcu_reclaim(list);
 		local_bh_enable();
 		list = next;
 		RCU_TRACE(cb_count++);
@@ -208,20 +221,6 @@ static int rcu_kthread(void *arg)
 }
 
 /*
- * Wake up rcu_kthread() to process callbacks now eligible for invocation
- * or to boost readers.
- */
-static void invoke_rcu_kthread(void)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	have_rcu_kthread_work = 1;
-	wake_up(&rcu_kthread_wq);
-	local_irq_restore(flags);
-}
-
-/*
  * Wait for a grace period to elapse.  But it is illegal to invoke
  * synchronize_sched() from within an RCU read-side critical section.
  * Therefore, any legal call to synchronize_sched() is a quiescent
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 3cb8e36..f259c67 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -100,23 +100,28 @@ struct rcu_preempt_ctrlblk {
 	u8 completed;		/* Last grace period completed. */
 				/*  If all three are equal, RCU is idle. */
 #ifdef CONFIG_RCU_BOOST
-	s8 boosted_this_gp;	/* Has boosting already happened? */
 	unsigned long boost_time; /* When to start boosting (jiffies) */
 #endif /* #ifdef CONFIG_RCU_BOOST */
 #ifdef CONFIG_RCU_TRACE
 	unsigned long n_grace_periods;
 #ifdef CONFIG_RCU_BOOST
 	unsigned long n_tasks_boosted;
+				/* Total number of tasks boosted. */
 	unsigned long n_exp_boosts;
+				/* Number of tasks boosted for expedited GP. */
 	unsigned long n_normal_boosts;
-	unsigned long n_normal_balk_blkd_tasks;
-	unsigned long n_normal_balk_gp_tasks;
-	unsigned long n_normal_balk_boost_tasks;
-	unsigned long n_normal_balk_boosted;
-	unsigned long n_normal_balk_notyet;
-	unsigned long n_normal_balk_nos;
-	unsigned long n_exp_balk_blkd_tasks;
-	unsigned long n_exp_balk_nos;
+				/* Number of tasks boosted for normal GP. */
+	unsigned long n_balk_blkd_tasks;
+				/* Refused to boost: no blocked tasks. */
+	unsigned long n_balk_exp_gp_tasks;
+				/* Refused to boost: nothing blocking GP. */
+	unsigned long n_balk_boost_tasks;
+				/* Refused to boost: already boosting. */
+	unsigned long n_balk_notyet;
+				/* Refused to boost: not yet time. */
+	unsigned long n_balk_nos;
+				/* Refused to boost: not sure why, though. */
+				/*  This can happen due to race conditions. */
 #endif /* #ifdef CONFIG_RCU_BOOST */
 #endif /* #ifdef CONFIG_RCU_TRACE */
 };
@@ -201,7 +206,6 @@ static struct list_head *rcu_next_node_entry(struct task_struct *t)
 
 #ifdef CONFIG_RCU_BOOST
 static void rcu_initiate_boost_trace(void);
-static void rcu_initiate_exp_boost_trace(void);
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
 /*
@@ -219,41 +223,21 @@ static void show_tiny_preempt_stats(struct seq_file *m)
 		   "N."[!rcu_preempt_ctrlblk.gp_tasks],
 		   "E."[!rcu_preempt_ctrlblk.exp_tasks]);
 #ifdef CONFIG_RCU_BOOST
-	seq_printf(m, "             ttb=%c btg=",
-		   "B."[!rcu_preempt_ctrlblk.boost_tasks]);
-	switch (rcu_preempt_ctrlblk.boosted_this_gp) {
-	case -1:
-		seq_puts(m, "exp");
-		break;
-	case 0:
-		seq_puts(m, "no");
-		break;
-	case 1:
-		seq_puts(m, "begun");
-		break;
-	case 2:
-		seq_puts(m, "done");
-		break;
-	default:
-		seq_printf(m, "?%d?", rcu_preempt_ctrlblk.boosted_this_gp);
-	}
-	seq_printf(m, " ntb=%lu neb=%lu nnb=%lu j=%04x bt=%04x\n",
+	seq_printf(m, "%sttb=%c ntb=%lu neb=%lu nnb=%lu j=%04x bt=%04x\n",
+		   "             ",
+		   "B."[!rcu_preempt_ctrlblk.boost_tasks],
 		   rcu_preempt_ctrlblk.n_tasks_boosted,
 		   rcu_preempt_ctrlblk.n_exp_boosts,
 		   rcu_preempt_ctrlblk.n_normal_boosts,
 		   (int)(jiffies & 0xffff),
 		   (int)(rcu_preempt_ctrlblk.boost_time & 0xffff));
-	seq_printf(m, "             %s: nt=%lu gt=%lu bt=%lu b=%lu ny=%lu nos=%lu\n",
-		   "normal balk",
-		   rcu_preempt_ctrlblk.n_normal_balk_blkd_tasks,
-		   rcu_preempt_ctrlblk.n_normal_balk_gp_tasks,
-		   rcu_preempt_ctrlblk.n_normal_balk_boost_tasks,
-		   rcu_preempt_ctrlblk.n_normal_balk_boosted,
-		   rcu_preempt_ctrlblk.n_normal_balk_notyet,
-		   rcu_preempt_ctrlblk.n_normal_balk_nos);
-	seq_printf(m, "             exp balk: bt=%lu nos=%lu\n",
-		   rcu_preempt_ctrlblk.n_exp_balk_blkd_tasks,
-		   rcu_preempt_ctrlblk.n_exp_balk_nos);
+	seq_printf(m, "%s: nt=%lu egt=%lu bt=%lu ny=%lu nos=%lu\n",
+		   "             balk",
+		   rcu_preempt_ctrlblk.n_balk_blkd_tasks,
+		   rcu_preempt_ctrlblk.n_balk_exp_gp_tasks,
+		   rcu_preempt_ctrlblk.n_balk_boost_tasks,
+		   rcu_preempt_ctrlblk.n_balk_notyet,
+		   rcu_preempt_ctrlblk.n_balk_nos);
 #endif /* #ifdef CONFIG_RCU_BOOST */
 }
 
@@ -271,25 +255,59 @@ static int rcu_boost(void)
 {
 	unsigned long flags;
 	struct rt_mutex mtx;
-	struct list_head *np;
 	struct task_struct *t;
+	struct list_head *tb;
 
-	if (rcu_preempt_ctrlblk.boost_tasks == NULL)
+	if (rcu_preempt_ctrlblk.boost_tasks == NULL &&
+	    rcu_preempt_ctrlblk.exp_tasks == NULL)
 		return 0;  /* Nothing to boost. */
+
 	raw_local_irq_save(flags);
-	rcu_preempt_ctrlblk.boosted_this_gp++;
-	t = container_of(rcu_preempt_ctrlblk.boost_tasks, struct task_struct,
-			 rcu_node_entry);
-	np = rcu_next_node_entry(t);
+
+	/*
+	 * Recheck with irqs disabled: all tasks in need of boosting
+	 * might exit their RCU read-side critical sections on their own
+	 * if we are preempted just before disabling irqs.
+	 */
+	if (rcu_preempt_ctrlblk.boost_tasks == NULL &&
+	    rcu_preempt_ctrlblk.exp_tasks == NULL) {
+		raw_local_irq_restore(flags);
+		return 0;
+	}
+
+	/*
+	 * Preferentially boost tasks blocking expedited grace periods.
+	 * This cannot starve the normal grace periods because a second
+	 * expedited grace period must boost all blocked tasks, including
+	 * those blocking the pre-existing normal grace period.
+	 */
+	if (rcu_preempt_ctrlblk.exp_tasks != NULL) {
+		tb = rcu_preempt_ctrlblk.exp_tasks;
+		RCU_TRACE(rcu_preempt_ctrlblk.n_exp_boosts++);
+	} else {
+		tb = rcu_preempt_ctrlblk.boost_tasks;
+		RCU_TRACE(rcu_preempt_ctrlblk.n_normal_boosts++);
+	}
+	RCU_TRACE(rcu_preempt_ctrlblk.n_tasks_boosted++);
+
+	/*
+	 * We boost task t by manufacturing an rt_mutex that appears to
+	 * be held by task t.  We leave a pointer to that rt_mutex where
+	 * task t can find it, and task t will release the mutex when it
+	 * exits its outermost RCU read-side critical section.  Then
+	 * simply acquiring this artificial rt_mutex will boost task
+	 * t's priority.  (Thanks to tglx for suggesting this approach!)
+	 */
+	t = container_of(tb, struct task_struct, rcu_node_entry);
 	rt_mutex_init_proxy_locked(&mtx, t);
 	t->rcu_boost_mutex = &mtx;
 	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;
 	raw_local_irq_restore(flags);
 	rt_mutex_lock(&mtx);
-	RCU_TRACE(rcu_preempt_ctrlblk.n_tasks_boosted++);
-	rcu_preempt_ctrlblk.boosted_this_gp++;
-	rt_mutex_unlock(&mtx);
-	return rcu_preempt_ctrlblk.boost_tasks != NULL;
+	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
+
+	return rcu_preempt_ctrlblk.boost_tasks != NULL ||
+	       rcu_preempt_ctrlblk.exp_tasks != NULL;
 }
 
 /*
@@ -304,42 +322,25 @@ static int rcu_boost(void)
  */
 static int rcu_initiate_boost(void)
 {
-	if (!rcu_preempt_blocked_readers_cgp()) {
-		RCU_TRACE(rcu_preempt_ctrlblk.n_normal_balk_blkd_tasks++);
+	if (!rcu_preempt_blocked_readers_cgp() &&
+	    rcu_preempt_ctrlblk.exp_tasks == NULL) {
+		RCU_TRACE(rcu_preempt_ctrlblk.n_balk_exp_gp_tasks++);
 		return 0;
 	}
-	if (rcu_preempt_ctrlblk.gp_tasks != NULL &&
-	    rcu_preempt_ctrlblk.boost_tasks == NULL &&
-	    rcu_preempt_ctrlblk.boosted_this_gp == 0 &&
-	    ULONG_CMP_GE(jiffies, rcu_preempt_ctrlblk.boost_time)) {
-		rcu_preempt_ctrlblk.boost_tasks = rcu_preempt_ctrlblk.gp_tasks;
+	if (rcu_preempt_ctrlblk.exp_tasks != NULL ||
+	    (rcu_preempt_ctrlblk.gp_tasks != NULL &&
+	     rcu_preempt_ctrlblk.boost_tasks == NULL &&
+	     ULONG_CMP_GE(jiffies, rcu_preempt_ctrlblk.boost_time))) {
+		if (rcu_preempt_ctrlblk.exp_tasks == NULL)
+			rcu_preempt_ctrlblk.boost_tasks =
+				rcu_preempt_ctrlblk.gp_tasks;
 		invoke_rcu_kthread();
-		RCU_TRACE(rcu_preempt_ctrlblk.n_normal_boosts++);
 	} else
 		RCU_TRACE(rcu_initiate_boost_trace());
 	return 1;
 }
 
-/*
- * Initiate boosting for an expedited grace period.
- */
-static void rcu_initiate_expedited_boost(void)
-{
-	unsigned long flags;
-
-	raw_local_irq_save(flags);
-	if (!list_empty(&rcu_preempt_ctrlblk.blkd_tasks)) {
-		rcu_preempt_ctrlblk.boost_tasks =
-			rcu_preempt_ctrlblk.blkd_tasks.next;
-		rcu_preempt_ctrlblk.boosted_this_gp = -1;
-		invoke_rcu_kthread();
-		RCU_TRACE(rcu_preempt_ctrlblk.n_exp_boosts++);
-	} else
-		RCU_TRACE(rcu_initiate_exp_boost_trace());
-	raw_local_irq_restore(flags);
-}
-
-#define RCU_BOOST_DELAY_JIFFIES DIV_ROUND_UP(CONFIG_RCU_BOOST_DELAY * HZ, 1000);
+#define RCU_BOOST_DELAY_JIFFIES DIV_ROUND_UP(CONFIG_RCU_BOOST_DELAY * HZ, 1000)
 
 /*
  * Do priority-boost accounting for the start of a new grace period.
@@ -347,8 +348,6 @@ static void rcu_initiate_expedited_boost(void)
 static void rcu_preempt_boost_start_gp(void)
 {
 	rcu_preempt_ctrlblk.boost_time = jiffies + RCU_BOOST_DELAY_JIFFIES;
-	if (rcu_preempt_ctrlblk.boosted_this_gp > 0)
-		rcu_preempt_ctrlblk.boosted_this_gp = 0;
 }
 
 #else /* #ifdef CONFIG_RCU_BOOST */
@@ -372,13 +371,6 @@ static int rcu_initiate_boost(void)
 }
 
 /*
- * If there is no RCU priority boosting, we don't initiate expedited boosting.
- */
-static void rcu_initiate_expedited_boost(void)
-{
-}
-
-/*
  * If there is no RCU priority boosting, nothing to do at grace-period start.
  */
 static void rcu_preempt_boost_start_gp(void)
@@ -418,7 +410,7 @@ static void rcu_preempt_cpu_qs(void)
 	if (!rcu_preempt_gp_in_progress())
 		return;
 	/*
-	 * Check up on boosting.  If there are no readers blocking the
+	 * Check up on boosting.  If there are readers blocking the
 	 * current grace period, leave.
 	 */
 	if (rcu_initiate_boost())
@@ -578,7 +570,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		empty = !rcu_preempt_blocked_readers_cgp();
 		empty_exp = rcu_preempt_ctrlblk.exp_tasks == NULL;
 		np = rcu_next_node_entry(t);
-		list_del(&t->rcu_node_entry);
+		list_del_init(&t->rcu_node_entry);
 		if (&t->rcu_node_entry == rcu_preempt_ctrlblk.gp_tasks)
 			rcu_preempt_ctrlblk.gp_tasks = np;
 		if (&t->rcu_node_entry == rcu_preempt_ctrlblk.exp_tasks)
@@ -587,7 +579,6 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		if (&t->rcu_node_entry == rcu_preempt_ctrlblk.boost_tasks)
 			rcu_preempt_ctrlblk.boost_tasks = np;
 #endif /* #ifdef CONFIG_RCU_BOOST */
-		INIT_LIST_HEAD(&t->rcu_node_entry);
 
 		/*
 		 * If this was the last task on the current list, and if
@@ -812,13 +803,16 @@ void synchronize_rcu_expedited(void)
 	rpcp->exp_tasks = rpcp->blkd_tasks.next;
 	if (rpcp->exp_tasks == &rpcp->blkd_tasks)
 		rpcp->exp_tasks = NULL;
-	local_irq_restore(flags);
 
 	/* Wait for tail of ->blkd_tasks list to drain. */
-	if (rcu_preempted_readers_exp())
-		rcu_initiate_expedited_boost();
+	if (!rcu_preempted_readers_exp())
+		local_irq_restore(flags);
+	else {
+		rcu_initiate_boost();
+		local_irq_restore(flags);
 		wait_event(sync_rcu_preempt_exp_wq,
 			   !rcu_preempted_readers_exp());
+	}
 
 	/* Clean up and exit. */
 	barrier(); /* ensure expedited GP seen before counter increment. */
@@ -931,24 +925,17 @@ void __init rcu_scheduler_starting(void)
 
 static void rcu_initiate_boost_trace(void)
 {
-	if (rcu_preempt_ctrlblk.gp_tasks == NULL)
-		rcu_preempt_ctrlblk.n_normal_balk_gp_tasks++;
+	if (list_empty(&rcu_preempt_ctrlblk.blkd_tasks))
+		rcu_preempt_ctrlblk.n_balk_blkd_tasks++;
+	else if (rcu_preempt_ctrlblk.gp_tasks == NULL &&
+		 rcu_preempt_ctrlblk.exp_tasks == NULL)
+		rcu_preempt_ctrlblk.n_balk_exp_gp_tasks++;
 	else if (rcu_preempt_ctrlblk.boost_tasks != NULL)
-		rcu_preempt_ctrlblk.n_normal_balk_boost_tasks++;
-	else if (rcu_preempt_ctrlblk.boosted_this_gp != 0)
-		rcu_preempt_ctrlblk.n_normal_balk_boosted++;
+		rcu_preempt_ctrlblk.n_balk_boost_tasks++;
 	else if (!ULONG_CMP_GE(jiffies, rcu_preempt_ctrlblk.boost_time))
-		rcu_preempt_ctrlblk.n_normal_balk_notyet++;
-	else
-		rcu_preempt_ctrlblk.n_normal_balk_nos++;
-}
-
-static void rcu_initiate_exp_boost_trace(void)
-{
-	if (list_empty(&rcu_preempt_ctrlblk.blkd_tasks))
-		rcu_preempt_ctrlblk.n_exp_balk_blkd_tasks++;
+		rcu_preempt_ctrlblk.n_balk_notyet++;
 	else
-		rcu_preempt_ctrlblk.n_exp_balk_nos++;
+		rcu_preempt_ctrlblk.n_balk_nos++;
 }
 
 #endif /* #ifdef CONFIG_RCU_BOOST */
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index c224da4..2e138db 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -131,7 +131,7 @@ struct rcu_torture {
 
 static LIST_HEAD(rcu_torture_freelist);
 static struct rcu_torture __rcu *rcu_torture_current;
-static long rcu_torture_current_version;
+static unsigned long rcu_torture_current_version;
 static struct rcu_torture rcu_tortures[10 * RCU_TORTURE_PIPE_LEN];
 static DEFINE_SPINLOCK(rcu_torture_lock);
 static DEFINE_PER_CPU(long [RCU_TORTURE_PIPE_LEN + 1], rcu_torture_count) =
@@ -146,8 +146,6 @@ static atomic_t n_rcu_torture_mberror;
 static atomic_t n_rcu_torture_error;
 static long n_rcu_torture_boost_ktrerror;
 static long n_rcu_torture_boost_rterror;
-static long n_rcu_torture_boost_allocerror;
-static long n_rcu_torture_boost_afferror;
 static long n_rcu_torture_boost_failure;
 static long n_rcu_torture_boosts;
 static long n_rcu_torture_timers;
@@ -163,11 +161,11 @@ static int stutter_pause_test;
 #endif
 int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
 
-#ifdef CONFIG_RCU_BOOST
+#if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU)
 #define rcu_can_boost() 1
-#else /* #ifdef CONFIG_RCU_BOOST */
+#else /* #if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU) */
 #define rcu_can_boost() 0
-#endif /* #else #ifdef CONFIG_RCU_BOOST */
+#endif /* #else #if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU) */
 
 static unsigned long boost_starttime;	/* jiffies of next boost test start. */
 DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
@@ -751,6 +749,7 @@ static int rcu_torture_boost(void *arg)
 		n_rcu_torture_boost_rterror++;
 	}
 
+	init_rcu_head_on_stack(&rbi.rcu);
 	/* Each pass through the following loop does one boost-test cycle. */
 	do {
 		/* Wait for the next test interval. */
@@ -810,6 +809,7 @@ checkwait:	rcu_stutter_wait("rcu_torture_boost");
 
 	/* Clean up and exit. */
 	VERBOSE_PRINTK_STRING("rcu_torture_boost task stopping");
+	destroy_rcu_head_on_stack(&rbi.rcu);
 	rcutorture_shutdown_absorb("rcu_torture_boost");
 	while (!kthread_should_stop() || rbi.inflight)
 		schedule_timeout_uninterruptible(1);
@@ -886,7 +886,7 @@ rcu_torture_writer(void *arg)
 			old_rp->rtort_pipe_count++;
 			cur_ops->deferred_free(old_rp);
 		}
-		rcu_torture_current_version++;
+		rcutorture_record_progress(++rcu_torture_current_version);
 		oldbatch = cur_ops->completed();
 		rcu_stutter_wait("rcu_torture_writer");
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
@@ -1066,8 +1066,8 @@ rcu_torture_printk(char *page)
 	}
 	cnt += sprintf(&page[cnt], "%s%s ", torture_type, TORTURE_FLAG);
 	cnt += sprintf(&page[cnt],
-		       "rtc: %p ver: %ld tfle: %d rta: %d rtaf: %d rtf: %d "
-		       "rtmbe: %d rtbke: %ld rtbre: %ld rtbae: %ld rtbafe: %ld "
+		       "rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d "
+		       "rtmbe: %d rtbke: %ld rtbre: %ld "
 		       "rtbf: %ld rtb: %ld nt: %ld",
 		       rcu_torture_current,
 		       rcu_torture_current_version,
@@ -1078,16 +1078,12 @@ rcu_torture_printk(char *page)
 		       atomic_read(&n_rcu_torture_mberror),
 		       n_rcu_torture_boost_ktrerror,
 		       n_rcu_torture_boost_rterror,
-		       n_rcu_torture_boost_allocerror,
-		       n_rcu_torture_boost_afferror,
 		       n_rcu_torture_boost_failure,
 		       n_rcu_torture_boosts,
 		       n_rcu_torture_timers);
 	if (atomic_read(&n_rcu_torture_mberror) != 0 ||
 	    n_rcu_torture_boost_ktrerror != 0 ||
 	    n_rcu_torture_boost_rterror != 0 ||
-	    n_rcu_torture_boost_allocerror != 0 ||
-	    n_rcu_torture_boost_afferror != 0 ||
 	    n_rcu_torture_boost_failure != 0)
 		cnt += sprintf(&page[cnt], " !!!");
 	cnt += sprintf(&page[cnt], "\n%s%s ", torture_type, TORTURE_FLAG);
@@ -1331,6 +1327,7 @@ rcu_torture_cleanup(void)
 	int i;
 
 	mutex_lock(&fullstop_mutex);
+	rcutorture_record_test_transition();
 	if (fullstop == FULLSTOP_SHUTDOWN) {
 		printk(KERN_WARNING /* but going down anyway, so... */
 		       "Concurrent 'rmmod rcutorture' and shutdown illegal!\n");
@@ -1486,8 +1483,6 @@ rcu_torture_init(void)
 	atomic_set(&n_rcu_torture_error, 0);
 	n_rcu_torture_boost_ktrerror = 0;
 	n_rcu_torture_boost_rterror = 0;
-	n_rcu_torture_boost_allocerror = 0;
-	n_rcu_torture_boost_afferror = 0;
 	n_rcu_torture_boost_failure = 0;
 	n_rcu_torture_boosts = 0;
 	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
@@ -1624,6 +1619,7 @@ rcu_torture_init(void)
 		}
 	}
 	register_reboot_notifier(&rcutorture_shutdown_nb);
+	rcutorture_record_test_transition();
 	mutex_unlock(&fullstop_mutex);
 	return 0;
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index dd4aea8..e486f7c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -47,6 +47,8 @@
 #include <linux/mutex.h>
 #include <linux/time.h>
 #include <linux/kernel_stat.h>
+#include <linux/wait.h>
+#include <linux/kthread.h>
 
 #include "rcutree.h"
 
@@ -79,10 +81,41 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
 struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
+static struct rcu_state *rcu_state;
+
 int rcu_scheduler_active __read_mostly;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 
 /*
+ * Control variables for per-CPU and per-rcu_node kthreads.  These
+ * handle all flavors of RCU.
+ */
+static DEFINE_PER_CPU(struct task_struct *, rcu_cpu_kthread_task);
+DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
+DEFINE_PER_CPU(int, rcu_cpu_kthread_cpu);
+DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
+static DEFINE_PER_CPU(wait_queue_head_t, rcu_cpu_wq);
+DEFINE_PER_CPU(char, rcu_cpu_has_work);
+static char rcu_kthreads_spawnable;
+
+static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu);
+static void invoke_rcu_cpu_kthread(void);
+
+#define RCU_KTHREAD_PRIO 1	/* RT priority for per-CPU kthreads. */
+
+/*
+ * Track the rcutorture test sequence number and the update version
+ * number within a given test.  The rcutorture_testseq is incremented
+ * on every rcutorture module load and unload, so has an odd value
+ * when a test is running.  The rcutorture_vernum is set to zero
+ * when rcutorture starts and is incremented on each rcutorture update.
+ * These variables enable correlating rcutorture output with the
+ * RCU tracing information.
+ */
+unsigned long rcutorture_testseq;
+unsigned long rcutorture_vernum;
+
+/*
  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
  * permit this function to be invoked without holding the root rcu_node
  * structure's ->lock, but of course results can be subject to change.
@@ -124,6 +157,7 @@ void rcu_note_context_switch(int cpu)
 	rcu_sched_qs(cpu);
 	rcu_preempt_note_context_switch(cpu);
 }
+EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
 #ifdef CONFIG_NO_HZ
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
@@ -140,10 +174,8 @@ module_param(blimit, int, 0);
 module_param(qhimark, int, 0);
 module_param(qlowmark, int, 0);
 
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-int rcu_cpu_stall_suppress __read_mostly = RCU_CPU_STALL_SUPPRESS_INIT;
+int rcu_cpu_stall_suppress __read_mostly;
 module_param(rcu_cpu_stall_suppress, int, 0644);
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
 static int rcu_pending(int cpu);
@@ -176,6 +208,31 @@ void rcu_bh_force_quiescent_state(void)
 EXPORT_SYMBOL_GPL(rcu_bh_force_quiescent_state);
 
 /*
+ * Record the number of times rcutorture tests have been initiated and
+ * terminated.  This information allows the debugfs tracing stats to be
+ * correlated to the rcutorture messages, even when the rcutorture module
+ * is being repeatedly loaded and unloaded.  In other words, we cannot
+ * store this state in rcutorture itself.
+ */
+void rcutorture_record_test_transition(void)
+{
+	rcutorture_testseq++;
+	rcutorture_vernum = 0;
+}
+EXPORT_SYMBOL_GPL(rcutorture_record_test_transition);
+
+/*
+ * Record the number of writer passes through the current rcutorture test.
+ * This is also used to correlate debugfs tracing stats with the rcutorture
+ * messages.
+ */
+void rcutorture_record_progress(unsigned long vernum)
+{
+	rcutorture_vernum++;
+}
+EXPORT_SYMBOL_GPL(rcutorture_record_progress);
+
+/*
  * Force a quiescent state for RCU-sched.
  */
 void rcu_sched_force_quiescent_state(void)
@@ -234,8 +291,8 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 		return 1;
 	}
 
-	/* If preemptable RCU, no point in sending reschedule IPI. */
-	if (rdp->preemptable)
+	/* If preemptible RCU, no point in sending reschedule IPI. */
+	if (rdp->preemptible)
 		return 0;
 
 	/* The CPU is online, so send it a reschedule IPI. */
@@ -450,8 +507,6 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-
 int rcu_cpu_stall_suppress __read_mostly;
 
 static void record_gp_stall_check_time(struct rcu_state *rsp)
@@ -537,21 +592,24 @@ static void print_cpu_stall(struct rcu_state *rsp)
 
 static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	long delta;
+	unsigned long j;
+	unsigned long js;
 	struct rcu_node *rnp;
 
 	if (rcu_cpu_stall_suppress)
 		return;
-	delta = jiffies - ACCESS_ONCE(rsp->jiffies_stall);
+	j = ACCESS_ONCE(jiffies);
+	js = ACCESS_ONCE(rsp->jiffies_stall);
 	rnp = rdp->mynode;
-	if ((ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && delta >= 0) {
+	if ((ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && ULONG_CMP_GE(j, js)) {
 
 		/* We haven't checked in, so go dump stack. */
 		print_cpu_stall(rsp);
 
-	} else if (rcu_gp_in_progress(rsp) && delta >= RCU_STALL_RAT_DELAY) {
+	} else if (rcu_gp_in_progress(rsp) &&
+		   ULONG_CMP_GE(j, js + RCU_STALL_RAT_DELAY)) {
 
-		/* They had two time units to dump stack, so complain. */
+		/* They had a few time units to dump stack, so complain. */
 		print_other_cpu_stall(rsp);
 	}
 }
@@ -587,26 +645,6 @@ static void __init check_cpu_stall_init(void)
 	atomic_notifier_chain_register(&panic_notifier_list, &rcu_panic_block);
 }
 
-#else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
-static void record_gp_stall_check_time(struct rcu_state *rsp)
-{
-}
-
-static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
-{
-}
-
-void rcu_cpu_stall_reset(void)
-{
-}
-
-static void __init check_cpu_stall_init(void)
-{
-}
-
-#endif /* #else #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
 /*
  * Update CPU-local rcu_data state to record the newly noticed grace period.
  * This is used both when we started the grace period and when we notice
@@ -809,6 +847,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		rnp->completed = rsp->completed;
 		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
 		rcu_start_gp_per_cpu(rsp, rnp, rdp);
+		rcu_preempt_boost_start_gp(rnp);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
@@ -844,6 +883,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		rnp->completed = rsp->completed;
 		if (rnp == rdp->mynode)
 			rcu_start_gp_per_cpu(rsp, rnp, rdp);
+		rcu_preempt_boost_start_gp(rnp);
 		raw_spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 	}
 
@@ -864,7 +904,12 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	__releases(rcu_get_root(rsp)->lock)
 {
+	unsigned long gp_duration;
+
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
+	gp_duration = jiffies - rsp->gp_start;
+	if (gp_duration > rsp->gp_max)
+		rsp->gp_max = gp_duration;
 	rsp->completed = rsp->gpnum;
 	rsp->signaled = RCU_GP_IDLE;
 	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
@@ -894,7 +939,7 @@ rcu_report_qs_rnp(unsigned long mask, struct rcu_state *rsp,
 			return;
 		}
 		rnp->qsmask &= ~mask;
-		if (rnp->qsmask != 0 || rcu_preempted_readers(rnp)) {
+		if (rnp->qsmask != 0 || rcu_preempt_blocked_readers_cgp(rnp)) {
 
 			/* Other bits still set at this level, so done. */
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
@@ -1037,6 +1082,8 @@ static void rcu_send_cbs_to_online(struct rcu_state *rsp)
 /*
  * Remove the outgoing CPU from the bitmasks in the rcu_node hierarchy
  * and move all callbacks from the outgoing CPU to the current one.
+ * There can only be one CPU hotplug operation at a time, so no other
+ * CPU can be attempting to update rcu_cpu_kthread_task.
  */
 static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 {
@@ -1045,6 +1092,14 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	int need_report = 0;
 	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp;
+	struct task_struct *t;
+
+	/* Stop the CPU's kthread. */
+	t = per_cpu(rcu_cpu_kthread_task, cpu);
+	if (t != NULL) {
+		per_cpu(rcu_cpu_kthread_task, cpu) = NULL;
+		kthread_stop(t);
+	}
 
 	/* Exclude any attempts to start a new grace period. */
 	raw_spin_lock_irqsave(&rsp->onofflock, flags);
@@ -1082,6 +1137,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	if (need_report & RCU_OFL_TASKS_EXP_GP)
 		rcu_report_exp_rnp(rsp, rnp);
+	rcu_node_kthread_setaffinity(rnp, -1);
 }
 
 /*
@@ -1143,7 +1199,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 		next = list->next;
 		prefetch(next);
 		debug_rcu_head_unqueue(list);
-		list->func(list);
+		__rcu_reclaim(list);
 		list = next;
 		if (++count >= rdp->blimit)
 			break;
@@ -1179,7 +1235,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	/* Re-raise the RCU softirq if there are callbacks remaining. */
 	if (cpu_has_callbacks_ready_to_invoke(rdp))
-		raise_softirq(RCU_SOFTIRQ);
+		invoke_rcu_cpu_kthread();
 }
 
 /*
@@ -1225,7 +1281,7 @@ void rcu_check_callbacks(int cpu, int user)
 	}
 	rcu_preempt_check_callbacks(cpu);
 	if (rcu_pending(cpu))
-		raise_softirq(RCU_SOFTIRQ);
+		invoke_rcu_cpu_kthread();
 }
 
 #ifdef CONFIG_SMP
@@ -1233,6 +1289,8 @@ void rcu_check_callbacks(int cpu, int user)
 /*
  * Scan the leaf rcu_node structures, processing dyntick state for any that
  * have not yet encountered a quiescent state, using the function specified.
+ * Also initiate boosting for any threads blocked on the root rcu_node.
+ *
  * The caller must have suppressed start of new grace periods.
  */
 static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
@@ -1251,7 +1309,7 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 			return;
 		}
 		if (rnp->qsmask == 0) {
-			raw_spin_unlock_irqrestore(&rnp->lock, flags);
+			rcu_initiate_boost(rnp, flags); /* releases rnp->lock */
 			continue;
 		}
 		cpu = rnp->grplo;
@@ -1269,6 +1327,11 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 		}
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
+	rnp = rcu_get_root(rsp);
+	if (rnp->qsmask == 0) {
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
+	}
 }
 
 /*
@@ -1389,7 +1452,7 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 /*
  * Do softirq processing for the current CPU.
  */
-static void rcu_process_callbacks(struct softirq_action *unused)
+static void rcu_process_callbacks(void)
 {
 	/*
 	 * Memory references from any prior RCU read-side critical sections
@@ -1414,6 +1477,347 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 	rcu_needs_cpu_flush();
 }
 
+/*
+ * Wake up the current CPU's kthread.  This replaces raise_softirq()
+ * in earlier versions of RCU.  Note that because we are running on
+ * the current CPU with interrupts disabled, the rcu_cpu_kthread_task
+ * cannot disappear out from under us.
+ */
+static void invoke_rcu_cpu_kthread(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__this_cpu_write(rcu_cpu_has_work, 1);
+	if (__this_cpu_read(rcu_cpu_kthread_task) == NULL) {
+		local_irq_restore(flags);
+		return;
+	}
+	wake_up(&__get_cpu_var(rcu_cpu_wq));
+	local_irq_restore(flags);
+}
+
+/*
+ * Wake up the specified per-rcu_node-structure kthread.
+ * Because the per-rcu_node kthreads are immortal, we don't need
+ * to do anything to keep them alive.
+ */
+static void invoke_rcu_node_kthread(struct rcu_node *rnp)
+{
+	struct task_struct *t;
+
+	t = rnp->node_kthread_task;
+	if (t != NULL)
+		wake_up_process(t);
+}
+
+/*
+ * Set the specified CPU's kthread to run RT or not, as specified by
+ * the to_rt argument.  The CPU-hotplug locks are held, so the task
+ * is not going away.
+ */
+static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
+{
+	int policy;
+	struct sched_param sp;
+	struct task_struct *t;
+
+	t = per_cpu(rcu_cpu_kthread_task, cpu);
+	if (t == NULL)
+		return;
+	if (to_rt) {
+		policy = SCHED_FIFO;
+		sp.sched_priority = RCU_KTHREAD_PRIO;
+	} else {
+		policy = SCHED_NORMAL;
+		sp.sched_priority = 0;
+	}
+	sched_setscheduler_nocheck(t, policy, &sp);
+}
+
+/*
+ * Timer handler to initiate the waking up of per-CPU kthreads that
+ * have yielded the CPU due to excess numbers of RCU callbacks.
+ * We wake up the per-rcu_node kthread, which in turn will wake up
+ * the booster kthread.
+ */
+static void rcu_cpu_kthread_timer(unsigned long arg)
+{
+	unsigned long flags;
+	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, arg);
+	struct rcu_node *rnp = rdp->mynode;
+
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	rnp->wakemask |= rdp->grpmask;
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	invoke_rcu_node_kthread(rnp);
+}
+
+/*
+ * Drop to non-real-time priority and yield, but only after posting a
+ * timer that will cause us to regain our real-time priority if we
+ * remain preempted.  Either way, we restore our real-time priority
+ * before returning.
+ */
+static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
+{
+	struct sched_param sp;
+	struct timer_list yield_timer;
+
+	setup_timer_on_stack(&yield_timer, f, arg);
+	mod_timer(&yield_timer, jiffies + 2);
+	sp.sched_priority = 0;
+	sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
+	set_user_nice(current, 19);
+	schedule();
+	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
+	del_timer(&yield_timer);
+}
+
+/*
+ * Handle cases where the rcu_cpu_kthread() ends up on the wrong CPU.
+ * This can happen while the corresponding CPU is either coming online
+ * or going offline.  We cannot wait until the CPU is fully online
+ * before starting the kthread, because the various notifier functions
+ * can wait for RCU grace periods.  So we park rcu_cpu_kthread() until
+ * the corresponding CPU is online.
+ *
+ * Return 1 if the kthread needs to stop, 0 otherwise.
+ *
+ * Caller must disable bh.  This function can momentarily enable it.
+ */
+static int rcu_cpu_kthread_should_stop(int cpu)
+{
+	while (cpu_is_offline(cpu) ||
+	       !cpumask_equal(&current->cpus_allowed, cpumask_of(cpu)) ||
+	       smp_processor_id() != cpu) {
+		if (kthread_should_stop())
+			return 1;
+		per_cpu(rcu_cpu_kthread_status, cpu) = RCU_KTHREAD_OFFCPU;
+		per_cpu(rcu_cpu_kthread_cpu, cpu) = raw_smp_processor_id();
+		local_bh_enable();
+		schedule_timeout_uninterruptible(1);
+		if (!cpumask_equal(&current->cpus_allowed, cpumask_of(cpu)))
+			set_cpus_allowed_ptr(current, cpumask_of(cpu));
+		local_bh_disable();
+	}
+	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
+	return 0;
+}
+
+/*
+ * Per-CPU kernel thread that invokes RCU callbacks.  This replaces the
+ * earlier RCU softirq.
+ */
+static int rcu_cpu_kthread(void *arg)
+{
+	int cpu = (int)(long)arg;
+	unsigned long flags;
+	int spincnt = 0;
+	unsigned int *statusp = &per_cpu(rcu_cpu_kthread_status, cpu);
+	wait_queue_head_t *wqp = &per_cpu(rcu_cpu_wq, cpu);
+	char work;
+	char *workp = &per_cpu(rcu_cpu_has_work, cpu);
+
+	for (;;) {
+		*statusp = RCU_KTHREAD_WAITING;
+		wait_event_interruptible(*wqp,
+					 *workp != 0 || kthread_should_stop());
+		local_bh_disable();
+		if (rcu_cpu_kthread_should_stop(cpu)) {
+			local_bh_enable();
+			break;
+		}
+		*statusp = RCU_KTHREAD_RUNNING;
+		per_cpu(rcu_cpu_kthread_loops, cpu)++;
+		local_irq_save(flags);
+		work = *workp;
+		*workp = 0;
+		local_irq_restore(flags);
+		if (work)
+			rcu_process_callbacks();
+		local_bh_enable();
+		if (*workp != 0)
+			spincnt++;
+		else
+			spincnt = 0;
+		if (spincnt > 10) {
+			*statusp = RCU_KTHREAD_YIELDING;
+			rcu_yield(rcu_cpu_kthread_timer, (unsigned long)cpu);
+			spincnt = 0;
+		}
+	}
+	*statusp = RCU_KTHREAD_STOPPED;
+	return 0;
+}
+
+/*
+ * Spawn a per-CPU kthread, setting up affinity and priority.
+ * Because the CPU hotplug lock is held, no other CPU will be attempting
+ * to manipulate rcu_cpu_kthread_task.  There might be another CPU
+ * attempting to access it during boot, but the locking in kthread_bind()
+ * will enforce sufficient ordering.
+ */
+static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
+{
+	struct sched_param sp;
+	struct task_struct *t;
+
+	if (!rcu_kthreads_spawnable ||
+	    per_cpu(rcu_cpu_kthread_task, cpu) != NULL)
+		return 0;
+	t = kthread_create(rcu_cpu_kthread, (void *)(long)cpu, "rcuc%d", cpu);
+	if (IS_ERR(t))
+		return PTR_ERR(t);
+	kthread_bind(t, cpu);
+	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
+	WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
+	per_cpu(rcu_cpu_kthread_task, cpu) = t;
+	wake_up_process(t);
+	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+	return 0;
+}
+
+/*
+ * Per-rcu_node kthread, which is in charge of waking up the per-CPU
+ * kthreads when needed.  We ignore requests to wake up kthreads
+ * for offline CPUs, which is OK because force_quiescent_state()
+ * takes care of this case.
+ */
+static int rcu_node_kthread(void *arg)
+{
+	int cpu;
+	unsigned long flags;
+	unsigned long mask;
+	struct rcu_node *rnp = (struct rcu_node *)arg;
+	struct sched_param sp;
+	struct task_struct *t;
+
+	for (;;) {
+		rnp->node_kthread_status = RCU_KTHREAD_WAITING;
+		wait_event_interruptible(rnp->node_wq, rnp->wakemask != 0);
+		rnp->node_kthread_status = RCU_KTHREAD_RUNNING;
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		mask = rnp->wakemask;
+		rnp->wakemask = 0;
+		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
+		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1) {
+			if ((mask & 0x1) == 0)
+				continue;
+			preempt_disable();
+			t = per_cpu(rcu_cpu_kthread_task, cpu);
+			if (!cpu_online(cpu) || t == NULL) {
+				preempt_enable();
+				continue;
+			}
+			per_cpu(rcu_cpu_has_work, cpu) = 1;
+			sp.sched_priority = RCU_KTHREAD_PRIO;
+			sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+			preempt_enable();
+		}
+	}
+	/* NOTREACHED */
+	rnp->node_kthread_status = RCU_KTHREAD_STOPPED;
+	return 0;
+}
+
+/*
+ * Set the per-rcu_node kthread's affinity to cover all CPUs that are
+ * served by the rcu_node in question.  The CPU hotplug lock is still
+ * held, so the value of rnp->qsmaskinit will be stable.
+ *
+ * We don't include outgoingcpu in the affinity set, use -1 if there is
+ * no outgoing CPU.  If there are no CPUs left in the affinity set,
+ * this function allows the kthread to execute on any CPU.
+ */
+static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
+{
+	cpumask_var_t cm;
+	int cpu;
+	unsigned long mask = rnp->qsmaskinit;
+
+	if (rnp->node_kthread_task == NULL)
+		return;
+	if (!alloc_cpumask_var(&cm, GFP_KERNEL))
+		return;
+	cpumask_clear(cm);
+	for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1)
+		if ((mask & 0x1) && cpu != outgoingcpu)
+			cpumask_set_cpu(cpu, cm);
+	if (cpumask_weight(cm) == 0) {
+		cpumask_setall(cm);
+		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++)
+			cpumask_clear_cpu(cpu, cm);
+		WARN_ON_ONCE(cpumask_weight(cm) == 0);
+	}
+	set_cpus_allowed_ptr(rnp->node_kthread_task, cm);
+	rcu_boost_kthread_setaffinity(rnp, cm);
+	free_cpumask_var(cm);
+}
+
+/*
+ * Spawn a per-rcu_node kthread, setting priority and affinity.
+ * Called during boot before online/offline can happen, or, if
+ * during runtime, with the main CPU-hotplug locks held.  So only
+ * one of these can be executing at a time.
+ */
+static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
+						struct rcu_node *rnp)
+{
+	unsigned long flags;
+	int rnp_index = rnp - &rsp->node[0];
+	struct sched_param sp;
+	struct task_struct *t;
+
+	if (!rcu_kthreads_spawnable ||
+	    rnp->qsmaskinit == 0)
+		return 0;
+	if (rnp->node_kthread_task == NULL) {
+		t = kthread_create(rcu_node_kthread, (void *)rnp,
+				   "rcun%d", rnp_index);
+		if (IS_ERR(t))
+			return PTR_ERR(t);
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		rnp->node_kthread_task = t;
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		wake_up_process(t);
+		sp.sched_priority = 99;
+		sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+	}
+	return rcu_spawn_one_boost_kthread(rsp, rnp, rnp_index);
+}
+
+/*
+ * Spawn all kthreads -- called as soon as the scheduler is running.
+ */
+static int __init rcu_spawn_kthreads(void)
+{
+	int cpu;
+	struct rcu_node *rnp;
+
+	rcu_kthreads_spawnable = 1;
+	for_each_possible_cpu(cpu) {
+		init_waitqueue_head(&per_cpu(rcu_cpu_wq, cpu));
+		per_cpu(rcu_cpu_has_work, cpu) = 0;
+		if (cpu_online(cpu))
+			(void)rcu_spawn_one_cpu_kthread(cpu);
+	}
+	rnp = rcu_get_root(rcu_state);
+	init_waitqueue_head(&rnp->node_wq);
+	rcu_init_boost_waitqueue(rnp);
+	(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
+	if (NUM_RCU_NODES > 1)
+		rcu_for_each_leaf_node(rcu_state, rnp) {
+			init_waitqueue_head(&rnp->node_wq);
+			rcu_init_boost_waitqueue(rnp);
+			(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
+		}
+	return 0;
+}
+early_initcall(rcu_spawn_kthreads);
+
 static void
 __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	   struct rcu_state *rsp)
@@ -1439,6 +1843,13 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	/* Add the callback to our list. */
 	*rdp->nxttail[RCU_NEXT_TAIL] = head;
 	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
+	rdp->qlen++;
+
+	/* If interrupts were disabled, don't dive into RCU core. */
+	if (irqs_disabled_flags(flags)) {
+		local_irq_restore(flags);
+		return;
+	}
 
 	/*
 	 * Force the grace period if too many callbacks or too long waiting.
@@ -1447,7 +1858,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	 * invoking force_quiescent_state() if the newly enqueued callback
 	 * is the only one waiting for a grace period to complete.
 	 */
-	if (unlikely(++rdp->qlen > rdp->qlen_last_fqs_check + qhimark)) {
+	if (unlikely(rdp->qlen > rdp->qlen_last_fqs_check + qhimark)) {
 
 		/* Are we ignoring a completed grace period? */
 		rcu_process_gp_end(rsp, rdp);
@@ -1583,7 +1994,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 		 * or RCU-bh, force a local reschedule.
 		 */
 		rdp->n_rp_qs_pending++;
-		if (!rdp->preemptable &&
+		if (!rdp->preemptible &&
 		    ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs) - 1,
 				 jiffies))
 			set_need_resched();
@@ -1760,7 +2171,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
  * that this CPU cannot possibly have any RCU callbacks in flight yet.
  */
 static void __cpuinit
-rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
+rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 {
 	unsigned long flags;
 	unsigned long mask;
@@ -1772,7 +2183,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
 	rdp->passed_quiesc = 0;  /* We could be racing with new GP, */
 	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
 	rdp->beenonline = 1;	 /* We have now been online. */
-	rdp->preemptable = preemptable;
+	rdp->preemptible = preemptible;
 	rdp->qlen_last_fqs_check = 0;
 	rdp->n_force_qs_snap = rsp->n_force_qs;
 	rdp->blimit = blimit;
@@ -1813,6 +2224,19 @@ static void __cpuinit rcu_online_cpu(int cpu)
 	rcu_preempt_init_percpu_data(cpu);
 }
 
+static void __cpuinit rcu_online_kthreads(int cpu)
+{
+	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
+	struct rcu_node *rnp = rdp->mynode;
+
+	/* Fire up the incoming CPU's kthread and leaf rcu_node kthread. */
+	if (rcu_kthreads_spawnable) {
+		(void)rcu_spawn_one_cpu_kthread(cpu);
+		if (rnp->node_kthread_task == NULL)
+			(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
+	}
+}
+
 /*
  * Handle CPU online/offline notification events.
  */
@@ -1820,11 +2244,23 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 				    unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
+	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
+	struct rcu_node *rnp = rdp->mynode;
 
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
 		rcu_online_cpu(cpu);
+		rcu_online_kthreads(cpu);
+		break;
+	case CPU_ONLINE:
+	case CPU_DOWN_FAILED:
+		rcu_node_kthread_setaffinity(rnp, -1);
+		rcu_cpu_kthread_setrt(cpu, 1);
+		break;
+	case CPU_DOWN_PREPARE:
+		rcu_node_kthread_setaffinity(rnp, cpu);
+		rcu_cpu_kthread_setrt(cpu, 0);
 		break;
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
@@ -1943,10 +2379,7 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 					      j / rsp->levelspread[i - 1];
 			}
 			rnp->level = i;
-			INIT_LIST_HEAD(&rnp->blocked_tasks[0]);
-			INIT_LIST_HEAD(&rnp->blocked_tasks[1]);
-			INIT_LIST_HEAD(&rnp->blocked_tasks[2]);
-			INIT_LIST_HEAD(&rnp->blocked_tasks[3]);
+			INIT_LIST_HEAD(&rnp->blkd_tasks);
 		}
 	}
 
@@ -1968,7 +2401,6 @@ void __init rcu_init(void)
 	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
 	__rcu_init_preempt();
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 
 	/*
 	 * We don't need protection against CPU-hotplug here because
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index e8f057e..2576648 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -91,6 +91,14 @@ struct rcu_dynticks {
 				/*  remains even for nmi from irq handler. */
 };
 
+/* RCU's kthread states for tracing. */
+#define RCU_KTHREAD_STOPPED  0
+#define RCU_KTHREAD_RUNNING  1
+#define RCU_KTHREAD_WAITING  2
+#define RCU_KTHREAD_OFFCPU   3
+#define RCU_KTHREAD_YIELDING 4
+#define RCU_KTHREAD_MAX      4
+
 /*
  * Definition for node within the RCU grace-period-detection hierarchy.
  */
@@ -109,10 +117,11 @@ struct rcu_node {
 				/*  an rcu_data structure, otherwise, each */
 				/*  bit corresponds to a child rcu_node */
 				/*  structure. */
-	unsigned long expmask;	/* Groups that have ->blocked_tasks[] */
+	unsigned long expmask;	/* Groups that have ->blkd_tasks */
 				/*  elements that need to drain to allow the */
 				/*  current expedited grace period to */
 				/*  complete (only for TREE_PREEMPT_RCU). */
+	unsigned long wakemask; /* CPUs whose kthread needs to be awakened. */
 	unsigned long qsmaskinit;
 				/* Per-GP initial value for qsmask & expmask. */
 	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
@@ -122,11 +131,68 @@ struct rcu_node {
 	u8	grpnum;		/* CPU/group number for next level up. */
 	u8	level;		/* root is at level 0. */
 	struct rcu_node *parent;
-	struct list_head blocked_tasks[4];
-				/* Tasks blocked in RCU read-side critsect. */
-				/*  Grace period number (->gpnum) x blocked */
-				/*  by tasks on the (x & 0x1) element of the */
-				/*  blocked_tasks[] array. */
+	struct list_head blkd_tasks;
+				/* Tasks blocked in RCU read-side critical */
+				/*  section.  Tasks are placed at the head */
+				/*  of this list and age towards the tail. */
+	struct list_head *gp_tasks;
+				/* Pointer to the first task blocking the */
+				/*  current grace period, or NULL if there */
+				/*  is no such task. */
+	struct list_head *exp_tasks;
+				/* Pointer to the first task blocking the */
+				/*  current expedited grace period, or NULL */
+				/*  if there is no such task.  If there */
+				/*  is no current expedited grace period, */
+				/*  then there can cannot be any such task. */
+#ifdef CONFIG_RCU_BOOST
+	struct list_head *boost_tasks;
+				/* Pointer to first task that needs to be */
+				/*  priority boosted, or NULL if no priority */
+				/*  boosting is needed for this rcu_node */
+				/*  structure.  If there are no tasks */
+				/*  queued on this rcu_node structure that */
+				/*  are blocking the current grace period, */
+				/*  there can be no such task. */
+	unsigned long boost_time;
+				/* When to start boosting (jiffies). */
+	struct task_struct *boost_kthread_task;
+				/* kthread that takes care of priority */
+				/*  boosting for this rcu_node structure. */
+	wait_queue_head_t boost_wq;
+				/* Wait queue on which to park the boost */
+				/*  kthread. */
+	unsigned int boost_kthread_status;
+				/* State of boost_kthread_task for tracing. */
+	unsigned long n_tasks_boosted;
+				/* Total number of tasks boosted. */
+	unsigned long n_exp_boosts;
+				/* Number of tasks boosted for expedited GP. */
+	unsigned long n_normal_boosts;
+				/* Number of tasks boosted for normal GP. */
+	unsigned long n_balk_blkd_tasks;
+				/* Refused to boost: no blocked tasks. */
+	unsigned long n_balk_exp_gp_tasks;
+				/* Refused to boost: nothing blocking GP. */
+	unsigned long n_balk_boost_tasks;
+				/* Refused to boost: already boosting. */
+	unsigned long n_balk_notblocked;
+				/* Refused to boost: RCU RS CS still running. */
+	unsigned long n_balk_notyet;
+				/* Refused to boost: not yet time. */
+	unsigned long n_balk_nos;
+				/* Refused to boost: not sure why, though. */
+				/*  This can happen due to race conditions. */
+#endif /* #ifdef CONFIG_RCU_BOOST */
+	struct task_struct *node_kthread_task;
+				/* kthread that takes care of this rcu_node */
+				/*  structure, for example, awakening the */
+				/*  per-CPU kthreads as needed. */
+	wait_queue_head_t node_wq;
+				/* Wait queue on which to park the per-node */
+				/*  kthread. */
+	unsigned int node_kthread_status;
+				/* State of node_kthread_task for tracing. */
 } ____cacheline_internodealigned_in_smp;
 
 /*
@@ -175,7 +241,7 @@ struct rcu_data {
 	bool		passed_quiesc;	/* User-mode/idle loop etc. */
 	bool		qs_pending;	/* Core waits for quiesc state. */
 	bool		beenonline;	/* CPU online at least once. */
-	bool		preemptable;	/* Preemptable RCU? */
+	bool		preemptible;	/* Preemptible RCU? */
 	struct rcu_node *mynode;	/* This CPU's leaf of hierarchy */
 	unsigned long grpmask;		/* Mask to apply to leaf qsmask. */
 
@@ -254,7 +320,6 @@ struct rcu_data {
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
 #define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 
 #ifdef CONFIG_PROVE_RCU
 #define RCU_STALL_DELAY_DELTA	       (5 * HZ)
@@ -272,13 +337,6 @@ struct rcu_data {
 						/*  scheduling clock irq */
 						/*  before ratting on them. */
 
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE
-#define RCU_CPU_STALL_SUPPRESS_INIT 0
-#else
-#define RCU_CPU_STALL_SUPPRESS_INIT 1
-#endif
-
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /*
  * RCU global state, including node hierarchy.  This hierarchy is
@@ -325,12 +383,12 @@ struct rcu_state {
 						/*  due to lock unavailable. */
 	unsigned long n_force_qs_ngp;		/* Number of calls leaving */
 						/*  due to no GP active. */
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 	unsigned long gp_start;			/* Time at which GP started, */
 						/*  but in jiffies. */
 	unsigned long jiffies_stall;		/* Time at which to check */
 						/*  for CPU stalls. */
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+	unsigned long gp_max;			/* Maximum GP duration in */
+						/*  jiffies. */
 	char *name;				/* Name of structure. */
 };
 
@@ -361,16 +419,14 @@ DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
 static void rcu_bootup_announce(void);
 long rcu_batches_completed(void);
 static void rcu_preempt_note_context_switch(int cpu);
-static int rcu_preempted_readers(struct rcu_node *rnp);
+static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
 				      unsigned long flags);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 static void rcu_print_detail_task_stall(struct rcu_state *rsp);
 static void rcu_print_task_stall(struct rcu_node *rnp);
 static void rcu_preempt_stall_reset(void);
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
 static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
@@ -390,5 +446,13 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
 static void rcu_preempt_send_cbs_to_online(void);
 static void __init __rcu_init_preempt(void);
 static void rcu_needs_cpu_flush(void);
+static void __init rcu_init_boost_waitqueue(struct rcu_node *rnp);
+static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
+static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
+					  cpumask_var_t cm);
+static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
+static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
+						 struct rcu_node *rnp,
+						 int rnp_index);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index a363871..3f6559a 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1,7 +1,7 @@
 /*
  * Read-Copy Update mechanism for mutual exclusion (tree-based version)
  * Internal non-public definitions that provide either classic
- * or preemptable semantics.
+ * or preemptible semantics.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -54,10 +54,6 @@ static void __init rcu_bootup_announce_oddness(void)
 #ifdef CONFIG_RCU_TORTURE_TEST_RUNNABLE
 	printk(KERN_INFO "\tRCU torture testing starts during boot.\n");
 #endif
-#ifndef CONFIG_RCU_CPU_STALL_DETECTOR
-	printk(KERN_INFO
-	       "\tRCU-based detection of stalled CPUs is disabled.\n");
-#endif
 #if defined(CONFIG_TREE_PREEMPT_RCU) && !defined(CONFIG_RCU_CPU_STALL_VERBOSE)
 	printk(KERN_INFO "\tVerbose stalled-CPUs detection is disabled.\n");
 #endif
@@ -70,6 +66,7 @@ static void __init rcu_bootup_announce_oddness(void)
 
 struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
+static struct rcu_state *rcu_state = &rcu_preempt_state;
 
 static int rcu_preempted_readers_exp(struct rcu_node *rnp);
 
@@ -78,7 +75,7 @@ static int rcu_preempted_readers_exp(struct rcu_node *rnp);
  */
 static void __init rcu_bootup_announce(void)
 {
-	printk(KERN_INFO "Preemptable hierarchical RCU implementation.\n");
+	printk(KERN_INFO "Preemptible hierarchical RCU implementation.\n");
 	rcu_bootup_announce_oddness();
 }
 
@@ -111,7 +108,7 @@ void rcu_force_quiescent_state(void)
 EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
 
 /*
- * Record a preemptable-RCU quiescent state for the specified CPU.  Note
+ * Record a preemptible-RCU quiescent state for the specified CPU.  Note
  * that this just means that the task currently running on the CPU is
  * not in a quiescent state.  There might be any number of tasks blocked
  * while in an RCU read-side critical section.
@@ -134,12 +131,12 @@ static void rcu_preempt_qs(int cpu)
  * We have entered the scheduler, and the current task might soon be
  * context-switched away from.  If this task is in an RCU read-side
  * critical section, we will no longer be able to rely on the CPU to
- * record that fact, so we enqueue the task on the appropriate entry
- * of the blocked_tasks[] array.  The task will dequeue itself when
- * it exits the outermost enclosing RCU read-side critical section.
- * Therefore, the current grace period cannot be permitted to complete
- * until the blocked_tasks[] entry indexed by the low-order bit of
- * rnp->gpnum empties.
+ * record that fact, so we enqueue the task on the blkd_tasks list.
+ * The task will dequeue itself when it exits the outermost enclosing
+ * RCU read-side critical section.  Therefore, the current grace period
+ * cannot be permitted to complete until the blkd_tasks list entries
+ * predating the current grace period drain, in other words, until
+ * rnp->gp_tasks becomes NULL.
  *
  * Caller must disable preemption.
  */
@@ -147,7 +144,6 @@ static void rcu_preempt_note_context_switch(int cpu)
 {
 	struct task_struct *t = current;
 	unsigned long flags;
-	int phase;
 	struct rcu_data *rdp;
 	struct rcu_node *rnp;
 
@@ -169,15 +165,30 @@ static void rcu_preempt_note_context_switch(int cpu)
 		 * (i.e., this CPU has not yet passed through a quiescent
 		 * state for the current grace period), then as long
 		 * as that task remains queued, the current grace period
-		 * cannot end.
+		 * cannot end.  Note that there is some uncertainty as
+		 * to exactly when the current grace period started.
+		 * We take a conservative approach, which can result
+		 * in unnecessarily waiting on tasks that started very
+		 * slightly after the current grace period began.  C'est
+		 * la vie!!!
 		 *
 		 * But first, note that the current CPU must still be
 		 * on line!
 		 */
 		WARN_ON_ONCE((rdp->grpmask & rnp->qsmaskinit) == 0);
 		WARN_ON_ONCE(!list_empty(&t->rcu_node_entry));
-		phase = (rnp->gpnum + !(rnp->qsmask & rdp->grpmask)) & 0x1;
-		list_add(&t->rcu_node_entry, &rnp->blocked_tasks[phase]);
+		if ((rnp->qsmask & rdp->grpmask) && rnp->gp_tasks != NULL) {
+			list_add(&t->rcu_node_entry, rnp->gp_tasks->prev);
+			rnp->gp_tasks = &t->rcu_node_entry;
+#ifdef CONFIG_RCU_BOOST
+			if (rnp->boost_tasks != NULL)
+				rnp->boost_tasks = rnp->gp_tasks;
+#endif /* #ifdef CONFIG_RCU_BOOST */
+		} else {
+			list_add(&t->rcu_node_entry, &rnp->blkd_tasks);
+			if (rnp->qsmask & rdp->grpmask)
+				rnp->gp_tasks = &t->rcu_node_entry;
+		}
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 
@@ -196,7 +207,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 }
 
 /*
- * Tree-preemptable RCU implementation for rcu_read_lock().
+ * Tree-preemptible RCU implementation for rcu_read_lock().
  * Just increment ->rcu_read_lock_nesting, shared state will be updated
  * if we block.
  */
@@ -212,12 +223,9 @@ EXPORT_SYMBOL_GPL(__rcu_read_lock);
  * for the specified rcu_node structure.  If the caller needs a reliable
  * answer, it must hold the rcu_node's ->lock.
  */
-static int rcu_preempted_readers(struct rcu_node *rnp)
+static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp)
 {
-	int phase = rnp->gpnum & 0x1;
-
-	return !list_empty(&rnp->blocked_tasks[phase]) ||
-	       !list_empty(&rnp->blocked_tasks[phase + 2]);
+	return rnp->gp_tasks != NULL;
 }
 
 /*
@@ -233,7 +241,7 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 	unsigned long mask;
 	struct rcu_node *rnp_p;
 
-	if (rnp->qsmask != 0 || rcu_preempted_readers(rnp)) {
+	if (rnp->qsmask != 0 || rcu_preempt_blocked_readers_cgp(rnp)) {
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;  /* Still need more quiescent states! */
 	}
@@ -257,6 +265,21 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 }
 
 /*
+ * Advance a ->blkd_tasks-list pointer to the next entry, instead
+ * returning NULL if at the end of the list.
+ */
+static struct list_head *rcu_next_node_entry(struct task_struct *t,
+					     struct rcu_node *rnp)
+{
+	struct list_head *np;
+
+	np = t->rcu_node_entry.next;
+	if (np == &rnp->blkd_tasks)
+		np = NULL;
+	return np;
+}
+
+/*
  * Handle special cases during rcu_read_unlock(), such as needing to
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
@@ -266,6 +289,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 	int empty;
 	int empty_exp;
 	unsigned long flags;
+	struct list_head *np;
 	struct rcu_node *rnp;
 	int special;
 
@@ -306,10 +330,19 @@ static void rcu_read_unlock_special(struct task_struct *t)
 				break;
 			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 		}
-		empty = !rcu_preempted_readers(rnp);
+		empty = !rcu_preempt_blocked_readers_cgp(rnp);
 		empty_exp = !rcu_preempted_readers_exp(rnp);
 		smp_mb(); /* ensure expedited fastpath sees end of RCU c-s. */
+		np = rcu_next_node_entry(t, rnp);
 		list_del_init(&t->rcu_node_entry);
+		if (&t->rcu_node_entry == rnp->gp_tasks)
+			rnp->gp_tasks = np;
+		if (&t->rcu_node_entry == rnp->exp_tasks)
+			rnp->exp_tasks = np;
+#ifdef CONFIG_RCU_BOOST
+		if (&t->rcu_node_entry == rnp->boost_tasks)
+			rnp->boost_tasks = np;
+#endif /* #ifdef CONFIG_RCU_BOOST */
 		t->rcu_blocked_node = NULL;
 
 		/*
@@ -322,6 +355,15 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		else
 			rcu_report_unblock_qs_rnp(rnp, flags);
 
+#ifdef CONFIG_RCU_BOOST
+		/* Unboost if we were boosted. */
+		if (special & RCU_READ_UNLOCK_BOOSTED) {
+			t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BOOSTED;
+			rt_mutex_unlock(t->rcu_boost_mutex);
+			t->rcu_boost_mutex = NULL;
+		}
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
 		/*
 		 * If this was the last task on the expedited lists,
 		 * then we need to report up the rcu_node hierarchy.
@@ -334,7 +376,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 }
 
 /*
- * Tree-preemptable RCU implementation for rcu_read_unlock().
+ * Tree-preemptible RCU implementation for rcu_read_unlock().
  * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
  * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
  * invoke rcu_read_unlock_special() to clean up after a context switch
@@ -356,8 +398,6 @@ void __rcu_read_unlock(void)
 }
 EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-
 #ifdef CONFIG_RCU_CPU_STALL_VERBOSE
 
 /*
@@ -367,18 +407,16 @@ EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 static void rcu_print_detail_task_stall_rnp(struct rcu_node *rnp)
 {
 	unsigned long flags;
-	struct list_head *lp;
-	int phase;
 	struct task_struct *t;
 
-	if (rcu_preempted_readers(rnp)) {
-		raw_spin_lock_irqsave(&rnp->lock, flags);
-		phase = rnp->gpnum & 0x1;
-		lp = &rnp->blocked_tasks[phase];
-		list_for_each_entry(t, lp, rcu_node_entry)
-			sched_show_task(t);
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	}
+	if (!rcu_preempt_blocked_readers_cgp(rnp))
+		return;
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	t = list_entry(rnp->gp_tasks,
+		       struct task_struct, rcu_node_entry);
+	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry)
+		sched_show_task(t);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
@@ -408,16 +446,14 @@ static void rcu_print_detail_task_stall(struct rcu_state *rsp)
  */
 static void rcu_print_task_stall(struct rcu_node *rnp)
 {
-	struct list_head *lp;
-	int phase;
 	struct task_struct *t;
 
-	if (rcu_preempted_readers(rnp)) {
-		phase = rnp->gpnum & 0x1;
-		lp = &rnp->blocked_tasks[phase];
-		list_for_each_entry(t, lp, rcu_node_entry)
-			printk(" P%d", t->pid);
-	}
+	if (!rcu_preempt_blocked_readers_cgp(rnp))
+		return;
+	t = list_entry(rnp->gp_tasks,
+		       struct task_struct, rcu_node_entry);
+	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry)
+		printk(" P%d", t->pid);
 }
 
 /*
@@ -430,18 +466,21 @@ static void rcu_preempt_stall_reset(void)
 	rcu_preempt_state.jiffies_stall = jiffies + ULONG_MAX / 2;
 }
 
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
 /*
  * Check that the list of blocked tasks for the newly completed grace
  * period is in fact empty.  It is a serious bug to complete a grace
  * period that still has RCU readers blocked!  This function must be
  * invoked -before- updating this rnp's ->gpnum, and the rnp's ->lock
  * must be held by the caller.
+ *
+ * Also, if there are blocked tasks on the list, they automatically
+ * block the newly created grace period, so set up ->gp_tasks accordingly.
  */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
 {
-	WARN_ON_ONCE(rcu_preempted_readers(rnp));
+	WARN_ON_ONCE(rcu_preempt_blocked_readers_cgp(rnp));
+	if (!list_empty(&rnp->blkd_tasks))
+		rnp->gp_tasks = rnp->blkd_tasks.next;
 	WARN_ON_ONCE(rnp->qsmask);
 }
 
@@ -465,50 +504,68 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 				     struct rcu_node *rnp,
 				     struct rcu_data *rdp)
 {
-	int i;
 	struct list_head *lp;
 	struct list_head *lp_root;
 	int retval = 0;
 	struct rcu_node *rnp_root = rcu_get_root(rsp);
-	struct task_struct *tp;
+	struct task_struct *t;
 
 	if (rnp == rnp_root) {
 		WARN_ONCE(1, "Last CPU thought to be offlined?");
 		return 0;  /* Shouldn't happen: at least one CPU online. */
 	}
-	WARN_ON_ONCE(rnp != rdp->mynode &&
-		     (!list_empty(&rnp->blocked_tasks[0]) ||
-		      !list_empty(&rnp->blocked_tasks[1]) ||
-		      !list_empty(&rnp->blocked_tasks[2]) ||
-		      !list_empty(&rnp->blocked_tasks[3])));
+
+	/* If we are on an internal node, complain bitterly. */
+	WARN_ON_ONCE(rnp != rdp->mynode);
 
 	/*
-	 * Move tasks up to root rcu_node.  Rely on the fact that the
-	 * root rcu_node can be at most one ahead of the rest of the
-	 * rcu_nodes in terms of gp_num value.  This fact allows us to
-	 * move the blocked_tasks[] array directly, element by element.
+	 * Move tasks up to root rcu_node.  Don't try to get fancy for
+	 * this corner-case operation -- just put this node's tasks
+	 * at the head of the root node's list, and update the root node's
+	 * ->gp_tasks and ->exp_tasks pointers to those of this node's,
+	 * if non-NULL.  This might result in waiting for more tasks than
+	 * absolutely necessary, but this is a good performance/complexity
+	 * tradeoff.
 	 */
-	if (rcu_preempted_readers(rnp))
+	if (rcu_preempt_blocked_readers_cgp(rnp))
 		retval |= RCU_OFL_TASKS_NORM_GP;
 	if (rcu_preempted_readers_exp(rnp))
 		retval |= RCU_OFL_TASKS_EXP_GP;
-	for (i = 0; i < 4; i++) {
-		lp = &rnp->blocked_tasks[i];
-		lp_root = &rnp_root->blocked_tasks[i];
-		while (!list_empty(lp)) {
-			tp = list_entry(lp->next, typeof(*tp), rcu_node_entry);
-			raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
-			list_del(&tp->rcu_node_entry);
-			tp->rcu_blocked_node = rnp_root;
-			list_add(&tp->rcu_node_entry, lp_root);
-			raw_spin_unlock(&rnp_root->lock); /* irqs remain disabled */
-		}
+	lp = &rnp->blkd_tasks;
+	lp_root = &rnp_root->blkd_tasks;
+	while (!list_empty(lp)) {
+		t = list_entry(lp->next, typeof(*t), rcu_node_entry);
+		raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
+		list_del(&t->rcu_node_entry);
+		t->rcu_blocked_node = rnp_root;
+		list_add(&t->rcu_node_entry, lp_root);
+		if (&t->rcu_node_entry == rnp->gp_tasks)
+			rnp_root->gp_tasks = rnp->gp_tasks;
+		if (&t->rcu_node_entry == rnp->exp_tasks)
+			rnp_root->exp_tasks = rnp->exp_tasks;
+#ifdef CONFIG_RCU_BOOST
+		if (&t->rcu_node_entry == rnp->boost_tasks)
+			rnp_root->boost_tasks = rnp->boost_tasks;
+#endif /* #ifdef CONFIG_RCU_BOOST */
+		raw_spin_unlock(&rnp_root->lock); /* irqs still disabled */
 	}
+
+#ifdef CONFIG_RCU_BOOST
+	/* In case root is being boosted and leaf is not. */
+	raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
+	if (rnp_root->boost_tasks != NULL &&
+	    rnp_root->boost_tasks != rnp_root->gp_tasks)
+		rnp_root->boost_tasks = rnp_root->gp_tasks;
+	raw_spin_unlock(&rnp_root->lock); /* irqs still disabled */
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
+	rnp->gp_tasks = NULL;
+	rnp->exp_tasks = NULL;
 	return retval;
 }
 
 /*
- * Do CPU-offline processing for preemptable RCU.
+ * Do CPU-offline processing for preemptible RCU.
  */
 static void rcu_preempt_offline_cpu(int cpu)
 {
@@ -537,7 +594,7 @@ static void rcu_preempt_check_callbacks(int cpu)
 }
 
 /*
- * Process callbacks for preemptable RCU.
+ * Process callbacks for preemptible RCU.
  */
 static void rcu_preempt_process_callbacks(void)
 {
@@ -546,7 +603,7 @@ static void rcu_preempt_process_callbacks(void)
 }
 
 /*
- * Queue a preemptable-RCU callback for invocation after a grace period.
+ * Queue a preemptible-RCU callback for invocation after a grace period.
  */
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 {
@@ -594,8 +651,7 @@ static DEFINE_MUTEX(sync_rcu_preempt_exp_mutex);
  */
 static int rcu_preempted_readers_exp(struct rcu_node *rnp)
 {
-	return !list_empty(&rnp->blocked_tasks[2]) ||
-	       !list_empty(&rnp->blocked_tasks[3]);
+	return rnp->exp_tasks != NULL;
 }
 
 /*
@@ -655,13 +711,17 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 static void
 sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
 {
-	int must_wait;
+	unsigned long flags;
+	int must_wait = 0;
 
-	raw_spin_lock(&rnp->lock); /* irqs already disabled */
-	list_splice_init(&rnp->blocked_tasks[0], &rnp->blocked_tasks[2]);
-	list_splice_init(&rnp->blocked_tasks[1], &rnp->blocked_tasks[3]);
-	must_wait = rcu_preempted_readers_exp(rnp);
-	raw_spin_unlock(&rnp->lock); /* irqs remain disabled */
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	if (list_empty(&rnp->blkd_tasks))
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	else {
+		rnp->exp_tasks = rnp->blkd_tasks.next;
+		rcu_initiate_boost(rnp, flags);  /* releases rnp->lock */
+		must_wait = 1;
+	}
 	if (!must_wait)
 		rcu_report_exp_rnp(rsp, rnp);
 }
@@ -669,9 +729,7 @@ sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
 /*
  * Wait for an rcu-preempt grace period, but expedite it.  The basic idea
  * is to invoke synchronize_sched_expedited() to push all the tasks to
- * the ->blocked_tasks[] lists, move all entries from the first set of
- * ->blocked_tasks[] lists to the second set, and finally wait for this
- * second set to drain.
+ * the ->blkd_tasks lists and wait for this list to drain.
  */
 void synchronize_rcu_expedited(void)
 {
@@ -703,7 +761,7 @@ void synchronize_rcu_expedited(void)
 	if ((ACCESS_ONCE(sync_rcu_preempt_exp_count) - snap) > 0)
 		goto unlock_mb_ret; /* Others did our work for us. */
 
-	/* force all RCU readers onto blocked_tasks[]. */
+	/* force all RCU readers onto ->blkd_tasks lists. */
 	synchronize_sched_expedited();
 
 	raw_spin_lock_irqsave(&rsp->onofflock, flags);
@@ -715,7 +773,7 @@ void synchronize_rcu_expedited(void)
 		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 	}
 
-	/* Snapshot current state of ->blocked_tasks[] lists. */
+	/* Snapshot current state of ->blkd_tasks lists. */
 	rcu_for_each_leaf_node(rsp, rnp)
 		sync_rcu_preempt_exp_init(rsp, rnp);
 	if (NUM_RCU_NODES > 1)
@@ -723,7 +781,7 @@ void synchronize_rcu_expedited(void)
 
 	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 
-	/* Wait for snapshotted ->blocked_tasks[] lists to drain. */
+	/* Wait for snapshotted ->blkd_tasks lists to drain. */
 	rnp = rcu_get_root(rsp);
 	wait_event(sync_rcu_preempt_exp_wq,
 		   sync_rcu_preempt_exp_done(rnp));
@@ -739,7 +797,7 @@ mb_ret:
 EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
 
 /*
- * Check to see if there is any immediate preemptable-RCU-related work
+ * Check to see if there is any immediate preemptible-RCU-related work
  * to be done.
  */
 static int rcu_preempt_pending(int cpu)
@@ -749,7 +807,7 @@ static int rcu_preempt_pending(int cpu)
 }
 
 /*
- * Does preemptable RCU need the CPU to stay out of dynticks mode?
+ * Does preemptible RCU need the CPU to stay out of dynticks mode?
  */
 static int rcu_preempt_needs_cpu(int cpu)
 {
@@ -766,7 +824,7 @@ void rcu_barrier(void)
 EXPORT_SYMBOL_GPL(rcu_barrier);
 
 /*
- * Initialize preemptable RCU's per-CPU data.
+ * Initialize preemptible RCU's per-CPU data.
  */
 static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 {
@@ -774,7 +832,7 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 }
 
 /*
- * Move preemptable RCU's callbacks from dying CPU to other online CPU.
+ * Move preemptible RCU's callbacks from dying CPU to other online CPU.
  */
 static void rcu_preempt_send_cbs_to_online(void)
 {
@@ -782,7 +840,7 @@ static void rcu_preempt_send_cbs_to_online(void)
 }
 
 /*
- * Initialize preemptable RCU's state structures.
+ * Initialize preemptible RCU's state structures.
  */
 static void __init __rcu_init_preempt(void)
 {
@@ -790,7 +848,7 @@ static void __init __rcu_init_preempt(void)
 }
 
 /*
- * Check for a task exiting while in a preemptable-RCU read-side
+ * Check for a task exiting while in a preemptible-RCU read-side
  * critical section, clean up if so.  No need to issue warnings,
  * as debug_check_no_locks_held() already does this if lockdep
  * is enabled.
@@ -802,11 +860,13 @@ void exit_rcu(void)
 	if (t->rcu_read_lock_nesting == 0)
 		return;
 	t->rcu_read_lock_nesting = 1;
-	rcu_read_unlock();
+	__rcu_read_unlock();
 }
 
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
+static struct rcu_state *rcu_state = &rcu_sched_state;
+
 /*
  * Tell them what RCU they are running.
  */
@@ -836,7 +896,7 @@ void rcu_force_quiescent_state(void)
 EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
 
 /*
- * Because preemptable RCU does not exist, we never have to check for
+ * Because preemptible RCU does not exist, we never have to check for
  * CPUs being in quiescent states.
  */
 static void rcu_preempt_note_context_switch(int cpu)
@@ -844,10 +904,10 @@ static void rcu_preempt_note_context_switch(int cpu)
 }
 
 /*
- * Because preemptable RCU does not exist, there are never any preempted
+ * Because preemptible RCU does not exist, there are never any preempted
  * RCU readers.
  */
-static int rcu_preempted_readers(struct rcu_node *rnp)
+static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp)
 {
 	return 0;
 }
@@ -862,10 +922,8 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-
 /*
- * Because preemptable RCU does not exist, we never have to check for
+ * Because preemptible RCU does not exist, we never have to check for
  * tasks blocked within RCU read-side critical sections.
  */
 static void rcu_print_detail_task_stall(struct rcu_state *rsp)
@@ -873,7 +931,7 @@ static void rcu_print_detail_task_stall(struct rcu_state *rsp)
 }
 
 /*
- * Because preemptable RCU does not exist, we never have to check for
+ * Because preemptible RCU does not exist, we never have to check for
  * tasks blocked within RCU read-side critical sections.
  */
 static void rcu_print_task_stall(struct rcu_node *rnp)
@@ -888,10 +946,8 @@ static void rcu_preempt_stall_reset(void)
 {
 }
 
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
 /*
- * Because there is no preemptable RCU, there can be no readers blocked,
+ * Because there is no preemptible RCU, there can be no readers blocked,
  * so there is no need to check for blocked tasks.  So check only for
  * bogus qsmask values.
  */
@@ -903,7 +959,7 @@ static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
 #ifdef CONFIG_HOTPLUG_CPU
 
 /*
- * Because preemptable RCU does not exist, it never needs to migrate
+ * Because preemptible RCU does not exist, it never needs to migrate
  * tasks that were blocked within RCU read-side critical sections, and
  * such non-existent tasks cannot possibly have been blocking the current
  * grace period.
@@ -916,7 +972,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 }
 
 /*
- * Because preemptable RCU does not exist, it never needs CPU-offline
+ * Because preemptible RCU does not exist, it never needs CPU-offline
  * processing.
  */
 static void rcu_preempt_offline_cpu(int cpu)
@@ -926,7 +982,7 @@ static void rcu_preempt_offline_cpu(int cpu)
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
 /*
- * Because preemptable RCU does not exist, it never has any callbacks
+ * Because preemptible RCU does not exist, it never has any callbacks
  * to check.
  */
 static void rcu_preempt_check_callbacks(int cpu)
@@ -934,7 +990,7 @@ static void rcu_preempt_check_callbacks(int cpu)
 }
 
 /*
- * Because preemptable RCU does not exist, it never has any callbacks
+ * Because preemptible RCU does not exist, it never has any callbacks
  * to process.
  */
 static void rcu_preempt_process_callbacks(void)
@@ -943,7 +999,7 @@ static void rcu_preempt_process_callbacks(void)
 
 /*
  * Wait for an rcu-preempt grace period, but make it happen quickly.
- * But because preemptable RCU does not exist, map to rcu-sched.
+ * But because preemptible RCU does not exist, map to rcu-sched.
  */
 void synchronize_rcu_expedited(void)
 {
@@ -954,7 +1010,7 @@ EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
 #ifdef CONFIG_HOTPLUG_CPU
 
 /*
- * Because preemptable RCU does not exist, there is never any need to
+ * Because preemptible RCU does not exist, there is never any need to
  * report on tasks preempted in RCU read-side critical sections during
  * expedited RCU grace periods.
  */
@@ -966,7 +1022,7 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
 /*
- * Because preemptable RCU does not exist, it never has any work to do.
+ * Because preemptible RCU does not exist, it never has any work to do.
  */
 static int rcu_preempt_pending(int cpu)
 {
@@ -974,7 +1030,7 @@ static int rcu_preempt_pending(int cpu)
 }
 
 /*
- * Because preemptable RCU does not exist, it never needs any CPU.
+ * Because preemptible RCU does not exist, it never needs any CPU.
  */
 static int rcu_preempt_needs_cpu(int cpu)
 {
@@ -982,7 +1038,7 @@ static int rcu_preempt_needs_cpu(int cpu)
 }
 
 /*
- * Because preemptable RCU does not exist, rcu_barrier() is just
+ * Because preemptible RCU does not exist, rcu_barrier() is just
  * another name for rcu_barrier_sched().
  */
 void rcu_barrier(void)
@@ -992,7 +1048,7 @@ void rcu_barrier(void)
 EXPORT_SYMBOL_GPL(rcu_barrier);
 
 /*
- * Because preemptable RCU does not exist, there is no per-CPU
+ * Because preemptible RCU does not exist, there is no per-CPU
  * data to initialize.
  */
 static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
@@ -1000,14 +1056,14 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 }
 
 /*
- * Because there is no preemptable RCU, there are no callbacks to move.
+ * Because there is no preemptible RCU, there are no callbacks to move.
  */
 static void rcu_preempt_send_cbs_to_online(void)
 {
 }
 
 /*
- * Because preemptable RCU does not exist, it need not be initialized.
+ * Because preemptible RCU does not exist, it need not be initialized.
  */
 static void __init __rcu_init_preempt(void)
 {
@@ -1015,6 +1071,276 @@ static void __init __rcu_init_preempt(void)
 
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
+#ifdef CONFIG_RCU_BOOST
+
+#include "rtmutex_common.h"
+
+#ifdef CONFIG_RCU_TRACE
+
+static void rcu_initiate_boost_trace(struct rcu_node *rnp)
+{
+	if (list_empty(&rnp->blkd_tasks))
+		rnp->n_balk_blkd_tasks++;
+	else if (rnp->exp_tasks == NULL && rnp->gp_tasks == NULL)
+		rnp->n_balk_exp_gp_tasks++;
+	else if (rnp->gp_tasks != NULL && rnp->boost_tasks != NULL)
+		rnp->n_balk_boost_tasks++;
+	else if (rnp->gp_tasks != NULL && rnp->qsmask != 0)
+		rnp->n_balk_notblocked++;
+	else if (rnp->gp_tasks != NULL &&
+		 ULONG_CMP_LT(jiffies, rnp->boost_time))
+		rnp->n_balk_notyet++;
+	else
+		rnp->n_balk_nos++;
+}
+
+#else /* #ifdef CONFIG_RCU_TRACE */
+
+static void rcu_initiate_boost_trace(struct rcu_node *rnp)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_TRACE */
+
+/*
+ * Carry out RCU priority boosting on the task indicated by ->exp_tasks
+ * or ->boost_tasks, advancing the pointer to the next task in the
+ * ->blkd_tasks list.
+ *
+ * Note that irqs must be enabled: boosting the task can block.
+ * Returns 1 if there are more tasks needing to be boosted.
+ */
+static int rcu_boost(struct rcu_node *rnp)
+{
+	unsigned long flags;
+	struct rt_mutex mtx;
+	struct task_struct *t;
+	struct list_head *tb;
+
+	if (rnp->exp_tasks == NULL && rnp->boost_tasks == NULL)
+		return 0;  /* Nothing left to boost. */
+
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+
+	/*
+	 * Recheck under the lock: all tasks in need of boosting
+	 * might exit their RCU read-side critical sections on their own.
+	 */
+	if (rnp->exp_tasks == NULL && rnp->boost_tasks == NULL) {
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		return 0;
+	}
+
+	/*
+	 * Preferentially boost tasks blocking expedited grace periods.
+	 * This cannot starve the normal grace periods because a second
+	 * expedited grace period must boost all blocked tasks, including
+	 * those blocking the pre-existing normal grace period.
+	 */
+	if (rnp->exp_tasks != NULL) {
+		tb = rnp->exp_tasks;
+		rnp->n_exp_boosts++;
+	} else {
+		tb = rnp->boost_tasks;
+		rnp->n_normal_boosts++;
+	}
+	rnp->n_tasks_boosted++;
+
+	/*
+	 * We boost task t by manufacturing an rt_mutex that appears to
+	 * be held by task t.  We leave a pointer to that rt_mutex where
+	 * task t can find it, and task t will release the mutex when it
+	 * exits its outermost RCU read-side critical section.  Then
+	 * simply acquiring this artificial rt_mutex will boost task
+	 * t's priority.  (Thanks to tglx for suggesting this approach!)
+	 *
+	 * Note that task t must acquire rnp->lock to remove itself from
+	 * the ->blkd_tasks list, which it will do from exit() if from
+	 * nowhere else.  We therefore are guaranteed that task t will
+	 * stay around at least until we drop rnp->lock.  Note that
+	 * rnp->lock also resolves races between our priority boosting
+	 * and task t's exiting its outermost RCU read-side critical
+	 * section.
+	 */
+	t = container_of(tb, struct task_struct, rcu_node_entry);
+	rt_mutex_init_proxy_locked(&mtx, t);
+	t->rcu_boost_mutex = &mtx;
+	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
+	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
+
+	return rnp->exp_tasks != NULL || rnp->boost_tasks != NULL;
+}
+
+/*
+ * Timer handler to initiate waking up of boost kthreads that
+ * have yielded the CPU due to excessive numbers of tasks to
+ * boost.  We wake up the per-rcu_node kthread, which in turn
+ * will wake up the booster kthread.
+ */
+static void rcu_boost_kthread_timer(unsigned long arg)
+{
+	invoke_rcu_node_kthread((struct rcu_node *)arg);
+}
+
+/*
+ * Priority-boosting kthread.  One per leaf rcu_node and one for the
+ * root rcu_node.
+ */
+static int rcu_boost_kthread(void *arg)
+{
+	struct rcu_node *rnp = (struct rcu_node *)arg;
+	int spincnt = 0;
+	int more2boost;
+
+	for (;;) {
+		rnp->boost_kthread_status = RCU_KTHREAD_WAITING;
+		wait_event_interruptible(rnp->boost_wq, rnp->boost_tasks ||
+							rnp->exp_tasks);
+		rnp->boost_kthread_status = RCU_KTHREAD_RUNNING;
+		more2boost = rcu_boost(rnp);
+		if (more2boost)
+			spincnt++;
+		else
+			spincnt = 0;
+		if (spincnt > 10) {
+			rcu_yield(rcu_boost_kthread_timer, (unsigned long)rnp);
+			spincnt = 0;
+		}
+	}
+	/* NOTREACHED */
+	return 0;
+}
+
+/*
+ * Check to see if it is time to start boosting RCU readers that are
+ * blocking the current grace period, and, if so, tell the per-rcu_node
+ * kthread to start boosting them.  If there is an expedited grace
+ * period in progress, it is always time to boost.
+ *
+ * The caller must hold rnp->lock, which this function releases,
+ * but irqs remain disabled.  The ->boost_kthread_task is immortal,
+ * so we don't need to worry about it going away.
+ */
+static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
+{
+	struct task_struct *t;
+
+	if (!rcu_preempt_blocked_readers_cgp(rnp) && rnp->exp_tasks == NULL) {
+		rnp->n_balk_exp_gp_tasks++;
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
+	if (rnp->exp_tasks != NULL ||
+	    (rnp->gp_tasks != NULL &&
+	     rnp->boost_tasks == NULL &&
+	     rnp->qsmask == 0 &&
+	     ULONG_CMP_GE(jiffies, rnp->boost_time))) {
+		if (rnp->exp_tasks == NULL)
+			rnp->boost_tasks = rnp->gp_tasks;
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		t = rnp->boost_kthread_task;
+		if (t != NULL)
+			wake_up_process(t);
+	} else {
+		rcu_initiate_boost_trace(rnp);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	}
+}
+
+/*
+ * Set the affinity of the boost kthread.  The CPU-hotplug locks are
+ * held, so no one should be messing with the existence of the boost
+ * kthread.
+ */
+static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
+					  cpumask_var_t cm)
+{
+	struct task_struct *t;
+
+	t = rnp->boost_kthread_task;
+	if (t != NULL)
+		set_cpus_allowed_ptr(rnp->boost_kthread_task, cm);
+}
+
+#define RCU_BOOST_DELAY_JIFFIES DIV_ROUND_UP(CONFIG_RCU_BOOST_DELAY * HZ, 1000)
+
+/*
+ * Do priority-boost accounting for the start of a new grace period.
+ */
+static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
+{
+	rnp->boost_time = jiffies + RCU_BOOST_DELAY_JIFFIES;
+}
+
+/*
+ * Initialize the RCU-boost waitqueue.
+ */
+static void __init rcu_init_boost_waitqueue(struct rcu_node *rnp)
+{
+	init_waitqueue_head(&rnp->boost_wq);
+}
+
+/*
+ * Create an RCU-boost kthread for the specified node if one does not
+ * already exist.  We only create this kthread for preemptible RCU.
+ * Returns zero if all is well, a negated errno otherwise.
+ */
+static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
+						 struct rcu_node *rnp,
+						 int rnp_index)
+{
+	unsigned long flags;
+	struct sched_param sp;
+	struct task_struct *t;
+
+	if (&rcu_preempt_state != rsp)
+		return 0;
+	if (rnp->boost_kthread_task != NULL)
+		return 0;
+	t = kthread_create(rcu_boost_kthread, (void *)rnp,
+			   "rcub%d", rnp_index);
+	if (IS_ERR(t))
+		return PTR_ERR(t);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	rnp->boost_kthread_task = t;
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	wake_up_process(t);
+	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+	return 0;
+}
+
+#else /* #ifdef CONFIG_RCU_BOOST */
+
+static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
+{
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+}
+
+static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
+					  cpumask_var_t cm)
+{
+}
+
+static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
+{
+}
+
+static void __init rcu_init_boost_waitqueue(struct rcu_node *rnp)
+{
+}
+
+static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
+						 struct rcu_node *rnp,
+						 int rnp_index)
+{
+	return 0;
+}
+
+#endif /* #else #ifdef CONFIG_RCU_BOOST */
+
 #ifndef CONFIG_SMP
 
 void synchronize_sched_expedited(void)
@@ -1187,8 +1513,8 @@ static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
  *
  * Because it is not legal to invoke rcu_process_callbacks() with irqs
  * disabled, we do one pass of force_quiescent_state(), then do a
- * raise_softirq() to cause rcu_process_callbacks() to be invoked later.
- * The per-cpu rcu_dyntick_drain variable controls the sequencing.
+ * invoke_rcu_cpu_kthread() to cause rcu_process_callbacks() to be invoked
+ * later.  The per-cpu rcu_dyntick_drain variable controls the sequencing.
  */
 int rcu_needs_cpu(int cpu)
 {
@@ -1239,7 +1565,7 @@ int rcu_needs_cpu(int cpu)
 
 	/* If RCU callbacks are still pending, RCU still needs this CPU. */
 	if (c)
-		raise_softirq(RCU_SOFTIRQ);
+		invoke_rcu_cpu_kthread();
 	return c;
 }
 
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index c8e9785..aa0fd72 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -46,6 +46,18 @@
 #define RCU_TREE_NONCORE
 #include "rcutree.h"
 
+DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
+DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_cpu);
+DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
+DECLARE_PER_CPU(char, rcu_cpu_has_work);
+
+static char convert_kthread_status(unsigned int kthread_status)
+{
+	if (kthread_status > RCU_KTHREAD_MAX)
+		return '?';
+	return "SRWOY"[kthread_status];
+}
+
 static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 {
 	if (!rdp->beenonline)
@@ -64,7 +76,21 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, " ql=%ld b=%ld", rdp->qlen, rdp->blimit);
+	seq_printf(m, " ql=%ld qs=%c%c%c%c kt=%d/%c/%d ktl=%x b=%ld",
+		   rdp->qlen,
+		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
+			rdp->nxttail[RCU_NEXT_TAIL]],
+		   ".R"[rdp->nxttail[RCU_WAIT_TAIL] !=
+			rdp->nxttail[RCU_NEXT_READY_TAIL]],
+		   ".W"[rdp->nxttail[RCU_DONE_TAIL] !=
+			rdp->nxttail[RCU_WAIT_TAIL]],
+		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]],
+		   per_cpu(rcu_cpu_has_work, rdp->cpu),
+		   convert_kthread_status(per_cpu(rcu_cpu_kthread_status,
+					  rdp->cpu)),
+		   per_cpu(rcu_cpu_kthread_cpu, rdp->cpu),
+		   per_cpu(rcu_cpu_kthread_loops, rdp->cpu) & 0xffff,
+		   rdp->blimit);
 	seq_printf(m, " ci=%lu co=%lu ca=%lu\n",
 		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
@@ -121,7 +147,18 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, ",%ld,%ld", rdp->qlen, rdp->blimit);
+	seq_printf(m, ",%ld,\"%c%c%c%c\",%d,\"%c\",%ld", rdp->qlen,
+		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
+			rdp->nxttail[RCU_NEXT_TAIL]],
+		   ".R"[rdp->nxttail[RCU_WAIT_TAIL] !=
+			rdp->nxttail[RCU_NEXT_READY_TAIL]],
+		   ".W"[rdp->nxttail[RCU_DONE_TAIL] !=
+			rdp->nxttail[RCU_WAIT_TAIL]],
+		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]],
+		   per_cpu(rcu_cpu_has_work, rdp->cpu),
+		   convert_kthread_status(per_cpu(rcu_cpu_kthread_status,
+					  rdp->cpu)),
+		   rdp->blimit);
 	seq_printf(m, ",%lu,%lu,%lu\n",
 		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
@@ -157,11 +194,76 @@ static const struct file_operations rcudata_csv_fops = {
 	.release = single_release,
 };
 
+#ifdef CONFIG_RCU_BOOST
+
+static void print_one_rcu_node_boost(struct seq_file *m, struct rcu_node *rnp)
+{
+	seq_printf(m,  "%d:%d tasks=%c%c%c%c kt=%c ntb=%lu neb=%lu nnb=%lu "
+		   "j=%04x bt=%04x\n",
+		   rnp->grplo, rnp->grphi,
+		   "T."[list_empty(&rnp->blkd_tasks)],
+		   "N."[!rnp->gp_tasks],
+		   "E."[!rnp->exp_tasks],
+		   "B."[!rnp->boost_tasks],
+		   convert_kthread_status(rnp->boost_kthread_status),
+		   rnp->n_tasks_boosted, rnp->n_exp_boosts,
+		   rnp->n_normal_boosts,
+		   (int)(jiffies & 0xffff),
+		   (int)(rnp->boost_time & 0xffff));
+	seq_printf(m, "%s: nt=%lu egt=%lu bt=%lu nb=%lu ny=%lu nos=%lu\n",
+		   "     balk",
+		   rnp->n_balk_blkd_tasks,
+		   rnp->n_balk_exp_gp_tasks,
+		   rnp->n_balk_boost_tasks,
+		   rnp->n_balk_notblocked,
+		   rnp->n_balk_notyet,
+		   rnp->n_balk_nos);
+}
+
+static int show_rcu_node_boost(struct seq_file *m, void *unused)
+{
+	struct rcu_node *rnp;
+
+	rcu_for_each_leaf_node(&rcu_preempt_state, rnp)
+		print_one_rcu_node_boost(m, rnp);
+	return 0;
+}
+
+static int rcu_node_boost_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_rcu_node_boost, NULL);
+}
+
+static const struct file_operations rcu_node_boost_fops = {
+	.owner = THIS_MODULE,
+	.open = rcu_node_boost_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+/*
+ * Create the rcuboost debugfs entry.  Standard error return.
+ */
+static int rcu_boost_trace_create_file(struct dentry *rcudir)
+{
+	return !debugfs_create_file("rcuboost", 0444, rcudir, NULL,
+				    &rcu_node_boost_fops);
+}
+
+#else /* #ifdef CONFIG_RCU_BOOST */
+
+static int rcu_boost_trace_create_file(struct dentry *rcudir)
+{
+	return 0;  /* There cannot be an error if we didn't create it! */
+}
+
+#endif /* #else #ifdef CONFIG_RCU_BOOST */
+
 static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 {
 	unsigned long gpnum;
 	int level = 0;
-	int phase;
 	struct rcu_node *rnp;
 
 	gpnum = rsp->gpnum;
@@ -178,13 +280,11 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 			seq_puts(m, "\n");
 			level = rnp->level;
 		}
-		phase = gpnum & 0x1;
-		seq_printf(m, "%lx/%lx %c%c>%c%c %d:%d ^%d    ",
+		seq_printf(m, "%lx/%lx %c%c>%c %d:%d ^%d    ",
 			   rnp->qsmask, rnp->qsmaskinit,
-			   "T."[list_empty(&rnp->blocked_tasks[phase])],
-			   "E."[list_empty(&rnp->blocked_tasks[phase + 2])],
-			   "T."[list_empty(&rnp->blocked_tasks[!phase])],
-			   "E."[list_empty(&rnp->blocked_tasks[!phase + 2])],
+			   ".G"[rnp->gp_tasks != NULL],
+			   ".E"[rnp->exp_tasks != NULL],
+			   ".T"[!list_empty(&rnp->blkd_tasks)],
 			   rnp->grplo, rnp->grphi, rnp->grpnum);
 	}
 	seq_puts(m, "\n");
@@ -216,16 +316,35 @@ static const struct file_operations rcuhier_fops = {
 	.release = single_release,
 };
 
+static void show_one_rcugp(struct seq_file *m, struct rcu_state *rsp)
+{
+	unsigned long flags;
+	unsigned long completed;
+	unsigned long gpnum;
+	unsigned long gpage;
+	unsigned long gpmax;
+	struct rcu_node *rnp = &rsp->node[0];
+
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	completed = rsp->completed;
+	gpnum = rsp->gpnum;
+	if (rsp->completed == rsp->gpnum)
+		gpage = 0;
+	else
+		gpage = jiffies - rsp->gp_start;
+	gpmax = rsp->gp_max;
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	seq_printf(m, "%s: completed=%ld  gpnum=%lu  age=%ld  max=%ld\n",
+		   rsp->name, completed, gpnum, gpage, gpmax);
+}
+
 static int show_rcugp(struct seq_file *m, void *unused)
 {
 #ifdef CONFIG_TREE_PREEMPT_RCU
-	seq_printf(m, "rcu_preempt: completed=%ld  gpnum=%lu\n",
-		   rcu_preempt_state.completed, rcu_preempt_state.gpnum);
+	show_one_rcugp(m, &rcu_preempt_state);
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-	seq_printf(m, "rcu_sched: completed=%ld  gpnum=%lu\n",
-		   rcu_sched_state.completed, rcu_sched_state.gpnum);
-	seq_printf(m, "rcu_bh: completed=%ld  gpnum=%lu\n",
-		   rcu_bh_state.completed, rcu_bh_state.gpnum);
+	show_one_rcugp(m, &rcu_sched_state);
+	show_one_rcugp(m, &rcu_bh_state);
 	return 0;
 }
 
@@ -298,6 +417,29 @@ static const struct file_operations rcu_pending_fops = {
 	.release = single_release,
 };
 
+static int show_rcutorture(struct seq_file *m, void *unused)
+{
+	seq_printf(m, "rcutorture test sequence: %lu %s\n",
+		   rcutorture_testseq >> 1,
+		   (rcutorture_testseq & 0x1) ? "(test in progress)" : "");
+	seq_printf(m, "rcutorture update version number: %lu\n",
+		   rcutorture_vernum);
+	return 0;
+}
+
+static int rcutorture_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_rcutorture, NULL);
+}
+
+static const struct file_operations rcutorture_fops = {
+	.owner = THIS_MODULE,
+	.open = rcutorture_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
 static struct dentry *rcudir;
 
 static int __init rcutree_trace_init(void)
@@ -318,6 +460,9 @@ static int __init rcutree_trace_init(void)
 	if (!retval)
 		goto free_out;
 
+	if (rcu_boost_trace_create_file(rcudir))
+		goto free_out;
+
 	retval = debugfs_create_file("rcugp", 0444, rcudir, NULL, &rcugp_fops);
 	if (!retval)
 		goto free_out;
@@ -331,6 +476,11 @@ static int __init rcutree_trace_init(void)
 						NULL, &rcu_pending_fops);
 	if (!retval)
 		goto free_out;
+
+	retval = debugfs_create_file("rcutorture", 0444, rcudir,
+						NULL, &rcutorture_fops);
+	if (!retval)
+		goto free_out;
 	return 0;
 free_out:
 	debugfs_remove_recursive(rcudir);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 174f976..1396017 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -58,7 +58,7 @@ DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
 char *softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
-	"TASKLET", "SCHED", "HRTIMER",	"RCU"
+	"TASKLET", "SCHED", "HRTIMER"
 };
 
 /*
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c768bcd..3aa2780 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -337,7 +337,7 @@ config DEBUG_OBJECTS_WORK
 
 config DEBUG_OBJECTS_RCU_HEAD
 	bool "Debug RCU callbacks objects"
-	depends on DEBUG_OBJECTS && PREEMPT
+	depends on DEBUG_OBJECTS
 	help
 	  Enable this to turn on debugging of RCU list heads (call_rcu() usage).
 
@@ -875,22 +875,9 @@ config RCU_TORTURE_TEST_RUNNABLE
 	  Say N here if you want the RCU torture tests to start only
 	  after being manually enabled via /proc.
 
-config RCU_CPU_STALL_DETECTOR
-	bool "Check for stalled CPUs delaying RCU grace periods"
-	depends on TREE_RCU || TREE_PREEMPT_RCU
-	default y
-	help
-	  This option causes RCU to printk information on which
-	  CPUs are delaying the current grace period, but only when
-	  the grace period extends for excessive time periods.
-
-	  Say N if you want to disable such checks.
-
-	  Say Y if you are unsure.
-
 config RCU_CPU_STALL_TIMEOUT
 	int "RCU CPU stall timeout in seconds"
-	depends on RCU_CPU_STALL_DETECTOR
+	depends on TREE_RCU || TREE_PREEMPT_RCU
 	range 3 300
 	default 60
 	help
@@ -899,22 +886,9 @@ config RCU_CPU_STALL_TIMEOUT
 	  RCU grace period persists, additional CPU stall warnings are
 	  printed at more widely spaced intervals.
 
-config RCU_CPU_STALL_DETECTOR_RUNNABLE
-	bool "RCU CPU stall checking starts automatically at boot"
-	depends on RCU_CPU_STALL_DETECTOR
-	default y
-	help
-	  If set, start checking for RCU CPU stalls immediately on
-	  boot.  Otherwise, RCU CPU stall checking must be manually
-	  enabled.
-
-	  Say Y if you are unsure.
-
-	  Say N if you wish to suppress RCU CPU stall checking during boot.
-
 config RCU_CPU_STALL_VERBOSE
 	bool "Print additional per-task information for RCU_CPU_STALL_DETECTOR"
-	depends on RCU_CPU_STALL_DETECTOR && TREE_PREEMPT_RCU
+	depends on TREE_PREEMPT_RCU
 	default y
 	help
 	  This option causes RCU to printk detailed per-task information
diff --git a/net/batman-adv/gateway_client.c b/net/batman-adv/gateway_client.c
index 3cc4355..150b6ce 100644
--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -28,18 +28,10 @@
 #include <linux/udp.h>
 #include <linux/if_vlan.h>
 
-static void gw_node_free_rcu(struct rcu_head *rcu)
-{
-	struct gw_node *gw_node;
-
-	gw_node = container_of(rcu, struct gw_node, rcu);
-	kfree(gw_node);
-}
-
 static void gw_node_free_ref(struct gw_node *gw_node)
 {
 	if (atomic_dec_and_test(&gw_node->refcount))
-		call_rcu(&gw_node->rcu, gw_node_free_rcu);
+		kfree_rcu(gw_node, rcu);
 }
 
 void *gw_get_selected(struct bat_priv *bat_priv)
diff --git a/net/batman-adv/originator.c b/net/batman-adv/originator.c
index 0b91330..ed23a589 100644
--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -56,18 +56,10 @@ err:
 	return 0;
 }
 
-static void neigh_node_free_rcu(struct rcu_head *rcu)
-{
-	struct neigh_node *neigh_node;
-
-	neigh_node = container_of(rcu, struct neigh_node, rcu);
-	kfree(neigh_node);
-}
-
 void neigh_node_free_ref(struct neigh_node *neigh_node)
 {
 	if (atomic_dec_and_test(&neigh_node->refcount))
-		call_rcu(&neigh_node->rcu, neigh_node_free_rcu);
+		kfree_rcu(neigh_node, rcu);
 }
 
 struct neigh_node *create_neighbor(struct orig_node *orig_node,
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 824e1f6..04efe02 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -76,18 +76,10 @@ int my_skb_head_push(struct sk_buff *skb, unsigned int len)
 	return 0;
 }
 
-static void softif_neigh_free_rcu(struct rcu_head *rcu)
-{
-	struct softif_neigh *softif_neigh;
-
-	softif_neigh = container_of(rcu, struct softif_neigh, rcu);
-	kfree(softif_neigh);
-}
-
 static void softif_neigh_free_ref(struct softif_neigh *softif_neigh)
 {
 	if (atomic_dec_and_test(&softif_neigh->refcount))
-		call_rcu(&softif_neigh->rcu, softif_neigh_free_rcu);
+		kfree_rcu(softif_neigh, rcu);
 }
 
 void softif_neigh_purge(struct bat_priv *bat_priv)
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 7b39f3e..e2e6693 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -68,14 +68,6 @@ static int __hw_addr_add(struct netdev_hw_addr_list *list, unsigned char *addr,
 	return __hw_addr_add_ex(list, addr, addr_len, addr_type, false);
 }
 
-static void ha_rcu_free(struct rcu_head *head)
-{
-	struct netdev_hw_addr *ha;
-
-	ha = container_of(head, struct netdev_hw_addr, rcu_head);
-	kfree(ha);
-}
-
 static int __hw_addr_del_ex(struct netdev_hw_addr_list *list,
 			    unsigned char *addr, int addr_len,
 			    unsigned char addr_type, bool global)
@@ -94,7 +86,7 @@ static int __hw_addr_del_ex(struct netdev_hw_addr_list *list,
 			if (--ha->refcount)
 				return 0;
 			list_del_rcu(&ha->list);
-			call_rcu(&ha->rcu_head, ha_rcu_free);
+			kfree_rcu(ha, rcu_head);
 			list->count--;
 			return 0;
 		}
@@ -197,7 +189,7 @@ void __hw_addr_flush(struct netdev_hw_addr_list *list)
 
 	list_for_each_entry_safe(ha, tmp, &list->list, list) {
 		list_del_rcu(&ha->list);
-		call_rcu(&ha->rcu_head, ha_rcu_free);
+		kfree_rcu(ha, rcu_head);
 	}
 	list->count = 0;
 }
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 706502f..7f36b38 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -207,14 +207,6 @@ static void trace_napi_poll_hit(void *ignore, struct napi_struct *napi)
 	rcu_read_unlock();
 }
 
-
-static void free_dm_hw_stat(struct rcu_head *head)
-{
-	struct dm_hw_stat_delta *n;
-	n = container_of(head, struct dm_hw_stat_delta, rcu);
-	kfree(n);
-}
-
 static int set_all_monitor_traces(int state)
 {
 	int rc = 0;
@@ -245,7 +237,7 @@ static int set_all_monitor_traces(int state)
 		list_for_each_entry_safe(new_stat, temp, &hw_stats_list, list) {
 			if (new_stat->dev == NULL) {
 				list_del_rcu(&new_stat->list);
-				call_rcu(&new_stat->rcu, free_dm_hw_stat);
+				kfree_rcu(new_stat, rcu);
 			}
 		}
 		break;
@@ -314,7 +306,7 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 				new_stat->dev = NULL;
 				if (trace_state == TRACE_OFF) {
 					list_del_rcu(&new_stat->list);
-					call_rcu(&new_stat->rcu, free_dm_hw_stat);
+					kfree_rcu(new_stat, rcu);
 					break;
 				}
 			}
diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index 7c23733..43b03dd 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -249,13 +249,6 @@ int gen_new_estimator(struct gnet_stats_basic_packed *bstats,
 }
 EXPORT_SYMBOL(gen_new_estimator);
 
-static void __gen_kill_estimator(struct rcu_head *head)
-{
-	struct gen_estimator *e = container_of(head,
-					struct gen_estimator, e_rcu);
-	kfree(e);
-}
-
 /**
  * gen_kill_estimator - remove a rate estimator
  * @bstats: basic statistics
@@ -279,7 +272,7 @@ void gen_kill_estimator(struct gnet_stats_basic_packed *bstats,
 		write_unlock(&est_lock);
 
 		list_del_rcu(&e->list);
-		call_rcu(&e->e_rcu, __gen_kill_estimator);
+		kfree_rcu(e, e_rcu);
 	}
 	spin_unlock_bh(&est_tree_lock);
 }
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 5ceb257..80b2aad 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -565,13 +565,6 @@ static ssize_t show_rps_map(struct netdev_rx_queue *queue,
 	return len;
 }
 
-static void rps_map_release(struct rcu_head *rcu)
-{
-	struct rps_map *map = container_of(rcu, struct rps_map, rcu);
-
-	kfree(map);
-}
-
 static ssize_t store_rps_map(struct netdev_rx_queue *queue,
 		      struct rx_queue_attribute *attribute,
 		      const char *buf, size_t len)
@@ -619,7 +612,7 @@ static ssize_t store_rps_map(struct netdev_rx_queue *queue,
 	spin_unlock(&rps_map_lock);
 
 	if (old_map)
-		call_rcu(&old_map->rcu, rps_map_release);
+		kfree_rcu(old_map, rcu);
 
 	free_cpumask_var(mask);
 	return len;
@@ -728,7 +721,7 @@ static void rx_queue_release(struct kobject *kobj)
 	map = rcu_dereference_raw(queue->rps_map);
 	if (map) {
 		RCU_INIT_POINTER(queue->rps_map, NULL);
-		call_rcu(&map->rcu, rps_map_release);
+		kfree_rcu(map, rcu);
 	}
 
 	flow_table = rcu_dereference_raw(queue->rps_flow_table);
@@ -898,21 +891,6 @@ static ssize_t show_xps_map(struct netdev_queue *queue,
 	return len;
 }
 
-static void xps_map_release(struct rcu_head *rcu)
-{
-	struct xps_map *map = container_of(rcu, struct xps_map, rcu);
-
-	kfree(map);
-}
-
-static void xps_dev_maps_release(struct rcu_head *rcu)
-{
-	struct xps_dev_maps *dev_maps =
-	    container_of(rcu, struct xps_dev_maps, rcu);
-
-	kfree(dev_maps);
-}
-
 static DEFINE_MUTEX(xps_map_mutex);
 #define xmap_dereference(P)		\
 	rcu_dereference_protected((P), lockdep_is_held(&xps_map_mutex))
@@ -1009,7 +987,7 @@ static ssize_t store_xps_map(struct netdev_queue *queue,
 		map = dev_maps ?
 			xmap_dereference(dev_maps->cpu_map[cpu]) : NULL;
 		if (map && xmap_dereference(new_dev_maps->cpu_map[cpu]) != map)
-			call_rcu(&map->rcu, xps_map_release);
+			kfree_rcu(map, rcu);
 		if (new_dev_maps->cpu_map[cpu])
 			nonempty = 1;
 	}
@@ -1022,7 +1000,7 @@ static ssize_t store_xps_map(struct netdev_queue *queue,
 	}
 
 	if (dev_maps)
-		call_rcu(&dev_maps->rcu, xps_dev_maps_release);
+		kfree_rcu(dev_maps, rcu);
 
 	netdev_queue_numa_node_write(queue, (numa_node >= 0) ? numa_node :
 					    NUMA_NO_NODE);
@@ -1084,7 +1062,7 @@ static void netdev_queue_release(struct kobject *kobj)
 				else {
 					RCU_INIT_POINTER(dev_maps->cpu_map[i],
 					    NULL);
-					call_rcu(&map->rcu, xps_map_release);
+					kfree_rcu(map, rcu);
 					map = NULL;
 				}
 			}
@@ -1094,7 +1072,7 @@ static void netdev_queue_release(struct kobject *kobj)
 
 		if (!nonempty) {
 			RCU_INIT_POINTER(dev->xps_maps, NULL);
-			call_rcu(&dev_maps->rcu, xps_dev_maps_release);
+			kfree_rcu(dev_maps, rcu);
 		}
 	}
 
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 3f86026..297bb92 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -27,14 +27,6 @@ EXPORT_SYMBOL(init_net);
 
 #define INITIAL_NET_GEN_PTRS	13 /* +1 for len +2 for rcu_head */
 
-static void net_generic_release(struct rcu_head *rcu)
-{
-	struct net_generic *ng;
-
-	ng = container_of(rcu, struct net_generic, rcu);
-	kfree(ng);
-}
-
 static int net_assign_generic(struct net *net, int id, void *data)
 {
 	struct net_generic *ng, *old_ng;
@@ -68,7 +60,7 @@ static int net_assign_generic(struct net *net, int id, void *data)
 	memcpy(&ng->ptr, &old_ng->ptr, old_ng->len * sizeof(void*));
 
 	rcu_assign_pointer(net->gen, ng);
-	call_rcu(&old_ng->rcu, net_generic_release);
+	kfree_rcu(old_ng, rcu);
 assign:
 	ng->ptr[id - 1] = data;
 	return 0;
diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index 0dcaa90..4c27615 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -332,14 +332,9 @@ static struct dn_ifaddr *dn_dev_alloc_ifa(void)
 	return ifa;
 }
 
-static void dn_dev_free_ifa_rcu(struct rcu_head *head)
-{
-	kfree(container_of(head, struct dn_ifaddr, rcu));
-}
-
 static void dn_dev_free_ifa(struct dn_ifaddr *ifa)
 {
-	call_rcu(&ifa->rcu, dn_dev_free_ifa_rcu);
+	kfree_rcu(ifa, rcu);
 }
 
 static void dn_dev_del_ifa(struct dn_dev *dn_db, struct dn_ifaddr __rcu **ifap, int destroy)
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 641a5a2..33e2c35 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -141,18 +141,8 @@ const struct fib_prop fib_props[RTN_MAX + 1] = {
 	},
 };
 
-
 /* Release a nexthop info record */
 
-static void free_fib_info_rcu(struct rcu_head *head)
-{
-	struct fib_info *fi = container_of(head, struct fib_info, rcu);
-
-	if (fi->fib_metrics != (u32 *) dst_default_metrics)
-		kfree(fi->fib_metrics);
-	kfree(fi);
-}
-
 void free_fib_info(struct fib_info *fi)
 {
 	if (fi->fib_dead == 0) {
@@ -166,7 +156,7 @@ void free_fib_info(struct fib_info *fi)
 	} endfor_nexthops(fi);
 	fib_info_cnt--;
 	release_net(fi->fib_net);
-	call_rcu(&fi->rcu, free_fib_info_rcu);
+	kfree_rcu(fi, rcu);
 }
 
 void fib_release_info(struct fib_info *fi)
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 5fe9b8b..11d4d28 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -350,14 +350,9 @@ static inline void free_leaf(struct leaf *l)
 	call_rcu_bh(&l->rcu, __leaf_free_rcu);
 }
 
-static void __leaf_info_free_rcu(struct rcu_head *head)
-{
-	kfree(container_of(head, struct leaf_info, rcu));
-}
-
 static inline void free_leaf_info(struct leaf_info *leaf)
 {
-	call_rcu(&leaf->rcu, __leaf_info_free_rcu);
+	kfree_rcu(leaf, rcu);
 }
 
 static struct tnode *tnode_alloc(size_t size)
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 1fd3d9c..8f62d66 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -149,17 +149,11 @@ static void ip_mc_clear_src(struct ip_mc_list *pmc);
 static int ip_mc_add_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
 			 int sfcount, __be32 *psfsrc, int delta);
 
-
-static void ip_mc_list_reclaim(struct rcu_head *head)
-{
-	kfree(container_of(head, struct ip_mc_list, rcu));
-}
-
 static void ip_ma_put(struct ip_mc_list *im)
 {
 	if (atomic_dec_and_test(&im->refcnt)) {
 		in_dev_put(im->interface);
-		call_rcu(&im->rcu, ip_mc_list_reclaim);
+		kfree_rcu(im, rcu);
 	}
 }
 
@@ -1836,12 +1830,6 @@ done:
 }
 EXPORT_SYMBOL(ip_mc_join_group);
 
-static void ip_sf_socklist_reclaim(struct rcu_head *rp)
-{
-	kfree(container_of(rp, struct ip_sf_socklist, rcu));
-	/* sk_omem_alloc should have been decreased by the caller*/
-}
-
 static int ip_mc_leave_src(struct sock *sk, struct ip_mc_socklist *iml,
 			   struct in_device *in_dev)
 {
@@ -1858,18 +1846,10 @@ static int ip_mc_leave_src(struct sock *sk, struct ip_mc_socklist *iml,
 	rcu_assign_pointer(iml->sflist, NULL);
 	/* decrease mem now to avoid the memleak warning */
 	atomic_sub(IP_SFLSIZE(psf->sl_max), &sk->sk_omem_alloc);
-	call_rcu(&psf->rcu, ip_sf_socklist_reclaim);
+	kfree_rcu(psf, rcu);
 	return err;
 }
 
-
-static void ip_mc_socklist_reclaim(struct rcu_head *rp)
-{
-	kfree(container_of(rp, struct ip_mc_socklist, rcu));
-	/* sk_omem_alloc should have been decreased by the caller*/
-}
-
-
 /*
  *	Ask a socket to leave a group.
  */
@@ -1909,7 +1889,7 @@ int ip_mc_leave_group(struct sock *sk, struct ip_mreqn *imr)
 		rtnl_unlock();
 		/* decrease mem now to avoid the memleak warning */
 		atomic_sub(sizeof(*iml), &sk->sk_omem_alloc);
-		call_rcu(&iml->rcu, ip_mc_socklist_reclaim);
+		kfree_rcu(iml, rcu);
 		return 0;
 	}
 	if (!in_dev)
@@ -2026,7 +2006,7 @@ int ip_mc_source(int add, int omode, struct sock *sk, struct
 				newpsl->sl_addr[i] = psl->sl_addr[i];
 			/* decrease mem now to avoid the memleak warning */
 			atomic_sub(IP_SFLSIZE(psl->sl_max), &sk->sk_omem_alloc);
-			call_rcu(&psl->rcu, ip_sf_socklist_reclaim);
+			kfree_rcu(psl, rcu);
 		}
 		rcu_assign_pointer(pmc->sflist, newpsl);
 		psl = newpsl;
@@ -2127,7 +2107,7 @@ int ip_mc_msfilter(struct sock *sk, struct ip_msfilter *msf, int ifindex)
 			psl->sl_count, psl->sl_addr, 0);
 		/* decrease mem now to avoid the memleak warning */
 		atomic_sub(IP_SFLSIZE(psl->sl_max), &sk->sk_omem_alloc);
-		call_rcu(&psl->rcu, ip_sf_socklist_reclaim);
+		kfree_rcu(psl, rcu);
 	} else
 		(void) ip_mc_del_src(in_dev, &msf->imsf_multiaddr, pmc->sfmode,
 			0, NULL, 0);
@@ -2324,7 +2304,7 @@ void ip_mc_drop_socket(struct sock *sk)
 			ip_mc_dec_group(in_dev, iml->multi.imr_multiaddr.s_addr);
 		/* decrease mem now to avoid the memleak warning */
 		atomic_sub(sizeof(*iml), &sk->sk_omem_alloc);
-		call_rcu(&iml->rcu, ip_mc_socklist_reclaim);
+		kfree_rcu(iml, rcu);
 	}
 	rtnl_unlock();
 }
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index a7bda07..8f13d88 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -317,12 +317,6 @@ static void snmp6_free_dev(struct inet6_dev *idev)
 
 /* Nobody refers to this device, we may destroy it. */
 
-static void in6_dev_finish_destroy_rcu(struct rcu_head *head)
-{
-	struct inet6_dev *idev = container_of(head, struct inet6_dev, rcu);
-	kfree(idev);
-}
-
 void in6_dev_finish_destroy(struct inet6_dev *idev)
 {
 	struct net_device *dev = idev->dev;
@@ -339,7 +333,7 @@ void in6_dev_finish_destroy(struct inet6_dev *idev)
 		return;
 	}
 	snmp6_free_dev(idev);
-	call_rcu(&idev->rcu, in6_dev_finish_destroy_rcu);
+	kfree_rcu(idev, rcu);
 }
 
 EXPORT_SYMBOL(in6_dev_finish_destroy);
@@ -535,12 +529,6 @@ static int addrconf_fixup_forwarding(struct ctl_table *table, int *p, int old)
 }
 #endif
 
-static void inet6_ifa_finish_destroy_rcu(struct rcu_head *head)
-{
-	struct inet6_ifaddr *ifp = container_of(head, struct inet6_ifaddr, rcu);
-	kfree(ifp);
-}
-
 /* Nobody refers to this ifaddr, destroy it */
 void inet6_ifa_finish_destroy(struct inet6_ifaddr *ifp)
 {
@@ -561,7 +549,7 @@ void inet6_ifa_finish_destroy(struct inet6_ifaddr *ifp)
 	}
 	dst_release(&ifp->rt->dst);
 
-	call_rcu(&ifp->rcu, inet6_ifa_finish_destroy_rcu);
+	kfree_rcu(ifp, rcu);
 }
 
 static void
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 76b8937..f2d98ca 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -201,10 +201,6 @@ int ipv6_sock_mc_join(struct sock *sk, int ifindex, const struct in6_addr *addr)
 	return 0;
 }
 
-static void ipv6_mc_socklist_reclaim(struct rcu_head *head)
-{
-	kfree(container_of(head, struct ipv6_mc_socklist, rcu));
-}
 /*
  *	socket leave on multicast group
  */
@@ -239,7 +235,7 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex, const struct in6_addr *addr)
 				(void) ip6_mc_leave_src(sk, mc_lst, NULL);
 			rcu_read_unlock();
 			atomic_sub(sizeof(*mc_lst), &sk->sk_omem_alloc);
-			call_rcu(&mc_lst->rcu, ipv6_mc_socklist_reclaim);
+			kfree_rcu(mc_lst, rcu);
 			return 0;
 		}
 	}
@@ -307,7 +303,7 @@ void ipv6_sock_mc_close(struct sock *sk)
 		rcu_read_unlock();
 
 		atomic_sub(sizeof(*mc_lst), &sk->sk_omem_alloc);
-		call_rcu(&mc_lst->rcu, ipv6_mc_socklist_reclaim);
+		kfree_rcu(mc_lst, rcu);
 
 		spin_lock(&ipv6_sk_mc_lock);
 	}
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 43b3337..5f35d59 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -401,11 +401,6 @@ out:
 	return err;
 }
 
-static void prl_entry_destroy_rcu(struct rcu_head *head)
-{
-	kfree(container_of(head, struct ip_tunnel_prl_entry, rcu_head));
-}
-
 static void prl_list_destroy_rcu(struct rcu_head *head)
 {
 	struct ip_tunnel_prl_entry *p, *n;
@@ -433,7 +428,7 @@ ipip6_tunnel_del_prl(struct ip_tunnel *t, struct ip_tunnel_prl *a)
 		     p = &x->next) {
 			if (x->addr == a->addr) {
 				*p = x->next;
-				call_rcu(&x->rcu_head, prl_entry_destroy_rcu);
+				kfree_rcu(x, rcu_head);
 				t->prl_count--;
 				goto out;
 			}
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 63d852c..53defaf 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -136,14 +136,6 @@ void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u1
 	ieee80211_tx_skb(sdata, skb);
 }
 
-static void kfree_tid_tx(struct rcu_head *rcu_head)
-{
-	struct tid_ampdu_tx *tid_tx =
-	    container_of(rcu_head, struct tid_ampdu_tx, rcu_head);
-
-	kfree(tid_tx);
-}
-
 int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				    enum ieee80211_back_parties initiator,
 				    bool tx)
@@ -163,7 +155,7 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 		/* not even started yet! */
 		rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], NULL);
 		spin_unlock_bh(&sta->lock);
-		call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
+		kfree_rcu(tid_tx, rcu_head);
 		return 0;
 	}
 
@@ -322,7 +314,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 		spin_unlock_bh(&sta->lock);
 
 		ieee80211_wake_queue_agg(local, tid);
-		call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
+		kfree_rcu(tid_tx, rcu_head);
 		return;
 	}
 
@@ -701,7 +693,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
 
 	ieee80211_agg_splice_finish(local, tid);
 
-	call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
+	kfree_rcu(tid_tx, rcu_head);
 
  unlock_sta:
 	spin_unlock_bh(&sta->lock);
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index e73c8ca..ac35496 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -65,17 +65,9 @@ static void run_again(struct ieee80211_local *local,
 		mod_timer(&local->work_timer, timeout);
 }
 
-static void work_free_rcu(struct rcu_head *head)
-{
-	struct ieee80211_work *wk =
-		container_of(head, struct ieee80211_work, rcu_head);
-
-	kfree(wk);
-}
-
 void free_work(struct ieee80211_work *wk)
 {
-	call_rcu(&wk->rcu_head, work_free_rcu);
+	kfree_rcu(wk, rcu_head);
 }
 
 static int ieee80211_compatible_rates(const u8 *supp_rates, int supp_rates_len,
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 80a23ed..05ecdc2 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -68,12 +68,6 @@ nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id, gfp_t gfp)
 	return (void *)(*ext) + off;
 }
 
-static void __nf_ct_ext_free_rcu(struct rcu_head *head)
-{
-	struct nf_ct_ext *ext = container_of(head, struct nf_ct_ext, rcu);
-	kfree(ext);
-}
-
 void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 {
 	struct nf_ct_ext *old, *new;
@@ -114,7 +108,7 @@ void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 					(void *)old + old->offset[i]);
 			rcu_read_unlock();
 		}
-		call_rcu(&old->rcu, __nf_ct_ext_free_rcu);
+		kfree_rcu(old, rcu);
 		ct->ext = new;
 	}
 
diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index 4327e10..846f895 100644
--- a/net/netfilter/xt_osf.c
+++ b/net/netfilter/xt_osf.c
@@ -62,13 +62,6 @@ static const struct nla_policy xt_osf_policy[OSF_ATTR_MAX + 1] = {
 	[OSF_ATTR_FINGER]	= { .len = sizeof(struct xt_osf_user_finger) },
 };
 
-static void xt_osf_finger_free_rcu(struct rcu_head *rcu_head)
-{
-	struct xt_osf_finger *f = container_of(rcu_head, struct xt_osf_finger, rcu_head);
-
-	kfree(f);
-}
-
 static int xt_osf_add_callback(struct sock *ctnl, struct sk_buff *skb,
 			       const struct nlmsghdr *nlh,
 			       const struct nlattr * const osf_attrs[])
@@ -133,7 +126,7 @@ static int xt_osf_remove_callback(struct sock *ctnl, struct sk_buff *skb,
 		 * We are protected by nfnl mutex.
 		 */
 		list_del_rcu(&sf->finger_entry);
-		call_rcu(&sf->rcu_head, xt_osf_finger_free_rcu);
+		kfree_rcu(sf, rcu_head);
 
 		err = 0;
 		break;
@@ -414,7 +407,7 @@ static void __exit xt_osf_fini(void)
 
 		list_for_each_entry_rcu(f, &xt_osf_fingers[i], finger_entry) {
 			list_del_rcu(&f->finger_entry);
-			call_rcu(&f->rcu_head, xt_osf_finger_free_rcu);
+			kfree_rcu(f, rcu_head);
 		}
 	}
 	rcu_read_unlock();
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index e2b0a68..9c38658 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -154,44 +154,6 @@ static const struct nla_policy netlbl_unlabel_genl_policy[NLBL_UNLABEL_A_MAX + 1
  */
 
 /**
- * netlbl_unlhsh_free_addr4 - Frees an IPv4 address entry from the hash table
- * @entry: the entry's RCU field
- *
- * Description:
- * This function is designed to be used as a callback to the call_rcu()
- * function so that memory allocated to a hash table address entry can be
- * released safely.
- *
- */
-static void netlbl_unlhsh_free_addr4(struct rcu_head *entry)
-{
-	struct netlbl_unlhsh_addr4 *ptr;
-
-	ptr = container_of(entry, struct netlbl_unlhsh_addr4, rcu);
-	kfree(ptr);
-}
-
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-/**
- * netlbl_unlhsh_free_addr6 - Frees an IPv6 address entry from the hash table
- * @entry: the entry's RCU field
- *
- * Description:
- * This function is designed to be used as a callback to the call_rcu()
- * function so that memory allocated to a hash table address entry can be
- * released safely.
- *
- */
-static void netlbl_unlhsh_free_addr6(struct rcu_head *entry)
-{
-	struct netlbl_unlhsh_addr6 *ptr;
-
-	ptr = container_of(entry, struct netlbl_unlhsh_addr6, rcu);
-	kfree(ptr);
-}
-#endif /* IPv6 */
-
-/**
  * netlbl_unlhsh_free_iface - Frees an interface entry from the hash table
  * @entry: the entry's RCU field
  *
@@ -568,7 +530,7 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 	if (entry == NULL)
 		return -ENOENT;
 
-	call_rcu(&entry->rcu, netlbl_unlhsh_free_addr4);
+	kfree_rcu(entry, rcu);
 	return 0;
 }
 
@@ -629,7 +591,7 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 	if (entry == NULL)
 		return -ENOENT;
 
-	call_rcu(&entry->rcu, netlbl_unlhsh_free_addr6);
+	kfree_rcu(entry, rcu);
 	return 0;
 }
 #endif /* IPv6 */
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index c8f35b5..5fe4f3b 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1566,12 +1566,6 @@ netlink_kernel_release(struct sock *sk)
 }
 EXPORT_SYMBOL(netlink_kernel_release);
 
-
-static void listeners_free_rcu(struct rcu_head *head)
-{
-	kfree(container_of(head, struct listeners, rcu));
-}
-
 int __netlink_change_ngroups(struct sock *sk, unsigned int groups)
 {
 	struct listeners *new, *old;
@@ -1588,7 +1582,7 @@ int __netlink_change_ngroups(struct sock *sk, unsigned int groups)
 		memcpy(new->masks, old->masks, NLGRPSZ(tbl->groups));
 		rcu_assign_pointer(tbl->listeners, new);
 
-		call_rcu(&old->rcu, listeners_free_rcu);
+		kfree_rcu(old, rcu);
 	}
 	tbl->groups = groups;
 
diff --git a/net/phonet/pn_dev.c b/net/phonet/pn_dev.c
index 947038d..1566672 100644
--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -162,14 +162,6 @@ int phonet_address_add(struct net_device *dev, u8 addr)
 	return err;
 }
 
-static void phonet_device_rcu_free(struct rcu_head *head)
-{
-	struct phonet_device *pnd;
-
-	pnd = container_of(head, struct phonet_device, rcu);
-	kfree(pnd);
-}
-
 int phonet_address_del(struct net_device *dev, u8 addr)
 {
 	struct phonet_device_list *pndevs = phonet_device_list(dev_net(dev));
@@ -188,7 +180,7 @@ int phonet_address_del(struct net_device *dev, u8 addr)
 	mutex_unlock(&pndevs->lock);
 
 	if (pnd)
-		call_rcu(&pnd->rcu, phonet_device_rcu_free);
+		kfree_rcu(pnd, rcu);
 
 	return err;
 }
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 14b42f4..a606025 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -26,11 +26,6 @@
 #include <net/act_api.h>
 #include <net/netlink.h>
 
-static void tcf_common_free_rcu(struct rcu_head *head)
-{
-	kfree(container_of(head, struct tcf_common, tcfc_rcu));
-}
-
 void tcf_hash_destroy(struct tcf_common *p, struct tcf_hashinfo *hinfo)
 {
 	unsigned int h = tcf_hash(p->tcfc_index, hinfo->hmask);
@@ -47,7 +42,7 @@ void tcf_hash_destroy(struct tcf_common *p, struct tcf_hashinfo *hinfo)
 			 * gen_estimator est_timer() might access p->tcfc_lock
 			 * or bstats, wait a RCU grace period before freeing p
 			 */
-			call_rcu(&p->tcfc_rcu, tcf_common_free_rcu);
+			kfree_rcu(p, tcfc_rcu);
 			return;
 		}
 	}
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 8a16307..b3b9b32 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -96,11 +96,6 @@ nla_put_failure:
 	goto done;
 }
 
-static void tcf_police_free_rcu(struct rcu_head *head)
-{
-	kfree(container_of(head, struct tcf_police, tcf_rcu));
-}
-
 static void tcf_police_destroy(struct tcf_police *p)
 {
 	unsigned int h = tcf_hash(p->tcf_index, POL_TAB_MASK);
@@ -121,7 +116,7 @@ static void tcf_police_destroy(struct tcf_police *p)
 			 * gen_estimator est_timer() might access p->tcf_lock
 			 * or bstats, wait a RCU grace period before freeing p
 			 */
-			call_rcu(&p->tcf_rcu, tcf_police_free_rcu);
+			kfree_rcu(p, tcf_rcu);
 			return;
 		}
 	}
@@ -401,7 +396,6 @@ static void __exit
 police_cleanup_module(void)
 {
 	tcf_unregister_action(&act_police_ops);
-	rcu_barrier(); /* Wait for completion of call_rcu()'s (tcf_police_free_rcu) */
 }
 
 module_init(police_init_module);
diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index faf71d1..3c06c87 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -219,7 +219,7 @@ int sctp_del_bind_addr(struct sctp_bind_addr *bp, union sctp_addr *del_addr)
 	}
 
 	if (found) {
-		call_rcu(&addr->rcu, sctp_local_addr_free);
+		kfree_rcu(addr, rcu);
 		SCTP_DBG_OBJCNT_DEC(addr);
 		return 0;
 	}
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 865ce7b..185fe05 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -123,7 +123,7 @@ static int sctp_inet6addr_event(struct notifier_block *this, unsigned long ev,
 		}
 		spin_unlock_bh(&sctp_local_addr_lock);
 		if (found)
-			call_rcu(&addr->rcu, sctp_local_addr_free);
+			kfree_rcu(addr, rcu);
 		break;
 	}
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index d5bf91d..065d999 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -230,13 +230,6 @@ static void sctp_free_local_addr_list(void)
 	}
 }
 
-void sctp_local_addr_free(struct rcu_head *head)
-{
-	struct sctp_sockaddr_entry *e = container_of(head,
-				struct sctp_sockaddr_entry, rcu);
-	kfree(e);
-}
-
 /* Copy the local addresses which are valid for 'scope' into 'bp'.  */
 int sctp_copy_local_addr_list(struct sctp_bind_addr *bp, sctp_scope_t scope,
 			      gfp_t gfp, int copy_flags)
@@ -681,7 +674,7 @@ static int sctp_inetaddr_event(struct notifier_block *this, unsigned long ev,
 		}
 		spin_unlock_bh(&sctp_local_addr_lock);
 		if (found)
-			call_rcu(&addr->rcu, sctp_local_addr_free);
+			kfree_rcu(addr, rcu);
 		break;
 	}
 
diff --git a/net/socket.c b/net/socket.c
index 310d16b..c2ed7c9 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -263,15 +263,6 @@ static struct inode *sock_alloc_inode(struct super_block *sb)
 	return &ei->vfs_inode;
 }
 
-
-
-static void wq_free_rcu(struct rcu_head *head)
-{
-	struct socket_wq *wq = container_of(head, struct socket_wq, rcu);
-
-	kfree(wq);
-}
-
 static void sock_destroy_inode(struct inode *inode)
 {
 	struct socket_alloc *ei;
@@ -279,7 +270,7 @@ static void sock_destroy_inode(struct inode *inode)
 
 	ei = container_of(inode, struct socket_alloc, vfs_inode);
 	wq = rcu_dereference_protected(ei->socket.wq, 1);
-	call_rcu(&wq->rcu, wq_free_rcu);
+	kfree_rcu(wq, rcu);
 	kmem_cache_free(sock_inode_cachep, ei);
 }
 
diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index c6ca866..f66baf4 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -69,18 +69,6 @@ error:
 EXPORT_SYMBOL_GPL(user_instantiate);
 
 /*
- * dispose of the old data from an updated user defined key
- */
-static void user_update_rcu_disposal(struct rcu_head *rcu)
-{
-	struct user_key_payload *upayload;
-
-	upayload = container_of(rcu, struct user_key_payload, rcu);
-
-	kfree(upayload);
-}
-
-/*
  * update a user defined key
  * - the key's semaphore is write-locked
  */
@@ -114,7 +102,7 @@ int user_update(struct key *key, const void *data, size_t datalen)
 		key->expiry = 0;
 	}
 
-	call_rcu(&zap->rcu, user_update_rcu_disposal);
+	kfree_rcu(zap, rcu);
 
 error:
 	return ret;
@@ -145,7 +133,7 @@ void user_revoke(struct key *key)
 
 	if (upayload) {
 		rcu_assign_pointer(key->payload.data, NULL);
-		call_rcu(&upayload->rcu, user_update_rcu_disposal);
+		kfree_rcu(upayload, rcu);
 	}
 }
 
diff --git a/security/selinux/netif.c b/security/selinux/netif.c
index d6095d6..58cc481 100644
--- a/security/selinux/netif.c
+++ b/security/selinux/netif.c
@@ -104,22 +104,6 @@ static int sel_netif_insert(struct sel_netif *netif)
 }
 
 /**
- * sel_netif_free - Frees an interface entry
- * @p: the entry's RCU field
- *
- * Description:
- * This function is designed to be used as a callback to the call_rcu()
- * function so that memory allocated to a hash table interface entry can be
- * released safely.
- *
- */
-static void sel_netif_free(struct rcu_head *p)
-{
-	struct sel_netif *netif = container_of(p, struct sel_netif, rcu_head);
-	kfree(netif);
-}
-
-/**
  * sel_netif_destroy - Remove an interface record from the table
  * @netif: the existing interface record
  *
@@ -131,7 +115,7 @@ static void sel_netif_destroy(struct sel_netif *netif)
 {
 	list_del_rcu(&netif->list);
 	sel_netif_total--;
-	call_rcu(&netif->rcu_head, sel_netif_free);
+	kfree_rcu(netif, rcu_head);
 }
 
 /**
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 0a7ed5b..1e88485 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -2187,7 +2187,6 @@ static const struct flag flags[] = {
 	{ "TASKLET_SOFTIRQ", 6 },
 	{ "SCHED_SOFTIRQ", 7 },
 	{ "HRTIMER_SOFTIRQ", 8 },
-	{ "RCU_SOFTIRQ", 9 },
 
 	{ "HRTIMER_NORESTART", 0 },
 	{ "HRTIMER_RESTART", 1 },
