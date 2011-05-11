Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab1EKU7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:59:51 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35498 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438Ab1EKU7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:59:49 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/3] atomic: add atomic_or()
Date: Wed, 11 May 2011 13:59:36 -0700
Message-Id: <1305147577-1812-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110511205915.GA1731@linux.vnet.ibm.com>
References: <20110511205915.GA1731@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

An atomic_or() function is needed by TREE_RCU to avoid deadlock, so
add a generic version.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/atomic.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/atomic.h b/include/linux/atomic.h
index 96c038e..ee456c7 100644
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -34,4 +34,17 @@ static inline int atomic_inc_not_zero_hint(atomic_t *v, int hint)
 }
 #endif
 
+#ifndef CONFIG_ARCH_HAS_ATOMIC_OR
+static inline void atomic_or(int i, atomic_t *v)
+{
+	int old;
+	int new;
+
+	do {
+		old = atomic_read(v);
+		new = old | i;
+	} while (atomic_cmpxchg(v, old, new) != old);
+}
+#endif /* #ifndef CONFIG_ARCH_HAS_ATOMIC_OR */
+
 #endif /* _LINUX_ATOMIC_H */
-- 
1.7.3.2

