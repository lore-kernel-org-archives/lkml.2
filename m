Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab2FHE1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 00:27:44 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:51066 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2FHE1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 00:27:09 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH rcu 5/8] rcu: Dump only the current CPU's buffers for idle-entry/exit warnings
Date: Thu,  7 Jun 2012 21:26:52 -0700
Message-Id: <1339129615-1795-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339129615-1795-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120608042632.GA1250@linux.vnet.ibm.com>
 <1339129615-1795-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060804-4242-0000-0000-000001E80105
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Problems in RCU idle entry and exit are almost always confined to the
offending CPU.  This commit therefore switches ftrace_dump() from
DUMP_ALL to DUMP_ORIG.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Tested-by: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
---
 kernel/rcutree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 3b0f133..3b64896 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -357,7 +357,7 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		trace_rcu_dyntick("Error on entry: not idle task", oldval, 0);
-		ftrace_dump(DUMP_ALL);
+		ftrace_dump(DUMP_ORIG);
 		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
 			  current->pid, current->comm,
 			  idle->pid, idle->comm); /* must be idle task! */
@@ -467,7 +467,7 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 
 		trace_rcu_dyntick("Error on exit: not idle task",
 				  oldval, rdtp->dynticks_nesting);
-		ftrace_dump(DUMP_ALL);
+		ftrace_dump(DUMP_ORIG);
 		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
 			  current->pid, current->comm,
 			  idle->pid, idle->comm); /* must be idle task! */
-- 
1.7.8

