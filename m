Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab2F0WAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:00:19 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:13576 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249Ab2F0WAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:00:17 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-132.messagelabs.com!1340834397!12707810!35
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/19] staging: comedi: adl_pci6208: consolidate the attach messages
Date: Wed, 27 Jun 2012 15:00:02 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206271500.02857.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate the attach messages into one dev_info() output
at the end of a successful attach.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 8ec2660..13cdbcc 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -233,8 +233,6 @@ static int pci6208_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 	int ret;
 
-	printk(KERN_INFO "comedi%d: pci6208: ", dev->minor);
-
 	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
@@ -280,7 +278,8 @@ static int pci6208_attach(struct comedi_device *dev,
 	/* s->insn_bits = pci6208_dio_insn_bits; */
 	/* s->insn_config = pci6208_dio_insn_config; */
 
-	printk(KERN_INFO "attached\n");
+	dev_info(dev->class_dev, "%s: %s, I/O base=0x%04lx\n",
+		dev->driver->driver_name, dev->board_name, dev->iobase);
 
 	return 1;
 }
-- 
1.7.11

