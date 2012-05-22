Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588Ab2EVAzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 20:55:48 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:54214 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2EVAzr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 20:55:47 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-132.messagelabs.com!1337648145!12307814!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: icp_multi: io_addr is a void __iomem *
Date: Mon, 21 May 2012 17:55:33 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201205211755.34024.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The io_addr variable in struct dt3k_private is an ioremap'ed pci
resource and should be void __iomem * not a void *.

This quiets a lot of sparse warings for the writew and readw calls
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

diff --git a/drivers/staging/comedi/drivers/icp_multi.c b/drivers/staging/comedi/drivers/icp_multi.c
index fdc596f..f870d3d 100644
--- a/drivers/staging/comedi/drivers/icp_multi.c
+++ b/drivers/staging/comedi/drivers/icp_multi.c
@@ -148,7 +148,7 @@ struct boardtype {
 struct icp_multi_private {
 	struct pcilst_struct *card;	/*  pointer to card */
 	char valid;		/*  card is usable */
-	void *io_addr;		/*  Pointer to mapped io address */
+	void __iomem *io_addr;		/*  Pointer to mapped io address */
 	resource_size_t phys_iobase;	/*  Physical io address */
 	unsigned int AdcCmdStatus;	/*  ADC Command/Status register */
 	unsigned int DacCmdStatus;	/*  DAC Command/Status register */
