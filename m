Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab1KKFvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 00:51:12 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64520 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab1KKFvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 00:51:11 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH] pch_uart: Delete unused private data member
Date: Fri, 11 Nov 2011 14:50:13 +0900
Message-Id: <1320990613-3788-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using "[PATCH] pch_uart: Fix DMA resource leak issue" patch, this variable
becomes unused.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/serial/pch_uart.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/pch_uart.c b/drivers/serial/pch_uart.c
index de40722..edd2185 100644
--- a/drivers/serial/pch_uart.c
+++ b/drivers/serial/pch_uart.c
@@ -228,7 +228,6 @@ struct eg20t_port {
 	unsigned int fcr;
 	unsigned int mcr;
 	unsigned int use_dma;
-	unsigned int use_dma_flag;
 	struct dma_async_tx_descriptor	*desc_tx;
 	struct dma_async_tx_descriptor	*desc_rx;
 	struct pch_dma_slave		param_tx;
@@ -1416,7 +1415,6 @@ static int pch_uart_verify_port(struct uart_port *port,
 		return -EOPNOTSUPP;
 #endif
 		priv->use_dma = 1;
-		priv->use_dma_flag = 1;
 		dev_info(priv->port.dev, "PCH UART : Use DMA Mode\n");
 	}
 
-- 
1.7.4.4

