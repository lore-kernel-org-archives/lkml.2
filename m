Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab2FSBBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 21:01:21 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:58781 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab2FSBBT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 21:01:19 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-160.messagelabs.com!1340067677!4446251!3
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 18 Jun 2012 20:01:17 -0500
Subject: RE: [PATCH 1/4] staging: comedi: Kconfig: menuconfig options should
 be bool not tristate
Thread-Topic: [PATCH 1/4] staging: comedi: Kconfig: menuconfig options
 should be bool not tristate
Thread-Index: Ac1Nss8t9yBHiAmMRUK1+u3i9VSa5AAAwFSQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698DBD3D9@AUSP01VMBX24.collaborationhost.net>
References: <201206151520.04455.hartleys@visionengravers.com>
 <20120618235902.GA29679@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698DBD3D0@AUSP01VMBX24.collaborationhost.net>
 <20120619003047.GA25098@kroah.com>
In-Reply-To: <20120619003047.GA25098@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 18, 2012 5:31 PM, Greg KH wrote:
> Below is the .config I use.  Apply your patch, and select 'y' for the
> different options it asks for when running 'make oldconfig' and then see
> the build errors.

Ok. It looks like the patch below should fix it. Can you test it?

Regards,
Hartley


>From 41080f5af022a13e96bad3a5818e8cd816a7a925 Mon Sep 17 00:00:00 2001
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Date: Mon, 18 Jun 2012 17:45:51 -0700
Subject: [PATCH] staging: comedi: Kconfig: fix drivers that require the 8255 driver

Many of the comedi drivers require the 8255 driver for various
subdevices. The Makefile currently uses CONFIG_COMEDI_PCI_DRIVERS
to make sure the 8255 driver is compiled. The Kconfig help for
that option says that this option does not directly affect the
kernel.

Fix this by adding the proper 'select COMEDI_8255' where needed.

Also, remove two cases where the drivers don't actually need the
8255 support.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/Kconfig          | 3 +--
 drivers/staging/comedi/drivers/Makefile | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index 2ca7f08..198a55d 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -672,7 +672,6 @@ config COMEDI_ADDI_APCI_3XXX
 
 config COMEDI_ADL_PCI6208
 	tristate "ADLink PCI-6208A support"
-	select COMEDI_8255
 	---help---
 	  Enable support for ADLink PCI-6208A cards
 
@@ -689,6 +688,7 @@ config COMEDI_ADL_PCI7230
 
 config COMEDI_ADL_PCI7296
 	tristate "ADLink PCI-7296 96 ch. digital io board support"
+	select COMED_8255
 	---help---
 	  Enable support for ADlink PCI-7296 96 ch. digital io board support
 
@@ -1061,7 +1061,6 @@ config COMEDI_NI_PCIMIO
 
 config COMEDI_RTD520
 	tristate "Real Time Devices PCI4520/DM7520 support"
-	select COMEDI_8255
 	---help---
 	  Enable support for Real Time Devices PCI4520/DM7520
 
diff --git a/drivers/staging/comedi/drivers/Makefile b/drivers/staging/comedi/drivers/Makefile
index 170da60..513469d 100644
--- a/drivers/staging/comedi/drivers/Makefile
+++ b/drivers/staging/comedi/drivers/Makefile
@@ -55,7 +55,6 @@ obj-$(CONFIG_COMEDI_MULTIQ3)		+= multiq3.o
 obj-$(CONFIG_COMEDI_POC)		+= poc.o
 
 # Comedi PCI drivers
-obj-$(CONFIG_COMEDI_PCI_DRIVERS)	+= 8255.o
 obj-$(CONFIG_COMEDI_ADDI_APCI_035)	+= addi_apci_035.o
 obj-$(CONFIG_COMEDI_ADDI_APCI_1032)	+= addi_apci_1032.o
 obj-$(CONFIG_COMEDI_ADDI_APCI_1500)	+= addi_apci_1500.o
-- 
1.7.11

