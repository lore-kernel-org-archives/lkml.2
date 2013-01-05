Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab3AERL1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:11:27 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57803 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826Ab3AERKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:10:10 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/6] rcu: Make rcu_is_cpu_rrupt_from_idle helper functions static
Date: Sat,  5 Jan 2013 09:09:34 -0800
Message-Id: <1357405778-13903-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1357405778-13903-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130105170920.GA13766@linux.vnet.ibm.com>
 <1357405778-13903-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010517-7182-0000-0000-000004366671
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Triplett <josh@joshtriplett.org>

Both rcutiny and rcutree define a helper function named
rcu_is_cpu_rrupt_from_idle(), each used exactly once, later in the
same file.  This commit therefore declares these helper functions static.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny.c |    2 +-
 kernel/rcutree.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index e7dce58..9f72a0f 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -193,7 +193,7 @@ EXPORT_SYMBOL(rcu_is_cpu_idle);
  * interrupts don't count, we must be running at the first interrupt
  * level.
  */
-int rcu_is_cpu_rrupt_from_idle(void)
+static int rcu_is_cpu_rrupt_from_idle(void)
 {
 	return rcu_dynticks_nesting <= 1;
 }
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e441b77..cceda76 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -727,7 +727,7 @@ EXPORT_SYMBOL_GPL(rcu_lockdep_current_cpu_online);
  * interrupt from idle, return true.  The caller must have at least
  * disabled preemption.
  */
-int rcu_is_cpu_rrupt_from_idle(void)
+static int rcu_is_cpu_rrupt_from_idle(void)
 {
 	return __get_cpu_var(rcu_dynticks).dynticks_nesting <= 1;
 }
-- 
1.7.8

