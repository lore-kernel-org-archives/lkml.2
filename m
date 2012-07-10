Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab2GJXzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:55:46 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:64711 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab2GJXzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:55:45 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-127.messagelabs.com!1341964544!8247277!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 28/83] staging: comedi: rtd520: remove RtdInterruptOverrunClear macro
Date: Tue, 10 Jul 2012 16:55:40 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101655.41230.hartleys@visionengravers.com>
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
index 3c501ca..b159c2f 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Interrupt overrun clear */
-#define RtdInterruptOverrunClear(dev) \
-	writel(0, devpriv->las0+LAS0_OVERRUN)
-
 /* Pacer counter, 24bit */
 #define RtdPacerCount(dev) \
 	readl(devpriv->las0+LAS0_PCLK)
@@ -1419,7 +1415,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	RtdDma0Reset(dev);	/* reset onboard state */
 #endif /* USE_DMA */
 	writel(0, devpriv->las0 + LAS0_ADC_FIFO_CLEAR);
-	RtdInterruptOverrunClear(dev);
+	writel(0, devpriv->las0 + LAS0_OVERRUN);
 	devpriv->intCount = 0;
 
 	if (!dev->irq) {	/* we need interrupts for this */
@@ -1964,7 +1960,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	devpriv->intClearMask = ~0;
 	writew(devpriv->intClearMask, devpriv->las0 + LAS0_CLEAR);
 	readw(devpriv->las0 + LAS0_CLEAR);
-	RtdInterruptOverrunClear(dev);
+	writel(0, devpriv->las0 + LAS0_OVERRUN);
 	writel(0, devpriv->las0 + LAS0_CGT_CLEAR);
 	writel(0, devpriv->las0 + LAS0_ADC_FIFO_CLEAR);
 	RtdDacClearFifo(dev, 0);
-- 
1.7.11

