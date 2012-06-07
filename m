Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465Ab2FGXEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 19:04:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63924 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758267Ab2FGXE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 19:04:29 -0400
From: Sam Hansen <solid.se7en@gmail.com>
To: Sam Hansen <sam@meebo-inc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        Sam Hansen <solid.se7en@gmail.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 3/3] staging: zram: conventions, line splitting
Date: Thu,  7 Jun 2012 16:03:49 -0700
Message-Id: <1339110229-19383-4-git-send-email-solid.se7en@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1339110229-19383-1-git-send-email-solid.se7en@gmail.com>
References: <1339110229-19383-1-git-send-email-solid.se7en@gmail.com>
In-Reply-To: <1339100404-18773-1-git-send-email-solid.se7en@gmail.com>
References: <1339100404-18773-1-git-send-email-solid.se7en@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Opting to violate the 80-char limit in favor of not splitting strings onto
multiple lines (via pr_info()).  This mostly to help readability.

Signed-off-by: Sam Hansen <solid.se7en@gmail.com>
---
 drivers/staging/zram/zram_drv.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 55775ce..6292045 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -390,8 +390,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		clen = PAGE_SIZE;
 		page_store = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
 		if (unlikely(!page_store)) {
-			pr_info("Error allocating memory for "
-				"incompressible page: %u\n", index);
+			pr_info("Error allocating memory for incompressible page: %u\n",
+				index);
 			ret = -ENOMEM;
 			goto out;
 		}
@@ -407,8 +407,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 
 	handle = zs_malloc(zram->mem_pool, clen + sizeof(*zheader));
 	if (!handle) {
-		pr_info("Error allocating memory for compressed "
-			"page: %u, size=%zu\n", index, clen);
+		pr_info("Error allocating memory for compressed page: %u, size=%zu\n",
+			index, clen);
 		ret = -ENOMEM;
 		goto out;
 	}
-- 
1.7.5.4

