Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2KGT01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 14:26:27 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51278 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab2KGT0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 14:26:25 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Ben Collins <bcollins@bluecherry.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ismael Luceno <ismael.luceno@gmail.com>,
        Devendra Naga <devendra.aaru@gmail.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] Staging/media: Use dev_ printks in solo6x10/p2m.c
Date: Thu,  8 Nov 2012 04:26:19 +0900
Message-Id: <1352316379-8078-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/solo6x10/p2m.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/solo6x10/p2m.c b/drivers/staging/media/solo6x10/p2m.c
index 56210f0..58ab61b 100644
--- a/drivers/staging/media/solo6x10/p2m.c
+++ b/drivers/staging/media/solo6x10/p2m.c
@@ -231,15 +231,15 @@ static void run_p2m_test(struct solo_dev *solo_dev)
 	u32 size = SOLO_JPEG_EXT_ADDR(solo_dev) + SOLO_JPEG_EXT_SIZE(solo_dev);
 	int i, d;
 
-	printk(KERN_WARNING "%s: Testing %u bytes of external ram\n",
-	       SOLO6X10_NAME, size);
+	dev_warn(&solo_dev->pdev->dev, "Testing %u bytes of external ram\n",
+		 size);
 
 	for (i = 0; i < size; i += TEST_CHUNK_SIZE)
 		for (d = 0; d < 4; d++)
 			errs += p2m_test(solo_dev, d, i, TEST_CHUNK_SIZE);
 
-	printk(KERN_WARNING "%s: Found %llu errors during p2m test\n",
-	       SOLO6X10_NAME, errs);
+	dev_warn(&solo_dev->pdev->dev, "Found %llu errors during p2m test\n",
+		 errs);
 
 	return;
 }
-- 
1.7.9.5

