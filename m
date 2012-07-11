Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab2GKAJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:09:43 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:29020 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab2GKAJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:09:42 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1341965380!8371996!2
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 54/83] staging: comedi: rtd520: remove RtdDacUpdate macro
Date: Tue, 10 Jul 2012 17:09:31 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101709.32266.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/rtd520.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 8ba7877..e81939c 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Start single DAC conversion */
-#define RtdDacUpdate(dev, n) \
-	writew(0, devpriv->las0 + (((n) == 0) ? LAS0_DAC1 : LAS0_DAC2))
-
 /* Start single DAC conversion on both DACs */
 #define RtdDacBothUpdate(dev) \
 	writew(0, devpriv->las0+LAS0_DAC)
@@ -1572,7 +1568,7 @@ static int rtd_ao_winsn(struct comedi_device *dev,
 		/* a typical programming sequence */
 		writew(val, devpriv->las1 +
 			((chan == 0) ? LAS1_DAC1_FIFO : LAS1_DAC2_FIFO));
-		RtdDacUpdate(dev, chan);	/* trigger the conversion */
+		writew(0, devpriv->las0 + ((chan == 0) ? LAS0_DAC1 : LAS0_DAC2));
 
 		devpriv->aoValue[chan] = data[i];	/* save for read back */
 
-- 
1.7.11

