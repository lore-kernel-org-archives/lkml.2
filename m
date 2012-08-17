Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598Ab2HQCoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:44:12 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:44371 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab2HQCoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:44:07 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-132.messagelabs.com!1345171445!13459021!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/35] staging: comedi: cb_pcidio: remove thisboard macro
Date: Thu, 16 Aug 2012 19:43:55 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161943.55795.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro relies on a local variable having a specific name.
Remove it and use the comedi_board() helper to get the pointer.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidio.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index e370d0d..c377beb 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -85,11 +85,6 @@ static const struct pcidio_board pcidio_boards[] = {
 	 },
 };
 
-/*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct pcidio_board *)dev->board_ptr)
-
 static struct pci_dev *pcidio_find_pci_dev(struct comedi_device *dev,
 					   struct comedi_devconfig *it)
 {
@@ -122,6 +117,7 @@ static struct pci_dev *pcidio_find_pci_dev(struct comedi_device *dev,
 
 static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct pcidio_board *thisboard;
 	struct pci_dev *pcidev;
 	int i;
 	int ret;
@@ -130,11 +126,7 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (!pcidev)
 		return -EIO;
 	comedi_set_hw_dev(dev, &pcidev->dev);
-
-/*
- * Initialize dev->board_name.  Note that we can use the "thisboard"
- * macro now, since we just initialized it in the last line.
- */
+	thisboard = comedi_board(dev);
 	dev->board_name = thisboard->name;
 
 	if (comedi_pci_enable(pcidev, thisboard->name))
@@ -158,6 +150,7 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void pcidio_detach(struct comedi_device *dev)
 {
+	const struct pcidio_board *thisboard = comedi_board(dev);
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 
 	if (pcidev) {
-- 
1.7.11

