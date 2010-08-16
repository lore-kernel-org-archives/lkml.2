Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab0HPIsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 04:48:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61776 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab0HPIsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 04:48:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=TFm9aen69aqs/cFexAiWNORf1ZKpbQORqDQNQfAUJcoARvnqJCvMv9+jKpYwsXLP6t
         AYZmH7OseeA0Qohv9FHxtJoU+4rnU8NqmkNNQnkBjnH+TyuDruJDxO2qdxBqFVKoT1nB
         JZQahQSUScqEDzhFJtF0EPOpnXGX/D0ywKolA=
Subject: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for samsung2GbX8
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Eric Miao <eric.y.miao@gmail.com>,
        linux-mtd@lists.infradead.org
Content-Type: text/plain
Date: Mon, 16 Aug 2010 16:50:41 +0800
Message-Id: <1281948641.29696.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds timing settings for samsung2GbX8 and
fixes the cmdset settings. samsung2GbX8 is large page.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mtd/nand/pxa3xx_nand.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index 4d89f37..47c0442 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -227,9 +227,21 @@ static struct pxa3xx_nand_flash samsung512MbX16 = {
 	.chip_id	= 0x46ec,
 };
 
+static struct pxa3xx_nand_timing samsung2GbX8_timing = {
+	.tCH	= 5,
+	.tCS	= 20,
+	.tWH	= 10,
+	.tWP	= 12,
+	.tRH	= 10,
+	.tRP	= 12,
+	.tR	= 25000,
+	.tWHR	= 60,
+	.tAR	= 10,
+};
+
 static struct pxa3xx_nand_flash samsung2GbX8 = {
-	.timing		= &samsung512MbX16_timing,
-	.cmdset		= &smallpage_cmdset,
+	.timing		= &samsung2GbX8_timing,
+	.cmdset		= &largepage_cmdset,
 	.page_per_block	= 64,
 	.page_size	= 2048,
 	.flash_width	= 8,
-- 
1.7.2



