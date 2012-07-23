Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab2GWI2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:28:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076Ab2GWI0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:26:23 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/16] GFS2: Use seq_vprintf for glocks debugfs file
Date: Mon, 23 Jul 2012 09:00:59 +0100
Message-Id: <1343030466-3053-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
References: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the newly added seq_vprintf() function.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 10ae164..4d5d63d 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -51,7 +51,6 @@ struct gfs2_glock_iter {
 	struct gfs2_sbd *sdp;		/* incore superblock           */
 	struct gfs2_glock *gl;		/* current glock struct        */
 	loff_t last_pos;		/* last position               */
-	char string[512];		/* scratch space               */
 };
 
 typedef void (*glock_examiner) (struct gfs2_glock * gl);
@@ -951,9 +950,7 @@ void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...)
 	va_start(args, fmt);
 
 	if (seq) {
-		struct gfs2_glock_iter *gi = seq->private;
-		vsprintf(gi->string, fmt, args);
-		seq_puts(seq, gi->string);
+		seq_vprintf(seq, fmt, args);
 	} else {
 		vaf.fmt = fmt;
 		vaf.va = &args;
-- 
1.7.4

