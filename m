Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab0E2BUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 21:20:07 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:53807 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab0E2BTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 21:19:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nVacNJWYhIltq8vTGkLwWXxA7eswieqVX4pNdlHfCmNsroDTwATT39WRzWAXRDAqav
         m4yzOHPJmcCHkvqrPeGUljfqplelbV9rTK79JqeAW4h05BiFtFkIncCIJKzh7rC3I/dQ
         fOzbMKUo2vcJ/4QFT8OL6aI7J9vmGP2BIQGbc=
From: Changli Gao <xiaosuo@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH 1/2] fs: optimize mpage_readpage()
Date: Sat, 29 May 2010 09:18:46 +0800
Message-Id: <1275095926-18345-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

optimize mpage_readpage()

we don't need to initialize bio, and pass it to do_mpage_readpage() as
parameter, as it is returned by do_mpage_readpage().

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 fs/mpage.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
diff --git a/fs/mpage.c b/fs/mpage.c
index fd56ca2..94ff0d1 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -409,14 +409,14 @@ EXPORT_SYMBOL(mpage_readpages);
  */
 int mpage_readpage(struct page *page, get_block_t get_block)
 {
-	struct bio *bio = NULL;
+	struct bio *bio;
 	sector_t last_block_in_bio = 0;
 	struct buffer_head map_bh;
 	unsigned long first_logical_block = 0;
 
 	map_bh.b_state = 0;
 	map_bh.b_size = 0;
-	bio = do_mpage_readpage(bio, page, 1, &last_block_in_bio,
+	bio = do_mpage_readpage(NULL, page, 1, &last_block_in_bio,
 			&map_bh, &first_logical_block, get_block);
 	if (bio)
 		mpage_bio_submit(READ, bio);
