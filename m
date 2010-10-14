Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab0JNVKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:10:52 -0400
Received: from canuck.infradead.org ([134.117.69.58]:56108 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115Ab0JNVK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:10:28 -0400
Message-Id: <20101014203625.448565169@chello.nl>
User-Agent: quilt/0.47-1
Date: Thu, 14 Oct 2010 22:34:08 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 4/7] jump_label: More consitent naming
References: <20101014203404.222133139@chello.nl>
Content-Disposition: inline; filename=jump_label_rename.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that there's only a few users around, rename things.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/jump_label.h |    8 ++++----
 kernel/tracepoint.c        |    6 +++---
 lib/dynamic_debug.c        |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

Index: linux-2.6/include/linux/jump_label.h
===================================================================
--- linux-2.6.orig/include/linux/jump_label.h
+++ linux-2.6/include/linux/jump_label.h
@@ -25,10 +25,10 @@ extern void jump_label_update(unsigned l
 extern void jump_label_apply_nops(struct module *mod);
 extern int jump_label_text_reserved(void *start, void *end);
 
-#define enable_jump_label(key) \
+#define jump_label_enable(key) \
 	jump_label_update((unsigned long)key, JUMP_LABEL_ENABLE);
 
-#define disable_jump_label(key) \
+#define jump_label_disable(key) \
 	jump_label_update((unsigned long)key, JUMP_LABEL_DISABLE);
 
 #else
@@ -39,12 +39,12 @@ do {						\
 		goto label;			\
 } while (0)
 
-#define enable_jump_label(cond_var)	\
+#define jump_label_enable(cond_var)	\
 do {					\
        *(cond_var) = 1;			\
 } while (0)
 
-#define disable_jump_label(cond_var)	\
+#define jump_label_disable(cond_var)	\
 do {					\
        *(cond_var) = 0;			\
 } while (0)
Index: linux-2.6/kernel/tracepoint.c
===================================================================
--- linux-2.6.orig/kernel/tracepoint.c
+++ linux-2.6/kernel/tracepoint.c
@@ -265,10 +265,10 @@ static void set_tracepoint(struct tracep
 	 */
 	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
 	if (!elem->state && active) {
-		enable_jump_label(&elem->state);
+		jump_label_enable(&elem->state);
 		elem->state = active;
 	} else if (elem->state && !active) {
-		disable_jump_label(&elem->state);
+		jump_label_disable(&elem->state);
 		elem->state = active;
 	}
 }
@@ -285,7 +285,7 @@ static void disable_tracepoint(struct tr
 		elem->unregfunc();
 
 	if (elem->state) {
-		disable_jump_label(&elem->state);
+		jump_label_disable(&elem->state);
 		elem->state = 0;
 	}
 	rcu_assign_pointer(elem->funcs, NULL);
Index: linux-2.6/lib/dynamic_debug.c
===================================================================
--- linux-2.6.orig/lib/dynamic_debug.c
+++ linux-2.6/lib/dynamic_debug.c
@@ -142,9 +142,9 @@ static void ddebug_change(const struct d
 				dt->num_enabled++;
 			dp->flags = newflags;
 			if (newflags) {
-				enable_jump_label(&dp->enabled);
+				jump_label_enable(&dp->enabled);
 			} else {
-				disable_jump_label(&dp->enabled);
+				jump_label_disable(&dp->enabled);
 			}
 			if (verbose)
 				printk(KERN_INFO


