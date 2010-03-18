Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab0CRTZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 15:25:24 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49723 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab0CRTZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 15:25:23 -0400
Date: Thu, 18 Mar 2010 12:25:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH tip/core/urgent 0/2] RCU lockdep fix and shrink RCU API
Message-ID: <20100318192513.GA10832@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This set has two patches, one from Lai Jiangshan that fixes RCU lockdep's
rcu_read_lock_sched_held() to correctly interpret things like
local_irq_disable() as starting a valid RCU-sched read-side critical
section, and one from Alexey Dobriyan that removes several useless
members of the RCU API.

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/DocBook/kernel-locking.tmpl   |    8 --------
 b/arch/powerpc/mm/pgtable.c                   |    1 -
 b/block/cfq-iosched.c                         |    1 -
 b/block/genhd.c                               |    1 -
 b/drivers/staging/batman-adv/hard-interface.c |    1 -
 b/fs/file.c                                   |    3 ---
 b/fs/fs-writeback.c                           |    1 -
 b/fs/partitions/check.c                       |    1 -
 b/include/linux/init_task.h                   |    1 -
 b/include/linux/rcupdate.h                    |    4 ++--
 b/mm/backing-dev.c                            |    1 -
 b/mm/slob.c                                   |    1 -
 b/security/selinux/avc.c                      |    1 -
 b/security/selinux/netnode.c                  |    2 --
 include/linux/rcupdate.h                      |    6 ------
 15 files changed, 2 insertions(+), 31 deletions(-)
