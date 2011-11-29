Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab1LERnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:43:46 -0500
Received: from www17.your-server.de ([213.133.104.17]:50792 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674Ab1LERno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:43:44 -0500
Subject: [PATCH] fuse: Use kcalloc instead of kzalloc to allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: miklos@szeredi.hu, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.345.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/fs/fuse/file.c b/fs/fuse/file.c
--- a/fs/fuse/file.c 2011-11-13 11:08:00.957365615 +0100
+++ b/fs/fuse/file.c 2011-11-28 19:48:25.838294455 +0100
@@ -1804,7 +1804,7 @@ long fuse_do_ioctl(struct file *file, un
 	BUILD_BUG_ON(sizeof(struct fuse_ioctl_iovec) * FUSE_IOCTL_MAX_IOV > PAGE_SIZE);
 
 	err = -ENOMEM;
-	pages = kzalloc(sizeof(pages[0]) * FUSE_MAX_PAGES_PER_REQ, GFP_KERNEL);
+	pages = kcalloc(FUSE_MAX_PAGES_PER_REQ, sizeof(pages[0]), GFP_KERNEL);
 	iov_page = (struct iovec *) __get_free_page(GFP_KERNEL);
 	if (!pages || !iov_page)
 		goto out;
