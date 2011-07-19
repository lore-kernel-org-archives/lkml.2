Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab1GSTrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 15:47:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:41401 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab1GSTrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 15:47:07 -0400
Date: Tue, 19 Jul 2011 21:47:01 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Wendy Yuan-Hsin Chen(??????)" <yhchen@faraday-tech.com>
Cc: balbi@ti.com, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: [PATCH] usb/fusb300: remove #if 0 block
Message-ID: <20110719194701.GD6323@linutronix.de>
References: <cover.1310289795.git.joe@perches.com>
 <08f6dd600dbf588e87734b3a6b33d897cd253fe3.1310289795.git.joe@perches.com>
 <20110714080830.GA7149@linutronix.de>
 <B3F95056718EDE47B73D925D2FF34506782BC2@EX1.faraday.com.tw>
 <20110714103624.GG7149@linutronix.de>
 <B3F95056718EDE47B73D925D2FF34506782BDB@EX1.faraday.com.tw>
 <20110718083640.GB2837@legolas.emea.dhcp.ti.com>
 <B3F95056718EDE47B73D925D2FF34506782CB0@EX1.faraday.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <B3F95056718EDE47B73D925D2FF34506782CB0@EX1.faraday.com.tw>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in this block is unused and the Author is fine with removing:
|These functions were used to debug unstable hw fifo while developing
|fusb300.  It's much more stable now.
|So these functions can be removed.

Cc: "Wendy Yuan-Hsin Chen" <yhchen@faraday-tech.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/gadget/fusb300_udc.c |  101 --------------------------------------
 1 files changed, 0 insertions(+), 101 deletions(-)

diff --git a/drivers/usb/gadget/fusb300_udc.c b/drivers/usb/gadget/fusb300_udc.c
index 24a9243..4ec888f 100644
--- a/drivers/usb/gadget/fusb300_udc.c
+++ b/drivers/usb/gadget/fusb300_udc.c
@@ -609,107 +609,6 @@ void fusb300_rdcxf(struct fusb300 *fusb300,
 	}
 }
 
-#if 0
-static void fusb300_dbg_fifo(struct fusb300_ep *ep,
-				u8 entry, u16 length)
-{
-	u32 reg;
-	u32 i = 0;
-	u32 j = 0;
-
-	reg = ioread32(ep->fusb300->reg + FUSB300_OFFSET_GTM);
-	reg &= ~(FUSB300_GTM_TST_EP_ENTRY(0xF) |
-		FUSB300_GTM_TST_EP_NUM(0xF) | FUSB300_GTM_TST_FIFO_DEG);
-	reg |= (FUSB300_GTM_TST_EP_ENTRY(entry) |
-		FUSB300_GTM_TST_EP_NUM(ep->epnum) | FUSB300_GTM_TST_FIFO_DEG);
-	iowrite32(reg, ep->fusb300->reg + FUSB300_OFFSET_GTM);
-
-	for (i = 0; i < (length >> 2); i++) {
-		if (i * 4 == 1024)
-			break;
-		reg = ioread32(ep->fusb300->reg +
-			FUSB300_OFFSET_BUFDBG_START + i * 4);
-		printk(KERN_DEBUG"  0x%-8x", reg);
-		j++;
-		if ((j % 4)  == 0)
-			printk(KERN_DEBUG "\n");
-	}
-
-	if (length % 4) {
-		reg = ioread32(ep->fusb300->reg +
-			FUSB300_OFFSET_BUFDBG_START + i * 4);
-		printk(KERN_DEBUG "  0x%x\n", reg);
-	}
-
-	if ((j % 4)  != 0)
-		printk(KERN_DEBUG "\n");
-
-	fusb300_disable_bit(ep->fusb300, FUSB300_OFFSET_GTM,
-		FUSB300_GTM_TST_FIFO_DEG);
-}
-
-static void fusb300_cmp_dbg_fifo(struct fusb300_ep *ep,
-				u8 entry, u16 length, u8 *golden)
-{
-	u32 reg;
-	u32 i = 0;
-	u32 golden_value;
-	u8 *tmp;
-
-	tmp = golden;
-
-	printk(KERN_DEBUG "fusb300_cmp_dbg_fifo (entry %d) : start\n", entry);
-
-	reg = ioread32(ep->fusb300->reg + FUSB300_OFFSET_GTM);
-	reg &= ~(FUSB300_GTM_TST_EP_ENTRY(0xF) |
-		FUSB300_GTM_TST_EP_NUM(0xF) | FUSB300_GTM_TST_FIFO_DEG);
-	reg |= (FUSB300_GTM_TST_EP_ENTRY(entry) |
-		FUSB300_GTM_TST_EP_NUM(ep->epnum) | FUSB300_GTM_TST_FIFO_DEG);
-	iowrite32(reg, ep->fusb300->reg + FUSB300_OFFSET_GTM);
-
-	for (i = 0; i < (length >> 2); i++) {
-		if (i * 4 == 1024)
-			break;
-		golden_value = *tmp | *(tmp + 1) << 8 |
-				*(tmp + 2) << 16 | *(tmp + 3) << 24;
-
-		reg = ioread32(ep->fusb300->reg +
-			FUSB300_OFFSET_BUFDBG_START + i*4);
-
-		if (reg != golden_value) {
-			printk(KERN_DEBUG "0x%x  :  ", (u32)(ep->fusb300->reg +
-				FUSB300_OFFSET_BUFDBG_START + i*4));
-			printk(KERN_DEBUG "    golden = 0x%x, reg = 0x%x\n",
-				golden_value, reg);
-		}
-		tmp += 4;
-	}
-
-	switch (length % 4) {
-	case 1:
-		golden_value = *tmp;
-	case 2:
-		golden_value = *tmp | *(tmp + 1) << 8;
-	case 3:
-		golden_value = *tmp | *(tmp + 1) << 8 | *(tmp + 2) << 16;
-	default:
-		break;
-
-	reg = ioread32(ep->fusb300->reg + FUSB300_OFFSET_BUFDBG_START + i*4);
-	if (reg != golden_value) {
-		printk(KERN_DEBUG "0x%x:", (u32)(ep->fusb300->reg +
-			FUSB300_OFFSET_BUFDBG_START + i*4));
-		printk(KERN_DEBUG "  golden = 0x%x, reg = 0x%x\n",
-			golden_value, reg);
-	}
-	}
-
-	printk(KERN_DEBUG "fusb300_cmp_dbg_fifo : end\n");
-	fusb300_disable_bit(ep->fusb300, FUSB300_OFFSET_GTM,
-		FUSB300_GTM_TST_FIFO_DEG);
-}
-#endif
-
 static void fusb300_rdfifo(struct fusb300_ep *ep,
 			  struct fusb300_request *req,
 			  u32 length)
-- 
1.7.4.4

