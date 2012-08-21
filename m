Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab2HUQle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:41:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33163 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059Ab2HUQlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:41:32 -0400
Date: Tue, 21 Aug 2012 09:41:20 -0700
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-5a9af38d05f6a1bd0d3f1f69a074cdbe9c87e977@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tj@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tj@kernel.org, tglx@linutronix.de
In-Reply-To: <1344449428-24962-3-git-send-email-tj@kernel.org>
References: <1344449428-24962-3-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timer:
  Relocate declarations of init_timer_on_stack_key()
Git-Commit-ID: 5a9af38d05f6a1bd0d3f1f69a074cdbe9c87e977
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:41:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a9af38d05f6a1bd0d3f1f69a074cdbe9c87e977
Gitweb:     http://git.kernel.org/tip/5a9af38d05f6a1bd0d3f1f69a074cdbe9c87e977
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Wed, 8 Aug 2012 11:10:26 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 21 Aug 2012 16:28:30 +0200

timer: Relocate declarations of init_timer_on_stack_key()

init_timer_on_stack_key() is used by init macro definitions.  Move
init_timer_on_stack_key() and destroy_timer_on_stack() declarations
above init macro defs.  This will make the next init cleanup patch
easier to read.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/1344449428-24962-3-git-send-email-tj@kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timer.h |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index cbd32ec..1d364ae 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -97,6 +97,21 @@ void init_timer_deferrable_key(struct timer_list *timer,
 			       const char *name,
 			       struct lock_class_key *key);
 
+#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
+extern void init_timer_on_stack_key(struct timer_list *timer,
+				    const char *name,
+				    struct lock_class_key *key);
+extern void destroy_timer_on_stack(struct timer_list *timer);
+#else
+static inline void destroy_timer_on_stack(struct timer_list *timer) { }
+static inline void init_timer_on_stack_key(struct timer_list *timer,
+					   const char *name,
+					   struct lock_class_key *key)
+{
+	init_timer_key(timer, name, key);
+}
+#endif
+
 #ifdef CONFIG_LOCKDEP
 #define init_timer(timer)						\
 	do {								\
@@ -150,21 +165,6 @@ void init_timer_deferrable_key(struct timer_list *timer,
 	setup_deferrable_timer_on_stack_key((timer), NULL, NULL, (fn), (data))
 #endif
 
-#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
-extern void init_timer_on_stack_key(struct timer_list *timer,
-				    const char *name,
-				    struct lock_class_key *key);
-extern void destroy_timer_on_stack(struct timer_list *timer);
-#else
-static inline void destroy_timer_on_stack(struct timer_list *timer) { }
-static inline void init_timer_on_stack_key(struct timer_list *timer,
-					   const char *name,
-					   struct lock_class_key *key)
-{
-	init_timer_key(timer, name, key);
-}
-#endif
-
 static inline void setup_timer_key(struct timer_list * timer,
 				const char *name,
 				struct lock_class_key *key,
