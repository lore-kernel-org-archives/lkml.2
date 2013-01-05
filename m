Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab3AERKN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:10:13 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:50256 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab3AERKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:10:09 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/6] rcu: Use new nesting value for rcu_dyntick trace in rcu_eqs_enter_common
Date: Sat,  5 Jan 2013 09:09:35 -0800
Message-Id: <1357405778-13903-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1357405778-13903-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130105170920.GA13766@linux.vnet.ibm.com>
 <1357405778-13903-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010517-5518-0000-0000-00000A80829C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zhong <zhong@linux.vnet.ibm.com>

This patch uses the real new value of dynticks_nesting instead of 0 in
rcu_eqs_enter_common().

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index cceda76..d145796 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -336,7 +336,7 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
 static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
 				bool user)
 {
-	trace_rcu_dyntick("Start", oldval, 0);
+	trace_rcu_dyntick("Start", oldval, rdtp->dynticks_nesting);
 	if (!user && !is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
-- 
1.7.8

