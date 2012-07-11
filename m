Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab2GKAKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:10:47 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:57182 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2GKAKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:10:31 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1341965429!7792547!3
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 56/83] staging: comedi: rtd520: remove RtdDacRange macro
Date: Tue, 10 Jul 2012 17:10:27 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101710.27356.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/rtd520.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index ebe74bf..8cd056c 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,11 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Set DAC output type and range */
-#define RtdDacRange(dev, n, v) \
-	writew((v) & 7, devpriv->las0 \
-		+(((n) == 0) ? LAS0_DAC1_CTRL : LAS0_DAC2_CTRL))
-
 /* Reset DAC FIFO */
 #define RtdDacClearFifo(dev, n) \
 	writel(0, devpriv->las0+(((n) == 0) ? LAS0_DAC1_RESET : \
@@ -1538,7 +1533,8 @@ static int rtd_ao_winsn(struct comedi_device *dev,
 	int range = CR_RANGE(insn->chanspec);
 
 	/* Configure the output range (table index matches the range values) */
-	RtdDacRange(dev, chan, range);
+	writew(range & 7, devpriv->las0 +
+		((chan == 0) ? LAS0_DAC1_CTRL : LAS0_DAC2_CTRL));
 
 	/* Writing a list of values to an AO channel is probably not
 	 * very useful, but that's how the interface is defined. */
-- 
1.7.11

