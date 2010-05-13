Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865Ab0EMUH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:07:57 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:44489 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514Ab0EMUHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:07:51 -0400
Date: Thu, 13 May 2010 22:07:46 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Vincent Sanders <support@simtec.co.uk>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 20/20] drivers/mtd/nand: Use kzalloc
Message-ID: <Pine.LNX.4.64.1005132207300.6282@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kzalloc rather than the combination of kmalloc and memset.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,size,flags;
statement S;
@@

-x = kmalloc(size,flags);
+x = kzalloc(size,flags);
 if (x == NULL) S
-memset(x, 0, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mtd/nand/s3c2410.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -u -p a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -929,14 +929,13 @@ static int s3c24xx_nand_probe(struct pla
 
 	pr_debug("s3c2410_nand_probe(%p)\n", pdev);
 
-	info = kmalloc(sizeof(*info), GFP_KERNEL);
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (info == NULL) {
 		dev_err(&pdev->dev, "no memory for flash info\n");
 		err = -ENOMEM;
 		goto exit_error;
 	}
 
-	memset(info, 0, sizeof(*info));
 	platform_set_drvdata(pdev, info);
 
 	spin_lock_init(&info->controller.lock);
@@ -994,15 +993,13 @@ static int s3c24xx_nand_probe(struct pla
 	/* allocate our information */
 
 	size = nr_sets * sizeof(*info->mtds);
-	info->mtds = kmalloc(size, GFP_KERNEL);
+	info->mtds = kzalloc(size, GFP_KERNEL);
 	if (info->mtds == NULL) {
 		dev_err(&pdev->dev, "failed to allocate mtd storage\n");
 		err = -ENOMEM;
 		goto exit_error;
 	}
 
-	memset(info->mtds, 0, size);
-
 	/* initialise all possible chips */
 
 	nmtd = info->mtds;
