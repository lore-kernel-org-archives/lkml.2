Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0LFSQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 13:16:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:48000 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab0LFSQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 13:16:28 -0500
Date: Mon, 6 Dec 2010 18:15:51 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, rusty@rustcorp.com.au,
        ananth@in.ibm.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        tglx@linutronix.de, jbaron@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, rusty@rustcorp.com.au,
        ananth@in.ibm.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        jbaron@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101203095350.2961.48110.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101203095350.2961.48110.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Rename old_p to more appropriate name
Message-ID: <tip-6d8e40a85ef72a0514ebd00748eb18cab432b200@git.kernel.org>
Git-Commit-ID: 6d8e40a85ef72a0514ebd00748eb18cab432b200
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 18:15:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d8e40a85ef72a0514ebd00748eb18cab432b200
Gitweb:     http://git.kernel.org/tip/6d8e40a85ef72a0514ebd00748eb18cab432b200
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 3 Dec 2010 18:53:50 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 6 Dec 2010 17:59:29 +0100

kprobes: Rename old_p to more appropriate name

Rename irrelevant uses of "old_p" to more appropriate names.
Originally, "old_p" just meant "the old kprobe on given address"
but current code uses that name as "just another kprobe" or
something like that. This patch renames those pointer names
to more appropriate one for maintainability.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: 2nddept-manager@sdl.hitachi.co.jp
LKML-Reference: <20101203095350.2961.48110.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/kprobes.c |   93 ++++++++++++++++++++++++++---------------------------
 1 files changed, 46 insertions(+), 47 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 9737a76..8c3aa14 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -357,10 +357,10 @@ static inline int kprobe_aggrprobe(struct kprobe *p)
 /*
  * Keep all fields in the kprobe consistent
  */
-static inline void copy_kprobe(struct kprobe *old_p, struct kprobe *p)
+static inline void copy_kprobe(struct kprobe *ap, struct kprobe *p)
 {
-	memcpy(&p->opcode, &old_p->opcode, sizeof(kprobe_opcode_t));
-	memcpy(&p->ainsn, &old_p->ainsn, sizeof(struct arch_specific_insn));
+	memcpy(&p->opcode, &ap->opcode, sizeof(kprobe_opcode_t));
+	memcpy(&p->ainsn, &ap->ainsn, sizeof(struct arch_specific_insn));
 }
 
 #ifdef CONFIG_OPTPROBES
