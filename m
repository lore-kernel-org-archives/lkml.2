Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab1FHTgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:36:46 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48340 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab1FHTab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:30:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Andi Kleen <ak@linux.intel.com>,
        paulmck@linux.vnet.ibm.com
Subject: [PATCH tip/core/rcu 07/28] Fix mismatched variable in rcutree_trace.c
Date: Wed,  8 Jun 2011 12:29:46 -0700
Message-Id: <1307561407-13809-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110608192943.GA13211@linux.vnet.ibm.com>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

rcutree.c defines rcu_cpu_kthread_cpu as int, not unsigned int,
so the extern has to follow that.

Cc: paulmck@linux.vnet.ibm.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 9678cc3..91c56e5 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -47,7 +47,7 @@
 #include "rcutree.h"
 
 DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
-DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_cpu);
+DECLARE_PER_CPU(int, rcu_cpu_kthread_cpu);
 DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
 DECLARE_PER_CPU(char, rcu_cpu_has_work);
 
-- 
1.7.3.2

