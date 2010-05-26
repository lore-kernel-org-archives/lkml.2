Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0EZOpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 10:45:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35551 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab0EZOpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 10:45:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JI1W9NzMNlI9rabyfYCWvdRlbl2ZkA7t7ixtvkoxZxST5JibeiGA3BSGSwI5042Vd9
         5N7hYV+UVXJ0ic+3bR0GMiWUmxl5ge5R25+zs4vDBJHh4pePikY+9V/A7SFs4oH8yw90
         7OYCwea1fVsH70FLNeQDYov/YrZmHB5O9Cq2I=
From: Changli Gao <xiaosuo@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Miklos Szeredi <mszeredi@suse.cz>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH v2 4/4] splice: fix updating sd->pos wrongly
Date: Wed, 26 May 2010 22:44:43 +0800
Message-Id: <1274885083-15735-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix updating sd->pos wrongly.

In error path, we don't need to updating sd->pos, if the file isn't seekable.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 fs/splice.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
diff --git a/fs/splice.c b/fs/splice.c
index 57172ca..c69b241 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1185,7 +1185,8 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 		sd->pos = pos;
 
 		if (ret < read_len) {
-			sd->pos = prev_pos + ret;
+			if (sd->pos)
+				sd->pos = prev_pos + ret;
 			goto out_release;
 		}
 	}
