Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab1F3EfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 00:35:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44839 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab1F3EfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 00:35:03 -0400
Subject: [PATCH] mtd: tmio_nand: fix build error
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jun 2011 12:34:54 +0800
Message-ID: <1309408494.10500.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a mistake introduced by commit 33f4a3b
"mtd: tmio_nand.c: use mtd_device_parse_register"

  CC [M]  drivers/mtd/nand/tmio_nand.o
drivers/mtd/nand/tmio_nand.c:461:35: error: macro "mtd_device_register" passed 5 arguments, but takes just 3
drivers/mtd/nand/tmio_nand.c: In function 'tmio_probe':
drivers/mtd/nand/tmio_nand.c:459: error: 'mtd_device_register' undeclared (first use in this function)
drivers/mtd/nand/tmio_nand.c:459: error: (Each undeclared identifier is reported only once
drivers/mtd/nand/tmio_nand.c:459: error: for each function it appears in.)
make[3]: *** [drivers/mtd/nand/tmio_nand.o] Error 1
make[2]: *** [drivers/mtd/nand] Error 2
make[1]: *** [drivers/mtd] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mtd/nand/tmio_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/tmio_nand.c b/drivers/mtd/nand/tmio_nand.c
index d476857..beebd95 100644
--- a/drivers/mtd/nand/tmio_nand.c
+++ b/drivers/mtd/nand/tmio_nand.c
@@ -456,7 +456,7 @@ static int tmio_probe(struct platform_device *dev)
 		goto err_scan;
 	}
 	/* Register the partitions */
-	retval = mtd_device_register(mtd, NULL, 0,
+	retval = mtd_device_parse_register(mtd, NULL, 0,
 			data ? data->partition : NULL,
 			data ? data->num_partitions : 0);
 	if (!retval)
-- 
1.7.4.1



