Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679Ab2HQCxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:53:53 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:13408 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933197Ab2HQCxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:53:51 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-132.messagelabs.com!1345172029!10613942!2
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 30/35] staging: comedi: cb_pcimdda: fix bug in call to subdev_8255_cleanup
Date: Thu, 16 Aug 2012 19:53:45 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161953.45446.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The attach function only allocated 2 subdevices, an analog output
sundevice (index 0) and the 8255 dio subdevice (index 1). The
detach function is passing the wrong subdevice (index 2) to the
subdev_8255_cleanup function which will result in a bug when
it tries to do the kfree(s->private).

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index b10831d..99a6160 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -257,7 +257,7 @@ static void cb_pcimdda_detach(struct comedi_device *dev)
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 
 	if (dev->subdevices)
-		subdev_8255_cleanup(dev, dev->subdevices + 2);
+		subdev_8255_cleanup(dev, dev->subdevices + 1);
 	if (pcidev) {
 		if (dev->iobase)
 			comedi_pci_disable(pcidev);
-- 
1.7.11

