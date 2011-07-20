Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab1GTLRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 07:17:33 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:37815 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746Ab1GTLRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 07:17:32 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH] pch_uart: Set PCIe bus number using probe parameter 
Date: Wed, 20 Jul 2011 20:17:49 +0900
Message-Id: <1311160669-3927-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, PCIe bus number is set as fixed value "2".
However, PCIe bus number is not always "2".
This patch sets bus number using probe() parameter.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/tty/serial/pch_uart.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 58dc030..36441c7 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -611,7 +611,8 @@ static void pch_request_dma(struct uart_port *port)
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
-	dma_dev = pci_get_bus_and_slot(2, PCI_DEVFN(0xa, 0)); /* Get DMA's dev
+	dma_dev = pci_get_bus_and_slot(priv->pdev->bus->number,
+				       PCI_DEVFN(0xa, 0)); /* Get DMA's dev
 								information */
 	/* Set Tx DMA */
 	param = &priv->param_tx;
-- 
1.7.4.4

