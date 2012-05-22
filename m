Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab2EVBLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:11:21 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:23059 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab2EVBKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:10:40 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-132.messagelabs.com!1337649014!9448582!7
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: ii_pci20kc: iobase and ioaddr are void __iomem *
Date: Mon, 21 May 2012 18:10:07 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201205211810.07454.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iobase variables in struct pci20xxx_subdev_private and ioaddr
variable in struct pci20xxx_private should be void __iomem * not
void *.

This quiets a lot of sparse warings for the writeb and readb calls
like:

warning: incorrect type in argument 1 (different address spaces)
   expected void const volatile [noderef] <asn:2>*addr
   got void *<noident>

warning: incorrect type in argument 2 (different address spaces)
   expected void volatile [noderef] <asn:2>*addr
   got void *

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/ii_pci20kc.c b/drivers/staging/comedi/drivers/ii_pci20kc.c
index f0a579a..6f69476 100644
--- a/drivers/staging/comedi/drivers/ii_pci20kc.c
+++ b/drivers/staging/comedi/drivers/ii_pci20kc.c
@@ -135,15 +135,15 @@ options for PCI-20341M:
 #define PCI20341_SCANLIST		0x80	/* Channel/Gain Scan List */
 
 union pci20xxx_subdev_private {
-	void *iobase;
+	void __iomem *iobase;
 	struct {
-		void *iobase;
+		void __iomem *iobase;
 		const struct comedi_lrange *ao_range_list[2];
 					/* range of channels of ao module */
 		unsigned int last_data[2];
 	} pci20006;
 	struct {
-		void *iobase;
+		void __iomem *iobase;
 		int timebase;
 		int settling_time;
 		int ai_gain;
@@ -152,7 +152,7 @@ union pci20xxx_subdev_private {
 
 struct pci20xxx_private {
 
-	void *ioaddr;
+	void __iomem *ioaddr;
 	union pci20xxx_subdev_private subdev_private[PCI20000_MODULES];
 };
 
@@ -210,7 +210,7 @@ static int pci20xxx_attach(struct comedi_device *dev,
 	if (ret < 0)
 		return ret;
 
-	devpriv->ioaddr = (void *)(unsigned long)it->options[0];
+	devpriv->ioaddr = (void __iomem *)(unsigned long)it->options[0];
 	dev->board_name = "pci20kc";
 
 	/* Check PCI-20001 C-2A Carrier Board ID */
