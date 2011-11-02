Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933538Ab1KCBgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:36:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933355Ab1KCBg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:36:28 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:54 2011
Message-Id: <20111102221454.143823023@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Changli Gao <xiaosuo@gmail.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Jens Axboe <jaxboe@fusionio.com>
Subject: [044/107] splice: direct_splice_actor() should not use pos in sd
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -1221,7 +1221,8 @@ static int direct_splice_actor(struct pi
 {
 	struct file *file = sd->u.file;
 
-	return do_splice_from(pipe, file, &sd->pos, sd->total_len, sd->flags);
+	return do_splice_from(pipe, file, &file->f_pos, sd->total_len,
+			      sd->flags);
 }
 
 /**


