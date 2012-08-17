Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385Ab2HQCvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:51:36 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:21819 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933376Ab2HQCve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:51:34 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-127.messagelabs.com!1345171893!3211600!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 25/35] staging: comedi: cb_pcimdda: remove dio_offset from the boardinfo
Date: Thu, 16 Aug 2012 19:51:27 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161951.28158.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 8255 device is located at a fixed offset from the base
address of the card. There is not need to carry this offset
in the boardinfo. Remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 765f92c..ecad85b 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -107,8 +107,6 @@ struct cb_pcimdda_board {
 	unsigned short device_id;
 	int ao_chans;
 	int ao_bits;
-	/* how many bytes into the BADR are the DIO ports */
-	int dio_offset;
 	int regs_badrindex;	/* IO Region for the control, analog output,
 				   and DIO registers */
 	int reg_sz;		/* number of bytes of registers in io region */
@@ -120,7 +118,6 @@ static const struct cb_pcimdda_board cb_pcimdda_boards[] = {
 	 .device_id = PCI_ID_PCIM_DDA06_16,
 	 .ao_chans = 6,
 	 .ao_bits = 16,
-	 .dio_offset = 12,
 	 .regs_badrindex = 3,
 	 .reg_sz = 16,
 	 }
@@ -279,7 +276,7 @@ static int cb_pcimdda_attach(struct comedi_device *dev,
 	s = dev->subdevices + 1;
 	/* digital i/o subdevice */
 	ret = subdev_8255_init(dev, s, NULL,
-			dev->iobase + thisboard->dio_offset);
+			dev->iobase + PCIMDDA_8255_BASE_REG);
 	if (ret)
 		return ret;
 	devpriv->attached_to_8255 = 1;
-- 
1.7.11

