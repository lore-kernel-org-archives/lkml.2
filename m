Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2HRBVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:21:25 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:28682 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab2HRBVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:21:21 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-131.messagelabs.com!1345252878!6751754!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/20] staging: comedi: adv_pci_dio: fix bug in 'detach'
Date: Fri, 17 Aug 2012 18:21:12 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171821.13078.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'attach' function can fail between when the devpriv and
the comedi subdevices are allocated. If it does the 'detach'
will try to access unallocated memory when it goes thru the
subdevices.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 4da0e7b..a4c1b13 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -1184,6 +1184,8 @@ static void pci_dio_detach(struct comedi_device *dev)
 	if (devpriv) {
 		if (devpriv->valid)
 			pci_dio_reset(dev);
+	}
+	if (dev->subdevices) {
 		for (i = 0; i < dev->n_subdevices; i++) {
 			s = dev->subdevices + i;
 			if (s->type == COMEDI_SUBD_DIO)
-- 
1.7.11

