Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab2BYBWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 20:22:20 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38417 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250Ab2BYBWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 20:22:13 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: balbi@ti.com
Cc: dahlmann.thomas@arcor.de, gregkh@linuxfoundation.org,
        linux-geode@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH 1/6] amd5536udc: Fix brace coding style issues.
Date: Sat, 25 Feb 2012 02:14:57 +0100
Message-Id: <1330132502-17057-2-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330132502-17057-1-git-send-email-tipecaml@gmail.com>
References: <1330132502-17057-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a bunch of unneeded braces.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/usb/gadget/amd5536udc.c |   93 +++++++++++++++------------------------
 1 files changed, 36 insertions(+), 57 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index c16ff55..8d19053 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -204,9 +204,8 @@ static void print_regs(struct udc *dev)
 		DBG(dev, "DMA mode       = BF (buffer fill mode)\n");
 		dev_info(&dev->pdev->dev, "DMA mode (%s)\n", "BF");
 	}
-	if (!use_dma) {
+	if (!use_dma)
 		dev_info(&dev->pdev->dev, "FIFO mode\n");
-	}
 	DBG(dev, "-------------------------------------------------------\n");
 }
 
@@ -569,9 +568,8 @@ udc_free_request(struct usb_ep *usbep, struct usb_request *usbreq)
 		VDBG(ep->dev, "req->td_data=%p\n", req->td_data);
 
 		/* free dma chain if created */
-		if (req->chain_len > 1) {
+		if (req->chain_len > 1)
 			udc_free_dma_chain(ep->dev, req);
-		}
 
 		pci_pool_free(ep->dev->data_requests, req->td_data,
 							req->td_phys);
@@ -639,9 +637,8 @@ udc_txfifo_write(struct udc_ep *ep, struct usb_request *req)
 		bytes = remaining;
 
 	/* dwords first */
-	for (i = 0; i < bytes / UDC_DWORD_BYTES; i++) {
+	for (i = 0; i < bytes / UDC_DWORD_BYTES; i++)
 		writel(*(buf + i), ep->txfifo);
-	}
 
 	/* remaining bytes must be written by byte access */
 	for (j = 0; j < bytes % UDC_DWORD_BYTES; j++) {
@@ -660,9 +657,8 @@ static int udc_rxfifo_read_dwords(struct udc *dev, u32 *buf, int dwords)
 
 	VDBG(dev, "udc_read_dwords(): %d dwords\n", dwords);
 
-	for (i = 0; i < dwords; i++) {
+	for (i = 0; i < dwords; i++)
 		*(buf + i) = readl(dev->rxfifo);
-	}
 	return 0;
 }
 
@@ -675,9 +671,8 @@ static int udc_rxfifo_read_bytes(struct udc *dev, u8 *buf, int bytes)
 	VDBG(dev, "udc_read_bytes(): %d bytes\n", bytes);
 
 	/* dwords first */
