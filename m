Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab2GSBpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:45:40 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:3109 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab2GSBpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:45:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-132.messagelabs.com!1342662336!14782437!3
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 46/90] staging: comedi: cb_pcidio: remove the private data
Date: Wed, 18 Jul 2012 18:45:26 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181845.26715.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The private data is no longer needed by this driver. Remove the
struct, devpriv macro, and the allocation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidio.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index f30f6da..e370d0d 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -90,23 +90,6 @@ static const struct pcidio_board pcidio_boards[] = {
  */
 #define thisboard ((const struct pcidio_board *)dev->board_ptr)
 
-/* this structure is for data unique to this hardware driver.  If
-   several hardware drivers keep similar information in this structure,
-   feel free to suggest moving the variable to the struct comedi_device struct.  */
-struct pcidio_private {
-	int data;		/*  currently unused */
-
-	/* used for DO readback, currently unused */
-	unsigned int do_readback[4];	/* up to 4 unsigned int suffice to hold 96 bits for PCI-DIO96 */
-
-};
-
-/*
- * most drivers define the following macro to make it easy to
- * access the private structure.
- */
-#define devpriv ((struct pcidio_private *)dev->private)
-
 static struct pci_dev *pcidio_find_pci_dev(struct comedi_device *dev,
 					   struct comedi_devconfig *it)
 {
@@ -143,13 +126,6 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int i;
 	int ret;
 
-/*
- * Allocate the private structure area.  alloc_private() is a
- * convenient macro defined in comedidev.h.
- */
-	if (alloc_private(dev, sizeof(struct pcidio_private)) < 0)
-		return -ENOMEM;
-
 	pcidev = pcidio_find_pci_dev(dev, it);
 	if (!pcidev)
 		return -EIO;
-- 
1.7.11

