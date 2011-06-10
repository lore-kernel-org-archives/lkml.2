Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab1FJNan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:30:43 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40858 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263Ab1FJNaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:30:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=PgnT4vHU+Koism/rwm45iozPiH45ipNR4pYwpMJKL8P3EWNTwxiajL/Zxg64iVn83s
         uyTdcdsQ3RmxvZ6NoJvJRC7zgHzbpAZygHumlOF25pdxOXZvFLHSmA+Kp0/SgbmD1YCK
         nFq+09JPWoCCSS0GgH4qNQ+8rMI60exB7aruc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: =?UTF-8?q?=5BPATCH=204/4=5D=20sched=3A=20Generalize=20sleep=20inside=20spinlock=20detection?=
Date: Fri, 10 Jun 2011 15:30:22 +0200
Message-Id: <1307712622-11104-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1307712622-11104-1-git-send-email-fweisbec@gmail.com>
References: <1307712622-11104-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sleeping inside spinlock detection is actually used
for more general sleeping inside atomic sections
debugging: preemption disabled, rcu read side critical
sections, interrupts, interrupt disabled, etc...

Change the name of the config and its help section to
reflect its more general role.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-hacking.tmpl  |    2 +-
 Documentation/SubmitChecklist              |    2 +-
 Documentation/development-process/4.Coding |    2 +-
 Documentation/ja_JP/SubmitChecklist        |    2 +-
 Documentation/zh_CN/SubmitChecklist        |    2 +-
 include/linux/kernel.h                     |    2 +-
 kernel/sched.c                             |    2 +-
 lib/Kconfig.debug                          |    8 +++++---
 8 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/Documentation/DocBook/kernel-hacking.tmpl b/Documentation/DocBook/kernel-hacking.tmpl
index 7b3f493..07a9c48 100644
--- a/Documentation/DocBook/kernel-hacking.tmpl
+++ b/Documentation/DocBook/kernel-hacking.tmpl
@@ -409,7 +409,7 @@ cond_resched(); /* Will sleep */
 
   <para>
    You should always compile your kernel
-   <symbol>CONFIG_DEBUG_SPINLOCK_SLEEP</symbol> on, and it will warn
+   <symbol>CONFIG_DEBUG_ATOMIC_SLEEP</symbol> on, and it will warn
    you if you break these rules.  If you <emphasis>do</emphasis> break
    the rules, you will eventually lock up your box.
   </para>
diff --git a/Documentation/SubmitChecklist b/Documentation/SubmitChecklist
index da0382d..7b13be4 100644
--- a/Documentation/SubmitChecklist
+++ b/Documentation/SubmitChecklist
@@ -53,7 +53,7 @@ kernel patches.
 
 12: Has been tested with CONFIG_PREEMPT, CONFIG_DEBUG_PREEMPT,
     CONFIG_DEBUG_SLAB, CONFIG_DEBUG_PAGEALLOC, CONFIG_DEBUG_MUTEXES,
-    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_SPINLOCK_SLEEP all simultaneously
+    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_ATOMIC_SLEEP all simultaneously
     enabled.
 
 13: Has been build- and runtime tested with and without CONFIG_SMP and
diff --git a/Documentation/development-process/4.Coding b/Documentation/development-process/4.Coding
index f3f1a46..83f5f5b 100644
--- a/Documentation/development-process/4.Coding
+++ b/Documentation/development-process/4.Coding
@@ -244,7 +244,7 @@ testing purposes.  In particular, you should turn on:
  - DEBUG_SLAB can find a variety of memory allocation and use errors; it
    should be used on most development kernels.
 
- - DEBUG_SPINLOCK, DEBUG_SPINLOCK_SLEEP, and DEBUG_MUTEXES will find a
+ - DEBUG_SPINLOCK, DEBUG_ATOMIC_SLEEP, and DEBUG_MUTEXES will find a
    number of common locking errors.
 
 There are quite a few other debugging options, some of which will be