-	for (i = 0; i < bytes / UDC_DWORD_BYTES; i++) {
+	for (i = 0; i < bytes / UDC_DWORD_BYTES; i++)
 		*((u32 *)(buf + (i<<2))) = readl(dev->rxfifo);
-	}
 
 	/* remaining bytes must be read by byte access */
 	if (bytes % UDC_DWORD_BYTES) {
@@ -897,9 +892,8 @@ static struct udc_data_dma *udc_get_last_dma_desc(struct udc_request *req)
 	struct udc_data_dma	*td;
 
 	td = req->td_data;
-	while (td && !(td->status & AMD_BIT(UDC_DMA_IN_STS_L))) {
+	while (td && !(td->status & AMD_BIT(UDC_DMA_IN_STS_L)))
 		td = phys_to_virt(td->next);
-	}
 
 	return td;
 
@@ -949,21 +943,18 @@ static int udc_create_dma_chain(
 	dma_addr = DMA_DONT_USE;
 
 	/* unset L bit in first desc for OUT */
-	if (!ep->in) {
+	if (!ep->in)
 		req->td_data->status &= AMD_CLEAR_BIT(UDC_DMA_IN_STS_L);
-	}
 
 	/* alloc only new desc's if not already available */
 	len = req->req.length / ep->ep.maxpacket;
-	if (req->req.length % ep->ep.maxpacket) {
+	if (req->req.length % ep->ep.maxpacket)
 		len++;
-	}
 
 	if (len > req->chain_len) {
 		/* shorter chain already allocated before */
-		if (req->chain_len > 1) {
+		if (req->chain_len > 1)
 			udc_free_dma_chain(ep->dev, req);
-		}
 		req->chain_len = len;
 		create_new_chain = 1;
 	}
@@ -1006,11 +997,12 @@ static int udc_create_dma_chain(
 
 		/* link td and assign tx bytes */
 		if (i == buf_len) {
-			if (create_new_chain) {
+			if (create_new_chain)
 				req->td_data->next = dma_addr;
-			} else {
-				/* req->td_data->next = virt_to_phys(td); */
-			}
+			/*
+			else
+				req->td_data->next = virt_to_phys(td);
+			*/
 			/* write tx bytes */
 			if (ep->in) {
 				/* first desc */
@@ -1024,11 +1016,12 @@ static int udc_create_dma_chain(
 							UDC_DMA_IN_STS_TXBYTES);
 			}
 		} else {
-			if (create_new_chain) {
+			if (create_new_chain)
 				last->next = dma_addr;
-			} else {
-				/* last->next = virt_to_phys(td); */
-			}
+			/*
+			else
+				last->next = virt_to_phys(td);
+			*/
 			if (ep->in) {
 				/* write tx bytes */
 				td->status = AMD_ADDBITS(td->status,
@@ -1479,11 +1472,10 @@ static int startup_registers(struct udc *dev)
 
 	/* program speed */
 	tmp = readl(&dev->regs->cfg);
-	if (use_fullspeed) {
+	if (use_fullspeed)
 		tmp = AMD_ADDBITS(tmp, UDC_DEVCFG_SPD_FS, UDC_DEVCFG_SPD);
-	} else {
+	else
 		tmp = AMD_ADDBITS(tmp, UDC_DEVCFG_SPD_HS, UDC_DEVCFG_SPD);
-	}
 	writel(tmp, &dev->regs->cfg);
 
 	return 0;
@@ -1504,9 +1496,8 @@ static void udc_basic_init(struct udc *dev)
 		mod_timer(&udc_timer, jiffies - 1);
 	}
 	/* stop poll stall timer */
-	if (timer_pending(&udc_pollstall_timer)) {
+	if (timer_pending(&udc_pollstall_timer))
 		mod_timer(&udc_pollstall_timer, jiffies - 1);
-	}
 	/* disable DMA */
 	tmp = readl(&dev->regs->ctl);
 	tmp &= AMD_UNMASK_BIT(UDC_DEVCTL_RDE);
@@ -1540,11 +1531,10 @@ static void udc_setup_endpoints(struct udc *dev)
 	/* read enum speed */
 	tmp = readl(&dev->regs->sts);
 	tmp = AMD_GETBITS(tmp, UDC_DEVSTS_ENUM_SPEED);
-	if (tmp == UDC_DEVSTS_ENUM_SPEED_HIGH) {
+	if (tmp == UDC_DEVSTS_ENUM_SPEED_HIGH)
 		dev->gadget.speed = USB_SPEED_HIGH;
-	} else if (tmp == UDC_DEVSTS_ENUM_SPEED_FULL) {
+	else if (tmp == UDC_DEVSTS_ENUM_SPEED_FULL)
 		dev->gadget.speed = USB_SPEED_FULL;
-	}
 
 	/* set basic ep parameters */
 	for (tmp = 0; tmp < UDC_EP_NUM; tmp++) {
@@ -1570,9 +1560,8 @@ static void udc_setup_endpoints(struct udc *dev)
 		 * disabling ep interrupts when ENUM interrupt occurs but ep is
 		 * not enabled by gadget driver
 		 */
-		if (!ep->desc) {
+		if (!ep->desc)
 			ep_init(dev->regs, ep);
-		}
 
 		if (use_dma) {
 			/*
@@ -1670,9 +1659,8 @@ static void udc_tasklet_disconnect(unsigned long par)
 		spin_lock(&dev->lock);
 
 		/* empty queues */
-		for (tmp = 0; tmp < UDC_EP_NUM; tmp++) {
+		for (tmp = 0; tmp < UDC_EP_NUM; tmp++)
 			empty_req_queue(&dev->ep[tmp]);
-		}
 
 	}
 
@@ -1746,9 +1734,8 @@ static void udc_timer_function(unsigned long v)
 			 * open the fifo
 			 */
 			udc_timer.expires = jiffies + HZ/UDC_RDE_TIMER_DIV;
-			if (!stop_timer) {
+			if (!stop_timer)
 				add_timer(&udc_timer);
-			}
 		} else {
 			/*
 			 * fifo contains data now, setup timer for opening
@@ -1760,9 +1747,8 @@ static void udc_timer_function(unsigned long v)
 			set_rde++;
 			/* debug: lhadmot_timer_start = 221070 */
 			udc_timer.expires = jiffies + HZ*UDC_RDE_TIMER_SECONDS;
-			if (!stop_timer) {
+			if (!stop_timer)
 				add_timer(&udc_timer);
-			}
 		}
 
 	} else
@@ -1907,19 +1893,17 @@ static void activate_control_endpoints(struct udc *dev)
 			mod_timer(&udc_timer, jiffies - 1);
 		}
 		/* stop pollstall timer */
-		if (timer_pending(&udc_pollstall_timer)) {
+		if (timer_pending(&udc_pollstall_timer))
 			mod_timer(&udc_pollstall_timer, jiffies - 1);
-		}
 		/* enable DMA */
 		tmp = readl(&dev->regs->ctl);
 		tmp |= AMD_BIT(UDC_DEVCTL_MODE)
 				| AMD_BIT(UDC_DEVCTL_RDE)
 				| AMD_BIT(UDC_DEVCTL_TDE);
-		if (use_dma_bufferfill_mode) {
+		if (use_dma_bufferfill_mode)
 			tmp |= AMD_BIT(UDC_DEVCTL_BF);
-		} else if (use_dma_ppb_du) {
+		else if (use_dma_ppb_du)
 			tmp |= AMD_BIT(UDC_DEVCTL_DU);
-		}
 		writel(tmp, &dev->regs->ctl);
 	}
 
@@ -2104,9 +2088,8 @@ static void udc_ep0_set_rde(struct udc *dev)
 				udc_timer.expires =
 					jiffies + HZ/UDC_RDE_TIMER_DIV;
 				set_rde = 1;
-				if (!stop_timer) {
+				if (!stop_timer)
 					add_timer(&udc_timer);
-				}
 			}
 		}
 	}
