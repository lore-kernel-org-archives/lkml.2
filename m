Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819Ab1EANfz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:35:55 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38360 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756145Ab1EANW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:29 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 21/86] rcu: add DEBUG_OBJECTS_RCU_HEAD check for alignment
Date: Sun,  1 May 2011 06:21:01 -0700
Message-Id: <1304256126-26015-21-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Verify that rcu_head structures are aligned to a four-byte boundary.
This check is enabled by CONFIG_DEBUG_OBJECTS_RCU_HEAD.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9e169c2..c7aeacf 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -785,6 +785,7 @@ extern struct debug_obj_descr rcuhead_debug_descr;
 
 static inline void debug_rcu_head_queue(struct rcu_head *head)
 {
+	WARN_ON_ONCE((unsigned long)head & 0x3);
 	debug_object_activate(head, &rcuhead_debug_descr);
 	debug_object_active_state(head, &rcuhead_debug_descr,
 				  STATE_RCU_HEAD_READY,
-- 
1.7.3.2

