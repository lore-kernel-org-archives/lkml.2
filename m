Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab2KVTZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:25:59 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:47882 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365Ab2KVTZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:25:03 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 2/4] staging/rtl8187se: Remove an unnecessary line continuation in r8180_core.c
Date: Thu, 22 Nov 2012 09:06:37 +0900
Message-Id: <1353542797-21020-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353542753-20986-1-git-send-email-yamanetoshi@gmail.com>
References: <1353542753-20986-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings fixed.
- WARNING: Avoid unnecessary line continuations

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/r8180_core.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index ea8dbb1..8c8b09d 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -713,8 +713,8 @@ void rtl8180_rtx_disable(struct net_device *dev)
 	struct r8180_priv *priv = ieee80211_priv(dev);
 
 	cmd = read_nic_byte(dev, CMD);
-	write_nic_byte(dev, CMD, cmd & ~\
-		       ((1<<CMD_RX_ENABLE_SHIFT)|(1<<CMD_TX_ENABLE_SHIFT)));
+	write_nic_byte(dev, CMD, cmd &
+		       ~((1<<CMD_RX_ENABLE_SHIFT)|(1<<CMD_TX_ENABLE_SHIFT)));
 	force_pci_posting(dev);
 	mdelay(10);
 
@@ -1258,8 +1258,7 @@ void rtl8180_rx(struct net_device *dev)
 
 		pci_dma_sync_single_for_cpu(priv->pdev,
 				    priv->rxbuffer->dma,
-				    priv->rxbuffersize * \
-				    sizeof(u8),
+				    priv->rxbuffersize * sizeof(u8),
 				    PCI_DMA_FROMDEVICE);
 
 		first = *(priv->rxringtail) & (1<<29) ? 1 : 0;
@@ -1490,8 +1489,7 @@ void rtl8180_rx(struct net_device *dev)
 
 		pci_dma_sync_single_for_device(priv->pdev,
 				    priv->rxbuffer->dma,
-				    priv->rxbuffersize * \
-				    sizeof(u8),
+				    priv->rxbuffersize * sizeof(u8),
 				    PCI_DMA_FROMDEVICE);
 
 drop: /* this is used when we have not enough mem */
-- 
1.7.9.5

