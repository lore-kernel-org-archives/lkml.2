Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1FCFOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 01:14:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44756 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1FCFOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 01:14:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=pljodSjzCXBd6cTxL3sykZNe1SPQQHfpeolCy9nKtb+U59//AJ//N8vCPRecz2Ijh4
         CRFkOHltSSkHFQNvdK5xOVaIVFkImuCRquB4xinIcZjEyAPjbbelH/Qm9RDf5uSsPMHA
         dME6zWolsOhkQqjq7+CRl7G0i84OJGzs2L0go=
Subject: [PATCH 1/2] mtd: pxa3xx_nand: fix a memory leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 13:14:10 +0800
Message-ID: <1307078050.4167.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In pxa3xx_nand_remove, we should call nand_release instead of
mtd_device_unregister to properly free bad block table memory
and bad block descriptor memory.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mtd/nand/pxa3xx_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index 1fb3b3a..f7040ea 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -1119,7 +1119,7 @@ static int pxa3xx_nand_remove(struct platform_device *pdev)
 	clk_put(info->clk);
 
 	if (mtd) {
-		mtd_device_unregister(mtd);
+		nand_release(mtd);
 		kfree(mtd);
 	}
 	return 0;
-- 
1.7.4.1



