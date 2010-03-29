Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab0C2Ojl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:39:41 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:60658 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab0C2Oji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:39:38 -0400
Message-Id: <20100329143702.016858955@efficios.com>
References: <20100329143405.252313609@efficios.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Mar 2010 10:34:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com,
       "David S. Miller" <davem@davemloft.net>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [patch 2/5] rcu head introduce rcu head init on stack
Content-Disposition: inline; filename=rcu-head-introduce-rcu-head-init.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Mon, 29 Mar 2010 14:37:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PEM:
o     Would it be possible to make this bisectable as follows?

      a.      Insert a new patch after current patch 4/6 that
              defines destroy_rcu_head_on_stack(),
              init_rcu_head_on_stack(), and init_rcu_head() with
              their !CONFIG_DEBUG_OBJECTS_RCU_HEAD definitions.

This patch performs this transition.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: David S. Miller <davem@davemloft.net>
CC: akpm@linux-foundation.org
CC: mingo@elte.hu
CC: laijs@cn.fujitsu.com
CC: dipankar@in.ibm.com
CC: josh@joshtriplett.org
CC: dvhltc@us.ibm.com
CC: niv@us.ibm.com
CC: tglx@linutronix.de
CC: peterz@infradead.org
CC: rostedt@goodmis.org
CC: Valdis.Kletnieks@vt.edu
CC: dhowells@redhat.com
CC: eric.dumazet@gmail.com
CC: Alexey Dobriyan <adobriyan@gmail.com>
---
 include/linux/rcupdate.h |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux.trees.git/include/linux/rcupdate.h
===================================================================
--- linux.trees.git.orig/include/linux/rcupdate.h	2010-03-29 09:43:35.000000000 -0400
+++ linux.trees.git/include/linux/rcupdate.h	2010-03-29 09:57:09.000000000 -0400
@@ -83,6 +83,14 @@ extern void rcu_scheduler_starting(void)
        (ptr)->next = NULL; (ptr)->func = NULL; \
 } while (0)
 
+static inline void init_rcu_head_on_stack(struct rcu_head *head)
+{
+}
+
+static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
+{
+}
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 extern struct lockdep_map rcu_lock_map;

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
