Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1EHP3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 11:29:16 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52165 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab1EHP3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 11:29:14 -0400
Date: Sun, 8 May 2011 08:18:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110508151848.GA21906@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This pull request covers RCU chnages for 2.6.40.  The major new features
are RCU priority boosting and the addition of kfree_rcu(), the latter
courtesy of Lai Jiangshan.  These two features cover well over half
of the commits.  There are a number of smaller features and bug fixes.
All have been sent to LKML in the following batches:

0.	https://lkml.org/lkml/2011/2/22/660: RCU priority boosting preview
1.	https://lkml.org/lkml/2011/5/1/19: RCU priority boosting, kfree_rcu()
2.	https://lkml.org/lkml/2011/5/2/40: More uses of kfree_rcu()
3.	https://lkml.org/lkml/2011/5/8/60: miscellaneous

The kfree_rcu() uses in the pull request have Acked-by:s from the
maintainers.  I have some additional kfree_rcu() requests that lack
Acked-by:s, and I will deal with these later.

These channges are available in the -rcu git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next

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

Paul E. McKenney (34):
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

 Documentation/RCU/00-INDEX          |    2 +-
 Documentation/RCU/stallwarn.txt     |   23 +-
 Documentation/RCU/trace.txt         |  295 +++++++++++++----
 Documentation/filesystems/proc.txt  |    1 -
 drivers/net/ixgbe/ixgbe_main.c      |    7 +-
 drivers/net/macvlan.c               |   10 +-
 include/linux/interrupt.h           |    1 -
 include/linux/rcupdate.h            |   70 ++++-
 include/linux/rcutiny.h             |    8 +
 include/linux/rcutree.h             |   13 +
 include/net/sctp/sctp.h             |    1 -
 include/trace/events/irq.h          |    3 +-
 init/Kconfig                        |    2 +-
 kernel/cgroup.c                     |   27 +--
 kernel/perf_event.c                 |   20 +-
 kernel/rcupdate.c                   |   32 ++-
 kernel/rcutiny.c                    |   45 ++--
 kernel/rcutiny_plugin.h             |  203 +++++------
 kernel/rcutorture.c                 |   26 +-
 kernel/rcutree.c                    |  656 ++++++++++++++++++++++++++++-------
 kernel/rcutree.h                    |  113 +++++--
 kernel/rcutree_plugin.h             |  575 ++++++++++++++++++++++++-------
 kernel/rcutree_trace.c              |  192 +++++++++--
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
 56 files changed, 1797 insertions(+), 935 deletions(-)
