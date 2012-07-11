Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab2GKAGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:06:13 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:10621 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab2GKAGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:06:12 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-160.messagelabs.com!1341965134!9295024!13
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 47/83] staging: comedi: rtd520: remove RtdDio1Read macro
Date: Tue, 10 Jul 2012 17:05:55 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101705.55704.hartleys@visionengravers.com>
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
index 6640e1b..826c01b 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,8 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-#define RtdDio1Read(dev) \
-	(readw(devpriv->las0+LAS0_DIO1) & 0xff)
 #define RtdDio1Write(dev, v) \
 	writew((v) & 0xff, devpriv->las0+LAS0_DIO1)
 
-- 
1.7.11

