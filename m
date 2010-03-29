Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab0C2MJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:09:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab0C2MJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:09:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] SLOW_WORK: CONFIG_SLOW_WORK_PROC should be
	CONFIG_SLOW_WORK_DEBUG
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-cachefs@redhat.com, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Mon, 29 Mar 2010 13:08:52 +0100
Message-ID: <20100329120852.23029.10100.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SLOW_WORK_PROC was changed to CONFIG_SLOW_WORK_DEBUG, but not in all
instances.  Change the remaining instances.  This makes the debugfs file
display the time mark and the owner's description again.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/object.c           |    6 +++---
 fs/fscache/operation.c        |    4 ++--
 include/linux/fscache-cache.h |    2 +-
 kernel/slow-work.h            |    8 ++++----
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index e513ac5..0b589a9 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -53,7 +53,7 @@ const char fscache_object_states_short[FSCACHE_OBJECT__NSTATES][5] = {
 static void fscache_object_slow_work_put_ref(struct slow_work *);
 static int  fscache_object_slow_work_get_ref(struct slow_work *);
 static void fscache_object_slow_work_execute(struct slow_work *);
-#ifdef CONFIG_SLOW_WORK_PROC
+#ifdef CONFIG_SLOW_WORK_DEBUG
 static void fscache_object_slow_work_desc(struct slow_work *, struct seq_file *);
 #endif
 static void fscache_initialise_object(struct fscache_object *);
@@ -69,7 +69,7 @@ const struct slow_work_ops fscache_object_slow_work_ops = {
 	.get_ref	= fscache_object_slow_work_get_ref,
 	.put_ref	= fscache_object_slow_work_put_ref,
 	.execute	= fscache_object_slow_work_execute,
-#ifdef CONFIG_SLOW_WORK_PROC
+#ifdef CONFIG_SLOW_WORK_DEBUG
 	.desc		= fscache_object_slow_work_desc,
 #endif
 };
@@ -364,7 +364,7 @@ static void fscache_object_slow_work_execute(struct slow_work *work)
 /*
  * describe an object for slow-work debugging
  */
-#ifdef CONFIG_SLOW_WORK_PROC
+#ifdef CONFIG_SLOW_WORK_DEBUG
 static void fscache_object_slow_work_desc(struct slow_work *work,
 					  struct seq_file *m)
 {
diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
index 313e79a..9f6c928 100644
--- a/fs/fscache/operation.c
+++ b/fs/fscache/operation.c
@@ -500,7 +500,7 @@ static void fscache_op_execute(struct slow_work *work)
 /*
  * describe an operation for slow-work debugging
  */
-#ifdef CONFIG_SLOW_WORK_PROC
+#ifdef CONFIG_SLOW_WORK_DEBUG
 static void fscache_op_desc(struct slow_work *work, struct seq_file *m)
 {
 	struct fscache_operation *op =
@@ -517,7 +517,7 @@ const struct slow_work_ops fscache_op_slow_work_ops = {
 	.get_ref	= fscache_op_get_ref,
 	.put_ref	= fscache_op_put_ref,
 	.execute	= fscache_op_execute,
-#ifdef CONFIG_SLOW_WORK_PROC
+#ifdef CONFIG_SLOW_WORK_DEBUG
 	.desc		= fscache_op_desc,
 #endif
 };
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index 7be0c6f..c57db27 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -105,7 +105,7 @@ struct fscache_operation {
 	/* operation releaser */
 	fscache_operation_release_t release;
 
-#ifdef CONFIG_SLOW_WORK_PROC
+#ifdef CONFIG_SLOW_WORK_DEBUG
 	const char *name;		/* operation name */
 	const char *state;		/* operation state */
 #define fscache_set_op_name(OP, N)	do { (OP)->name  = (N); } while(0)
diff --git a/kernel/slow-work.h b/kernel/slow-work.h
index 321f3c5..a29ebd1 100644
--- a/kernel/slow-work.h
+++ b/kernel/slow-work.h
@@ -43,28 +43,28 @@ extern void slow_work_new_thread_desc(struct slow_work *, struct seq_file *);
  */
 static inline void slow_work_set_thread_pid(int id, pid_t pid)
 {
-#ifdef CONFIG_SLOW_WORK_PROC
+#ifdef CONFIG_SLOW_WORK_DEBUG
 	slow_work_pids[id] = pid;
 #endif
 }
 
 static inline void slow_work_mark_time(struct slow_work *work)
 {
-#ifdef CONFIG_SLOW_WORK_PROC
+#ifdef CONFIG_SLOW_WORK_DEBUG
 	work->mark = CURRENT_TIME;
 #endif
 }
 
 static inline void slow_work_begin_exec(int id, struct slow_work *work)
 {
-#ifdef CONFIG_SLOW_WORK_PROC
+#ifdef CONFIG_SLOW_WORK_DEBUG
 	slow_work_execs[id] = work;
 #endif
 }
 
 static inline void slow_work_end_exec(int id, struct slow_work *work)
 {
-#ifdef CONFIG_SLOW_WORK_PROC
+#ifdef CONFIG_SLOW_WORK_DEBUG
 	write_lock(&slow_work_execs_lock);
 	slow_work_execs[id] = NULL;
 	write_unlock(&slow_work_execs_lock);

