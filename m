Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab0LQMs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:48:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab0LQMqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:46:12 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Joe Perches <joe@perches.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/15] GFS2: fs/gfs2/glock.c: Use printf extension %pV
Date: Fri, 17 Dec 2010 12:24:11 +0000
Message-Id: <1292588661-14350-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
References: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Using %pV reduces the number of printk calls and
eliminates any possible message interleaving from
other printk calls.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 13155f6..a9b53a4 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -951,17 +951,22 @@ int gfs2_glock_wait(struct gfs2_holder *gh)
 
 void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	va_start(args, fmt);
+
 	if (seq) {
 		struct gfs2_glock_iter *gi = seq->private;
 		vsprintf(gi->string, fmt, args);
 		seq_printf(seq, gi->string);
 	} else {
-		printk(KERN_ERR " ");
-		vprintk(fmt, args);
+		vaf.fmt = fmt;
+		vaf.va = &args;
+
+		printk(KERN_ERR " %pV", &vaf);
 	}
+
 	va_end(args);
 }
 
-- 
1.7.3.3

