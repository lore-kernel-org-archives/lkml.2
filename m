Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab1KZLAm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 06:00:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60212 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab1KZLAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 06:00:40 -0500
From: Mika Westerberg <mika.westerberg@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, dan.j.williams@intel.com,
        hsweeten@visionengravers.com, rmallon@gmail.com,
        Rafal Prylowski <prylowski@metasoft.pl>,
        Mika Westerberg <mika.westerberg@iki.fi>
Subject: [PATCH v2 1/2] dma/ep93xx_dma: fix initialization of M2M control register
Date: Sat, 26 Nov 2011 12:54:07 +0200
Message-Id: <1bb25192ca6c0dc6f3631a3f937120d560e4e643.1322304185.git.mika.westerberg@iki.fi>
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
Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
---
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

