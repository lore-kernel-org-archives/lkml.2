Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab2GKAEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:04:06 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:39578 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab2GKAEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:04:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-160.messagelabs.com!1341965043!9277901!2
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 43/83] staging: comedi: rtd520: remove RtdUtcGateSource macro
Date: Tue, 10 Jul 2012 17:03:32 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101703.32579.hartleys@visionengravers.com>
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
index c411e60..5da6930 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,12 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Set UTCn gate source (write only) */
-#define RtdUtcGateSource(dev, n, v) \
-	writew(v, devpriv->las0 \
-		+ ((n <= 0) ? LAS0_UTC0_GATE : \
-			((1 == n) ? LAS0_UTC1_GATE : LAS0_UTC2_GATE)))
-
 /* User output N source select (write only) */
 #define RtdUsrOutSource(dev, n, v) \
 	writel(v, devpriv->las0+((n <= 0) ? LAS0_UOUT0_SELECT : \
-- 
1.7.11

