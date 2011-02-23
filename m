Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab1BWBkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:40:01 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:35130 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab1BWBkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:40:00 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 05/11] rcu: add comment saying why DEBUG_OBJECTS_RCU_HEAD depends on PREEMPT.
Date: Tue, 22 Feb 2011 17:39:34 -0800
Message-Id: <1298425183-21265-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110223013917.GA20996@linux.vnet.ibm.com>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The build will break if you change the Kconfig to allow
DEBUG_OBJECTS_RCU_HEAD and !PREEMPT, so document the reasoning
near where the breakage would occur.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcupdate.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index afd21d1..f3240e9 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -214,6 +214,11 @@ static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
 		 * Ensure that queued callbacks are all executed.
 		 * If we detect that we are nested in a RCU read-side critical
 		 * section, we should simply fail, otherwise we would deadlock.
+		 * Note that the machinery to reliably determine whether
+		 * or not we are in an RCU read-side critical section
+		 * exists only in the preemptible RCU implementations
+		 * (TINY_PREEMPT_RCU and TREE_PREEMPT_RCU), which is why
+		 * DEBUG_OBJECTS_RCU_HEAD is disallowed if !PREEMPT.
 		 */
 		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
 		    irqs_disabled()) {
-- 
1.7.3.2

