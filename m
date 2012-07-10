Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab2GJXjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:39:36 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:54002 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab2GJXjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:39:35 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1341963573!7790439!3
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/83] staging: comedi: rtd520: remove RtdResetBoard macro
Date: Tue, 10 Jul 2012 16:39:25 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101639.25825.hartleys@visionengravers.com>
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
index cc1371d..0b6da10 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Reset board */
-#define RtdResetBoard(dev) \
-	writel(0, devpriv->las0+LAS0_BOARD_RESET)
-
 /* Reset channel gain table read pointer */
 #define RtdResetCGT(dev) \
 	writel(0, devpriv->las0+LAS0_CGT_RESET)
@@ -2050,7 +2046,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/* initialize board, per RTD spec */
 	/* also, initialize shadow registers */
-	RtdResetBoard(dev);
+	writel(0, devpriv->las0 + LAS0_BOARD_RESET);
 	udelay(100);		/* needed? */
 	RtdPlxInterruptWrite(dev, 0);
 	RtdInterruptMask(dev, 0);	/* and sets shadow */
@@ -2231,7 +2227,7 @@ static void rtd_detach(struct comedi_device *dev)
 		}
 #endif /* USE_DMA */
 		if (devpriv->las0) {
-			RtdResetBoard(dev);
+			writel(0, devpriv->las0 + LAS0_BOARD_RESET);
 			RtdInterruptMask(dev, 0);
 			RtdInterruptClearMask(dev, ~0);
 			RtdInterruptClear(dev);	/* clears bits set by mask */
-- 
1.7.11

