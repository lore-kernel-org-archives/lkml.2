Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab2GKALh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:11:37 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:35896 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab2GKALg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:11:36 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1341965493!9215139!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 58/83] staging: comedi: rtd520: remove RtdDma0Source macro
Date: Tue, 10 Jul 2012 17:11:29 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101711.29830.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro uses the 'devpriv' macro which relies on a local variable
having a specific name. Plus it's just a wrapper around a simple
'writel'. Remove the macro.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index ead8420..847e98c 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Set source for DMA 0 (write only, shadow?) */
-#define RtdDma0Source(dev, n) \
-	writel((n) & 0xf, devpriv->las0+LAS0_DMA0_SRC)
-
 /* Set source for DMA 1 (write only, shadow?) */
 #define RtdDma1Source(dev, n) \
 	writel((n) & 0xf, devpriv->las0+LAS0_DMA1_SRC)
@@ -1464,7 +1460,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		RtdDma0Mode(dev, DMA_MODE_BITS);
 		RtdDma0Next(dev,	/* point to first block */
 			    devpriv->dma0Chain[DMA_CHAIN_COUNT - 1].next);
-		RtdDma0Source(dev, DMAS_ADFIFO_HALF_FULL);	/* set DMA trigger source */
+		writel(DMAS_ADFIFO_HALF_FULL, devpriv->las0 + LAS0_DMA0_SRC);
 
 		RtdPlxInterruptWrite(dev,	/* enable interrupt */
 				     RtdPlxInterruptRead(dev) | ICS_DMA0_E);
@@ -1961,7 +1957,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 		RtdDma0Mode(dev, DMA_MODE_BITS);
 		/* set DMA trigger source */
-		RtdDma0Source(dev, DMAS_ADFIFO_HALF_FULL);
+		writel(DMAS_ADFIFO_HALF_FULL, devpriv->las0 + LAS0_DMA0_SRC);
 	} else {
 		printk(KERN_INFO "( no IRQ->no DMA )");
 	}
-- 
1.7.11

