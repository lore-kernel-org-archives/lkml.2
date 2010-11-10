Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab0KJAga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:36:30 -0500
Received: from mail.perches.com ([173.55.12.10]:4847 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab0KJAfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:35:31 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH 6/9] fs/gfs2/glock.c: Use printf extension %pV
Date: Tue,  9 Nov 2010 16:35:20 -0800
Message-Id: <5918196ac71b4e3184a534643cdf499b54416541.1289348757.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289348757.git.joe@perches.com>
References: <cover.1289348757.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pV reduces the number of printk calls and
eliminates any possible message interleaving from
other printk calls.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/gfs2/glock.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 8777885..d30b39c 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -952,17 +952,22 @@ int gfs2_glock_wait(struct gfs2_holder *gh)
 
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
1.7.3.1.g432b3.dirty

