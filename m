Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab2GJXmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:42:15 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:9518 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab2GJXmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:42:14 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-132.messagelabs.com!1341963727!13969175!6
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/83] staging: comedi: rtd520: remove RtdWriteCGTable macro
Date: Tue, 10 Jul 2012 16:42:08 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101642.08783.hartleys@visionengravers.com>
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
index 550ebbd..0467877 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Write channel gain table entry */
-#define RtdWriteCGTable(dev, v) \
-	writel(v, devpriv->las0+LAS0_CGT_WRITE)
-
 /* Write Channel Gain Latch */
 #define RtdWriteCGLatch(dev, v) \
 	writel(v, devpriv->las0+LAS0_CGL_WRITE)
@@ -793,8 +789,8 @@ static void rtd_load_channelgain_list(struct comedi_device *dev,
 		writel(0, devpriv->las0 + LAS0_CGT_CLEAR);
 		writel(1, devpriv->las0 + LAS0_CGT_ENABLE);
 		for (ii = 0; ii < n_chan; ii++) {
-			RtdWriteCGTable(dev, rtdConvertChanGain(dev, list[ii],
-								ii));
+			writel(rtdConvertChanGain(dev, list[ii], ii),
+				devpriv->las0 + LAS0_CGT_WRITE);
 		}
 	} else {		/* just use the channel gain latch */
 		writel(0, devpriv->las0 + LAS0_CGT_ENABLE);
-- 
1.7.11

