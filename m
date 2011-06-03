Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1FCBwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 21:52:00 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51995 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab1FCBv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 21:51:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=judnHMA28pr0jtlJIRCK57matrN5Rd5+5f6/B5xn1k3ySLhXfB3wsYnAYavL4lHO6F
         qd+Yz5eOi+1nYT+oco96XrpUAaT3U8vxh8qzBn6lSthYrIW9sahL1+kHnWEWMV5aoljs
         DUCuSSiNiBWhZNMaqgV6UIqImtwJ1n95kxPcU=
Subject: [PATCH 1/2] mtd: nuc900_nand: add missing nand_release in
 nuc900_nand_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wan ZongShun <mcuos.com@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-mtd@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 09:51:53 +0800
Message-ID: <1307065913.10001.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mtd/nand/nuc900_nand.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/nuc900_nand.c b/drivers/mtd/nand/nuc900_nand.c
index 9c30a0b..fa8faed 100644
--- a/drivers/mtd/nand/nuc900_nand.c
+++ b/drivers/mtd/nand/nuc900_nand.c
@@ -339,6 +339,7 @@ static int __devexit nuc900_nand_remove(struct platform_device *pdev)
 	struct nuc900_nand *nuc900_nand = platform_get_drvdata(pdev);
 	struct resource *res;
 
+	nand_release(&nuc900_nand->mtd);
 	iounmap(nuc900_nand->reg);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
1.7.4.1



