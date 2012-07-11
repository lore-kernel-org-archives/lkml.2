Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2GKACI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:02:08 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:6064 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062Ab2GKABx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:01:53 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-160.messagelabs.com!1341964864!6625634!37
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 40/83] staging: comedi: rtd520: remove RtdUtcCounterPut macro
Date: Tue, 10 Jul 2012 17:01:47 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101701.47973.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro uses the 'devpriv' macro which relies on a local variable
having a specific name. It's also not used. Remove the macro.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 051cc196..21c9291 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-#define RtdUtcCounterPut(dev, n, v) \
-	writeb((v) & 0xff, devpriv->las0 \
-		+ ((n <= 0) ? LAS0_UTC0 : ((1 == n) ? LAS0_UTC1 : LAS0_UTC2)))
-
 /* Set UTC (8254) control byte  */
 #define RtdUtcCtrlPut(dev, n, v) \
 	writeb(devpriv->utcCtrl[(n) & 3] = (((n) & 3) << 6) | ((v) & 0x3f), \
-- 
1.7.11

