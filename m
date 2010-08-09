Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab0HIWPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 18:15:32 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33663 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757203Ab0HIWPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 18:15:22 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/10] rcu: allow RCU CPU stall warning messages to be controlled in /sys
Date: Mon,  9 Aug 2010 15:15:05 -0700
Message-Id: <1281392111-25060-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100809221447.GA24358@linux.vnet.ibm.com>
References: <20100809221447.GA24358@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the permissions of the rcu_cpu_stall_suppress to 644 to enable RCU
CPU stall warnings to be enabled and disabled at runtime via sysfs.

Suggested-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f3d5906..5d910be 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -145,7 +145,7 @@ module_param(qlowmark, int, 0);
 
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 int rcu_cpu_stall_suppress __read_mostly;
-module_param(rcu_cpu_stall_suppress, int, 0);
+module_param(rcu_cpu_stall_suppress, int, 0644);
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
-- 
1.7.0.6

