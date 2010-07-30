Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab0G3R7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:59:08 -0400
Received: from kroah.org ([198.145.64.141]:59044 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932665Ab0G3R5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:11 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:48 2010
Message-Id: <20100730175147.957283369@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Changli Gao <xiaosuo@gmail.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [154/205] splice: check f_mode for seekable file
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Changli Gao <xiaosuo@gmail.com>

commit 19c9a49b432f245c6293508d164a4350f1f2c601 upstream.

check f_mode for seekable file

As a seekable file is allowed without a llseek function, so the old way isn't
work any more.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/splice.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1322,8 +1322,7 @@ static long do_splice(struct file *in, l
 		if (off_in)
 			return -ESPIPE;
 		if (off_out) {
-			if (!out->f_op || !out->f_op->llseek ||
-			    out->f_op->llseek == no_llseek)
+			if (!(out->f_mode & FMODE_PWRITE))
 				return -EINVAL;
 			if (copy_from_user(&offset, off_out, sizeof(loff_t)))
 				return -EFAULT;
@@ -1343,8 +1342,7 @@ static long do_splice(struct file *in, l
 		if (off_out)
 			return -ESPIPE;
 		if (off_in) {
-			if (!in->f_op || !in->f_op->llseek ||
-			    in->f_op->llseek == no_llseek)
+			if (!(in->f_mode & FMODE_PREAD))
 				return -EINVAL;
 			if (copy_from_user(&offset, off_in, sizeof(loff_t)))
 				return -EFAULT;


