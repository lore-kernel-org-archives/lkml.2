Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab2GKAKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:10:33 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:58717 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab2GKAKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:10:06 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-132.messagelabs.com!1341965402!13993012!4
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 55/83] staging: comedi: rtd520: remove RtdDacBothUpdate macro
Date: Tue, 10 Jul 2012 17:09:59 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101710.00172.hartleys@visionengravers.com>
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
index e81939c..ebe74bf 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Start single DAC conversion on both DACs */
-#define RtdDacBothUpdate(dev) \
-	writew(0, devpriv->las0+LAS0_DAC)
-
 /* Set DAC output type and range */
 #define RtdDacRange(dev, n, v) \
 	writew((v) & 7, devpriv->las0 \
-- 
1.7.11

