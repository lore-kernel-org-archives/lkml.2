Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab2EWA7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 20:59:22 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:5783 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab2EWA7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 20:59:19 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-127.messagelabs.com!1337734758!6299641!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove this_board macro in the rti800 driver
Date: Tue, 22 May 2012 17:59:07 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221759.08150.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'this_board' macro depends on having a local variable with
a magic name. The CodingStyle document suggests not doing this
to avoid confusion. Remove the macro and use the comedi_board()
inline helper to get the dev->board_ptr information.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/rti800.c b/drivers/staging/comedi/drivers/rti800.c
index f0eb52a..04a2368 100644
--- a/drivers/staging/comedi/drivers/rti800.c
+++ b/drivers/staging/comedi/drivers/rti800.c
@@ -138,8 +138,6 @@ struct rti800_board {
 	int has_ao;
 };
 
-#define this_board ((const struct rti800_board *)dev->board_ptr)
-
 static irqreturn_t rti800_interrupt(int irq, void *dev);
 
 struct rti800_private {
@@ -309,6 +307,7 @@ static int rti800_do_insn_bits(struct comedi_device *dev,
 
 static int rti800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct rti800_board *board = comedi_board(dev);
 	unsigned int irq;
 	unsigned long iobase;
 	int ret;
@@ -347,7 +346,7 @@ static int rti800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		printk(KERN_INFO "( no irq )\n");
 	}
 
-	dev->board_name = this_board->name;
+	dev->board_name = board->name;
 
 	ret = alloc_subdevices(dev, 4);
 	if (ret < 0)
@@ -386,7 +385,7 @@ static int rti800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	s++;
-	if (this_board->has_ao) {
+	if (board->has_ao) {
 		/* ao subdevice (only on rti815) */
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_WRITABLE;
