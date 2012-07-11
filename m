Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab2GKAOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:14:34 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:51827 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2GKAOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:14:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-160.messagelabs.com!1341965669!9288073!4
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 64/83] staging: comedi: rtd520: remove RtdDma0Mode macro
Date: Tue, 10 Jul 2012 17:14:25 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101714.25962.hartleys@visionengravers.com>
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
index 202e1d8..46d892a 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Set  mode for DMA 0 */
-#define RtdDma0Mode(dev, m) \
-	writel((m), devpriv->lcfg+LCFG_DMAMODE0)
-
 /* Set PCI address for DMA 0 */
 #define RtdDma0PciAddr(dev, a) \
 	writel((a), devpriv->lcfg+LCFG_DMAPADR0)
@@ -1438,7 +1434,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 		/* point to first transfer in ring */
 		devpriv->dma0Offset = 0;
-		RtdDma0Mode(dev, DMA_MODE_BITS);
+		writel(DMA_MODE_BITS, devpriv->lcfg + LCFG_DMAMODE0);
 		RtdDma0Next(dev,	/* point to first block */
 			    devpriv->dma0Chain[DMA_CHAIN_COUNT - 1].next);
 		writel(DMAS_ADFIFO_HALF_FULL, devpriv->las0 + LAS0_DMA0_SRC);
@@ -1935,7 +1931,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			goto rtd_attach_die_error;
 		}
 
-		RtdDma0Mode(dev, DMA_MODE_BITS);
+		writel(DMA_MODE_BITS, devpriv->lcfg + LCFG_DMAMODE0);
 		/* set DMA trigger source */
 		writel(DMAS_ADFIFO_HALF_FULL, devpriv->las0 + LAS0_DMA0_SRC);
 	} else {
-- 
1.7.11

