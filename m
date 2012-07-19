Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab2GSCFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 22:05:45 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:35444 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab2GSCFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 22:05:39 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-131.messagelabs.com!1342663538!22564707!1
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 89/90] staging: comedi: aio_iiro_16: remove the private data
Date: Wed, 18 Jul 2012 19:05:32 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181905.32612.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The private data is not used by this driver. Remove the struct,
devpriv macro, and the allocation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/aio_iiro_16.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/aio_iiro_16.c b/drivers/staging/comedi/drivers/aio_iiro_16.c
index 16f28f6..ba1e3bb 100644
--- a/drivers/staging/comedi/drivers/aio_iiro_16.c
+++ b/drivers/staging/comedi/drivers/aio_iiro_16.c
@@ -57,14 +57,6 @@ static const struct aio_iiro_16_board aio_iiro_16_boards[] = {
 	 .do_ = 16},
 };
 
-struct aio_iiro_16_private {
-	int data;
-	struct pci_dev *pci_dev;
-	unsigned int ao_readback[2];
-};
-
-#define	devpriv	((struct aio_iiro_16_private *) dev->private)
-
 static int aio_iiro_16_dio_insn_bits_write(struct comedi_device *dev,
 					   struct comedi_subdevice *s,
 					   struct comedi_insn *insn,
@@ -116,9 +108,6 @@ static int aio_iiro_16_attach(struct comedi_device *dev,
 
 	dev->iobase = iobase;
 
-	if (alloc_private(dev, sizeof(struct aio_iiro_16_private)) < 0)
-		return -ENOMEM;
-
 	ret = comedi_alloc_subdevices(dev, 2);
 	if (ret)
 		return ret;
-- 
1.7.11

