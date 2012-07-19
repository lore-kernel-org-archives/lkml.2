Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab2GSB0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:26:36 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:11484 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2GSB0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:26:35 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-131.messagelabs.com!1342661193!7942567!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/90] staging: comedi: adl_pci7296: remove the private data
Date: Wed, 18 Jul 2012 18:26:23 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181826.23893.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The private data is no longer needed by this driver. Remove the
struct, devpriv macro, and the allocation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci7296.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci7296.c b/drivers/staging/comedi/drivers/adl_pci7296.c
index b003ed0..19b47af 100644
--- a/drivers/staging/comedi/drivers/adl_pci7296.c
+++ b/drivers/staging/comedi/drivers/adl_pci7296.c
@@ -47,12 +47,6 @@ Configuration Options:
 
 #define PCI_DEVICE_ID_PCI7296 0x7296
 
-struct adl_pci7296_private {
-	int data;
-};
-
-#define devpriv ((struct adl_pci7296_private *)dev->private)
-
 static struct pci_dev *adl_pci7296_find_pci(struct comedi_device *dev,
 					    struct comedi_devconfig *it)
 {
@@ -89,9 +83,6 @@ static int adl_pci7296_attach(struct comedi_device *dev,
 
 	dev->board_name = "pci7432";
 
-	if (alloc_private(dev, sizeof(struct adl_pci7296_private)) < 0)
-		return -ENOMEM;
-
 	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret)
 		return ret;
-- 
1.7.11

