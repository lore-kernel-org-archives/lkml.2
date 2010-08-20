Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0HTSqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 14:46:44 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50190 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab0HTSpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 14:45:51 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 7/7] rcu: add comment stating that list_empty() applies to RCU-protected lists
Date: Fri, 20 Aug 2010 11:45:45 -0700
Message-Id: <1282329945-26043-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100820184521.GA24715@linux.vnet.ibm.com>
References: <20100820184521.GA24715@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because list_empty() does not dereference any RCU-protected pointers, and
further does not pass such pointers to the caller (so that the caller
does not dereference them either), it is safe to use list_empty() on
RCU-protected lists.  There is no need for a list_empty_rcu().  This
commit adds a comment stating this explicitly.

Requested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rculist.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index c10b105..f31ef61 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -10,6 +10,15 @@
 #include <linux/rcupdate.h>
 
 /*
+ * Why is there no list_empty_rcu()?  Because list_empty() serves this
+ * purpose.  The list_empty() function fetches the RCU-protected pointer
+ * and compares it to the address of the list head, but neither dereferences
+ * this pointer itself nor provides this pointer to the caller.  Therefore,
+ * it is not necessary to use rcu_dereference(), so that list_empty() can
+ * be used anywhere you would want to use a list_empty_rcu().
+ */
+
+/*
  * return the ->next pointer of a list_head in an rcu safe
  * way, we must not access it directly
  */
-- 
1.7.0.6

