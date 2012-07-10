Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2GJXv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:51:57 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:58485 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2GJXv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:51:56 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-160.messagelabs.com!1341964309!9283484!3
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 21/83] staging: comedi: rtd520: remove RtdPacerStart macro
Date: Tue, 10 Jul 2012 16:51:46 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101651.46587.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro uses the 'devpriv' macro which relies on a local variable
having a specific name. Plus it's just a wrapper around a simple
'readl'. Remove the macro.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 3b44776..190f287 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -407,8 +407,6 @@ struct rtdPrivate {
 /* Macros to access registers */
 
 /* pacer start/stop read=start, write=stop*/
-#define RtdPacerStart(dev) \
-	readl(devpriv->las0+LAS0_PACER)
 #define RtdPacerStop(dev) \
 	writel(0, devpriv->las0+LAS0_PACER)
 
@@ -1609,7 +1607,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	/* BUG: start_src is ASSUMED to be TRIG_NOW */
 	/* BUG? it seems like things are running before the "start" */
-	RtdPacerStart(dev);	/* Start PACER */
+	readl(devpriv->las0 + LAS0_PACER);
 	return 0;
 }
 
-- 
1.7.11

