Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab2K3KSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:18:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756467Ab2K3KSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:18:20 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/16] GFS2: Rename glops go_xmote_th to go_sync
Date: Fri, 30 Nov 2012 09:52:08 +0000
Message-Id: <1354269141-3311-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
References: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[Editorial: This is a nit, but has been a minor irritation for a long time:]

This patch renames glops structure item for go_xmote_th to go_sync.
The functionality is unchanged; it's just for readability.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index e543871..6114571 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -535,8 +535,8 @@ __acquires(&gl->gl_spin)
 	    (lck_flags & (LM_FLAG_TRY|LM_FLAG_TRY_1CB)))
 		clear_bit(GLF_BLOCKING, &gl->gl_flags);
 	spin_unlock(&gl->gl_spin);
-	if (glops->go_xmote_th)
-		glops->go_xmote_th(gl);
+	if (glops->go_sync)
+		glops->go_sync(gl);
 	if (test_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags))
 		glops->go_inval(gl, target == LM_ST_DEFERRED ? 0 : DIO_METADATA);
 	clear_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags);
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 0a3e7c7..e86fe26 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -536,7 +536,7 @@ const struct gfs2_glock_operations gfs2_meta_glops = {
 };
 
 const struct gfs2_glock_operations gfs2_inode_glops = {
-	.go_xmote_th = inode_go_sync,
+	.go_sync = inode_go_sync,
 	.go_inval = inode_go_inval,
 	.go_demote_ok = inode_go_demote_ok,
 	.go_lock = inode_go_lock,
@@ -546,7 +546,7 @@ const struct gfs2_glock_operations gfs2_inode_glops = {
 };
 
 const struct gfs2_glock_operations gfs2_rgrp_glops = {
-	.go_xmote_th = rgrp_go_sync,
+	.go_sync = rgrp_go_sync,
 	.go_inval = rgrp_go_inval,
 	.go_lock = gfs2_rgrp_go_lock,
 	.go_unlock = gfs2_rgrp_go_unlock,
@@ -556,7 +556,7 @@ const struct gfs2_glock_operations gfs2_rgrp_glops = {
 };
 
 const struct gfs2_glock_operations gfs2_trans_glops = {
-	.go_xmote_th = trans_go_sync,
+	.go_sync = trans_go_sync,
 	.go_xmote_bh = trans_go_xmote_bh,
 	.go_demote_ok = trans_go_demote_ok,
 	.go_type = LM_TYPE_NONDISK,
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 24bb0b8..a46f034 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -205,7 +205,7 @@ struct lm_lockname {
 
 
 struct gfs2_glock_operations {
-	void (*go_xmote_th) (struct gfs2_glock *gl);
+	void (*go_sync) (struct gfs2_glock *gl);
 	int (*go_xmote_bh) (struct gfs2_glock *gl, struct gfs2_holder *gh);
 	void (*go_inval) (struct gfs2_glock *gl, int flags);
 	int (*go_demote_ok) (const struct gfs2_glock *gl);
-- 
1.7.4

