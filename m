Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab2EVWvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:51:21 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:16614 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2EVWvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:51:20 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-132.messagelabs.com!1337727077!12408316!3
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove thisboard macro in the aio_iiro_16 driver
Date: Tue, 22 May 2012 15:51:14 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221551.14999.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'thisboard' macro depends on having a local variable with
a magic name. The CodingStyle document suggests not doing this
to avoid confusion. Remove the macro and use the comedi_board()
inline helper to get the dev->board_ptr information.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/aio_iiro_16.c b/drivers/staging/comedi/drivers/aio_iiro_16.c
index 04f6f94..5c1548b 100644
--- a/drivers/staging/comedi/drivers/aio_iiro_16.c
+++ b/drivers/staging/comedi/drivers/aio_iiro_16.c
@@ -57,8 +57,6 @@ static const struct aio_iiro_16_board aio_iiro_16_boards[] = {
 	 .do_ = 16},
 };
 
-#define	thisboard	((const struct aio_iiro_16_board *) dev->board_ptr)
-
 struct aio_iiro_16_private {
 	int data;
 	struct pci_dev *pci_dev;
@@ -106,12 +104,13 @@ static int aio_iiro_16_dio_insn_bits_read(struct comedi_device *dev,
 static int aio_iiro_16_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
 {
+	const struct aio_iiro_16_board *board = comedi_board(dev);
 	int iobase;
 	struct comedi_subdevice *s;
 
 	printk(KERN_INFO "comedi%d: aio_iiro_16: ", dev->minor);
 
-	dev->board_name = thisboard->name;
+	dev->board_name = board->name;
 
 	iobase = it->options[0];
 
