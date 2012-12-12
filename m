Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab2LLSWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:22:35 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:41834 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753966Ab2LLSWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:22:32 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 19/26] gfs2: Convert print_symbol to %pSR
Date: Wed, 12 Dec 2012 10:19:08 -0800
Message-Id: <9e86924627c3e2fa6e45bd07537115a291db50fe.1355335228.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1355335227.git.joe@perches.com>
References: <cover.1355335227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new vsprintf extension to avoid any possible
message interleaving.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/gfs2/glock.c |    4 ++--
 fs/gfs2/trans.c |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 992c5c0..453978b 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1016,11 +1016,11 @@ do_cancel:
 	return;
 
 trap_recursive:
-	print_symbol(KERN_ERR "original: %s\n", gh2->gh_ip);
+	printk(KERN_ERR "original: %pSR\n", (void *)gh2->gh_ip);
 	printk(KERN_ERR "pid: %d\n", pid_nr(gh2->gh_owner_pid));
 	printk(KERN_ERR "lock type: %d req lock state : %d\n",
 	       gh2->gh_gl->gl_name.ln_type, gh2->gh_state);
-	print_symbol(KERN_ERR "new: %s\n", gh->gh_ip);
+	printk(KERN_ERR "new: %pSR\n", (void *)gh->gh_ip);
 	printk(KERN_ERR "pid: %d\n", pid_nr(gh->gh_owner_pid));
 	printk(KERN_ERR "lock type: %d req lock state : %d\n",
 	       gh->gh_gl->gl_name.ln_type, gh->gh_state);
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 4136270..3d8aa7f 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -95,7 +95,8 @@ static void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks)
 
 static void gfs2_print_trans(const struct gfs2_trans *tr)
 {
-	print_symbol(KERN_WARNING "GFS2: Transaction created at: %s\n", tr->tr_ip);
+	printk(KERN_WARNING "GFS2: Transaction created at: %pSR\n",
+	       (void *)tr->tr_ip);
 	printk(KERN_WARNING "GFS2: blocks=%u revokes=%u reserved=%u touched=%d\n",
 	       tr->tr_blocks, tr->tr_revokes, tr->tr_reserved, tr->tr_touched);
 	printk(KERN_WARNING "GFS2: Buf %u/%u Databuf %u/%u Revoke %u/%u\n",
-- 
1.7.8.112.g3fd21

