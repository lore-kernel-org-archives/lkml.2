Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab2GJXwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:52:20 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:36800 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab2GJXwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:52:19 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-132.messagelabs.com!1341964337!13991877!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 22/83] staging: comedi: rtd520: remove RtdPacerStop macro
Date: Tue, 10 Jul 2012 16:52:14 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101652.14504.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/rtd520.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 190f287..5fca77b 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* pacer start/stop read=start, write=stop*/
-#define RtdPacerStop(dev) \
-	writel(0, devpriv->las0+LAS0_PACER)
-
 /* Interrupt status */
 #define RtdInterruptStatus(dev) \
 	readw(devpriv->las0+LAS0_IT)
@@ -1152,7 +1148,7 @@ abortTransfer:
 
 transferDone:
 	writel(0, devpriv->las0 + LAS0_PACER_STOP);
-	RtdPacerStop(dev);	/* Stop PACER */
+	writel(0, devpriv->las0 + LAS0_PACER);
 	writel(0, devpriv->las0 + LAS0_ADC_CONVERSION);
 	RtdInterruptMask(dev, 0);	/* mask out SAMPLE */
 #ifdef USE_DMA
@@ -1421,7 +1417,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	/* stop anything currently running */
 	writel(0, devpriv->las0 + LAS0_PACER_STOP);
-	RtdPacerStop(dev);	/* make sure PACER is stopped */
+	writel(0, devpriv->las0 + LAS0_PACER);
 	writel(0, devpriv->las0 + LAS0_ADC_CONVERSION);
 	RtdInterruptMask(dev, 0);
 #ifdef USE_DMA
@@ -1619,7 +1615,7 @@ static int rtd_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 	u16 status;
 
 	writel(0, devpriv->las0 + LAS0_PACER_STOP);
-	RtdPacerStop(dev);	/* Stop PACER */
+	writel(0, devpriv->las0 + LAS0_PACER);
 	writel(0, devpriv->las0 + LAS0_ADC_CONVERSION);
 	RtdInterruptMask(dev, 0);
 	devpriv->aiCount = 0;	/* stop and don't transfer any more */
-- 
1.7.11

