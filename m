Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab2GJXqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:46:43 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:41478 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab2GJXqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:46:42 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-209.messagelabs.com!1341964000!8306140!5
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/83] staging: comedi: rtd520: remove RtdPacerClockSource macro
Date: Tue, 10 Jul 2012 16:46:37 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101646.37849.hartleys@visionengravers.com>
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
index 6636b26..ecdc7e4 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Set Pacer clock source select (write only) 0=external 1=internal */
-#define RtdPacerClockSource(dev, v) \
-	writel((v > 0) ? 1 : 0, devpriv->las0+LAS0_PACER_SELECT)
-
 /* Set sample counter source select (write only) */
 #define RtdAdcSampleCounterSource(dev, v) \
 	writel(v, devpriv->las0+LAS0_ADC_SCNT_SRC)
@@ -1544,7 +1540,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		devpriv->transCount = 0;
 		devpriv->flags &= ~SEND_EOS;
 	}
-	RtdPacerClockSource(dev, 1);	/* use INTERNAL 8Mhz clock source */
+	writel(1, devpriv->las0 + LAS0_PACER_SELECT);
 	RtdAboutStopEnable(dev, 1);	/* just interrupt, dont stop */
 
 	/* BUG??? these look like enumerated values, but they are bit fields */
-- 
1.7.11

