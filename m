Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab2DWKsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:48:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58844 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab2DWKsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:48:52 -0400
Subject: [PATCH] mtd: block2mtd: page_read() never returns NULL
From: Ryosuke Saito <raitosyo@gmail.com>
To: linux-mtd@lists.infradead.org
Cc: artem.bityutskiy@linux.intel.com, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Apr 2012 19:47:17 +0900
Message-ID: <1335178037.3060.7.camel@HDL00099>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

page_read() never returns NULL, so we can remove the NULL check here.

Signed-off-by: Ryosuke Saito <raitosyo@gmail.com>
---
 drivers/mtd/devices/block2mtd.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index a4a80b7..300aeb8 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -52,8 +52,6 @@ static int _block2mtd_erase(struct block2mtd_dev *dev, loff_t to, size_t len)
 
 	while (pages) {
 		page = page_read(mapping, index);
-		if (!page)
-			return -ENOMEM;
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
@@ -112,8 +110,6 @@ static int block2mtd_read(struct mtd_info *mtd, loff_t from, size_t len,
 		len = len - cpylen;
 
 		page = page_read(dev->blkdev->bd_inode->i_mapping, index);
-		if (!page)
-			return -ENOMEM;
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
@@ -148,8 +144,6 @@ static int _block2mtd_write(struct block2mtd_dev *dev, const u_char *buf,
 		len = len - cpylen;
 
 		page = page_read(mapping, index);
-		if (!page)
-			return -ENOMEM;
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
-- 
1.7.9.6


