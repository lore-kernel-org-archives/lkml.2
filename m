Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab2HHVi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:38:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59235 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2HHViZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:38:25 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mingo@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de, peterz@infradead.org, davem@davemloft.net,
        tomi.valkeinen@ti.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/7] workqueue: cosmetic whitespace updates for macro definitions
Date: Wed,  8 Aug 2012 14:37:56 -0700
Message-Id: <1344461882-10149-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1344461882-10149-1-git-send-email-tj@kernel.org>
References: <1344461882-10149-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consistently use the last tab position for '\' line continuation in
complex macro definitions.  This is to help the following patches.

This patch is cosmetic.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |  126 ++++++++++++++++++++++----------------------
 1 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index b14d5d5..0b94714 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -126,43 +126,43 @@ struct execute_work {
 #define __WORK_INIT_LOCKDEP_MAP(n, k)
 #endif
 
-#define __WORK_INITIALIZER(n, f) {				\
-	.data = WORK_DATA_STATIC_INIT(),			\
-	.entry	= { &(n).entry, &(n).entry },			\
-	.func = (f),						\
-	__WORK_INIT_LOCKDEP_MAP(#n, &(n))			\
+#define __WORK_INITIALIZER(n, f) {					\
+	.data = WORK_DATA_STATIC_INIT(),				\
+	.entry	= { &(n).entry, &(n).entry },				\
+	.func = (f),							\
+	__WORK_INIT_LOCKDEP_MAP(#n, &(n))				\
 	}
 
-#define __DELAYED_WORK_INITIALIZER(n, f) {			\
-	.work = __WORK_INITIALIZER((n).work, (f)),		\
-	.timer = TIMER_INITIALIZER(delayed_work_timer_fn,	\
-				0, (unsigned long)&(n)),	\
+#define __DELAYED_WORK_INITIALIZER(n, f) {				\
+	.work = __WORK_INITIALIZER((n).work, (f)),			\
+	.timer = TIMER_INITIALIZER(delayed_work_timer_fn,		\
+				0, (unsigned long)&(n)),		\
 	}
 
-#define __DEFERRED_WORK_INITIALIZER(n, f) {			\
-	.work = __WORK_INITIALIZER((n).work, (f)),		\
-	.timer = TIMER_DEFERRED_INITIALIZER(delayed_work_timer_fn, \
-				0, (unsigned long)&(n)),	\
+#define __DEFERRED_WORK_INITIALIZER(n, f) {				\
+	.work = __WORK_INITIALIZER((n).work, (f)),			\
+	.timer = TIMER_DEFERRED_INITIALIZER(delayed_work_timer_fn,	\
+				0, (unsigned long)&(n)),		\
 	}
 
-#define DECLARE_WORK(n, f)					\
+#define DECLARE_WORK(n, f)						\
 	struct work_struct n = __WORK_INITIALIZER(n, f)
 
-#define DECLARE_DELAYED_WORK(n, f)				\
+#define DECLARE_DELAYED_WORK(n, f)					\
 	struct delayed_work n = __DELAYED_WORK_INITIALIZER(n, f)
 
-#define DECLARE_DEFERRED_WORK(n, f)				\
+#define DECLARE_DEFERRED_WORK(n, f)					\
 	struct delayed_work n = __DEFERRED_WORK_INITIALIZER(n, f)
 
 /*
  * initialize a work item's function pointer
  */
-#define PREPARE_WORK(_work, _func)				\
-	do {							\
-		(_work)->func = (_func);			\
+#define PREPARE_WORK(_work, _func)					\
+	do {								\
+		(_work)->func = (_func);				\
 	} while (0)
 
-#define PREPARE_DELAYED_WORK(_work, _func)			\
+#define PREPARE_DELAYED_WORK(_work, _func)				\
 	PREPARE_WORK(&(_work)->work, (_func))
 
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
@@ -192,7 +192,7 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }
 									\
 		__init_work((_work), _onstack);				\
 		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
-		lockdep_init_map(&(_work)->lockdep_map, #_work, &__key, 0);\
+		lockdep_init_map(&(_work)->lockdep_map, #_work, &__key, 0); \
 		INIT_LIST_HEAD(&(_work)->entry);			\
 		PREPARE_WORK((_work), (_func));				\
 	} while (0)
@@ -206,38 +206,38 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }
 	} while (0)
 #endif
 
