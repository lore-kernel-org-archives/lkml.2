Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab0HIWP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 18:15:27 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59619 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757197Ab0HIWPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 18:15:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/10] rcu head remove init
Date: Mon,  9 Aug 2010 15:15:02 -0700
Message-Id: <1281392111-25060-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100809221447.GA24358@linux.vnet.ibm.com>
References: <20100809221447.GA24358@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

RCU heads really don't need to be initialized. Their state before call_rcu()
really does not matter.

We need to keep init/destroy_rcu_head_on_stack() though, since we want
debugobjects to be able to keep track of these objects.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: David S. Miller <davem@davemloft.net>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
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
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/rcupdate.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 3e1b662..27b44b3 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -75,12 +75,6 @@ extern void rcu_init(void);
 #error "Unknown RCU implementation specified to kernel configuration"
 #endif
 
-#define RCU_HEAD_INIT	{ .next = NULL, .func = NULL }
-#define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
-#define INIT_RCU_HEAD(ptr) do { \
-       (ptr)->next = NULL; (ptr)->func = NULL; \
-} while (0)
-
 /*
  * init_rcu_head_on_stack()/destroy_rcu_head_on_stack() are needed for dynamic
  * initialization and destruction of rcu_head on the stack. rcu_head structures
-- 
1.7.0.6