diff --git a/Documentation/ja_JP/SubmitChecklist b/Documentation/ja_JP/SubmitChecklist
index 2df4576..cb5507b 100644
--- a/Documentation/ja_JP/SubmitChecklist
+++ b/Documentation/ja_JP/SubmitChecklist
@@ -68,7 +68,7 @@ Linux „Ç´„Éº„Éç„É´„Éë„ÉÉ„ÉÅÊäïÁ®øËÄÖÂêë„Åë„ÉÅ„Çß„ÉÉ„ÇØ„É™„Çπ„Éà
 
 12: CONFIG_PREEMPT, CONFIG_DEBUG_PREEMPT, CONFIG_DEBUG_SLAB,
     CONFIG_DEBUG_PAGEALLOC, CONFIG_DEBUG_MUTEXES, CONFIG_DEBUG_SPINLOCK,
-    CONFIG_DEBUG_SPINLOCK_SLEEP „Åì„Çå„ÇâÂÖ®„Å¶„ÇíÂêåÊôÇ„Å´ÊúâÂäπ„Å´„Åó„Å¶Âãï‰ΩúÁ¢∫Ë™ç„Çí
+    CONFIG_DEBUG_ATOMIC_SLEEP „Åì„Çå„ÇâÂÖ®„Å¶„ÇíÂêåÊôÇ„Å´ÊúâÂäπ„Å´„Åó„Å¶Âãï‰ΩúÁ¢∫Ë™ç„Çí
     Ë°å„Å£„Å¶„Åè„Å†„Åï„ÅÑ„ÄÇ
 
 13: CONFIG_SMP, CONFIG_PREEMPT „ÇíÊúâÂäπ„Å´„Åó„ÅüÂ†¥Âêà„Å®ÁÑ°Âäπ„Å´„Åó„ÅüÂ†¥Âêà„ÅÆ‰∏°Êñπ„Åß
diff --git a/Documentation/zh_CN/SubmitChecklist b/Documentation/zh_CN/SubmitChecklist
index 951415b..4c741d6 100644
--- a/Documentation/zh_CN/SubmitChecklist
+++ b/Documentation/zh_CN/SubmitChecklist
@@ -67,7 +67,7 @@ Linux
 
 12£∫“—æ≠Õ®π˝CONFIG_PREEMPT, CONFIG_DEBUG_PREEMPT,
     CONFIG_DEBUG_SLAB, CONFIG_DEBUG_PAGEALLOC, CONFIG_DEBUG_MUTEXES,
-    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_SPINLOCK_SLEEP≤‚ ‘£¨≤¢«“Õ¨ ±∂º
+    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_ATOMIC_SLEEP≤‚ ‘£¨≤¢«“Õ¨ ±∂º
      πƒ‹°£
 
 13£∫“—æ≠∂ºππΩ®≤¢«“ π”√ªÚ’ﬂ≤ª π”√ CONFIG_SMP ∫Õ CONFIG_PREEMPT≤‚ ‘÷¥–– ±º‰°£
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index fb0e732..24b489f 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -121,7 +121,7 @@ extern int _cond_resched(void);
 # define might_resched() do { } while (0)
 #endif
 
-#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
+#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
   void __might_sleep(const char *file, int line, int preempt_offset);
 /**
  * might_sleep - annotation for functions that can sleep
diff --git a/kernel/sched.c b/kernel/sched.c
index 90ad7cf..a5f318b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8018,7 +8018,7 @@ void __init sched_init(void)
 	scheduler_running = 1;
 }
 
-#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
+#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
 static inline int preempt_count_equals(int preempt_offset)
 {
 	int nested = (preempt_count() & ~PREEMPT_ACTIVE) + rcu_preempt_depth();
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a7dd7b5..81a4f33 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -648,13 +648,15 @@ config TRACE_IRQFLAGS
 	  Enables hooks to interrupt enabling and disabling for
 	  either tracing or lock debugging.
 
-config DEBUG_SPINLOCK_SLEEP
-	bool "Spinlock debugging: sleep-inside-spinlock checking"
+config DEBUG_ATOMIC_SLEEP
+	bool "Sleep inside atomic section checking"
 	select PREEMPT_COUNT
 	depends on DEBUG_KERNEL
 	help
 	  If you say Y here, various routines which may sleep will become very
-	  noisy if they are called with a spinlock held.
+	  noisy if they are called inside atomic sections: when a spinlock is
+	  held, inside an rcu read side critical section, inside preempt disabled
+	  sections, inside an interrupt, etc...
 
 config DEBUG_LOCKING_API_SELFTESTS
 	bool "Locking API boot-time self-tests"
-- 
1.7.5.4

