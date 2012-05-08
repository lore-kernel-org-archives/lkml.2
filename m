Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab2EHPza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:55:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62138 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005Ab2EHPz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:55:27 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: kay@vrfy.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        isdn@linux-pingi.de, akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 2/4] locking: add KERN_CONT when needed to self test
Date: Tue,  8 May 2012 17:56:11 +0200
Message-Id: <1336492573-17530-2-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1336492573-17530-1-git-send-email-levinsasha928@gmail.com>
References: <1336492573-17530-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this behaviour:

                    A-A deadlock:
  ok  |
  ok  |
  ok  |
  ok  |
  ok  |
  ok  |

 Revealed due to a new modification to printk().

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 lib/locking-selftest.c |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 7aae0f2..885890a 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -959,16 +959,16 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 	if (debug_locks != expected) {
 		if (expected_failure) {
 			expected_testcase_failures++;
-			printk("failed|");
+			printk(KERN_CONT "failed|");
 		} else {
 			unexpected_testcase_failures++;
 
-			printk("FAILED|");
+			printk(KERN_CONT "FAILED|");
 			dump_stack();
 		}
 	} else {
 		testcase_successes++;
-		printk("  ok  |");
+		printk(KERN_CONT "  ok  |");
 	}
 	testcase_total++;
 
@@ -998,26 +998,26 @@ static inline void print_testname(const char *testname)
 #define DO_TESTCASE_1(desc, name, nr)				\
 	print_testname(desc"/"#nr);				\
 	dotest(name##_##nr, SUCCESS, LOCKTYPE_RWLOCK);		\
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 #define DO_TESTCASE_1B(desc, name, nr)				\
 	print_testname(desc"/"#nr);				\
 	dotest(name##_##nr, FAILURE, LOCKTYPE_RWLOCK);		\
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 #define DO_TESTCASE_3(desc, name, nr)				\
 	print_testname(desc"/"#nr);				\
 	dotest(name##_spin_##nr, FAILURE, LOCKTYPE_SPIN);	\
 	dotest(name##_wlock_##nr, FAILURE, LOCKTYPE_RWLOCK);	\
 	dotest(name##_rlock_##nr, SUCCESS, LOCKTYPE_RWLOCK);	\
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 #define DO_TESTCASE_3RW(desc, name, nr)				\
 	print_testname(desc"/"#nr);				\
 	dotest(name##_spin_##nr, FAILURE, LOCKTYPE_SPIN|LOCKTYPE_RWLOCK);\
 	dotest(name##_wlock_##nr, FAILURE, LOCKTYPE_RWLOCK);	\
 	dotest(name##_rlock_##nr, SUCCESS, LOCKTYPE_RWLOCK);	\
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 #define DO_TESTCASE_6(desc, name)				\
 	print_testname(desc);					\
@@ -1027,7 +1027,7 @@ static inline void print_testname(const char *testname)
 	dotest(name##_mutex, FAILURE, LOCKTYPE_MUTEX);		\
 	dotest(name##_wsem, FAILURE, LOCKTYPE_RWSEM);		\
 	dotest(name##_rsem, FAILURE, LOCKTYPE_RWSEM);		\
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 #define DO_TESTCASE_6_SUCCESS(desc, name)			\
 	print_testname(desc);					\
@@ -1037,7 +1037,7 @@ static inline void print_testname(const char *testname)
 	dotest(name##_mutex, SUCCESS, LOCKTYPE_MUTEX);		\
 	dotest(name##_wsem, SUCCESS, LOCKTYPE_RWSEM);		\
 	dotest(name##_rsem, SUCCESS, LOCKTYPE_RWSEM);		\
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 /*
  * 'read' variant: rlocks must not trigger.
@@ -1050,7 +1050,7 @@ static inline void print_testname(const char *testname)
 	dotest(name##_mutex, FAILURE, LOCKTYPE_MUTEX);		\
 	dotest(name##_wsem, FAILURE, LOCKTYPE_RWSEM);		\
 	dotest(name##_rsem, FAILURE, LOCKTYPE_RWSEM);		\
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 #define DO_TESTCASE_2I(desc, name, nr)				\
 	DO_TESTCASE_1("hard-"desc, name##_hard, nr);		\
@@ -1146,32 +1146,32 @@ void locking_selftest(void)
 
 	printk("  --------------------------------------------------------------------------\n");
 	print_testname("recursive read-lock");
-	printk("             |");
+	printk(KERN_CONT "             |");
 	dotest(rlock_AA1, SUCCESS, LOCKTYPE_RWLOCK);
-	printk("             |");
+	printk(KERN_CONT "             |");
 	dotest(rsem_AA1, FAILURE, LOCKTYPE_RWSEM);
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	print_testname("recursive read-lock #2");
-	printk("             |");
+	printk(KERN_CONT "             |");
 	dotest(rlock_AA1B, SUCCESS, LOCKTYPE_RWLOCK);
-	printk("             |");
+	printk(KERN_CONT "             |");
 	dotest(rsem_AA1B, FAILURE, LOCKTYPE_RWSEM);
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	print_testname("mixed read-write-lock");
-	printk("             |");
+	printk(KERN_CONT "             |");
 	dotest(rlock_AA2, FAILURE, LOCKTYPE_RWLOCK);
-	printk("             |");
+	printk(KERN_CONT "             |");
 	dotest(rsem_AA2, FAILURE, LOCKTYPE_RWSEM);
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	print_testname("mixed write-read-lock");
-	printk("             |");
+	printk(KERN_CONT "             |");
 	dotest(rlock_AA3, FAILURE, LOCKTYPE_RWLOCK);
-	printk("             |");
+	printk(KERN_CONT "             |");
 	dotest(rsem_AA3, FAILURE, LOCKTYPE_RWSEM);
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	printk("  --------------------------------------------------------------------------\n");
 
-- 
1.7.8.5

