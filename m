Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750854Ab0HHEkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 00:40:13 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36926 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab0HHEkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 00:40:10 -0400
Date: Sat, 7 Aug 2010 21:40:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, laijs@cn.fujitsu.com,
        penguin-kernel@I-love.SAKURA.ne.jp
Subject: [GIT PULL rcu/next] RCU sparse modifications etc.
Message-ID: <20100808044006.GA12957@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This pull request finally provides the rest of Arnd Bergmann's sparse-RCU
work, along with a few other changes.  These have been tested repeatedly
and heavily in my tree, so could go into 2.6.36 if desired.

These changes are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next

------------------>
Arnd Bergmann (17):
      rculist: avoid __rcu annotations
      cgroups: __rcu annotations
      credentials: rcu annotation
      keys: __rcu annotations
      nfs: __rcu annotations
      perf_event: __rcu annotations
      input: __rcu annotations
      net/netfilter: __rcu annotations
      kvm: add __rcu annotations
      net: __rcu annotations for drivers
      notifiers: __rcu annotations
      radix-tree: __rcu annotations
      idr: __rcu annotations
      kernel: __rcu annotations
      net: __rcu annotations
      kvm: more __rcu annotations
      vhost: add __rcu annotations

Lai Jiangshan (2):
      rcutorture: add random preemption
      rcu: simplify the usage of percpu data

Paul E. McKenney (6):
      net: convert to rcu_dereference_index_check()
      rcu: define __rcu address space modifier for sparse
      rcu: add shiny new debug assists to Documentation/RCU/checklist.txt
      rcu: make CPU stall warning timeout configurable
      rcu: add boot parameter to suppress RCU CPU stall warning messages
      rcu: improve kerneldoc for rcu_read_lock(), call_rcu(), and synchronize_rcu()

Tetsuo Handa (1):
      Add RCU check for find_task_by_vpid().

 Documentation/RCU/checklist.txt      |   23 ++
 arch/x86/include/asm/kvm_host.h      |    2 +-
 drivers/input/evdev.c                |    2 +-
 drivers/net/bnx2.h                   |    2 +-
 drivers/net/bnx2x.h                  |    2 +-
 drivers/net/cnic.h                   |    2 +-
 drivers/net/macvtap.c                |    2 +-
 drivers/vhost/net.c                  |   15 +-
 drivers/vhost/vhost.c                |   29 ++-
 drivers/vhost/vhost.h                |   11 +-
 include/linux/cgroup.h               |    4 +-
 include/linux/compiler.h             |    4 +
 include/linux/cred.h                 |    2 +-
 include/linux/fdtable.h              |    6 +-
 include/linux/fs.h                   |    2 +-
 include/linux/genhd.h                |    6 +-
 include/linux/idr.h                  |    4 +-
 include/linux/if_macvlan.h           |    2 +-
 include/linux/igmp.h                 |    4 +-
 include/linux/init_task.h            |    4 +-
 include/linux/input.h                |    2 +-
 include/linux/iocontext.h            |    2 +-
 include/linux/key.h                  |    3 +-
 include/linux/kvm_host.h             |    6 +-
 include/linux/mm_types.h             |    2 +-
 include/linux/netdevice.h            |   12 +-
 include/linux/nfs_fs.h               |    2 +-
 include/linux/notifier.h             |   10 +-
 include/linux/perf_event.h           |    6 +-
 include/linux/radix-tree.h           |    4 +-
 include/linux/rculist.h              |   53 +++--
 include/linux/rculist_nulls.h        |   16 +-
 include/linux/rcupdate.h             |  374 ++++++++++++++++++++-------------
 include/linux/sched.h                |    8 +-
 include/linux/srcu.h                 |   27 ++-
 include/linux/sunrpc/auth_gss.h      |    4 +-
 include/net/cls_cgroup.h             |    3 +-
 include/net/dst.h                    |    2 +-
 include/net/fib_rules.h              |    2 +-
 include/net/garp.h                   |    2 +-
 include/net/inet_sock.h              |    2 +-
 include/net/ip6_tunnel.h             |    2 +-
 include/net/ipip.h                   |    6 +-
 include/net/net_namespace.h          |    2 +-
 include/net/netfilter/nf_conntrack.h |    2 +-
 include/net/netns/xfrm.h             |    2 +-
 include/net/sock.h                   |    4 +-
 kernel/cgroup.c                      |    2 +-
 kernel/pid.c                         |    3 +-
 kernel/rcupdate.c                    |    6 +-
 kernel/rcutorture.c                  |    6 +
 kernel/rcutree.c                     |   53 ++---
 kernel/rcutree.h                     |    7 +-
 kernel/rcutree_plugin.h              |   12 +-
 kernel/rcutree_trace.c               |    2 +-
 kernel/sched.c                       |    2 +-
 lib/Kconfig.debug                    |   24 +++
 lib/radix-tree.c                     |    2 +-
 net/802/stp.c                        |    4 +-
 net/ipv4/ip_gre.c                    |    2 +-
 net/ipv4/ipip.c                      |   10 +-
 net/ipv4/netfilter/nf_nat_core.c     |    2 +-
 net/ipv4/protocol.c                  |    2 +-
 net/ipv4/route.c                     |    2 +-
 net/ipv4/tcp.c                       |    4 +-
 net/ipv6/ip6_tunnel.c                |    6 +-
 net/ipv6/protocol.c                  |    2 +-
 net/ipv6/sit.c                       |   10 +-
 net/mac80211/ieee80211_i.h           |   15 +-
 net/mac80211/sta_info.h              |    4 +-
 net/netfilter/core.c                 |    2 +-
 net/netfilter/nf_conntrack_ecache.c  |    4 +-
 net/netfilter/nf_conntrack_extend.c  |    2 +-
 net/netfilter/nf_conntrack_proto.c   |    4 +-
 net/netfilter/nf_log.c               |    2 +-
 net/netfilter/nf_queue.c             |    2 +-
 net/netlabel/netlabel_domainhash.c   |    4 +-
 net/netlabel/netlabel_unlabeled.c    |    4 +-
 net/netlink/af_netlink.c             |    2 +-
 net/phonet/af_phonet.c               |    2 +-
 net/phonet/pn_dev.c                  |    2 +-
 net/socket.c                         |    2 +-
 82 files changed, 556 insertions(+), 346 deletions(-)
