Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab2GKAMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:12:30 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:4279 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513Ab2GKAM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:12:28 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-132.messagelabs.com!1341965546!12976052!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 60/83] staging: comedi: rtd520: remove RtdDma0Reset macro
Date: Tue, 10 Jul 2012 17:12:22 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101712.23102.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/rtd520.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 783341a..8238fb0 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Reset board state for DMA 0 */
-#define RtdDma0Reset(dev) \
-	writel(0, devpriv->las0+LAS0_DMA0_RESET)
-
 /* Reset board state for DMA 1 */
 #define RtdDma1Reset(dev) \
 	writel(0, devpriv->las0+LAS0_DMA1_SRC)
@@ -1297,7 +1293,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 			RtdDma0Control(dev, PLX_CLEAR_DMA_INTR_BIT);
 		}
 	}
-	RtdDma0Reset(dev);	/* reset onboard state */
+	writel(0, devpriv->las0 + LAS0_DMA0_RESET);
 #endif /* USE_DMA */
 	writel(0, devpriv->las0 + LAS0_ADC_FIFO_CLEAR);
 	writel(0, devpriv->las0 + LAS0_OVERRUN);
-- 
1.7.11

