Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab0GNUQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:16:27 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33243 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757506Ab0GNUKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:10:15 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        Arnd Bergmann <arnd@arndb.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH RFC tip/core/rcu 10/30] notifiers: __rcu annotations
Date: Wed, 14 Jul 2010 13:09:44 -0700
Message-Id: <1279138204-12849-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100714200945.GA10535@linux.vnet.ibm.com>
References: <20100714200945.GA10535@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 include/linux/notifier.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index 540703b..ebf7210 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -49,28 +49,28 @@
 
 struct notifier_block {
 	int (*notifier_call)(struct notifier_block *, unsigned long, void *);
-	struct notifier_block *next;
+	struct notifier_block __rcu *next;
 	int priority;
 };
 
 struct atomic_notifier_head {
 	spinlock_t lock;
-	struct notifier_block *head;
+	struct notifier_block __rcu *head;
 };
 
 struct blocking_notifier_head {
 	struct rw_semaphore rwsem;
-	struct notifier_block *head;
+	struct notifier_block __rcu *head;
 };
 
 struct raw_notifier_head {
-	struct notifier_block *head;
+	struct notifier_block __rcu *head;
 };
 
 struct srcu_notifier_head {
 	struct mutex mutex;
 	struct srcu_struct srcu;
-	struct notifier_block *head;
+	struct notifier_block __rcu *head;
 };
 
 #define ATOMIC_INIT_NOTIFIER_HEAD(name) do {	\
-- 
1.7.0.6

