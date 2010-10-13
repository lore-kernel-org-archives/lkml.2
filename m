Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab0JMSDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 14:03:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39275 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab0JMSDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 14:03:09 -0400
Date: Wed, 13 Oct 2010 11:02:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] futex: fix kernel-doc notation & typos
Message-Id: <20101013110234.89b06043.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Convert futex_requeue() function parameters to use @name kernel-doc
notation and add @fshared & @cmpval to prevent kernel-doc warnings.

Add @list to struct futex_q.

Fix a few typos.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

Comments/changes/suggestions for @cmpval or @list ?

todo: add to docbook (kernel-locking ?)

--- lnx-2636-rc7.orig/kernel/futex.c
+++ lnx-2636-rc7/kernel/futex.c
@@ -91,6 +91,7 @@ struct futex_pi_state {
 
 /**
  * struct futex_q - The hashed futex queue entry, one per waiting task
+ * @list:		priority-sorted list of tasks waiting on this futex
  * @task:		the task waiting on the futex
  * @lock_ptr:		the hash bucket lock
  * @key:		the key the futex is hashed on
@@ -104,7 +105,7 @@ struct futex_pi_state {
  *
  * A futex_q has a woken state, just like tasks have TASK_RUNNING.
  * It is considered woken when plist_node_empty(&q->list) || q->lock_ptr == 0.
- * The order of wakup is always to make the first condition true, then
+ * The order of wakeup is always to make the first condition true, then
  * the second.
  *
  * PI futexes are typically woken before they are removed from the hash list via
@@ -295,7 +296,7 @@ void put_futex_key(int fshared, union fu
  * Slow path to fixup the fault we just took in the atomic write
  * access to @uaddr.
  *
- * We have no generic implementation of a non destructive write to the
+ * We have no generic implementation of a non-destructive write to the
  * user address. We know that we faulted in the atomic pagefault
  * disabled section so we can as well avoid the #PF overhead by
  * calling get_user_pages() right away.
@@ -515,7 +516,7 @@ lookup_pi_state(u32 uval, struct futex_h
 			 */
 			pi_state = this->pi_state;
 			/*
-			 * Userspace might have messed up non PI and PI futexes
+			 * Userspace might have messed up non-PI and PI futexes
 			 */
 			if (unlikely(!pi_state))
 				return -EINVAL;
@@ -736,8 +737,8 @@ static void wake_futex(struct futex_q *q
 
 	/*
 	 * We set q->lock_ptr = NULL _before_ we wake up the task. If
-	 * a non futex wake up happens on another CPU then the task
-	 * might exit and p would dereference a non existing task
+	 * a non-futex wake up happens on another CPU then the task
+	 * might exit and p would dereference a non-existing task
 	 * struct. Prevent this by holding a reference on p across the
 	 * wake up.
 	 */
@@ -1131,11 +1132,13 @@ static int futex_proxy_trylock_atomic(u3
 
 /**
  * futex_requeue() - Requeue waiters from uaddr1 to uaddr2
- * uaddr1:	source futex user address
- * uaddr2:	target futex user address
- * nr_wake:	number of waiters to wake (must be 1 for requeue_pi)
- * nr_requeue:	number of waiters to requeue (0-INT_MAX)
- * requeue_pi:	if we are attempting to requeue from a non-pi futex to a
+ * @uaddr1:	source futex user address
+ * @fshared:	0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
+ * @uaddr2:	target futex user address
+ * @nr_wake:	number of waiters to wake (must be 1 for requeue_pi)
+ * @nr_requeue:	number of waiters to requeue (0-INT_MAX)
+ * @cmpval:	@uaddr1 expected value (or %NULL)
+ * @requeue_pi:	if we are attempting to requeue from a non-pi futex to a
  * 		pi futex (pi to pi requeue is not supported)
  *
  * Requeue waiters on uaddr1 to uaddr2. In the requeue_pi case, try to acquire
@@ -2647,7 +2650,7 @@ static int __init futex_init(void)
 	 * of the complex code paths. Also we want to prevent
 	 * registration of robust lists in that case. NULL is
 	 * guaranteed to fault and we get -EFAULT on functional
-	 * implementation, the non functional ones will return
+	 * implementation, the non-functional ones will return
 	 * -ENOSYS.
 	 */
 	curval = cmpxchg_futex_value_locked(NULL, 0, 0);
