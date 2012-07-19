Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2GSB2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:28:25 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:54758 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab2GSB2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:28:22 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-209.messagelabs.com!1342661301!9067698!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/90] staging: comedi: adl_pci8164: remove the private data
Date: Wed, 18 Jul 2012 18:28:13 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181828.13341.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The private data is no longer needed by this driver. Remove the
struct, devpriv macro, and the allocation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci8164.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c b/drivers/staging/comedi/drivers/adl_pci8164.c
index 94230d6..247ef00 100644
--- a/drivers/staging/comedi/drivers/adl_pci8164.c
+++ b/drivers/staging/comedi/drivers/adl_pci8164.c
@@ -55,12 +55,6 @@ Configuration Options:
 
 #define PCI_DEVICE_ID_PCI8164 0x8164
 
-struct adl_pci8164_private {
-	int data;
-};
-
-#define devpriv ((struct adl_pci8164_private *)dev->private)
-
 /*
  all the read commands are the same except for the addition a constant
  * const to the data for inw()
@@ -259,9 +253,6 @@ static int adl_pci8164_attach(struct comedi_device *dev,
 
 	dev->board_name = "pci8164";
 
-	if (alloc_private(dev, sizeof(struct adl_pci8164_private)) < 0)
-		return -ENOMEM;
-
 	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret)
 		return ret;
-- 
1.7.11

