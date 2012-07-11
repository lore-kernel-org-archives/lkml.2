Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab2GKADK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:03:10 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:35733 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab2GKADI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:03:08 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-209.messagelabs.com!1341964985!7872015!3
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 42/83] staging: comedi: rtd520: remove RtdUtcClockSource macro
Date: Tue, 10 Jul 2012 17:02:58 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101702.58680.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro uses the 'devpriv' macro which relies on a local variable
having a specific name. It's also not used. Remove the macro.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 2201d11..c411e60 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,12 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Set UTCn clock source (write only) */
-#define RtdUtcClockSource(dev, n, v) \
-	writew(v, devpriv->las0 \
-		+ ((n <= 0) ? LAS0_UTC0_CLOCK : \
-			((1 == n) ? LAS0_UTC1_CLOCK : LAS0_UTC2_CLOCK)))
-
 /* Set UTCn gate source (write only) */
 #define RtdUtcGateSource(dev, n, v) \
 	writew(v, devpriv->las0 \
-- 
1.7.11

