Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab0JRTVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:21:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:35081 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529Ab0JRTVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:21:21 -0400
Date: Mon, 18 Oct 2010 19:21:00 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101014203625.448565169@chello.nl>
References: <20101014203625.448565169@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] jump_label: Use more consistent naming
Message-ID: <tip-3b6e901f839f42afb40f614418df82c08b01320a@git.kernel.org>
Git-Commit-ID: 3b6e901f839f42afb40f614418df82c08b01320a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:21:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b6e901f839f42afb40f614418df82c08b01320a
Gitweb:     http://git.kernel.org/tip/3b6e901f839f42afb40f614418df82c08b01320a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 14 Oct 2010 21:10:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 19:58:56 +0200

jump_label: Use more consistent naming

Now that there's still only a few users around, rename things to make
them more consistent.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101014203625.448565169@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/jump_label.h |    8 ++++----
 kernel/tracepoint.c        |    6 +++---
 lib/dynamic_debug.c        |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index b72cd9f..81be496 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -25,10 +25,10 @@ extern void jump_label_update(unsigned long key, enum jump_label_type type);
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
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index d6073a5..e95ee7f 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -265,10 +265,10 @@ static void set_tracepoint(struct tracepoint_entry **entry,
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
@@ -285,7 +285,7 @@ static void disable_tracepoint(struct tracepoint *elem)
 		elem->unregfunc();
 
 	if (elem->state) {
-		disable_jump_label(&elem->state);
+		jump_label_disable(&elem->state);
 		elem->state = 0;
 	}
 	rcu_assign_pointer(elem->funcs, NULL);
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index e925c7b..7bd6df7 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -142,9 +142,9 @@ static void ddebug_change(const struct ddebug_query *query,
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
