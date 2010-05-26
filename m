Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab0EZOoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 10:44:39 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44776 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab0EZOoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 10:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Vc8dcjKVQy3XGIMhd/QNiMF6oEfStf/flKeuXS8bbbIwfXusCxyYND15UNuhWUPqGX
         0vjymm486w3U4EdaBz+p2oWLTu6dPzoiDNw7sbA5dS75WKpShry/D9wsDRYwLPMXK6G/
         lBb/h6ZPBI+DqGAgvzfoAPh8BYSSFr0LjIvMY=
From: Changli Gao <xiaosuo@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Miklos Szeredi <mszeredi@suse.cz>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH v2 2/4] splice: direct_splice_actor() should not use pos in sd
Date: Wed, 26 May 2010 22:43:50 +0800
Message-Id: <1274885030-15661-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

direct_splice_actor() should not use pos in sd

direct_splice_actor() shouldn't use sd->pos, as sd->pos is for file reading,
file->f_pos should be used instead.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 fs/splice.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
diff --git a/fs/splice.c b/fs/splice.c
index 9e52de5..eb602cb 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1232,7 +1232,8 @@ static int direct_splice_actor(struct pipe_inode_info *pipe,
 {
 	struct file *file = sd->u.file;
 
-	return do_splice_from(pipe, file, &sd->pos, sd->total_len, sd->flags);
+	return do_splice_from(pipe, file, &file->f_pos, sd->total_len,
+			      sd->flags);
 }
 
 /**
