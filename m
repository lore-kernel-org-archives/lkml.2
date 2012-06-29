Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab2F2O4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 10:56:07 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:57379 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab2F2O4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 10:56:04 -0400
Message-ID: <1340981763.25226.5.camel@gurkel.linbit>
Subject: [RFC] [TCP 3/3] fs: Export bio_release_pages()
From: Andreas Gruenbacher <agruen@linbit.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 29 Jun 2012 16:56:03 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
---
 fs/bio.c            |    3 ++-
 include/linux/bio.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/bio.c b/fs/bio.c
index 73922ab..90501a5 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1335,7 +1335,7 @@ void bio_set_pages_dirty(struct bio *bio)
 	}
 }
 
-static void bio_release_pages(struct bio *bio)
+void bio_release_pages(struct bio *bio)
 {
 	struct bio_vec *bvec = bio->bi_io_vec;
 	int i;
@@ -1347,6 +1347,7 @@ static void bio_release_pages(struct bio *bio)
 			put_page(page);
 	}
 }
+EXPORT_SYMBOL(bio_release_pages);
 
 /*
  * bio_check_pages_dirty() will check that all the BIO's pages are still dirty.
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 2643589..268ec49 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -246,6 +246,7 @@ extern struct bio *bio_copy_kern(struct request_queue *, void *, unsigned int,
 				 gfp_t, int);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
+extern void bio_release_pages(struct bio *bio);
 
 #ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
 # error	"You should define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform"
-- 
1.7.10.2