@@ -2294,9 +2277,8 @@ static irqreturn_t udc_data_out_isr(struct udc *dev, int ep_ix)
 						jiffies
 						+ HZ*UDC_RDE_TIMER_SECONDS;
 					set_rde = 1;
-					if (!stop_timer) {
+					if (!stop_timer)
 						add_timer(&udc_timer);
-					}
 				}
 				if (ep->num != UDC_EP0OUT_IX)
 					dev->data_ep_queued = 0;
@@ -2318,9 +2300,8 @@ static irqreturn_t udc_data_out_isr(struct udc *dev, int ep_ix)
 	/* check pending CNAKS */
 	if (cnak_pending) {
 		/* CNAk processing when rxfifo empty only */
-		if (readl(&dev->regs->sts) & AMD_BIT(UDC_DEVSTS_RXFIFO_EMPTY)) {
+		if (readl(&dev->regs->sts) & AMD_BIT(UDC_DEVSTS_RXFIFO_EMPTY))
 			udc_process_cnak_queue(dev);
-		}
 	}
 
 	/* clear OUT bits in ep status */
@@ -2581,9 +2562,8 @@ __acquires(dev->lock)
 			if (!timer_pending(&udc_timer)) {
 				udc_timer.expires = jiffies +
 							HZ/UDC_RDE_TIMER_DIV;
-				if (!stop_timer) {
+				if (!stop_timer)
 					add_timer(&udc_timer);
-				}
 			}
 		}
 
@@ -2697,9 +2677,8 @@ __acquires(dev->lock)
 	/* check pending CNAKS */
 	if (cnak_pending) {
 		/* CNAk processing when rxfifo empty only */
-		if (readl(&dev->regs->sts) & AMD_BIT(UDC_DEVSTS_RXFIFO_EMPTY)) {
+		if (readl(&dev->regs->sts) & AMD_BIT(UDC_DEVSTS_RXFIFO_EMPTY))
 			udc_process_cnak_queue(dev);
-		}
 	}
 
 finished:
-- 
1.7.9

