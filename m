Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030764Ab2ERJKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 05:10:41 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:39870 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030267Ab2ERJKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 05:10:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EABMRtk9bdWOb/2dsb2JhbABFs2eBB4IWAQUnUhBRVwYTiBK8FJBFA5Ugj3WCaw
X-IronPort-AV: E=Sophos;i="4.75,616,1330902000"; 
   d="scan'208";a="915536506"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] Staging: ipack/bridges/tpci200: remove unneeded casts
Date: Fri, 18 May 2012 11:10:08 +0200
Message-Id: <1337332208-26057-4-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337332208-26057-1-git-send-email-siglesias@igalia.com>
References: <1337332208-26057-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   36 ++++++++++++++-----------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index c043345..ad28707 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -321,8 +321,8 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 	spin_lock_irqsave(&tpci200->info->access_lock, flags);
 
 	/* Read status register */
-	status_reg = readw((void __iomem *) (tpci200->info->interface_regs +
-					       TPCI200_STATUS_REG));
+	status_reg = readw(tpci200->info->interface_regs +
+			   TPCI200_STATUS_REG);
 
 	if (status_reg & TPCI200_SLOT_INT_MASK) {
 		unhandled_ints = status_reg & TPCI200_SLOT_INT_MASK;
@@ -334,12 +334,10 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 				ret = tpci200->slots[i].irq->handler(tpci200->slots[i].irq->arg);
 
 				/* Dummy reads */
-				readw((void __iomem *)
-				      (tpci200->slots[i].dev->io_space.address +
-				       0xC0));
-				readw((void __iomem *)
-				      (tpci200->slots[i].dev->io_space.address +
-				       0xC2));
+				readw(tpci200->slots[i].dev->io_space.address +
+				      0xC0);
+				readw(tpci200->slots[i].dev->io_space.address +
+				      0xC2);
 
 				unhandled_ints &= ~(((TPCI200_A_INT0 | TPCI200_A_INT1) << (2*i)));
 			}
@@ -352,13 +350,13 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 				pr_info("No registered ISR for slot [%d:%d]!. IRQ will be disabled.\n",
 					tpci200->number, i);
 				reg_value = readw(
-					(void __iomem *)(tpci200->info->interface_regs +
-								     control_reg[i]));
+					tpci200->info->interface_regs +
+					control_reg[i]);
 				reg_value &=
 					~(TPCI200_INT0_EN | TPCI200_INT1_EN);
 				writew(reg_value,
-				       (void __iomem *)(tpci200->info->interface_regs +
-							control_reg[i]));
+				       (tpci200->info->interface_regs +
+					control_reg[i]));
 			}
 		}
 	}
@@ -659,9 +657,8 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			(void __iomem *)mem_base + TPCI200_MEM8_GAP*i;
 		tpci200->slots[i].mem_phys.size = TPCI200_MEM8_SIZE;
 
-		writew(slot_ctrl,
-		       (void __iomem *)(tpci200->info->interface_regs +
-					  control_reg[i]));
+		writew(slot_ctrl, (tpci200->info->interface_regs +
+				   control_reg[i]));
 	}
 
 	res = request_irq(tpci200->info->pdev->irq,
@@ -703,8 +700,8 @@ static int __tpci200_request_irq(struct tpci200_board *tpci200,
 	 * clock rate 8 MHz
 	 */
 	slot_ctrl = TPCI200_INT0_EN | TPCI200_INT1_EN;
-	writew(slot_ctrl, (void __iomem *)(tpci200->info->interface_regs +
-					     control_reg[dev->slot]));
+	writew(slot_ctrl, (tpci200->info->interface_regs +
+			   control_reg[dev->slot]));
 
 	return 0;
 }
@@ -723,9 +720,8 @@ static void __tpci200_free_irq(struct tpci200_board *tpci200,
 	 * clock rate 8 MHz
 	 */
 	slot_ctrl = 0;
-	writew(slot_ctrl,
-	       (void __iomem *)(tpci200->info->interface_regs +
-				control_reg[dev->slot]));
+	writew(slot_ctrl, (tpci200->info->interface_regs +
+			   control_reg[dev->slot]));
 }
 
 static int tpci200_free_irq(struct ipack_device *dev)
-- 
1.7.10

