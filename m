Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab0ELVef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:34:35 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48435 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758178Ab0ELVeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:34:24 -0400
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
Subject: [PATCH RFC tip/core/rcu 14/23] notifiers: __rcu annotations
Date: Wed, 12 May 2010 14:33:33 -0700
Message-Id: <1273700022-16523-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100512213317.GA15085@linux.vnet.ibm.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com>
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
index fee6c2f..f05f5e4 100644
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

