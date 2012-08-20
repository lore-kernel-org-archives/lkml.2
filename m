Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab2HTWFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 18:05:33 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:45215 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab2HTWFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 18:05:30 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-209.messagelabs.com!1345500328!3793309!3
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] staging: comedi: comedi_test: convert attach message to dev_info
Date: Mon, 20 Aug 2012 15:05:23 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201505.24108.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the 'attach' message from a printk to a dev_info.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/comedi_test.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index 6864716..8ea9202 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -489,10 +489,12 @@ static int waveform_attach(struct comedi_device *dev,
 	devpriv->timer.function = waveform_ai_interrupt;
 	devpriv->timer.data = (unsigned long)dev;
 
-	printk(KERN_INFO "comedi%d: comedi_test: "
-	       "%i microvolt, %li microsecond waveform attached\n", dev->minor,
-	       devpriv->uvolt_amplitude, devpriv->usec_period);
-	return 1;
+	dev_info(dev->class_dev,
+		"%s: %i microvolt, %li microsecond waveform attached\n",
+		dev->board_name,
+		devpriv->uvolt_amplitude, devpriv->usec_period);
+
+	return 0;
 }
 
 static void waveform_detach(struct comedi_device *dev)
-- 
1.7.11

