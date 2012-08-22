Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab2HVQku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:40:50 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:46115 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab2HVQkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:40:45 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-209.messagelabs.com!1345653608!8157094!42
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: s626: fix build error due to subdevice pointer math removal
Date: Wed, 22 Aug 2012 09:40:28 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208220940.28845.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subdevice pointer math removal patch introduced a build error
in the s626 driver. Fix it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Not sure how this got thru. The build error did not appear until
I did a clean make.

 drivers/staging/comedi/drivers/s626.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 60b492e..719f4c6 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -1002,12 +1002,13 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
  */
 static void ResetADC(struct comedi_device *dev, uint8_t *ppl)
 {
+	struct comedi_subdevice *s = &dev->subdevices[0];
+	struct comedi_cmd *cmd = &s->async->cmd;
 	register uint32_t *pRPS;
 	uint32_t JmpAdrs;
 	uint16_t i;
 	uint16_t n;
 	uint32_t LocalPPL;
-	struct comedi_cmd *cmd = &(dev->subdevices[0]->async->cmd);
 
 	/*  Stop RPS program in case it is currently running. */
 	MC_DISABLE(P_MC1, MC1_ERPS1);
-- 
1.7.11

