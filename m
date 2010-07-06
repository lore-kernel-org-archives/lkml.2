Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab0GFRzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 13:55:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35577 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab0GFRzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 13:55:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=IW96clpYx0Z+iAmDnTJQBb4y8nfX8ssIHkB9c+vLbwTNa/fewKscOtTb30u4vIV5Zt
         71RzTLa6sl9C2i+6nlIo0zPrxgUAWH3yjwMwPYNEQDRSuFfLvMmmCybJ4vCkdVFe/D/e
         4O0tYRx/FnRl0jPwVb2JUiQkjsYHTLTB0ZMqA=
Subject: [PATCH] Staging: dt3155: fix coding style issues in dt3155_drv.c
From: Joe Eloff <kagen101@gmail.com>
Reply-To: kagen101@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Simon Horman <horms@verge.net.au>
Cc: devel <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Jul 2010 18:53:18 +0200
Message-ID: <1278435198.5396.73.camel@dermezel>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just realised how the commit chaining works after messing it up so I have already 
uploaded a 1/2 and 2/2 and now it made another 2/2 for this patch which is different.

I have realised how it works now and wont mess it up again and have no idea how to reverse chain the
3 patches.

This now fixes up all checkpatch.pl issues bar 1.


>From 66e4e73cbd28b516680b994d9c91deba21b7c727 Mon Sep 17 00:00:00 2001
From: Joe Eloff <kagen101@gmail.com>
Date: Tue, 6 Jul 2010 18:43:02 +0200
Subject: [PATCH 2/2] Staging: dt3155: fix coding style issues in dt3155_drv.c

This is a patch to the dt3155_drv.c file that fixes up all the
line lengths over 80 by the checkpatch.pl tool.
Signed-off-by: Joe Eloff <kagen101@gmail.com>
---
 drivers/staging/dt3155/dt3155_drv.c |   43 ++++++++++++++++++++++-------------
 1 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index 66db878..f6edd66 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -308,33 +308,42 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 #endif
 			if (fb->nbuffers > 2) {
 				if (!are_empty_buffers(minor)) {
-					/* The number of active + locked buffers is
-					 * at most 2, and since there are none empty, there
-					 * must be at least nbuffers-2 ready buffers.
-					 * This is where we 'drop frames', oldest first. */
+					/* The number of active +
+					 * locked buffers is at most 2,
+					 * and since there are none empty,
+					 * there must be at least nbuffers-2
+					 * ready buffers.
+					 * This is where we 'drop frames',
+					 * oldest first. */
 					push_empty(pop_ready(minor),  minor);
 				}
 
 				/* The ready_que can't be full, since we know
-				 * there is one active buffer right now, so it's safe
-				 * to push the active buf on the ready_que. */
+				 * there is one active buffer right now,
+				 * so it's safe to push the active buf on the
+				   ready_que. */
 				push_ready(minor, fb->active_buf);
 				/* There's at least 1 empty -- make it active */
 				fb->active_buf = pop_empty(minor);
-				fb->frame_info[fb->active_buf].tag = ++unique_tag;
+				fb->frame_info[fb->active_buf].tag =
+					++unique_tag;
 			} else {  /* nbuffers == 2, special case */
 
 				/* There is 1 active buffer.
-				 * If there is a locked buffer, keep the active buffer
-				 * the same -- that means we drop a frame.
+				 * If there is a locked buffer,
+				 * keep the active buffer the same
+				 *     -- that means we drop a frame.
 				 */
 				if (fb->locked_buf < 0) {
 					push_ready(minor, fb->active_buf);
 					if (are_empty_buffers(minor))
-						fb->active_buf = pop_empty(minor);
+						fb->active_buf =
+							pop_empty(minor);
 					else {
-						/* no empty or locked buffers, so use a readybuf */
-						fb->active_buf = pop_ready(minor);
+						/* no empty or locked buffers,
+						   so use a readybuf */
+						fb->active_buf =
+							pop_ready(minor);
 					}
 				}
 			}
@@ -358,7 +367,8 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 		else {
 			writel(buffer_addr, mmio + EVEN_DMA_START);
 
-			writel(buffer_addr + dts->config.cols, mmio + ODD_DMA_START);
+			writel(buffer_addr + dts->config.cols,
+				mmio + ODD_DMA_START);
 		}
 
 		/* Do error checking */
@@ -855,15 +865,16 @@ static int find_PCI(void)
 			goto err;
 		}
 
-		DT_3155_DEBUG_MSG(KERN_INFO "DT3155: Base address 0 for device is %lx\n",
-			base);
+		DT_3155_DEBUG_MSG(KERN_INFO "DT3155: "
+			"Base address 0 for device is %lx\n", base);
 		dts->reg_addr = base;
 
 		/* Remap the base address to a logical address through which we
 		 * can access it. */
 		dt3155_lbase[pci_index - 1] = ioremap(base, PCI_PAGE_SIZE);
 		dts->reg_addr = base;
-		DT_3155_DEBUG_MSG(KERN_INFO "DT3155: New logical address is %p\n",
+		DT_3155_DEBUG_MSG(KERN_INFO "DT3155: "
+			"New logical address is %p\n",
 			dt3155_lbase[pci_index-1]);
 
 		if (!dt3155_lbase[pci_index-1]) {
-- 
1.6.3.3



