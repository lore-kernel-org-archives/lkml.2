Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab0HTSpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 14:45:54 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47908 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab0HTSpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 14:45:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/7] rcu: Upgrade srcu_read_lock() docbook about SRCU grace periods
Date: Fri, 20 Aug 2010 11:45:42 -0700
Message-Id: <1282329945-26043-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100820184521.GA24715@linux.vnet.ibm.com>
References: <20100820184521.GA24715@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is illegal to wait for an SRCU grace period while within the
corresponding flavor of SRCU read-side critical section.  Therefore,
this commit updates the srcu_read_lock() docbook accordingly.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/srcu.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 6f456a7..58971e8 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -139,7 +139,12 @@ static inline int srcu_read_lock_held(struct srcu_struct *sp)
  * @sp: srcu_struct in which to register the new reader.
  *
  * Enter an SRCU read-side critical section.  Note that SRCU read-side
- * critical sections may be nested.
+ * critical sections may be nested.  However, it is illegal to
+ * call anything that waits on an SRCU grace period for the same
+ * srcu_struct, whether directly or indirectly.  Please note that
+ * one way to indirectly wait on an SRCU grace period is to acquire
+ * a mutex that is held elsewhere while calling synchronize_srcu() or
+ * synchronize_srcu_expedited().
  */
 static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 {
-- 
1.7.0.6

