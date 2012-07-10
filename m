Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab2GJXnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:43:00 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:31802 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab2GJXm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:42:58 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-209.messagelabs.com!1341963777!5479464!2
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/83] staging: comedi: rtd520: remove RtdWriteCGLatch macro
Date: Tue, 10 Jul 2012 16:42:48 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101642.48990.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/rtd520.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 0467877..3a7c030 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Write Channel Gain Latch */
-#define RtdWriteCGLatch(dev, v) \
-	writel(v, devpriv->las0+LAS0_CGL_WRITE)
-
 /* Reset ADC FIFO */
 #define RtdAdcClearFifo(dev) \
 	writel(0, devpriv->las0+LAS0_ADC_FIFO_CLEAR)
@@ -794,7 +790,8 @@ static void rtd_load_channelgain_list(struct comedi_device *dev,
 		}
 	} else {		/* just use the channel gain latch */
 		writel(0, devpriv->las0 + LAS0_CGT_ENABLE);
-		RtdWriteCGLatch(dev, rtdConvertChanGain(dev, list[0], 0));
+		writel(rtdConvertChanGain(dev, list[0], 0),
+			devpriv->las0 + LAS0_CGL_WRITE);
 	}
 }
 
-- 
1.7.11

