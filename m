Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab2HDHQu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 03:16:50 -0400
Received: from mail-pb0-f66.google.com ([209.85.160.66]:63838 "EHLO
	mail-pb0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab2HDHQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 03:16:48 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>,
        =?UTF-8?q?Mikko=20Virkkil=C3=A4?= <mikko.virkkila@bluegiga.com>,
        Lauri Hintsala <Lauri.Hintsala@bluegiga.com>,
        =?UTF-8?q?Riku=20Mett=C3=A4l=C3=A4?= <riku.mettala@bluegiga.com>,
        Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
Subject: =?UTF-8?q?=5BPATCH=201/5=5D=20staging/csr=3A=20clean=20coding=20style=20in=20uf=5Fstart=5Fthread?=
Date: Sat,  4 Aug 2012 13:01:38 +0545
Message-Id: <1344064598-12128-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in bh.c the function uf_start_thread needed a coding style fixes.

The following fixes:

* fix no space at the start of line
* fix over 80 character lines
* fix no brace needed for single statement blocks (if..else or for and while)
* use tabs instead of 4 spaces at the start of every line

Cc: Mikko Virkkilä <mikko.virkkila@bluegiga.com>
Cc: Lauri Hintsala <Lauri.Hintsala@bluegiga.com>
Cc: Riku Mettälä <riku.mettala@bluegiga.com>
Cc: Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/staging/csr/bh.c |   83 ++++++++++++++++++++++++----------------------
 1 file changed, 43 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/csr/bh.c b/drivers/staging/csr/bh.c
index b089c28..2b7c4c0 100644
--- a/drivers/staging/csr/bh.c
+++ b/drivers/staging/csr/bh.c
@@ -32,45 +32,49 @@
  *      0 on success or else a Linux error code.
  * ---------------------------------------------------------------------------
  */
-int
-uf_start_thread(unifi_priv_t *priv, struct uf_thread *thread, int (*func)(void *))
+int uf_start_thread(unifi_priv_t *priv,
+		    struct uf_thread *thread, int (*func)(void *))
 {
-    if (thread->thread_task != NULL) {
-        unifi_error(priv, "%s thread already started\n", thread->name);
-        return 0;
-    }
-
-    /* Start the kernel thread that handles all h/w accesses. */
-    thread->thread_task = kthread_run(func, priv, "%s", thread->name);
-    if (IS_ERR(thread->thread_task)) {
-        return PTR_ERR(thread->thread_task);
-    }
-
-    /* Module parameter overides the thread priority */
-    if (bh_priority != -1) {
-        if (bh_priority >= 0 && bh_priority <= MAX_RT_PRIO) {
-            struct sched_param param;
-            priv->bh_thread.prio = bh_priority;
-            unifi_trace(priv, UDBG1, "%s thread (RT) priority = %d\n",
-                        thread->name, bh_priority);
-            param.sched_priority = bh_priority;
-            sched_setscheduler(thread->thread_task, SCHED_FIFO, &param);
-        } else if (bh_priority > MAX_RT_PRIO && bh_priority <= MAX_PRIO) {
-            priv->bh_thread.prio = bh_priority;
-            unifi_trace(priv, UDBG1, "%s thread priority = %d\n",
-                        thread->name, PRIO_TO_NICE(bh_priority));
-            set_user_nice(thread->thread_task, PRIO_TO_NICE(bh_priority));
-        } else {
-            priv->bh_thread.prio = DEFAULT_PRIO;
-            unifi_warning(priv, "%s thread unsupported (%d) priority\n",
-                          thread->name, bh_priority);
-        }
-    } else {
-        priv->bh_thread.prio = DEFAULT_PRIO;
-    }
-    unifi_trace(priv, UDBG2, "Started %s thread\n", thread->name);
-
-    return 0;
+	if (thread->thread_task != NULL) {
+		unifi_error(priv, "%s thread already started\n", thread->name);
+		return 0;
+	}
+
+	/* Start the kernel thread that handles all h/w accesses. */
+	thread->thread_task = kthread_run(func, priv, "%s", thread->name);
+	if (IS_ERR(thread->thread_task))
+		return PTR_ERR(thread->thread_task);
+
+	/* Module parameter overides the thread priority */
+	if (bh_priority != -1) {
+		if (bh_priority >= 0 && bh_priority <= MAX_RT_PRIO) {
+			struct sched_param param;
+			priv->bh_thread.prio = bh_priority;
+			unifi_trace(priv, UDBG1,
+				"%s thread (RT) priority = %d\n",
+				thread->name, bh_priority);
+			param.sched_priority = bh_priority;
+			sched_setscheduler(thread->thread_task,
+					   SCHED_FIFO, &param);
+		} else if (bh_priority > MAX_RT_PRIO &&
+			   bh_priority <= MAX_PRIO) {
+			priv->bh_thread.prio = bh_priority;
+			unifi_trace(priv, UDBG1, "%s thread priority = %d\n",
+					thread->name,
+					PRIO_TO_NICE(bh_priority));
+			set_user_nice(thread->thread_task,
+				      PRIO_TO_NICE(bh_priority));
+		} else {
+			priv->bh_thread.prio = DEFAULT_PRIO;
+			unifi_warning(priv,
+				      "%s thread unsupported (%d) priority\n",
+				      thread->name, bh_priority);
+		}
+	} else
+		priv->bh_thread.prio = DEFAULT_PRIO;
+	unifi_trace(priv, UDBG2, "Started %s thread\n", thread->name);
+
+	return 0;
 } /* uf_start_thread() */
 
 
@@ -88,8 +92,7 @@ uf_start_thread(unifi_priv_t *priv, struct uf_thread *thread, int (*func)(void *
  *
  * ---------------------------------------------------------------------------
  */
-    void
-uf_stop_thread(unifi_priv_t *priv, struct uf_thread *thread)
+void uf_stop_thread(unifi_priv_t *priv, struct uf_thread *thread)
 {
     if (!thread->thread_task) {
         unifi_notice(priv, "%s thread is already stopped\n", thread->name);
-- 
1.7.9.5

