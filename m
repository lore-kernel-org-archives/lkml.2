Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab1KCB4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:56:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51182 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934393Ab1KCBkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:40:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:43 2011
Message-Id: <20111102222743.846479604@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Changli Gao <xiaosuo@gmail.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Jens Axboe <jaxboe@fusionio.com>
Subject: [045/101] splice: direct_splice_actor() should not use pos in sd
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -1231,7 +1231,8 @@ static int direct_splice_actor(struct pi
 {
 	struct file *file = sd->u.file;
 
-	return do_splice_from(pipe, file, &sd->pos, sd->total_len, sd->flags);
+	return do_splice_from(pipe, file, &file->f_pos, sd->total_len,
+			      sd->flags);
 }
 
 /**


