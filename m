Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab0IBWtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 18:49:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54277 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab0IBWtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 18:49:32 -0400
Date: Thu, 2 Sep 2010 15:48:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] mutex: add to kernel-locking docbook
Message-Id: <20100902154816.6cc2f9ad.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc notation in linux/mutex.h and kernel/mutex.c,
then add these 2 files to the kernel-locking docbook as the
Mutex API reference chapter.

Add one API function to mutex-design.txt and correct a typo in
that file.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/DocBook/kernel-locking.tmpl |    6 +++++
 Documentation/mutex-design.txt            |    3 +-
 include/linux/mutex.h                     |    8 ++++++
 kernel/mutex.c                            |   23 ++++++--------------
 4 files changed, 23 insertions(+), 17 deletions(-)

--- lnx-2636-rc3.orig/include/linux/mutex.h
+++ lnx-2636-rc3/include/linux/mutex.h
@@ -78,6 +78,14 @@ struct mutex_waiter {
 # include <linux/mutex-debug.h>
 #else
 # define __DEBUG_MUTEX_INITIALIZER(lockname)
+/**
+ * mutex_init - initialize the mutex
+ * @mutex: the mutex to be initialized
+ *
+ * Initialize the mutex to unlocked state.
+ *
+ * It is not allowed to initialize an already locked mutex.
+ */
 # define mutex_init(mutex) \
 do {							\
 	static struct lock_class_key __key;		\
--- lnx-2636-rc3.orig/kernel/mutex.c
+++ lnx-2636-rc3/kernel/mutex.c
@@ -36,15 +36,6 @@
 # include <asm/mutex.h>
 #endif
 
-/***
- * mutex_init - initialize the mutex
- * @lock: the mutex to be initialized
- * @key: the lock_class_key for the class; used by mutex lock debugging
- *
- * Initialize the mutex to unlocked state.
- *
- * It is not allowed to initialize an already locked mutex.
- */
 void
 __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
 {
@@ -68,7 +59,7 @@ EXPORT_SYMBOL(__mutex_init);
 static __used noinline void __sched
 __mutex_lock_slowpath(atomic_t *lock_count);
 
-/***
+/**
  * mutex_lock - acquire the mutex
  * @lock: the mutex to be acquired
  *
@@ -105,7 +96,7 @@ EXPORT_SYMBOL(mutex_lock);
 
 static __used noinline void __sched __mutex_unlock_slowpath(atomic_t *lock_count);
 
-/***
+/**
  * mutex_unlock - release the mutex
  * @lock: the mutex to be released
  *
@@ -364,8 +355,8 @@ __mutex_lock_killable_slowpath(atomic_t 
 static noinline int __sched
 __mutex_lock_interruptible_slowpath(atomic_t *lock_count);
 
-/***
- * mutex_lock_interruptible - acquire the mutex, interruptable
+/**
+ * mutex_lock_interruptible - acquire the mutex, interruptible
  * @lock: the mutex to be acquired
  *
  * Lock the mutex like mutex_lock(), and return 0 if the mutex has
@@ -456,15 +447,15 @@ static inline int __mutex_trylock_slowpa
 	return prev == 1;
 }
 
-/***
- * mutex_trylock - try acquire the mutex, without waiting
+/**
+ * mutex_trylock - try to acquire the mutex, without waiting
  * @lock: the mutex to be acquired
  *
  * Try to acquire the mutex atomically. Returns 1 if the mutex
  * has been acquired successfully, and 0 on contention.
  *
  * NOTE: this function follows the spin_trylock() convention, so
- * it is negated to the down_trylock() return values! Be careful
+ * it is negated from the down_trylock() return values! Be careful
  * about this when converting semaphore users to mutexes.
  *
  * This function must not be used in interrupt context. The
--- lnx-2636-rc3.orig/Documentation/DocBook/kernel-locking.tmpl
+++ lnx-2636-rc3/Documentation/DocBook/kernel-locking.tmpl
@@ -1961,6 +1961,12 @@ machines due to caching.
    </sect1>
   </chapter>
 
+  <chapter id="apiref">
+   <title>Mutex API reference</title>
+!Iinclude/linux/mutex.h
+!Ekernel/mutex.c
+  </chapter>
+
   <chapter id="references">
    <title>Further reading</title>
 
--- lnx-2636-rc3.orig/Documentation/mutex-design.txt
+++ lnx-2636-rc3/Documentation/mutex-design.txt
@@ -9,7 +9,7 @@ firstly, there's nothing wrong with sema
 mutex semantics are sufficient for your code, then there are a couple
 of advantages of mutexes:
 
- - 'struct mutex' is smaller on most architectures: .e.g on x86,
+ - 'struct mutex' is smaller on most architectures: E.g. on x86,
    'struct semaphore' is 20 bytes, 'struct mutex' is 16 bytes.
    A smaller structure size means less RAM footprint, and better
    CPU-cache utilization.
@@ -136,3 +136,4 @@ the APIs of 'struct mutex' have been str
  void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
  int  mutex_lock_interruptible_nested(struct mutex *lock,
                                       unsigned int subclass);
+ int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
