Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab2GKAIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:08:37 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:60997 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279Ab2GKAIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:08:36 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-131.messagelabs.com!1341965313!24725698!3
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 52/83] staging: comedi: rtd520: remove RtdDio0CtrlWrite macro
Date: Tue, 10 Jul 2012 17:08:29 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101708.29690.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro uses the 'devpriv' macro which relies on a local variable
having a specific name. Plus it's just a wrapper around a simple
'writew'. Remove the macro.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index b0c5f34..e7c550f 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,9 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-#define RtdDio0CtrlWrite(dev, v) \
-	writew((v) & 0xff, devpriv->las0+LAS0_DIO0_CTRL)
-
 /* Digital to Analog converter */
 /* Write one data value (sign + 12bit + marker bits) */
 /* Note: matches what DMA would put.  Actual value << 3 */
@@ -1686,7 +1683,7 @@ static int rtd_dio_insn_config(struct comedi_device *dev,
 	/* TODO support digital match interrupts and strobes */
 	devpriv->dioStatus = 0x01;	/* set direction */
 	writew(devpriv->dioStatus, devpriv->las0 + LAS0_DIO_STATUS);
-	RtdDio0CtrlWrite(dev, s->io_bits);	/* set direction 1 means Out */
+	writew(s->io_bits & 0xff, devpriv->las0 + LAS0_DIO0_CTRL);
 	devpriv->dioStatus = 0x00;	/* clear interrupts */
 	writew(devpriv->dioStatus, devpriv->las0 + LAS0_DIO_STATUS);
 
-- 
1.7.11

