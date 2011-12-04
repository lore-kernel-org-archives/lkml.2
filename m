Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab1LDFst (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 00:48:49 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:52445
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750867Ab1LDFso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 00:48:44 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h66h)
X-Spam-TCS-SCL: 5:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: <shuo.liu@freescale.com>
To: <dwmw2@infradead.org>, <Artem.Bityutskiy@nokia.com>,
        <scottwood@freescale.com>
CC: <linux-mtd@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <shuo.liu@freescale.com>
Subject: [PATCH 2/3] mtd/nand : set correct length to FBCR for a non-full-page write
Date: Sun, 4 Dec 2011 12:31:37 +0800
Message-ID: <1322973098-2528-2-git-send-email-shuo.liu@freescale.com>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Shuo <b35362@freescale.com>

When we do a non-full-page write, the length be set to FBCR should
not be 'elbc_fcm_ctrl->index', it should be 'elbc_fcm_ctrl->index -
elbc_fcm_ctrl->column'.

Signed-off-by: Liu Shuo <b35362@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
---
 drivers/mtd/nand/fsl_elbc_nand.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index 6fce7da..d634c5f 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -474,7 +474,8 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 		 */
 		if (elbc_fcm_ctrl->oob || elbc_fcm_ctrl->column != 0 ||
 		    elbc_fcm_ctrl->index != mtd->writesize + mtd->oobsize)
-			out_be32(&lbc->fbcr, elbc_fcm_ctrl->index);
+			out_be32(&lbc->fbcr,
+				elbc_fcm_ctrl->index - elbc_fcm_ctrl->column);
 		else
 			out_be32(&lbc->fbcr, 0);
 
-- 
1.7.1


