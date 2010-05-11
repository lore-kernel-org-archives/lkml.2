Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0EKXdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 19:33:19 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44071 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab0EKXdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 19:33:12 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH RFC tip/core/rcu 02/11] rcu head introduce rcu head init on stack
Date: Tue, 11 May 2010 16:32:57 -0700
Message-Id: <1273620786-20392-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100511233241.GA20250@linux.vnet.ibm.com>
References: <20100511233241.GA20250@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

PEM:
o     Would it be possible to make this bisectable as follows?

      a.      Insert a new patch after current patch 4/6 that
              defines destroy_rcu_head_on_stack(),
              init_rcu_head_on_stack(), and init_rcu_head() with
              their !CONFIG_DEBUG_OBJECTS_RCU_HEAD definitions.

This patch performs this transition.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: David S. Miller <davem@davemloft.net>
CC: akpm@linux-foundation.org
CC: mingo@elte.hu
CC: laijs@cn.fujitsu.com
CC: dipankar@in.ibm.com
CC: josh@joshtriplett.org
CC: dvhltc@us.ibm.com
CC: niv@us.ibm.com
CC: tglx@linutronix.de
CC: peterz@infradead.org
CC: rostedt@goodmis.org
CC: Valdis.Kletnieks@vt.edu
CC: dhowells@redhat.com
CC: eric.dumazet@gmail.com
CC: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 23be3a7..b653b4a 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -79,6 +79,14 @@ extern void rcu_init(void);
        (ptr)->next = NULL; (ptr)->func = NULL; \
 } while (0)
 
+static inline void init_rcu_head_on_stack(struct rcu_head *head)
+{
+}
+
+static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
+{
+}
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 extern struct lockdep_map rcu_lock_map;
-- 
1.7.0.6

