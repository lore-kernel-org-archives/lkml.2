Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab0E2BUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 21:20:38 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47987 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab0E2BUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 21:20:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=e49bqcWfa2PWnbvZYungDjJIOFbDV8IXC7q2h4NgKatgZmeP36nvyLLeAzwLli2cmT
         q/m85VYdOi+CzKCZwIuuh3nUe7+4sZk683Oc/xUmFs7pE9XeExKWghdzsM5YuUshnom1
         3q71h3tKpe7XbPBWyS703VfnP9rOk65yh3mhs=
From: Changli Gao <xiaosuo@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH 2/2] fs: optimize mpage_bio_submit()
Date: Sat, 29 May 2010 09:19:26 +0800
Message-Id: <1275095966-18382-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

optimize mpage_bio_submit()

check rw, then initialize bio->bi_end_io.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 fs/mpage.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)
diff --git a/fs/mpage.c b/fs/mpage.c
index 94ff0d1..632681c 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -85,9 +85,7 @@ static void mpage_end_io_write(struct bio *bio, int err)
 
 static struct bio *mpage_bio_submit(int rw, struct bio *bio)
 {
-	bio->bi_end_io = mpage_end_io_read;
-	if (rw == WRITE)
-		bio->bi_end_io = mpage_end_io_write;
+	bio->bi_end_io = rw != WRITE ? mpage_end_io_read : mpage_end_io_write;
 	submit_bio(rw, bio);
 	return NULL;
 }
