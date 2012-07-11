Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab2GKAFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:05:34 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:50909 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab2GKAFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:05:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-209.messagelabs.com!1341965131!8306484!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 46/83] staging: comedi: rtd520: remove RtdDio0Write macro
Date: Tue, 10 Jul 2012 17:05:27 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101705.27913.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/rtd520.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index e3a6aa2..6640e1b 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Digital IO */
-#define RtdDio0Write(dev, v) \
-	writew((v) & 0xff, devpriv->las0+LAS0_DIO0)
-
 #define RtdDio1Read(dev) \
 	(readw(devpriv->las0+LAS0_DIO1) & 0xff)
 #define RtdDio1Write(dev, v) \
@@ -1658,7 +1654,7 @@ static int rtd_dio_insn_bits(struct comedi_device *dev,
 		s->state |= data[0] & data[1];
 
 		/* Write out the new digital output lines */
-		RtdDio0Write(dev, s->state);
+		writew(s->state & 0xff, devpriv->las0 + LAS0_DIO0);
 	}
 	/* on return, data[1] contains the value of the digital
 	 * input lines. */
-- 
1.7.11

