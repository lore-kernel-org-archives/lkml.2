Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2GTRcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:32:22 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:21333 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab2GTRcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:32:19 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-131.messagelabs.com!1342805537!21873208!3
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] staging: comedi: daqboard2000: add back subsystem_device check
Date: Fri, 20 Jul 2012 10:32:10 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207201032.10303.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned by Ian Abbott, this driver originally checked
the pci_dev subsystem_device in order to make sure that the
pci_dev was compatible with this driver. The cleanup of the
"find pci device" code removed this check. Add it back.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reported-by: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/daqboard2000.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index ef28385..7236cbe 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -718,7 +718,8 @@ static struct pci_dev *daqboard2000_find_pci_dev(struct comedi_device *dev,
 				continue;
 		}
 		if (pcidev->vendor != PCI_VENDOR_ID_IOTECH ||
-		    pcidev->device != 0x0409)
+		    pcidev->device != 0x0409 ||
+		    pcidev->subsystem_device != PCI_VENDOR_ID_IOTECH)
 			continue;
 
 		for (i = 0; i < ARRAY_SIZE(boardtypes); i++) {
-- 
1.7.11

