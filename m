Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab2BJFrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:47:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577Ab2BJFru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:47:50 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Neil Brown <neilb@suse.de>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org
Subject: [PATCH 55/60] dm: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:40:16 +0800
Message-Id: <1328852421-19678-56-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/md/dm-crypt.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8c2a000..db6b516 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -590,9 +590,9 @@ static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
 	int r = 0;
 
 	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
-		src = kmap_atomic(sg_page(&dmreq->sg_in), KM_USER0);
+		src = kmap_atomic(sg_page(&dmreq->sg_in));
 		r = crypt_iv_lmk_one(cc, iv, dmreq, src + dmreq->sg_in.offset);
-		kunmap_atomic(src, KM_USER0);
+		kunmap_atomic(src);
 	} else
 		memset(iv, 0, cc->iv_size);
 
@@ -608,14 +608,14 @@ static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
 	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE)
 		return 0;
 
-	dst = kmap_atomic(sg_page(&dmreq->sg_out), KM_USER0);
+	dst = kmap_atomic(sg_page(&dmreq->sg_out));
 	r = crypt_iv_lmk_one(cc, iv, dmreq, dst + dmreq->sg_out.offset);
 
 	/* Tweak the first block of plaintext sector */
 	if (!r)
 		crypto_xor(dst + dmreq->sg_out.offset, iv, cc->iv_size);
 
-	kunmap_atomic(dst, KM_USER0);
+	kunmap_atomic(dst);
 	return r;
 }
 
-- 
1.7.7.6

