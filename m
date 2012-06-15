Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab2FOUOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:14:30 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56804 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334Ab2FOUNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:13:44 -0400
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
Subject: [PATCH tip/core/rcu 14/14] rcu: Fix rcu_is_cpu_idle() #ifdef in TINY_RCU
Date: Fri, 15 Jun 2012 13:13:15 -0700
Message-Id: <1339791195-26389-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615201256.GA26120@linux.vnet.ibm.com>
 <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061520-2398-0000-0000-0000078AB7AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The rcu_is_cpu_idle() function is used if CONFIG_DEBUG_LOCK_ALLOC,
but TINY_RCU defines it only when CONFIG_PROVE_RCU.  This causes
build failures when CONFIG_DEBUG_LOCK_ALLOC=y but CONFIG_PROVE_RCU=n.
This commit therefore adjusts the #ifdefs for rcu_is_cpu_idle() so
that it is defined when CONFIG_DEBUG_LOCK_ALLOC=y.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 37a5444..547b1fe 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -172,7 +172,7 @@ void rcu_irq_enter(void)
 	local_irq_restore(flags);
 }
 
-#ifdef CONFIG_PROVE_RCU
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 /*
  * Test whether RCU thinks that the current CPU is idle.
@@ -183,7 +183,7 @@ int rcu_is_cpu_idle(void)
 }
 EXPORT_SYMBOL(rcu_is_cpu_idle);
 
-#endif /* #ifdef CONFIG_PROVE_RCU */
+#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 /*
  * Test whether the current CPU was interrupted from idle.  Nested
-- 
1.7.8

