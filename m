Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab2HDHRz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 03:17:55 -0400
Received: from mail-pb0-f66.google.com ([209.85.160.66]:53447 "EHLO
	mail-pb0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2HDHRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 03:17:53 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>,
        =?UTF-8?q?Mikko=20Virkkil=C3=A4?= <mikko.virkkila@bluegiga.com>,
        Lauri Hintsala <Lauri.Hintsala@bluegiga.com>,
        =?UTF-8?q?Riku=20Mett=C3=A4l=C3=A4?= <riku.mettala@bluegiga.com>,
        Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
Subject: =?UTF-8?q?=5BPATCH=203/5=5D=20staging/csr=3A=20fix=20coding=20style=20problems=20in=20uf=5Fwait=5Ffor=5Fthread=5Fto=5Fstop?=
Date: Sat,  4 Aug 2012 13:02:45 +0545
Message-Id: <1344064665-12256-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the following fixes:

* fix no space at the start of line
* line over 80 characters
* use tabs instead of spaces at starting of every line

Cc: Mikko Virkkilä <mikko.virkkila@bluegiga.com>
Cc: Lauri Hintsala <Lauri.Hintsala@bluegiga.com>
Cc: Riku Mettälä <riku.mettala@bluegiga.com>
Cc: Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/staging/csr/bh.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/csr/bh.c b/drivers/staging/csr/bh.c
index 7a00aa8..2597e22 100644
--- a/drivers/staging/csr/bh.c
+++ b/drivers/staging/csr/bh.c
@@ -122,23 +122,24 @@ void uf_stop_thread(unifi_priv_t *priv, struct uf_thread *thread)
  *
  * ---------------------------------------------------------------------------
  */
-    void
+void
 uf_wait_for_thread_to_stop(unifi_priv_t *priv, struct uf_thread *thread)
 {
-    /*
-     * kthread_stop() cannot handle the thread exiting while
-     * kthread_should_stop() is false, so sleep until kthread_stop()
-     * wakes us up.
-     */
-    unifi_trace(priv, UDBG2, "%s waiting for the stop signal.\n", thread->name);
-    set_current_state(TASK_INTERRUPTIBLE);
-    if (!kthread_should_stop()) {
-        unifi_trace(priv, UDBG2, "%s schedule....\n", thread->name);
-        schedule();
-    }
+	/*
+	 * kthread_stop() cannot handle the thread exiting while
+	 * kthread_should_stop() is false, so sleep until kthread_stop()
+	 * wakes us up
+	 */
+	unifi_trace(priv, UDBG2, "%s waiting for the stop signal.\n",
+							thread->name);
+	set_current_state(TASK_INTERRUPTIBLE);
+	if (!kthread_should_stop()) {
+		unifi_trace(priv, UDBG2, "%s schedule....\n", thread->name);
+		schedule();
+	}
 
-    thread->thread_task = NULL;
-    unifi_trace(priv, UDBG2, "%s exiting....\n", thread->name);
+	thread->thread_task = NULL;
+	unifi_trace(priv, UDBG2, "%s exiting....\n", thread->name);
 } /* uf_wait_for_thread_to_stop() */
 
 
-- 
1.7.9.5

