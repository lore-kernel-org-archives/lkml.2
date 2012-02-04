Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab2BDBvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 20:51:40 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:35790 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517Ab2BDBqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 20:46:06 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 44/47] rcu: Remove redundant check for rcu_head misalignment
Date: Fri,  3 Feb 2012 17:45:19 -0800
Message-Id: <1328319922-30828-44-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120204014452.GA29811@linux.vnet.ibm.com>
 <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020401-4242-0000-0000-000000AEC5C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

There is now an unconditional check for rcu_head misalignment in
__call_rcu(), so remove the old conditional one in debug_rcu_head_queue().

Reported-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/rcu.h b/kernel/rcu.h
index a074b0b..30876f4 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -50,7 +50,6 @@ extern struct debug_obj_descr rcuhead_debug_descr;
 
 static inline void debug_rcu_head_queue(struct rcu_head *head)
 {
-	WARN_ON_ONCE((unsigned long)head & 0x3);
 	debug_object_activate(head, &rcuhead_debug_descr);
 	debug_object_active_state(head, &rcuhead_debug_descr,
 				  STATE_RCU_HEAD_READY,
-- 
1.7.8

