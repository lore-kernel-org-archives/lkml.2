Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab2HRBT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:19:27 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:8728 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab2HRBTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:19:10 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1345252741!21923431!23
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/20] staging: comedi: adv_pci_dio: remove function trace messages
Date: Fri, 17 Aug 2012 18:18:59 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171819.00052.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the DPRINTK function trace messages and associated
PCI_DIO_EXTDEBUG define. These should not be in the final driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 2d4cb7f..69508c8 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -36,15 +36,6 @@ Configuration options:
 #include "8255.h"
 #include "8253.h"
 
-#undef PCI_DIO_EXTDEBUG		/* if defined, enable extensive debug logging */
-
-#undef DPRINTK
-#ifdef PCI_DIO_EXTDEBUG
-#define DPRINTK(fmt, args...) printk(fmt, ## args)
-#else
-#define DPRINTK(fmt, args...)
-#endif
-
 #define PCI_VENDOR_ID_ADVANTECH		0x13fe
 
 /* hardware types of the cards */
@@ -816,8 +807,6 @@ static int pci1760_reset(struct comedi_device *dev)
 */
 static int pci_dio_reset(struct comedi_device *dev)
 {
-	DPRINTK("adv_pci_dio EDBG: BGN: pci171x_reset(...)\n");
-
 	switch (this_board->cardtype) {
 	case TYPE_PCI1730:
 		outb(0, dev->iobase + PCI1730_DO);	/*  clear outputs */
@@ -917,8 +906,6 @@ static int pci_dio_reset(struct comedi_device *dev)
 		break;
 	}
 
-	DPRINTK("adv_pci_dio EDBG: END: pci171x_reset(...)\n");
-
 	return 0;
 }
 
-- 
1.7.11

