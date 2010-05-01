Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab0EAAZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 20:25:54 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41989 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735Ab0EAAZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 20:25:52 -0400
Date: Fri, 30 Apr 2010 17:25:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH tip/core/urgent 0/10] v2: Fix RCU lockdep splats
Message-ID: <20100501002548.GA27375@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset contains ten fixes for various lockdep splats.  The first
two sets are repostings/revisions, the rest new.  The new patches have
all been posted to LKML, but this is the first time for inclusion.

o	rcu: v2: optionally leave lockdep enabled after RCU lockdep splat
	This is a repost that makes the one-splat-per-boot the default,
	but allows those who want multiple splats to get this behavior
	via a new CONFIG_PROVE_RCU_REPEATEDLY configuration parameter.
	(Original from Lai Jiangshan.)

o	KEYS: Fix an RCU warning
	KEYS: Fix an RCU warning in the reading of user keys
	Fixes for RCU-lockdep splats from David Howells for
	security/keys.  Repost of http://lkml.org/lkml/2010/4/22/411.

o	cgroup: Fix an RCU warning in cgroup_path()
	cgroup: Fix an RCU warning in alloc_css_id()
	sched: Fix an RCU warning in print_task()
	cgroup: Check task_lock in task_subsys_state()
	Fixes for new RCU-lockdep splats in cgroups and sched from
	Li Zefan.

o	memcg: css_id() must be called under rcu_read_lock()
	Fixes for new RCU-lockdep splats in memcg from Kamazawa Hiroyuki.

o	blk-cgroup: Fix RCU correctness warning in cfq_init_queue()
	Fix for new RCU-lockdep splat in I/O scheduler from Vivek Goyal.

o	vfs: fix RCU-lockdep false positive due to /proc access
	Fix for new RCU-lockdep splat from fdtable.h, with much
	debugging assist from Eric Dumazet.


 b/block/cfq-iosched.c          |    2 ++
 b/include/linux/cgroup.h       |    1 +
 b/include/linux/fdtable.h      |    3 ++-
 b/include/linux/rcupdate.h     |   15 +++++++++++----
 b/kernel/cgroup.c              |   12 +++++++++---
 b/kernel/lockdep.c             |    2 ++
 b/kernel/sched_debug.c         |    2 ++
 b/lib/Kconfig.debug            |   12 ++++++++++++
 b/mm/memcontrol.c              |   21 ++++++++++++++++-----
 b/security/keys/request_key.c  |   13 ++++++++-----
 b/security/keys/user_defined.c |    3 ++-
 kernel/cgroup.c                |    4 ++--
 12 files changed, 69 insertions(+), 21 deletions(-)
