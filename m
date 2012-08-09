Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759807Ab2HIVwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 17:52:06 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:51376 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759801Ab2HIVwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:52:03 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1344549115!13700089!20
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] staging: comedi: adl_pci6208: use the 'board_name' for the resource name
Date: Thu, 9 Aug 2012 14:51:51 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208091451.52240.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the 'dev->board_name' instead of the 'dev->driver->driver_name'
as the resource name used when requesing the pci regions in
comedi_pci_enable(). The board_name has a closer affinity to the
card.

Also, remove the dev_err() message when comedi_pci_enable() fails.
It's just noise and doesn't actually tell the real reason why the
call failed. It could have failed either the pci_enable_device()
or the pci_request_regions().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 74695bb..3abff556 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -196,12 +196,9 @@ static int pci6208_attach_pci(struct comedi_device *dev,
 		return ret;
 	devpriv = dev->private;
 
-	ret = comedi_pci_enable(pcidev, dev->driver->driver_name);
-	if (ret) {
-		dev_err(dev->class_dev,
-			"Failed to enable PCI device and request regions\n");
+	ret = comedi_pci_enable(pcidev, dev->board_name);
+	if (ret)
 		return ret;
-	}
 	dev->iobase = pci_resource_start(pcidev, 2);
 
 	ret = comedi_alloc_subdevices(dev, 3);
-- 
1.7.11

