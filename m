Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab2GJXs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:48:28 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:41905 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab2GJXs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:48:27 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-160.messagelabs.com!1341964106!9292522!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/83] staging: comedi: rtd520: remove RtdAboutStopEnable macro
Date: Tue, 10 Jul 2012 16:48:22 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101648.22429.hartleys@visionengravers.com>
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
index f3fea5a..df505a3 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Set About counter stop enable (write only) */
-#define RtdAboutStopEnable(dev, v) \
-	writel((v > 0) ? 1 : 0, devpriv->las0+LAS0_ACNT_STOP_ENABLE)
-
 /* Set external trigger polarity (write only) 0=positive edge, 1=negative */
 #define RtdTriggerPolarity(dev, v) \
 	writel((v > 0) ? 1 : 0, devpriv->las0+LAS0_ETRG_POLARITY)
@@ -1533,7 +1529,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		devpriv->flags &= ~SEND_EOS;
 	}
 	writel(1, devpriv->las0 + LAS0_PACER_SELECT);
-	RtdAboutStopEnable(dev, 1);	/* just interrupt, dont stop */
+	writel(1, devpriv->las0 + LAS0_ACNT_STOP_ENABLE);
 
 	/* BUG??? these look like enumerated values, but they are bit fields */
 
-- 
1.7.11

