Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab2FSAD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 20:03:27 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:57538 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab2FSAD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 20:03:26 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-131.messagelabs.com!1340064202!5011272!2
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: pcmmio: quiet NULL pointer sparse noise
Date: Mon, 18 Jun 2012 17:03:17 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206181703.17801.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comedi_async 'inttrig' member is a pointer to a callback
function. NULL should be used to clear it not 0.

This quiets a number of sparse warnings about:

Warning: Using plain integer as NULL pointer

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/pcmmio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index 0e64d84..0e66454 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -514,7 +514,7 @@ static void pcmmio_stop_intr(struct comedi_device *dev,
 
 	subpriv->dio.intr.enabled_mask = 0;
 	subpriv->dio.intr.active = 0;
-	s->async->inttrig = 0;
+	s->async->inttrig = NULL;
 	nports = subpriv->dio.intr.num_asic_chans / CHANS_PER_PORT;
 	firstport = subpriv->dio.intr.asic_chan / CHANS_PER_PORT;
 	switch_page(dev, asic, PAGE_ENAB);
@@ -780,7 +780,7 @@ pcmmio_inttrig_start_intr(struct comedi_device *dev, struct comedi_subdevice *s,
 		return -EINVAL;
 
 	spin_lock_irqsave(&subpriv->dio.intr.spinlock, flags);
-	s->async->inttrig = 0;
+	s->async->inttrig = NULL;
 	if (subpriv->dio.intr.active)
 		event = pcmmio_start_intr(dev, s);
 	spin_unlock_irqrestore(&subpriv->dio.intr.spinlock, flags);
-- 
1.7.11