@@ -671,12 +671,12 @@ int proc_kprobes_optimization_handler(struct ctl_table *table, int write,
 
 static void __kprobes __arm_kprobe(struct kprobe *p)
 {
-	struct kprobe *old_p;
+	struct kprobe *_p;
 
 	/* Check collision with other optimized kprobes */
-	old_p = get_optimized_kprobe((unsigned long)p->addr);
-	if (unlikely(old_p))
-		unoptimize_kprobe(old_p); /* Fallback to unoptimized kprobe */
+	_p = get_optimized_kprobe((unsigned long)p->addr);
+	if (unlikely(_p))
+		unoptimize_kprobe(_p); /* Fallback to unoptimized kprobe */
 
 	arch_arm_kprobe(p);
 	optimize_kprobe(p);	/* Try to optimize (add kprobe to a list) */
@@ -684,15 +684,15 @@ static void __kprobes __arm_kprobe(struct kprobe *p)
 
 static void __kprobes __disarm_kprobe(struct kprobe *p)
 {
-	struct kprobe *old_p;
+	struct kprobe *_p;
 
 	unoptimize_kprobe(p);	/* Try to unoptimize */
 	arch_disarm_kprobe(p);
 
 	/* If another kprobe was blocked, optimize it. */
-	old_p = get_optimized_kprobe((unsigned long)p->addr);
-	if (unlikely(old_p))
-		optimize_kprobe(old_p);
+	_p = get_optimized_kprobe((unsigned long)p->addr);
+	if (unlikely(_p))
+		optimize_kprobe(_p);
 }
 
 #else /* !CONFIG_OPTPROBES */
@@ -993,18 +993,18 @@ static void __kprobes init_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
  * This is the second or subsequent kprobe at the address - handle
  * the intricacies
  */
-static int __kprobes register_aggr_kprobe(struct kprobe *old_p,
+static int __kprobes register_aggr_kprobe(struct kprobe *orig_p,
 					  struct kprobe *p)
 {
 	int ret = 0;
-	struct kprobe *ap = old_p;
+	struct kprobe *ap = orig_p;
 
-	if (!kprobe_aggrprobe(old_p)) {
-		/* If old_p is not an aggr_kprobe, create new aggr_kprobe. */
-		ap = alloc_aggr_kprobe(old_p);
+	if (!kprobe_aggrprobe(orig_p)) {
+		/* If orig_p is not an aggr_kprobe, create new aggr_kprobe. */
+		ap = alloc_aggr_kprobe(orig_p);
 		if (!ap)
 			return -ENOMEM;
-		init_aggr_kprobe(ap, old_p);
+		init_aggr_kprobe(ap, orig_p);
 	}
 
 	if (kprobe_gone(ap)) {
@@ -1098,34 +1098,33 @@ static kprobe_opcode_t __kprobes *kprobe_addr(struct kprobe *p)
 /* Check passed kprobe is valid and return kprobe in kprobe_table. */
 static struct kprobe * __kprobes __get_valid_kprobe(struct kprobe *p)
 {
-	struct kprobe *old_p, *list_p;
+	struct kprobe *ap, *list_p;
 
-	old_p = get_kprobe(p->addr);
-	if (unlikely(!old_p))
+	ap = get_kprobe(p->addr);
+	if (unlikely(!ap))
 		return NULL;
 
-	if (p != old_p) {
-		list_for_each_entry_rcu(list_p, &old_p->list, list)
+	if (p != ap) {
+		list_for_each_entry_rcu(list_p, &ap->list, list)
 			if (list_p == p)
 			/* kprobe p is a valid probe */
 				goto valid;
 		return NULL;
 	}
 valid:
-	return old_p;
+	return ap;
 }
 
 /* Return error if the kprobe is being re-registered */
 static inline int check_kprobe_rereg(struct kprobe *p)
 {
 	int ret = 0;
-	struct kprobe *old_p;
 
 	mutex_lock(&kprobe_mutex);
-	old_p = __get_valid_kprobe(p);
-	if (old_p)
+	if (__get_valid_kprobe(p))
 		ret = -EINVAL;
 	mutex_unlock(&kprobe_mutex);
+
 	return ret;
 }
 
@@ -1234,43 +1233,43 @@ EXPORT_SYMBOL_GPL(register_kprobe);
  */
 static int __kprobes __unregister_kprobe_top(struct kprobe *p)
 {
-	struct kprobe *old_p, *list_p;
+	struct kprobe *ap, *list_p;
 
-	old_p = __get_valid_kprobe(p);
-	if (old_p == NULL)
+	ap = __get_valid_kprobe(p);
+	if (ap == NULL)
 		return -EINVAL;
 
-	if (old_p == p ||
-	    (kprobe_aggrprobe(old_p) &&
-	     list_is_singular(&old_p->list))) {
+	if (ap == p ||
+	    (kprobe_aggrprobe(ap) &&
+	     list_is_singular(&ap->list))) {
 		/*
 		 * Only probe on the hash list. Disarm only if kprobes are
 		 * enabled and not gone - otherwise, the breakpoint would
 		 * already have been removed. We save on flushing icache.
 		 */
-		if (!kprobes_all_disarmed && !kprobe_disabled(old_p))
-			disarm_kprobe(old_p);
-		hlist_del_rcu(&old_p->hlist);
+		if (!kprobes_all_disarmed && !kprobe_disabled(ap))
+			disarm_kprobe(ap);
+		hlist_del_rcu(&ap->hlist);
 	} else {
 		if (p->break_handler && !kprobe_gone(p))
-			old_p->break_handler = NULL;
+			ap->break_handler = NULL;
 		if (p->post_handler && !kprobe_gone(p)) {
-			list_for_each_entry_rcu(list_p, &old_p->list, list) {
+			list_for_each_entry_rcu(list_p, &ap->list, list) {
 				if ((list_p != p) && (list_p->post_handler))
 					goto noclean;
 			}
-			old_p->post_handler = NULL;
+			ap->post_handler = NULL;
 		}
 noclean:
 		list_del_rcu(&p->list);
-		if (!kprobe_disabled(old_p)) {
-			try_to_disable_aggr_kprobe(old_p);
+		if (!kprobe_disabled(ap)) {
+			try_to_disable_aggr_kprobe(ap);
 			if (!kprobes_all_disarmed) {
-				if (kprobe_disabled(old_p))
-					disarm_kprobe(old_p);
+				if (kprobe_disabled(ap))
+					disarm_kprobe(ap);
 				else
 					/* Try to optimize this probe again */
-					optimize_kprobe(old_p);
+					optimize_kprobe(ap);
 			}
 		}
 	}
@@ -1279,16 +1278,16 @@ noclean:
 
 static void __kprobes __unregister_kprobe_bottom(struct kprobe *p)
 {
-	struct kprobe *old_p;
+	struct kprobe *ap;
 
 	if (list_empty(&p->list))
 		arch_remove_kprobe(p);
 	else if (list_is_singular(&p->list)) {
 		/* "p" is the last child of an aggr_kprobe */
-		old_p = list_entry(p->list.next, struct kprobe, list);
+		ap = list_entry(p->list.next, struct kprobe, list);
 		list_del(&p->list);
-		arch_remove_kprobe(old_p);
-		free_aggr_kprobe(old_p);
+		arch_remove_kprobe(ap);
+		free_aggr_kprobe(ap);
 	}
 }
 
