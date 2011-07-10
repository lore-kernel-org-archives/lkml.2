Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab1GJL2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 07:28:34 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:40414 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058Ab1GJL1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 07:27:13 -0400
Message-Id: <db1360f4ddad69f9a3b8bd8ed87df27d2b2919cc.1310297055.git.mirq-linux@rere.qmqm.pl>
From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH] Fix DMA-API-HOWTO.txt misleading example
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 10 Jul 2011 13:27:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See: DMA-API.txt, part Id, DMA_FROM_DEVICE description.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 Documentation/DMA-API-HOWTO.txt |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
index d568bc2..a0b6250 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.txt
@@ -613,13 +613,13 @@ to use the dma_sync_*() interfaces.
 				pass_to_upper_layers(cp->rx_buf);
 				make_and_setup_new_rx_buf(cp);
 			} else {
-				/* Just sync the buffer and give it back
-				 * to the card.
+				/* CPU should not write to
+				 * DMA_FROM_DEVICE-mapped area,
+				 * so dma_sync_single_for_device() is
+				 * not needed here. It would be required
+				 * for DMA_BIDIRECTIONAL mapping if
+				 * the memory was modified.
 				 */
-				dma_sync_single_for_device(&cp->dev,
-							   cp->rx_dma,
-							   cp->rx_len,
-							   DMA_FROM_DEVICE);
 				give_rx_buf_to_card(cp);
 			}
 		}
-- 
1.7.5.4

