Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab1FPHNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:13:35 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:40044 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757079Ab1FPHLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:36 -0400
X-Sasl-enc: GyWWthFNX173u4TCXGyt2FQmr36m7Z9Jo7syRe7AArO5 1308208295
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:11 2011
Message-Id: <20110616002911.876042927@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:29:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [80/85] pata_cmd64x: remove unused definitions
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit c754d9b6e04371fb398cdd2f5e77be895126be20 upstream.

s/ARTIM2/ARTTIM23/ in cmd648_bmdma_stop() while at it

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_cmd64x.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -41,10 +41,6 @@
 enum {
 	CFR 		= 0x50,
 		CFR_INTR_CH0  = 0x04,
-	CNTRL 		= 0x51,
-		CNTRL_DIS_RA0 = 0x40,
-		CNTRL_DIS_RA1 = 0x80,
-		CNTRL_ENA_2ND = 0x08,
 	CMDTIM 		= 0x52,
 	ARTTIM0 	= 0x53,
 	DRWTIM0 	= 0x54,
@@ -54,9 +50,6 @@ enum {
 		ARTTIM23_DIS_RA2  = 0x04,
 		ARTTIM23_DIS_RA3  = 0x08,
 		ARTTIM23_INTR_CH1 = 0x10,
-	ARTTIM2 	= 0x57,
-	ARTTIM3 	= 0x57,
-	DRWTIM23	= 0x58,
 	DRWTIM2 	= 0x58,
 	BRST 		= 0x59,
 	DRWTIM3 	= 0x5b,
@@ -64,14 +57,11 @@ enum {
 	MRDMODE		= 0x71,
 		MRDMODE_INTR_CH0 = 0x04,
 		MRDMODE_INTR_CH1 = 0x08,
-		MRDMODE_BLK_CH0  = 0x10,
-		MRDMODE_BLK_CH1	 = 0x20,
 	BMIDESR0	= 0x72,
 	UDIDETCR0	= 0x73,
 	DTPR0		= 0x74,
 	BMIDECR1	= 0x78,
 	BMIDECSR	= 0x79,
-	BMIDESR1	= 0x7A,
 	UDIDETCR1	= 0x7B,
 	DTPR1		= 0x7C
 };
@@ -248,7 +238,7 @@ static void cmd648_bmdma_stop(struct ata
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 dma_intr;
 	int dma_mask = ap->port_no ? ARTTIM23_INTR_CH1 : CFR_INTR_CH0;
-	int dma_reg = ap->port_no ? ARTTIM2 : CFR;
+	int dma_reg = ap->port_no ? ARTTIM23 : CFR;
 
 	ata_bmdma_stop(qc);
 


