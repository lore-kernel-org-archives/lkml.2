Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab2GKAHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:07:15 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:56958 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab2GKAHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:07:01 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-209.messagelabs.com!1341965220!8306582!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 49/83] staging: comedi: rtd520: remove RtdDioStatusRead macro
Date: Tue, 10 Jul 2012 17:06:50 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101706.50921.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro uses the 'devpriv' macro which relies on a local variable
having a specific name. It's also not used. Remove the macro.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 452b04b..b7e1322 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,8 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-#define RtdDioStatusRead(dev) \
-	(readw(devpriv->las0+LAS0_DIO_STATUS) & 0xff)
 #define RtdDioStatusWrite(dev, v) \
 	writew((devpriv->dioStatus = (v)), devpriv->las0+LAS0_DIO_STATUS)
 
-- 
1.7.11

