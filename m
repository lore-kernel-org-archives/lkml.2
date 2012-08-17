Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030559Ab2HQCwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:52:14 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:33554 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030363Ab2HQCwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:52:13 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1345171926!8569241!5
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 26/35] staging: comedi: cb_pcimdda: remove regs_badrindex and reg_sz from boardinfo
Date: Thu, 16 Aug 2012 19:51:58 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161951.59131.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The base address of the card is always found in pci resource 3. There is
no need to carry this information in the boardinfo. The reg_sz is not
used in the driver. Remove them.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index ecad85b..0e34603 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -107,9 +107,6 @@ struct cb_pcimdda_board {
 	unsigned short device_id;
 	int ao_chans;
 	int ao_bits;
-	int regs_badrindex;	/* IO Region for the control, analog output,
-				   and DIO registers */
-	int reg_sz;		/* number of bytes of registers in io region */
 };
 
 static const struct cb_pcimdda_board cb_pcimdda_boards[] = {
@@ -118,8 +115,6 @@ static const struct cb_pcimdda_board cb_pcimdda_boards[] = {
 	 .device_id = PCI_ID_PCIM_DDA06_16,
 	 .ao_chans = 6,
 	 .ao_bits = 16,
-	 .regs_badrindex = 3,
-	 .reg_sz = 16,
 	 }
 };
 
@@ -252,7 +247,7 @@ static int cb_pcimdda_attach(struct comedi_device *dev,
 	ret = comedi_pci_enable(pcidev, dev->board_name);
 	if (ret)
 		return ret;
-	dev->iobase = pci_resource_start(pcidev, thisboard->regs_badrindex);
+	dev->iobase = pci_resource_start(pcidev, 3);
 
 	ret = comedi_alloc_subdevices(dev, 2);
 	if (ret)
-- 
1.7.11

