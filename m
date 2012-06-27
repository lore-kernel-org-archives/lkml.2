Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab2F0WDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:03:17 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:61836 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab2F0WDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:03:15 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-131.messagelabs.com!1340834594!24524824!3
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/19] staging: comedi: adl_pci6208: remove the bogus pci devices
Date: Wed, 27 Jun 2012 15:02:53 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206271502.53945.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the commented out pci device entries in the MODULE_DEVICE_TABLE
as well as the associated boardinfo, which is also commented out. Add
some whitespace to the boardinfo to improve readability.

This driver should also support the pci-6216 card which has an
additional 8 analog outputs (16 total). But the device id needs
to be determined.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 39bdf32..fe97db2 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -73,21 +73,11 @@ struct pci6208_board {
 };
 
 static const struct pci6208_board pci6208_boards[] = {
-	/*{
-	   .name = "pci6208v",
-	   .dev_id = 0x6208,      // not sure
-	   .ao_chans = 8
-	   },
-	   {
-	   .name = "pci6216v",
-	   .dev_id = 0x6208,      // not sure
-	   .ao_chans = 16
-	   }, */
 	{
-	 .name = "pci6208a",
-	 .dev_id = 0x6208,
-	 .ao_chans = 8
-	 }
+		.name		= "pci6208a",
+		.dev_id		= 0x6208,
+		.ao_chans	= 8,
+	},
 };
 
 struct pci6208_private {
@@ -307,11 +297,7 @@ static void __devexit adl_pci6208_pci_remove(struct pci_dev *dev)
 	comedi_pci_auto_unconfig(dev);
 }
 
-/* This is used by modprobe to translate PCI IDs to drivers.  Should
- * only be used for PCI and ISA-PnP devices */
 static DEFINE_PCI_DEVICE_TABLE(adl_pci6208_pci_table) = {
-	/* { PCI_VENDOR_ID_ADLINK, 0x6208, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, */
-	/* { PCI_VENDOR_ID_ADLINK, 0x6208, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, */
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, 0x6208) },
 	{ 0 }
 };
-- 
1.7.11

