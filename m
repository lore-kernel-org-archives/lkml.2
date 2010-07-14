Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab0GNUKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:10:24 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36537 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757473Ab0GNUKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:10:14 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        Arnd Bergmann <arnd@arndb.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 06/30] keys: __rcu annotations
Date: Wed, 14 Jul 2010 13:09:40 -0700
Message-Id: <1279138204-12849-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100714200945.GA10535@linux.vnet.ibm.com>
References: <20100714200945.GA10535@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
---
 include/linux/cred.h |    2 +-
 include/linux/key.h  |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 75c0fa8..94d2301 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -84,7 +84,7 @@ struct thread_group_cred {
 	atomic_t	usage;
 	pid_t		tgid;			/* thread group process ID */
 	spinlock_t	lock;
-	struct key	*session_keyring;	/* keyring inherited over fork */
+	struct key __rcu *session_keyring;	/* keyring inherited over fork */
 	struct key	*process_keyring;	/* keyring private to this process */
 	struct rcu_head	rcu;			/* RCU deletion hook */
 };
diff --git a/include/linux/key.h b/include/linux/key.h
index cd50dfa..3db0adc 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -178,8 +178,9 @@ struct key {
 	 */
 	union {
 		unsigned long		value;
+		void __rcu		*rcudata;
 		void			*data;
-		struct keyring_list	*subscriptions;
+		struct keyring_list __rcu *subscriptions;
 	} payload;
 };
 
-- 
1.7.0.6

