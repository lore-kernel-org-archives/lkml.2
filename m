Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163Ab0G3SOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:14:33 -0400
Received: from kroah.org ([198.145.64.141]:59036 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932364Ab0G3R5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:10 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:47 2010
Message-Id: <20100730175147.872040435@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Changli Gao <xiaosuo@gmail.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [153/205] splice: direct_splice_actor() should not use pos in sd
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Changli Gao <xiaosuo@gmail.com>

commit 2cb4b05e7647891b46b91c07c9a60304803d1688 upstream.

direct_splice_actor() shouldn't use sd->pos, as sd->pos is for file reading,
file->f_pos should be used instead.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/splice.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1232,7 +1232,8 @@ static int direct_splice_actor(struct pi
 {
 	struct file *file = sd->u.file;
 
-	return do_splice_from(pipe, file, &sd->pos, sd->total_len, sd->flags);
+	return do_splice_from(pipe, file, &file->f_pos, sd->total_len,
+			      sd->flags);
 }
 
 /**


