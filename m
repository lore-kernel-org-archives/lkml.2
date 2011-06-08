Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1FHNBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 09:01:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52438 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab1FHNBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 09:01:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Nz/nLdYtKisSloqnHMa/a4aVhbJuCgInI4r3hypsZdvmfLgT/wauUCfSUoW8NIYbU2
         t6i1HjAMrPQexRJVVf+LogrJj7XZygCJ2SsXJ5weg+DcJV5vrQASi4j5w1cpQpoGMHrr
         opolMSbtWK54d5lKnYTxs2EA+O02uyVlcqhDE=
Subject: [PATCH] mtd: davinci_nand: remove redundant mtd_device_unregister
 in nand_davinci_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-mtd@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 21:01:37 +0800
Message-ID: <1307538097.17552.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mtd_device_unregister is done in nand_release(),
thus no need to call it in nand_davinci_remove().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mtd/nand/davinci_nand.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index 0c582ed..70c92a5 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -811,9 +811,6 @@ err_nomem:
 static int __exit nand_davinci_remove(struct platform_device *pdev)
 {
 	struct davinci_nand_info *info = platform_get_drvdata(pdev);
-	int status;
-
-	status = mtd_device_unregister(&info->mtd);
 
 	spin_lock_irq(&davinci_nand_lock);
 	if (info->chip.ecc.mode == NAND_ECC_HW_SYNDROME)
-- 
1.7.4.1



