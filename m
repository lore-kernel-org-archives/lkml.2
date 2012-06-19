Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab2FSXUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 19:20:11 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:61834 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab2FSXUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 19:20:09 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-127.messagelabs.com!1340148008!6257261!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/5] staging: comedi: Kconfig: fix drivers that require the 8255 driver
Date: Tue, 19 Jun 2012 16:20:05 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206191620.05910.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the comedi drivers require the 8255 driver for
various subdevice support. The Makefile currently uses
CONFIG_COMEDI_PCI_DRIVERS to make sure the 8255 driver
is compiled. The Kconfig help for that option says that
it does not directly affect the kernel.

Fix this by adding 'select COMEDI_8255' to the drivers
that actually need the support.

Also, remove two cases where the drivers don't require
the 8255 support.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/Kconfig          | 3 +--
 drivers/staging/comedi/drivers/Makefile | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index 2ca7f08..03ee2d0 100644
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
+	select COMEDI_8255
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

