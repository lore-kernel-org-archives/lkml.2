Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab2GKALI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:11:08 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:9766 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab2GKALG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:11:06 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-209.messagelabs.com!1341965464!8333557!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 57/83] staging: comedi: rtd520: remove RtdDacClearFifo macro
Date: Tue, 10 Jul 2012 17:11:01 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101711.01461.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/rtd520.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 8cd056c..ead8420 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,11 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Reset DAC FIFO */
-#define RtdDacClearFifo(dev, n) \
-	writel(0, devpriv->las0+(((n) == 0) ? LAS0_DAC1_RESET : \
-				LAS0_DAC2_RESET))
-
 /* Set source for DMA 0 (write only, shadow?) */
 #define RtdDma0Source(dev, n) \
 	writel((n) & 0xf, devpriv->las0+LAS0_DMA0_SRC)
@@ -1866,8 +1861,8 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	writel(0, devpriv->las0 + LAS0_OVERRUN);
 	writel(0, devpriv->las0 + LAS0_CGT_CLEAR);
 	writel(0, devpriv->las0 + LAS0_ADC_FIFO_CLEAR);
-	RtdDacClearFifo(dev, 0);
-	RtdDacClearFifo(dev, 1);
+	writel(0, devpriv->las0 + LAS0_DAC1_RESET);
+	writel(0, devpriv->las0 + LAS0_DAC2_RESET);
 	/* clear digital IO fifo */
 	devpriv->dioStatus = 0;
 	writew(devpriv->dioStatus, devpriv->las0 + LAS0_DIO_STATUS);
-- 
1.7.11

