Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab1E1RjL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 13:39:11 -0400
Received: from mail.perches.com ([173.55.12.10]:2217 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427Ab1E1RhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 13:37:11 -0400
From: Joe Perches <joe@perches.com>
To: David Woodhouse <dwmw2@infradead.org>, Jiri Kosina <trivial@kernel.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH next 09/15] mtd: Convert vmalloc/memset to vzalloc
Date: Sat, 28 May 2011 10:36:29 -0700
Message-Id: <adc50014679048de28c7d536f1686cd945fc40f6.1306603968.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1306603968.git.joe@perches.com>
References: <cover.1306603968.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mtd/mtdswap.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/mtdswap.c b/drivers/mtd/mtdswap.c
index fd78853..5e5423b 100644
--- a/drivers/mtd/mtdswap.c
+++ b/drivers/mtd/mtdswap.c
@@ -1374,11 +1374,10 @@ static int mtdswap_init(struct mtdswap_dev *d, unsigned int eblocks,
 		goto revmap_fail;
 
 	eblk_bytes = sizeof(struct swap_eb)*d->eblks;
-	d->eb_data = vmalloc(eblk_bytes);
+	d->eb_data = vzalloc(eblk_bytes);
 	if (!d->eb_data)
 		goto eb_data_fail;
 
-	memset(d->eb_data, 0, eblk_bytes);
 	for (i = 0; i < pages; i++)
 		d->page_data[i] = BLOCK_UNDEF;
 
-- 
1.7.5.rc3.dirty

