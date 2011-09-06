Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab1IGG2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:28:09 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40062 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab1IGGU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:56 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Andi Kleen <ak@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/55] rcu: Fix mismatched variable in rcutree_trace.c
Date: Tue,  6 Sep 2011 11:00:01 -0700
Message-Id: <1315332049-2604-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

rcutree.c defines rcu_cpu_kthread_cpu as int, not unsigned int,
so the extern has to follow that.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 4e14487..8827b34 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -49,7 +49,7 @@
 #ifdef CONFIG_RCU_BOOST
 
 DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
-DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_cpu);
+DECLARE_PER_CPU(int, rcu_cpu_kthread_cpu);
 DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
 DECLARE_PER_CPU(char, rcu_cpu_has_work);
 
-- 
1.7.3.2