-#define INIT_WORK(_work, _func)					\
-	do {							\
-		__INIT_WORK((_work), (_func), 0);		\
+#define INIT_WORK(_work, _func)						\
+	do {								\
+		__INIT_WORK((_work), (_func), 0);			\
 	} while (0)
 
-#define INIT_WORK_ONSTACK(_work, _func)				\
-	do {							\
-		__INIT_WORK((_work), (_func), 1);		\
+#define INIT_WORK_ONSTACK(_work, _func)					\
+	do {								\
+		__INIT_WORK((_work), (_func), 1);			\
 	} while (0)
 
-#define INIT_DELAYED_WORK(_work, _func)				\
-	do {							\
-		INIT_WORK(&(_work)->work, (_func));		\
-		init_timer(&(_work)->timer);			\
-		(_work)->timer.function = delayed_work_timer_fn;\
-		(_work)->timer.data = (unsigned long)(_work);	\
+#define INIT_DELAYED_WORK(_work, _func)					\
+	do {								\
+		INIT_WORK(&(_work)->work, (_func));			\
+		init_timer(&(_work)->timer);				\
+		(_work)->timer.function = delayed_work_timer_fn;	\
+		(_work)->timer.data = (unsigned long)(_work);		\
 	} while (0)
 
-#define INIT_DELAYED_WORK_ONSTACK(_work, _func)			\
-	do {							\
-		INIT_WORK_ONSTACK(&(_work)->work, (_func));	\
-		init_timer_on_stack(&(_work)->timer);		\
-		(_work)->timer.function = delayed_work_timer_fn;\
-		(_work)->timer.data = (unsigned long)(_work);	\
+#define INIT_DELAYED_WORK_ONSTACK(_work, _func)				\
+	do {								\
+		INIT_WORK_ONSTACK(&(_work)->work, (_func));		\
+		init_timer_on_stack(&(_work)->timer);			\
+		(_work)->timer.function = delayed_work_timer_fn;	\
+		(_work)->timer.data = (unsigned long)(_work);		\
 	} while (0)
 
-#define INIT_DELAYED_WORK_DEFERRABLE(_work, _func)		\
-	do {							\
-		INIT_WORK(&(_work)->work, (_func));		\
-		init_timer_deferrable(&(_work)->timer);		\
-		(_work)->timer.function = delayed_work_timer_fn;\
-		(_work)->timer.data = (unsigned long)(_work);	\
+#define INIT_DELAYED_WORK_DEFERRABLE(_work, _func)			\
+	do {								\
+		INIT_WORK(&(_work)->work, (_func));			\
+		init_timer_deferrable(&(_work)->timer);			\
+		(_work)->timer.function = delayed_work_timer_fn;	\
+		(_work)->timer.data = (unsigned long)(_work);		\
 	} while (0)
 
 /**
@@ -340,22 +340,22 @@ __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
  * Pointer to the allocated workqueue on success, %NULL on failure.
  */
 #ifdef CONFIG_LOCKDEP
-#define alloc_workqueue(fmt, flags, max_active, args...)	\
-({								\
-	static struct lock_class_key __key;			\
-	const char *__lock_name;				\
-								\
-	if (__builtin_constant_p(fmt))				\
-		__lock_name = (fmt);				\
-	else							\
-		__lock_name = #fmt;				\
-								\
-	__alloc_workqueue_key((fmt), (flags), (max_active),	\
-			      &__key, __lock_name, ##args);	\
+#define alloc_workqueue(fmt, flags, max_active, args...)		\
+({									\
+	static struct lock_class_key __key;				\
+	const char *__lock_name;					\
+									\
+	if (__builtin_constant_p(fmt))					\
+		__lock_name = (fmt);					\
+	else								\
+		__lock_name = #fmt;					\
+									\
+	__alloc_workqueue_key((fmt), (flags), (max_active),		\
+			      &__key, __lock_name, ##args);		\
 })
 #else
-#define alloc_workqueue(fmt, flags, max_active, args...)	\
-	__alloc_workqueue_key((fmt), (flags), (max_active),	\
+#define alloc_workqueue(fmt, flags, max_active, args...)		\
+	__alloc_workqueue_key((fmt), (flags), (max_active),		\
 			      NULL, NULL, ##args)
 #endif
 
@@ -372,14 +372,14 @@ __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
  * RETURNS:
  * Pointer to the allocated workqueue on success, %NULL on failure.
  */
-#define alloc_ordered_workqueue(fmt, flags, args...)		\
+#define alloc_ordered_workqueue(fmt, flags, args...)			\
 	alloc_workqueue(fmt, WQ_UNBOUND | (flags), 1, ##args)
 
-#define create_workqueue(name)					\
+#define create_workqueue(name)						\
 	alloc_workqueue((name), WQ_MEM_RECLAIM, 1)
-#define create_freezable_workqueue(name)			\
+#define create_freezable_workqueue(name)				\
 	alloc_workqueue((name), WQ_FREEZABLE | WQ_UNBOUND | WQ_MEM_RECLAIM, 1)
-#define create_singlethread_workqueue(name)			\
+#define create_singlethread_workqueue(name)				\
 	alloc_workqueue((name), WQ_UNBOUND | WQ_MEM_RECLAIM, 1)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
-- 
1.7.7.3

