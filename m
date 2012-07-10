Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab2GJFGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 01:06:17 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51750 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab2GJFGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 01:06:15 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Devendra Naga <devendra.aaru@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH V2] staging/ft1000: remove all spaces, tabs issue in while loop of ft1000_interrupt
Date: Tue, 10 Jul 2012 10:36:05 +0530
Message-Id: <1341896765-11237-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

all spaces in the main while loop of ft1000_interrupt are converted
to tabs.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
Greg,

	You mean to say this only right?

drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |   60 +++++++++++-----------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 0059cac..86a680c 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -1996,41 +1996,43 @@ static irqreturn_t ft1000_interrupt(int irq, void *dev_id)
 	inttype = ft1000_read_reg(dev, FT1000_REG_SUP_ISR);
 
     // Make sure we process all interrupt before leaving the ISR due to the edge trigger interrupt type
-    while (inttype) {
+	while (inttype) {
 		if (inttype & ISR_DOORBELL_PEND)
 			ft1000_parse_dpram_msg(dev);
 
-	if (inttype & ISR_RCV) {
-		DEBUG(1, "Data in FIFO\n");
+		if (inttype & ISR_RCV) {
+			DEBUG(1, "Data in FIFO\n");
 
-		cnt = 0;
-		do {
-			// Check if we have packets in the Downlink FIFO
-			if (info->AsicID == ELECTRABUZZ_ID) {
-				tempword =
-					ft1000_read_reg(dev, FT1000_REG_DFIFO_STAT);
-			} else {
-				tempword =
-					ft1000_read_reg(dev, FT1000_REG_MAG_DFSR);
-			}
-			if (tempword & 0x1f) {
-				ft1000_copy_up_pkt(dev);
-			} else {
-				break;
-			}
-			cnt++;
-		} while (cnt < MAX_RCV_LOOP);
+			cnt = 0;
+			do {
+				// Check if we have packets in the Downlink FIFO
+				if (info->AsicID == ELECTRABUZZ_ID) {
+					tempword =
+					ft1000_read_reg(dev,
+							FT1000_REG_DFIFO_STAT);
+				} else {
+					tempword =
+					ft1000_read_reg(dev,
+							FT1000_REG_MAG_DFSR);
+				}
+				if (tempword & 0x1f) {
+					ft1000_copy_up_pkt(dev);
+				} else {
+					break;
+				}
+				cnt++;
+			} while (cnt < MAX_RCV_LOOP);
 
+		}
+		// clear interrupts
+		tempword = ft1000_read_reg(dev, FT1000_REG_SUP_ISR);
+		DEBUG(1, "ft1000_hw: interrupt status register = 0x%x\n", tempword);
+		ft1000_write_reg(dev, FT1000_REG_SUP_ISR, tempword);
+
+		// Read interrupt type
+		inttype = ft1000_read_reg (dev, FT1000_REG_SUP_ISR);
+		DEBUG(1,"ft1000_hw: interrupt status register after clear = 0x%x\n",inttype);
 	}
-	// clear interrupts
-	tempword = ft1000_read_reg(dev, FT1000_REG_SUP_ISR);
-	DEBUG(1, "ft1000_hw: interrupt status register = 0x%x\n", tempword);
-	ft1000_write_reg(dev, FT1000_REG_SUP_ISR, tempword);
-
-        // Read interrupt type
-        inttype = ft1000_read_reg (dev, FT1000_REG_SUP_ISR);
-        DEBUG(1,"ft1000_hw: interrupt status register after clear = 0x%x\n",inttype);
-    }
 	ft1000_enable_interrupts(dev);
 	return IRQ_HANDLED;
 }
-- 
1.7.9.5

