Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab2BCNqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 08:46:16 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47443 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412Ab2BCNqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 08:46:15 -0500
From: amit.sahrawat83@gmail.com
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Amit Sahrawat <a.sahrawat@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 3/3] bio-integrity: use kmem_cache_zalloc in bio_integrity_alloc_bioset()
Date: Fri,  3 Feb 2012 19:20:19 +0530
Message-Id: <4f2be526.8706440a.5b8d.2713@mx.google.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Sahrawat <amit.sahrawat83@gmail.com>

Use advantage of kmem_cache_zalloc() to remove memset() call in
bio_integrity_alloc_bioset()

Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/bio-integrity.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index c2183f3..836e34b 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -93,7 +93,7 @@ struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *bio,
 
 	/* Lower order allocations come straight from slab */
 	if (!use_bip_pool(idx))
-		bip = kmem_cache_alloc(bip_slab[idx].slab, gfp_mask);
+		bip = kmem_cache_zalloc(bip_slab[idx].slab, gfp_mask);
 
 	/* Use mempool if lower order alloc failed or max vecs were requested */
 	if (bip == NULL) {
@@ -106,8 +106,6 @@ struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *bio,
 		}
 	}
 
-	memset(bip, 0, sizeof(*bip));
-
 	bip->bip_slab = idx;
 	bip->bip_bio = bio;
 	bio->bi_integrity = bip;
-- 
1.7.2.3

