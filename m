Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423429Ab2I1VjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:39:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63067 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423354Ab2I1VgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:36:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH 01/12] mtd: atmel nand: build regression
Date: Fri, 28 Sep 2012 23:36:06 +0200
Message-Id: <1348868177-21205-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1348868177-21205-1-git-send-email-arnd@arndb.de>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:9Fbq1MsUJ6ygBmdvuMvCw5l1YBa5tixauLBXHjpezPS
 7XjGAC0y9mmto3CZ2xKlakgzP7Yd/X8mcfvmBCXrmGIej4hzbT
 3RM0Wxjjhs8Ia4YbrdAfhMHI9XwZ4p3Qd/mYUZ+rrk7T/XBkda
 Yb12wN8gA94mIuJLduualKvZPs54CoGgh9y7Xrs7wx03Q0eNFT
 N+uqNje4f2y8HkKW9S6bnBQtjvmWHgtIrYM3USXJ63mUOXthhq
 wBCqrWPCmR2dloXXx0b6fB8Rc/FIEd5mwF7/9cJxiRtREv8jI0
 e2EHFcZIlyTgYvIJMFlALr+UMJbH6bJ17wMyXJa4vJiuQXF9yx
 AOXBGcUEGCsSm70dfUzWbyn0RIDMLjOywUt+ZvUTZy+H6gI3Hh
 S3ODNglIchogw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atmel_nand driver was broken by b654a9a46fc2 "mtd: atmel nand: fix
gpio missing request". This is a rather helpless attempt to fix this,
probably messing up the error handling even further but getting the
build to work again, so please treat it as a bug report rather than
a fix to be applied.

Without this patch, building any at91 configuration results in:

drivers/mtd/nand/atmel_nand.c: In function 'atmel_nand_probe':
drivers/mtd/nand/atmel_nand.c:1451:4: error: label 'err_ecc_ioremap' used but not defined

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 drivers/mtd/nand/atmel_nand.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 9144557..eba5b2a 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -1420,7 +1420,7 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev,
 				"can't request rdy gpio %d\n",
 				host->board.rdy_pin);
-			goto err_ecc_ioremap;
+			goto err_no_card;
 		}
 
 		res = gpio_direction_input(host->board.rdy_pin);
@@ -1428,7 +1428,7 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev,
 				"can't request input direction rdy gpio %d\n",
 				host->board.rdy_pin);
-			goto err_ecc_ioremap;
+			goto err_no_card;
 		}
 
 		nand_chip->dev_ready = atmel_nand_device_ready;
@@ -1440,7 +1440,7 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev,
 				"can't request enable gpio %d\n",
 				host->board.enable_pin);
-			goto err_ecc_ioremap;
+			goto err_no_card;
 		}
 
 		res = gpio_direction_output(host->board.enable_pin, 1);
@@ -1448,7 +1448,7 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev,
 				"can't request output direction enable gpio %d\n",
 				host->board.enable_pin);
-			goto err_ecc_ioremap;
+			goto err_no_card;
 		}
 	}
 
-- 
1.7.10

