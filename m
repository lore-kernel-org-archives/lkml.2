Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385Ab2GKWWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:22:12 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:56367 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933363Ab2GKWWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:22:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-127.messagelabs.com!1342045329!8347730!6
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/30] staging: comedi: adl_pci7296: remove private data
Date: Wed, 11 Jul 2012 15:22:02 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111522.02383.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The private data is no longer needed by this driver. Remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci7296.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci7296.c b/drivers/staging/comedi/drivers/adl_pci7296.c
index ef6c773..1eed29a 100644
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
@@ -88,9 +82,6 @@ static int adl_pci7296_attach(struct comedi_device *dev,
 
 	dev->board_name = "pci7432";
 
-	if (alloc_private(dev, sizeof(struct adl_pci7296_private)) < 0)
-		return -ENOMEM;
-
 	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret)
 		return ret;
-- 
1.7.11

