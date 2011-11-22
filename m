Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab1KVTp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:45:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36389 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab1KVTpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:45:55 -0500
From: Mika Westerberg <mika.westerberg@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, dan.j.williams@intel.com,
        hsweeten@visionengravers.com, rmallon@gmail.com,
        Rafal Prylowski <prylowski@metasoft.pl>,
        Mika Westerberg <mika.westerberg@iki.fi>
Subject: [PATCH 1/2] dma/ep93xx_dma: fix initialization of M2M control register
Date: Tue, 22 Nov 2011 21:45:35 +0200
Message-Id: <19bcd0ee953116fd71bc1c705636c5fec80608cb.1321990466.git.mika.westerberg@iki.fi>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafal Prylowski <prylowski@metasoft.pl>

Setting the flags in case of IDE didn't have any effect since the control
register is overwritten few lines below. So move these to be after the control
register is initialized.

Signed-off-by: Rafal Prylowski <prylowski@metasoft.pl>
Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
---
Rafal,

I hope you don't mind that I added your Signed-of-by to the patches. After all
they both came from you :)

 drivers/dma/ep93xx_dma.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index b47e2b8..6181811 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -459,10 +459,6 @@ static int m2m_hw_setup(struct ep93xx_dma_chan *edmac)
 		 * This IDE part is totally untested. Values below are taken
 		 * from the EP93xx Users's Guide and might not be correct.
 		 */
-		control |= M2M_CONTROL_NO_HDSK;
-		control |= M2M_CONTROL_RSS_IDE;
-		control |= M2M_CONTROL_PW_16;
-
 		if (data->direction == DMA_TO_DEVICE) {
 			/* Worst case from the UG */
 			control = (3 << M2M_CONTROL_PWSC_SHIFT);
@@ -473,6 +469,10 @@ static int m2m_hw_setup(struct ep93xx_dma_chan *edmac)
 			control |= M2M_CONTROL_SAH;
 			control |= M2M_CONTROL_TM_RX;
 		}
+
+		control |= M2M_CONTROL_NO_HDSK;
+		control |= M2M_CONTROL_RSS_IDE;
+		control |= M2M_CONTROL_PW_16;
 		break;
 
 	default:
-- 
1.7.7

