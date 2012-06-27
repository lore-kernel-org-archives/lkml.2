Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab2F0V5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 17:57:33 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:4780 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab2F0V5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 17:57:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1340834245!7975544!2
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/19] staging: comedi: adl_pci6208: cleanup pci6208_pci_setup()
Date: Wed, 27 Jun 2012 14:57:22 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206271457.22361.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "local configuration register" stuff is not required. The
io base/range are only queried for use in a kernel message
that it just added noise. Similar with the io range for the
actual io base used by the driver.

Remove both printk's and all the unnecessary code.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index b6a8439..a96fac4 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -229,7 +229,7 @@ static int
 pci6208_pci_setup(struct pci_dev *pci_dev, unsigned long *io_base_ptr,
 		  int dev_minor)
 {
-	unsigned long io_base, io_range, lcr_io_base, lcr_io_range;
+	unsigned long io_base;
 
 	/*  Enable PCI device and request regions */
 	if (comedi_pci_enable(pci_dev, "adl_pci6208") < 0) {
@@ -238,28 +238,11 @@ pci6208_pci_setup(struct pci_dev *pci_dev, unsigned long *io_base_ptr,
 			dev_minor);
 		return -EIO;
 	}
-	/* Read local configuration register
-	 * base address [PCI_BASE_ADDRESS #1].
-	 */
-	lcr_io_base = pci_resource_start(pci_dev, 1);
-	lcr_io_range = pci_resource_len(pci_dev, 1);
-
-	printk(KERN_INFO "comedi%d: local config registers at address"
-			" 0x%4lx [0x%4lx]\n",
-			dev_minor, lcr_io_base, lcr_io_range);
 
 	/*  Read PCI6208 register base address [PCI_BASE_ADDRESS #2]. */
 	io_base = pci_resource_start(pci_dev, 2);
-	io_range = pci_resource_end(pci_dev, 2) - io_base + 1;
-
-	printk("comedi%d: 6208 registers at address 0x%4lx [0x%4lx]\n",
-	       dev_minor, io_base, io_range);
 
 	*io_base_ptr = io_base;
-	/* devpriv->io_range = io_range; */
-	/* devpriv->is_valid=0; */
-	/* devpriv->lcr_io_base=lcr_io_base; */
-	/* devpriv->lcr_io_range=lcr_io_range; */
 
 	return 0;
 }
-- 
1.7.11

