Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab1BRCXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 21:23:53 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:19436 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753859Ab1BRCXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 21:23:14 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 4/8] pch_uart : Use dev_xxx not pr_xxx
Date: Fri, 18 Feb 2011 11:24:00 +0900
Message-Id: <1297995844-11282-4-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1297995844-11282-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1297995844-11282-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For easy to understad which port the message is out,
replace pr_xxx with dev_xxx.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/serial/pch_uart.c |   77 ++++++++++++++++++++++++++++----------------
 1 files changed, 49 insertions(+), 28 deletions(-)

diff --git a/drivers/serial/pch_uart.c b/drivers/serial/pch_uart.c
index 0e171b8..6885535 100644
--- a/drivers/serial/pch_uart.c
+++ b/drivers/serial/pch_uart.c
@@ -282,7 +282,7 @@ static int pch_uart_hal_set_line(struct eg20t_port *priv, int baud,
 
 	div = DIV_ROUND(priv->base_baud / 16, baud);
 	if (div < 0 || USHRT_MAX <= div) {
-		pr_err("Invalid Baud(div=0x%x)\n", div);
+		dev_err(priv->port.dev, "Invalid Baud(div=0x%x)\n", div);
 		return -EINVAL;
 	}
 
@@ -290,17 +290,17 @@ static int pch_uart_hal_set_line(struct eg20t_port *priv, int baud,
 	dlm = ((unsigned int)div >> 8) & 0x00FFU;
 
 	if (parity & ~(PCH_UART_LCR_PEN | PCH_UART_LCR_EPS | PCH_UART_LCR_SP)) {
-		pr_err("Invalid parity(0x%x)\n", parity);
+		dev_err(priv->port.dev, "Invalid parity(0x%x)\n", parity);
 		return -EINVAL;
 	}
 
 	if (bits & ~PCH_UART_LCR_WLS) {
-		pr_err("Invalid bits(0x%x)\n", bits);
+		dev_err(priv->port.dev, "Invalid bits(0x%x)\n", bits);
 		return -EINVAL;
 	}
 
 	if (stb & ~PCH_UART_LCR_STB) {
-		pr_err("Invalid STB(0x%x)\n", stb);
+		dev_err(priv->port.dev, "Invalid STB(0x%x)\n", stb);
 		return -EINVAL;
 	}
 
@@ -308,7 +308,7 @@ static int pch_uart_hal_set_line(struct eg20t_port *priv, int baud,
 	lcr |= bits;
 	lcr |= stb;
 
-	pr_debug("%s:baud = %d, div = %04x, lcr = %02x (%lu)\n",
+	dev_dbg(priv->port.dev, "%s:baud = %d, div = %04x, lcr = %02x (%lu)\n",
 		 __func__, baud, div, lcr, jiffies);
 	iowrite8(PCH_UART_LCR_DLAB, priv->membase + UART_LCR);
 	iowrite8(dll, priv->membase + PCH_UART_DLL);
@@ -322,7 +322,8 @@ static int pch_uart_hal_fifo_reset(struct eg20t_port *priv,
 				    unsigned int flag)
 {
 	if (flag & ~(PCH_UART_FCR_TFR | PCH_UART_FCR_RFR)) {
-		pr_err("%s:Invalid flag(0x%x)\n", __func__, flag);
+		dev_err(priv->port.dev, "%s:Invalid flag(0x%x)\n",
+			__func__, flag);
 		return -EINVAL;
 	}
 
@@ -341,17 +342,20 @@ static int pch_uart_hal_set_fifo(struct eg20t_port *priv,
 	u8 fcr;
 
 	if (dmamode & ~PCH_UART_FCR_DMS) {
-		pr_err("%s:Invalid DMA Mode(0x%x)\n", __func__, dmamode);
+		dev_err(priv->port.dev, "%s:Invalid DMA Mode(0x%x)\n",
+			__func__, dmamode);
 		return -EINVAL;
 	}
 
 	if (fifo_size & ~(PCH_UART_FCR_FIFOE | PCH_UART_FCR_FIFO256)) {
-		pr_err("%s:Invalid FIFO SIZE(0x%x)\n", __func__, fifo_size);
+		dev_err(priv->port.dev, "%s:Invalid FIFO SIZE(0x%x)\n",
+			__func__, fifo_size);
 		return -EINVAL;
 	}
 
 	if (trigger & ~PCH_UART_FCR_RFTL) {
-		pr_err("%s:Invalid TRIGGER(0x%x)\n", __func__, trigger);
+		dev_err(priv->port.dev, "%s:Invalid TRIGGER(0x%x)\n",
+			__func__, trigger);
 		return -EINVAL;
 	}
 
@@ -455,7 +459,7 @@ static int push_rx(struct eg20t_port *priv, const unsigned char *buf,
 	port = &priv->port;
 	tty = tty_port_tty_get(&port->state->port);
 	if (!tty) {
-		pr_debug("%s:tty is busy now", __func__);
+		dev_dbg(priv->port.dev, "%s:tty is busy now", __func__);
 		return -EBUSY;
 	}
 
@@ -472,8 +476,8 @@ static int pop_tx_x(struct eg20t_port *priv, unsigned char *buf)
 	struct uart_port *port = &priv->port;
 
 	if (port->x_char) {
-		pr_debug("%s:X character send %02x (%lu)\n", __func__,
-			port->x_char, jiffies);
+		dev_dbg(priv->port.dev, "%s:X character send %02x (%lu)\n",
+			__func__, port->x_char, jiffies);
 		buf[0] = port->x_char;
 		port->x_char = 0;
 		ret = 1;
@@ -493,7 +497,7 @@ static int dma_push_rx(struct eg20t_port *priv, int size)
 	port = &priv->port;
 	tty = tty_port_tty_get(&port->state->port);
 	if (!tty) {
-		pr_debug("%s:tty is busy now", __func__);
+		dev_dbg(priv->port.dev, "%s:tty is busy now", __func__);
 		return 0;
 	}
 
@@ -567,7 +571,8 @@ static void pch_request_dma(struct uart_port *port)
 	param->tx_reg = port->mapbase + UART_TX;
 	chan = dma_request_channel(mask, filter, param);
 	if (!chan) {
-		pr_err("%s:dma_request_channel FAILS(Tx)\n", __func__);
+		dev_err(priv->port.dev, "%s:dma_request_channel FAILS(Tx)\n",
+			__func__);
 		return;
 	}
 	priv->chan_tx = chan;
@@ -579,7 +584,8 @@ static void pch_request_dma(struct uart_port *port)
 	param->rx_reg = port->mapbase + UART_RX;
 	chan = dma_request_channel(mask, filter, param);
 	if (!chan) {
-		pr_err("%s:dma_request_channel FAILS(Rx)\n", __func__);
+		dev_err(priv->port.dev, "%s:dma_request_channel FAILS(Rx)\n",
+			__func__);
 		dma_release_channel(priv->chan_tx);
 		return;
 	}
@@ -598,7 +604,7 @@ static void pch_dma_rx_complete(void *arg)
 	int count;
 
 	if (!tty) {
-		pr_debug("%s:tty is busy now", __func__);
+		dev_dbg(priv->port.dev, "%s:tty is busy now", __func__);
 		return;
 	}
 
@@ -652,7 +658,7 @@ static int pop_tx(struct eg20t_port *priv, int size)
 	} while (!uart_circ_empty(xmit) && count < size);
 
 pop_tx_end:
-	pr_debug("%d characters. Remained %d characters. (%lu)\n",
+	dev_dbg(priv->port.dev, "%d characters. Remained %d characters.(%lu)\n",
 		 count, size - count, jiffies);
 
 	return count;
@@ -728,7 +734,8 @@ static unsigned int handle_tx(struct eg20t_port *priv)
 	int tx_empty;
 
 	if (!priv->start_tx) {
-		pr_info("%s:Tx isn't started. (%lu)\n", __func__, jiffies);
+		dev_info(priv->port.dev, "%s:Tx isn't started. (%lu)\n",
+			__func__, jiffies);
 		pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_TX_INT);
 		priv->tx_empty = 1;
 		return 0;
@@ -778,7 +785,8 @@ static unsigned int dma_handle_tx(struct eg20t_port *priv)
 	int rem;
 
 	if (!priv->start_tx) {
-		pr_info("%s:Tx isn't started. (%lu)\n", __func__, jiffies);
+		dev_info(priv->port.dev, "%s:Tx isn't started. (%lu)\n",
+			__func__, jiffies);
 		pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_TX_INT);
 		priv->tx_empty = 1;
 		return 0;
@@ -797,6 +805,7 @@ static unsigned int dma_handle_tx(struct eg20t_port *priv)
 			     UART_XMIT_SIZE), CIRC_CNT_TO_END(xmit->head,
 			     xmit->tail, UART_XMIT_SIZE));
 	if (!bytes) {
+		dev_dbg(priv->port.dev, "%s 0 bytes return\n", __func__);
 		pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_TX_INT);
 		uart_write_wakeup(port);
 		return 0;
@@ -812,6 +821,9 @@ static unsigned int dma_handle_tx(struct eg20t_port *priv)
 		rem = bytes;
 	}
 
+	dev_dbg(priv->port.dev, "%s num=%d size=%d rem=%d\n",
+		__func__, num, size, rem);
+
 	priv->tx_dma_use = 1;
 
 	priv->sg_tx_p = kzalloc(sizeof(struct scatterlist)*num, GFP_ATOMIC);
@@ -831,7 +843,7 @@ static unsigned int dma_handle_tx(struct eg20t_port *priv)
 	sg = priv->sg_tx_p;
 	nent = dma_map_sg(port->dev, sg, num, DMA_TO_DEVICE);
 	if (!nent) {
-		pr_err("%s:dma_map_sg Failed\n", __func__);
+		dev_err(priv->port.dev, "%s:dma_map_sg Failed\n", __func__);
 		return 0;
 	}
 	priv->nent = nent;
@@ -851,7 +863,8 @@ static unsigned int dma_handle_tx(struct eg20t_port *priv)
 					priv->sg_tx_p, nent, DMA_TO_DEVICE,
 					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc) {
-		pr_err("%s:device_prep_slave_sg Failed\n", __func__);
+		dev_err(priv->port.dev, "%s:device_prep_slave_sg Failed\n",
+			__func__);
 		return 0;
 	}
 	dma_sync_sg_for_device(port->dev, priv->sg_tx_p, nent, DMA_TO_DEVICE);
@@ -935,7 +948,8 @@ static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
 			ret = PCH_UART_HANDLED_MS_INT;
 			break;
 		default:	/* Never junp to this label */
-			pr_err("%s:iid=%d (%lu)\n", __func__, iid, jiffies);
+			dev_err(priv->port.dev, "%s:iid=%d (%lu)\n", __func__,
+				iid, jiffies);
 			ret = -1;
 			break;
 		}
@@ -1024,9 +1038,13 @@ static void pch_uart_start_tx(struct uart_port *port)
 
 	priv = container_of(port, struct eg20t_port, port);
 
-	if (priv->use_dma)
-		if (priv->tx_dma_use)
+	if (priv->use_dma) {
+		if (priv->tx_dma_use) {
+			dev_dbg(priv->port.dev, "%s : Tx DMA is NOT empty.\n",
+				__func__);
 			return;
+		}
+	}
 
 	priv->start_tx = 1;
 	pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_TX_INT);
@@ -1142,7 +1160,8 @@ static void pch_uart_shutdown(struct uart_port *port)
 	ret = pch_uart_hal_set_fifo(priv, PCH_UART_HAL_DMA_MODE0,
 			      PCH_UART_HAL_FIFO_DIS, PCH_UART_HAL_TRIGGER1);
 	if (ret)
-		pr_err("pch_uart_hal_set_fifo Failed(ret=%d)\n", ret);
+		dev_err(priv->port.dev,
+			"pch_uart_hal_set_fifo Failed(ret=%d)\n", ret);
 
 	if (priv->use_dma_flag)
 		pch_free_dma(port);
@@ -1263,17 +1282,19 @@ static int pch_uart_verify_port(struct uart_port *port,
 
 	priv = container_of(port, struct eg20t_port, port);
 	if (serinfo->flags & UPF_LOW_LATENCY) {
-		pr_info("PCH UART : Use PIO Mode (without DMA)\n");
+		dev_info(priv->port.dev,
+			"PCH UART : Use PIO Mode (without DMA)\n");
 		priv->use_dma = 0;
 		serinfo->flags &= ~UPF_LOW_LATENCY;
 	} else {
 #ifndef CONFIG_PCH_DMA
-		pr_err("%s : PCH DMA is not Loaded.\n", __func__);
+		dev_err(priv->port.dev, "%s : PCH DMA is not Loaded.\n",
+			__func__);
 		return -EOPNOTSUPP;
 #endif
 		priv->use_dma = 1;
 		priv->use_dma_flag = 1;
-		pr_info("PCH UART : Use DMA Mode\n");
+		dev_info(priv->port.dev, "PCH UART : Use DMA Mode\n");
 	}
 
 	return 0;
-- 
1.7.3.4

