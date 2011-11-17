Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab1KQF6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 00:58:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55095 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab1KQF6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 00:58:21 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 6/6] pch_uart: Add initialize processing
Date: Thu, 17 Nov 2011 14:57:33 +0900
Message-Id: <1321509453-12008-6-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1321509453-12008-1-git-send-email-tomoya.rohm@gmail.com>
References: <1321509453-12008-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add initialize variable to prevent duplicate free memory.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/tty/serial/pch_uart.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 8c750d8..efc30b9 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -566,10 +566,13 @@ static void pch_free_dma(struct uart_port *port)
 		dma_release_channel(priv->chan_rx);
 		priv->chan_rx = NULL;
 	}
-	if (sg_dma_address(&priv->sg_rx))
-		dma_free_coherent(port->dev, port->fifosize,
-				  sg_virt(&priv->sg_rx),
-				  sg_dma_address(&priv->sg_rx));
+
+	if (priv->rx_buf_dma) {
+		dma_free_coherent(port->dev, port->fifosize, priv->rx_buf_virt,
+				  priv->rx_buf_dma);
+		priv->rx_buf_virt = NULL;
+		priv->rx_buf_dma = 0;
+	}
 
 	return;
 }
-- 
1.7.4.4

