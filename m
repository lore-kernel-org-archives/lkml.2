Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab2FKM6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 08:58:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab2FKM6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 08:58:10 -0400
Subject: Re: [Cluster-devel] [PATCH] Add seq_vprintf and use in gfs2 (was
 Re: GFS2: Cache last hash bucket for glock seq_files)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <1339410072.2734.17.camel@menhir>
References: <1339152726.2752.3.camel@menhir>
	 <1339230731.6001.159.camel@edumazet-glaptop>
	 <1339403377.2734.7.camel@menhir>
	 <1339404517.6001.1767.camel@edumazet-glaptop>
	 <1339410072.2734.17.camel@menhir>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 11 Jun 2012 13:56:55 +0100
Message-ID: <1339419415.2734.27.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1bb49303b7a82eb9bce0595087523343683abdf0 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Mon, 11 Jun 2012 13:26:50 +0100
Subject: [PATCH 2/2] GFS2: Use seq_vprintf for glocks debugfs file

Make use of the newly added seq_vprintf() function.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
---
 fs/gfs2/glock.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

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



