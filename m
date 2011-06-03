Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1FCHel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 03:34:41 -0400
Received: from mail-px0-f170.google.com ([209.85.212.170]:41571 "EHLO
	mail-px0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab1FCHek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 03:34:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=NUEk2Dt5vyQixuevCFFYOpglcOf/ZA1Cd6RmtqC3WabbjDPjDSHEjfRQTkZwC7iZ9S
         UMjD0lhAnE70+t7U0a+QFUE80udckpaevm0aajWKidxMCqUVSYqVTtYgddYnxVfKVu26
         RDLKPMX/kmdpUnUcHKNhJcTB7xOoH9XpblXbc=
Subject: [PATCH] mtd: pxa3xx_nand: remove unused variable 'mtd'
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Eric Miao <eric.y.miao@gmail.com>, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 15:34:33 +0800
Message-ID: <1307086473.7474.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused variable 'mtd' to eliminate below warning.

  CC      drivers/mtd/nand/pxa3xx_nand.o
drivers/mtd/nand/pxa3xx_nand.c: In function 'pxa3xx_nand_suspend':
drivers/mtd/nand/pxa3xx_nand.c:1167: warning: unused variable 'mtd'
drivers/mtd/nand/pxa3xx_nand.c: In function 'pxa3xx_nand_resume':
drivers/mtd/nand/pxa3xx_nand.c:1180: warning: unused variable 'mtd'

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mtd/nand/pxa3xx_nand.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index 1fb3b3a..5cae8ae 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -1164,7 +1164,6 @@ static int pxa3xx_nand_probe(struct platform_device *pdev)
 static int pxa3xx_nand_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct pxa3xx_nand_info *info = platform_get_drvdata(pdev);
-	struct mtd_info *mtd = info->mtd;
 
 	if (info->state) {
 		dev_err(&pdev->dev, "driver busy, state = %d\n", info->state);
@@ -1177,7 +1176,6 @@ static int pxa3xx_nand_suspend(struct platform_device *pdev, pm_message_t state)
 static int pxa3xx_nand_resume(struct platform_device *pdev)
 {
 	struct pxa3xx_nand_info *info = platform_get_drvdata(pdev);
-	struct mtd_info *mtd = info->mtd;
 
 	nand_writel(info, NDTR0CS0, info->ndtr0cs0);
 	nand_writel(info, NDTR1CS0, info->ndtr1cs0);
-- 
1.7.4.1



