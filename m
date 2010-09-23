Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0IWAvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 20:51:09 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59335 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab0IWAvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 20:51:02 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com,
        Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/8] kernel: Removing undead ifdef CONFIG_DEBUG_LOCK_ALLOC
Date: Wed, 22 Sep 2010 17:50:49 -0700
Message-Id: <1285203053-22068-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100923005033.GA22006@linux.vnet.ibm.com>
References: <20100923005033.GA22006@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>

The CONFIG_DEBUG_LOCK_ALLOC ifdef isn't necessary at this point, because it is
checked in an outer ifdef level already and has no effect here.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/srcu.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/srcu.c b/kernel/srcu.c
index 2980da3..c71e075 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -46,11 +46,9 @@ static int init_srcu_struct_fields(struct srcu_struct *sp)
 int __init_srcu_struct(struct srcu_struct *sp, const char *name,
 		       struct lock_class_key *key)
 {
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
 	/* Don't re-initialize a lock while it is held. */
 	debug_check_no_locks_freed((void *)sp, sizeof(*sp));
 	lockdep_init_map(&sp->dep_map, name, key, 0);
-#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 	return init_srcu_struct_fields(sp);
 }
 EXPORT_SYMBOL_GPL(__init_srcu_struct);
-- 
1.7.0.6

