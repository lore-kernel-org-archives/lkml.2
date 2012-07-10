Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab2GJXpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:45:09 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:19705 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab2GJXpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:45:08 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1341963878!7790765!12
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/83] staging: comedi: rtd520: remove RtdBurstStartSource macro
Date: Tue, 10 Jul 2012 16:44:49 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101644.49312.hartleys@visionengravers.com>
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
index 62748b9..26bdcab 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Set burst start source select (write only) */
-#define RtdBurstStartSource(dev, v) \
-	writel(v, devpriv->las0+LAS0_BURST_START)
-
 /* Set Pacer start source select (write only) */
 #define RtdPacerStartSource(dev, v) \
 	writel(v, devpriv->las0+LAS0_PACER_START)
@@ -1504,7 +1500,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (cmd->chanlist_len > 1) {
 		/*DPRINTK ("rtd520: Multi channel setup\n"); */
 		RtdPacerStartSource(dev, 0);	/* software triggers pacer */
-		RtdBurstStartSource(dev, 1);	/* PACER triggers burst */
+		writel(1, devpriv->las0 + LAS0_BURST_START);
 		writel(2, devpriv->las0 + LAS0_ADC_CONVERSION);
 	} else {		/* single channel */
 		/*DPRINTK ("rtd520: single channel setup\n"); */
@@ -1614,7 +1610,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		break;
 
 	case TRIG_EXT:		/* external */
-		RtdBurstStartSource(dev, 2);	/* EXTERNALy trigger burst */
+		writel(2, devpriv->las0 + LAS0_BURST_START);
 		break;
 
 	default:
-- 
1.7.11

