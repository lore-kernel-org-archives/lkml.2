Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab1IWMKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 08:10:09 -0400
Received: from mailbackup.inode.at ([213.229.60.24]:51482 "EHLO
	mailbackup.inode.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab1IWMKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 08:10:06 -0400
X-Greylist: delayed 961 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Sep 2011 08:10:05 EDT
From: Michael Thalmeier <michael.thalmeier@hale.at>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mxc_nand: preset_v1_v2: unlock all NAND flash blocks
Date: Fri, 23 Sep 2011 13:53:44 +0200
Message-Id: <1316778824-12518-1-git-send-email-michael.thalmeier@hale.at>
X-Mailer: git-send-email 1.7.6.2
MIME-Version: 1.0
X-HALE-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: p8NBroZl005055
X-HALE-MailScanner: Found to be clean
X-HALE-MailScanner-From: michael.thalmeier@hale.at
MailScanner-NULL-Check: 1317383631.54472@KxNHLD3yMKWLP5M7Kx0ctw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Stering <wolfram.stering@hale.at>

For NFC v1, the unlock end block address was 0x4000, which would only
unlock the first 32 blocks of the NAND flash.  Change that value to
0xffff to unlock all available blocks, as is done for NFC v21 as well.

Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
---
 drivers/mtd/nand/mxc_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 90df34c..5b40786 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -849,7 +849,7 @@ static void preset_v1_v2(struct mtd_info *mtd)
 		writew(0xffff, NFC_V21_UNLOCKEND_BLKADDR3);
 	} else if (nfc_is_v1()) {
 		writew(0x0, NFC_V1_UNLOCKSTART_BLKADDR);
-		writew(0x4000, NFC_V1_UNLOCKEND_BLKADDR);
+		writew(0xffff, NFC_V1_UNLOCKEND_BLKADDR);
 	} else
 		BUG();
 
-- 
1.7.6.2



--
Scanned by MailScanner.

