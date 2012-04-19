Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783Ab2DSVji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:39:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933495Ab2DSVN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:13:57 -0400
Message-Id: <20120419210615.052704993@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:06:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [ 46/59] pch_uart: Set PCIe bus number using probe parameter
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

commit 6c4b47d243112e98811ce0da7bbb32cc3857dd1a upstream.

Currently, PCIe bus number is set as fixed value "2".
However, PCIe bus number is not always "2".
This patch sets bus number using probe() parameter.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/pch_uart.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -602,7 +602,8 @@ static void pch_request_dma(struct uart_
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
-	dma_dev = pci_get_bus_and_slot(2, PCI_DEVFN(0xa, 0)); /* Get DMA's dev
+	dma_dev = pci_get_bus_and_slot(priv->pdev->bus->number,
+				       PCI_DEVFN(0xa, 0)); /* Get DMA's dev
 								information */
 	/* Set Tx DMA */
 	param = &priv->param_tx;


