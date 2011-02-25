Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200Ab1BYFJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 00:09:14 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:43680
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750753Ab1BYFJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 00:09:12 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw01.freescale.net;RD:az33egw01.freescale.net;EFVD:NLI
From: Jason Liu <r64343@freescale.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <David.Woodhouse@intel.com>, <dedekind1@gmail.com>
Subject: [PATCH] mtd: nand: fix one typo in the comments
Date: Fri, 25 Feb 2011 13:06:18 +0800
Message-ID: <1298610378-3105-1-git-send-email-r64343@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the function nand_do_write_oob, the comments
has one typo, this patch fix it.

- /* Do not allow reads past end of device */
+ /* Do not allow write past end of device */
if (unlikely(to >= mtd->size ||
	     ops->ooboffs + ops->ooblen >
		((mtd->size >> chip->page_shift) -
		 (to >> chip->page_shift)) * len)) {
	DEBUG(MTD_DEBUG_LEVEL0, "%s: Attempt write beyond "
			"end of device\n", __func__);
	return -EINVAL;
}

Signed-off-by: Jason Liu <r64343@freescale.com>
---
 drivers/mtd/nand/nand_base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index a9c6ce7..da76040 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2377,7 +2377,7 @@ static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
 		return -EINVAL;
 	}
 
-	/* Do not allow reads past end of device */
+	/* Do not allow write past end of device */
 	if (unlikely(to >= mtd->size ||
 		     ops->ooboffs + ops->ooblen >
 			((mtd->size >> chip->page_shift) -
-- 
1.7.0.4


