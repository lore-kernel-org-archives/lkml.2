Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab0F2LJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 07:09:23 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48317 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab0F2LJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 07:09:22 -0400
To: Jens Axboe <axboe@kernel.dk>
CC: xiaosuo@gmail.com, tim.gardner@canonical.com,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <E1OTYfk-0008GY-PJ@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Tue, 29 Jun 2010 13:08:12 +0200)
Subject: [PATCH 1/3] splice: direct_splice_actor() should not use pos in sd
References: <E1OTYfk-0008GY-PJ@pomaz-ex.szeredi.hu>
Message-Id: <E1OTYgo-0008HJ-Jk@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 29 Jun 2010 13:09:18 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Changli Gao <xiaosuo@gmail.com>

direct_splice_actor() shouldn't use sd->pos, as sd->pos is for file reading,
file->f_pos should be used instead.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
----
 fs/splice.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2010-06-29 12:46:27.000000000 +0200
+++ linux-2.6/fs/splice.c	2010-06-29 12:46:28.000000000 +0200
@@ -1282,7 +1282,8 @@ static int direct_splice_actor(struct pi
 {
 	struct file *file = sd->u.file;
 
-	return do_splice_from(pipe, file, &sd->pos, sd->total_len, sd->flags);
+	return do_splice_from(pipe, file, &file->f_pos, sd->total_len,
+			      sd->flags);
 }
 
 /**
