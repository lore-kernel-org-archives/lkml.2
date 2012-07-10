Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab2GJXto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:49:44 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:47842 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab2GJXtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:49:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-127.messagelabs.com!1341964120!8236748!17
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/83] staging: comedi: rtd520: remove RtdAdcStart macro
Date: Tue, 10 Jul 2012 16:49:28 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101649.28576.hartleys@visionengravers.com>
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
index 1face98..b76bb75 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Start single ADC conversion */
-#define RtdAdcStart(dev) \
-	writew(0, devpriv->las0+LAS0_ADC)
-
 /* Read one ADC data value (12bit (with sign extend) as 16bit) */
 /* Note: matches what DMA would get.  Actual value >> 3 */
 #define RtdAdcFifoGet(dev) \
@@ -771,7 +767,7 @@ static int rtd520_probe_fifo_depth(struct comedi_device *dev)
 	for (i = 0; i < limit; ++i) {
 		unsigned fifo_status;
 		/* trigger conversion */
-		RtdAdcStart(dev);
+		writew(0, devpriv->las0 + LAS0_ADC);
 		udelay(1);
 		fifo_status = RtdFifoStatus(dev);
 		if ((fifo_status & FS_ADC_HEMPTY) == 0) {
@@ -822,7 +818,7 @@ static int rtd_ai_rinsn(struct comedi_device *dev,
 	for (n = 0; n < insn->n; n++) {
 		s16 d;
 		/* trigger conversion */
-		RtdAdcStart(dev);
+		writew(0, devpriv->las0 + LAS0_ADC);
 
 		for (ii = 0; ii < RTD_ADC_TIMEOUT; ++ii) {
 			stat = RtdFifoStatus(dev);
-- 
1.7.11

