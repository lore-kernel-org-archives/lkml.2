Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab2IZIvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:51:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab2IZIvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:46 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/27] GFS2: Combine functions gfs2_glock_wait and wait_on_holder
Date: Wed, 26 Sep 2012 09:25:33 +0100
Message-Id: <1348647948-3219-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Function gfs2_glock_wait only called function wait_on_holder and
returned its return code, so they were combined for readability.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 67f3e42..5c87909 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -869,7 +869,14 @@ static int gfs2_glock_demote_wait(void *word)
 	return 0;
 }
 
-static void wait_on_holder(struct gfs2_holder *gh)
+/**
+ * gfs2_glock_wait - wait on a glock acquisition
+ * @gh: the glock holder
+ *
+ * Returns: 0 on success
+ */
+
+int gfs2_glock_wait(struct gfs2_holder *gh)
 {
 	unsigned long time1 = jiffies;
 
@@ -880,6 +887,7 @@ static void wait_on_holder(struct gfs2_holder *gh)
 		gh->gh_gl->gl_hold_time = min(gh->gh_gl->gl_hold_time +
 					      GL_GLOCK_HOLD_INCR,
 					      GL_GLOCK_MAX_HOLD);
+	return gh->gh_error;
 }
 
 static void wait_on_demote(struct gfs2_glock *gl)
@@ -915,19 +923,6 @@ static void handle_callback(struct gfs2_glock *gl, unsigned int state,
 	trace_gfs2_demote_rq(gl);
 }
 
-/**
- * gfs2_glock_wait - wait on a glock acquisition
- * @gh: the glock holder
- *
- * Returns: 0 on success
- */
-
-int gfs2_glock_wait(struct gfs2_holder *gh)
-{
-	wait_on_holder(gh);
-	return gh->gh_error;
-}
-
 void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...)
 {
 	struct va_format vaf;
-- 
1.7.4

