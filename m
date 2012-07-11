Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab2GKAWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:22:55 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:37655 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab2GKAWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:22:54 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-131.messagelabs.com!1341966171!15041687!6
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 76/83] staging: comedi: rtd520: remove RtdDma1Control macro
Date: Tue, 10 Jul 2012 17:22:46 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101722.46469.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro uses the 'devpriv' macro which relies on a local variable
having a specific name. Plus it's just a wrapper around a simple
'writeb'. Remove the macro.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 65f0b11..09e3938 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Set control for DMA 1 (write only, shadow?) */
-#define RtdDma1Control(dev, n) \
-	writeb(devpriv->dma1Control = (n), devpriv->lcfg+LCFG_DMACSR1)
-
 /* Get status for DMA 1 */
 #define RtdDma1Status(dev) \
 	readb(devpriv->lcfg+LCFG_DMACSR1)
@@ -1968,9 +1964,11 @@ static void rtd_detach(struct comedi_device *dev)
 #ifdef USE_DMA
 		if (devpriv->lcfg) {
 			devpriv->dma0Control = 0;
+			devpriv->dma1Control = 0;
 			writeb(devpriv->dma0Control,
 				devpriv->lcfg + LCFG_DMACSR0);
-			RtdDma1Control(dev, 0);	/* disable DMA */
+			writeb(devpriv->dma1Control,
+				devpriv->lcfg + LCFG_DMACSR1);
 			writel(ICS_PIE | ICS_PLIE, devpriv->lcfg + LCFG_ITCSR);
 		}
 #endif /* USE_DMA */
-- 
1.7.11

