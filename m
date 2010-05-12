Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab0ELVd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:33:27 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49591 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757833Ab0ELVdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:33:25 -0400
Date: Wed, 12 May 2010 14:33:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH tip/core/rcu 0/23] infrastructure for sparse checks for RCU
 usage
Message-ID: <20100512213317.GA15085@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset pulls Arnd's sparse-checking commits out of the earlier
patchbomb (http://lkml.org/lkml/2010/5/4/298):

1.	Add an rcu_dereference_check() API in order to continue supporting
	the array-index use cases that would otherwise be invalidated
	by this change.
2.	Add an empty __rcu annotation API to reduce inter-commit dependency.
3-5.	Updates to vfs, net, and mce to avoid breakage by later commits.
6.	Introduce sparse __rcu functionality.
7.	Update rculist primitives to avoid false positives.
8-22.	Introduce __rcu annotations to cgroups, credentials, keys, nfs,
	net, perf_event, notifiers, radix-tree, idr, input, net-netfilter,
	kvm, and kernel.
23.	Introduce __rcu annotations and checks to vhost.

These have been reordered and consolidated to reduce inter-commit
dependencies.

							Thanx, Paul

 b/arch/x86/include/asm/kvm_host.h      |    2 
 b/arch/x86/kernel/cpu/mcheck/mce.c     |    2 
 b/drivers/input/evdev.c                |    2 
 b/drivers/net/bnx2.h                   |    2 
 b/drivers/net/bnx2x.h                  |    2 
 b/drivers/net/cnic.h                   |    2 
 b/drivers/net/macvtap.c                |    2 
 b/drivers/vhost/net.c                  |   11 -
 b/drivers/vhost/vhost.c                |   14 -
 b/drivers/vhost/vhost.h                |    4 
 b/include/linux/cgroup.h               |    4 
 b/include/linux/compiler.h             |    2 
 b/include/linux/cred.h                 |    2 
 b/include/linux/fdtable.h              |    1 
 b/include/linux/fs.h                   |    2 
 b/include/linux/genhd.h                |    6 
 b/include/linux/idr.h                  |    4 
 b/include/linux/if_bridge.h            |    3 
 b/include/linux/if_macvlan.h           |    2 
 b/include/linux/igmp.h                 |    4 
 b/include/linux/init_task.h            |    4 
 b/include/linux/input.h                |    2 
 b/include/linux/iocontext.h            |    2 
 b/include/linux/key.h                  |    3 
 b/include/linux/kvm_host.h             |    2 
 b/include/linux/mm_types.h             |    2 
 b/include/linux/netdevice.h            |   12 -
 b/include/linux/nfs_fs.h               |    2 
 b/include/linux/notifier.h             |   10 
 b/include/linux/perf_event.h           |    6 
 b/include/linux/radix-tree.h           |    4 
 b/include/linux/rculist.h              |   53 +++-
 b/include/linux/rculist_nulls.h        |   16 +
 b/include/linux/rcupdate.h             |   33 +++
 b/include/linux/sched.h                |    2 
 b/include/linux/srcu.h                 |   27 ++
 b/include/linux/sunrpc/auth_gss.h      |    4 
 b/include/net/dst.h                    |    2 
 b/include/net/fib_rules.h              |    2 
 b/include/net/garp.h                   |    2 
 b/include/net/inet_sock.h              |    2 
 b/include/net/ip6_tunnel.h             |    2 
 b/include/net/ipip.h                   |    6 
 b/include/net/net_namespace.h          |    2 
 b/include/net/netfilter/nf_conntrack.h |    2 
 b/include/net/netns/xfrm.h             |    2 
 b/include/net/sock.h                   |    4 
 b/kernel/cgroup.c                      |    2 
 b/kernel/pid.c                         |    2 
 b/kernel/rcupdate.c                    |    6 
 b/kernel/sched.c                       |    2 
 b/lib/Kconfig.debug                    |   13 +
 b/lib/radix-tree.c                     |    2 
 b/net/802/stp.c                        |    4 
 b/net/bridge/br_fdb.c                  |    2 
 b/net/bridge/br_private.h              |    8 
 b/net/bridge/netfilter/ebt_redirect.c  |    2 
 b/net/bridge/netfilter/ebt_ulog.c      |    4 
 b/net/bridge/netfilter/ebtables.c      |    4 
 b/net/ipv4/ip_gre.c                    |    2 
 b/net/ipv4/ipip.c                      |   10 
 b/net/ipv4/netfilter/nf_nat_core.c     |    2 
 b/net/ipv4/protocol.c                  |    2 
 b/net/ipv4/route.c                     |    2 
 b/net/ipv4/tcp.c                       |    4 
 b/net/ipv6/ip6_tunnel.c                |    6 
 b/net/ipv6/protocol.c                  |    2 
 b/net/ipv6/sit.c                       |   10 
 b/net/mac80211/ieee80211_i.h           |   15 -
 b/net/mac80211/sta_info.h              |    4 
 b/net/netfilter/core.c                 |    2 
 b/net/netfilter/nf_conntrack_ecache.c  |    4 
 b/net/netfilter/nf_conntrack_extend.c  |    2 
 b/net/netfilter/nf_conntrack_proto.c   |    4 
 b/net/netfilter/nf_log.c               |    2 
 b/net/netfilter/nf_queue.c             |    2 
 b/net/netfilter/nfnetlink_log.c        |    4 
 b/net/netfilter/nfnetlink_queue.c      |    4 
 b/net/netlabel/netlabel_domainhash.c   |    4 
 b/net/netlabel/netlabel_unlabeled.c    |    4 
 b/net/netlink/af_netlink.c             |    2 
 b/net/phonet/af_phonet.c               |    2 
 b/net/phonet/pn_dev.c                  |    2 
 b/net/socket.c                         |    2 
 include/linux/compiler.h               |    4 
 include/linux/fdtable.h                |    6 
 include/linux/kvm_host.h               |    4 
 include/linux/rcupdate.h               |  352 +++++++++++++++++++--------------
 include/linux/sched.h                  |    6 
 89 files changed, 498 insertions(+), 307 deletions(-)
