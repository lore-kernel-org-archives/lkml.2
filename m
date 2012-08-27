Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2H0WOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 18:14:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669Ab2H0WOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 18:14:49 -0400
Message-ID: <503BF17D.4080806@suse.com>
Date: Mon, 27 Aug 2012 18:15:25 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Richard Zhao <richard.zhao@freescale.com>
Subject: [PATCH] chipidea: Allow user to select PCI/IMX options
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The chipidea driver currently has needless ifneq rules in the makefile
for things that should be config options. This can be problematic,
especially in the IMX case, since the OF_DEVICE dependency will be met
on powerpc systems - which don't actually support the hardware via that
method.

This patch adds _PCI and _IMX config options to allow the user to
select whether to build the modules.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/usb/chipidea/Kconfig  |   11 +++++++++++
 drivers/usb/chipidea/Makefile |   11 ++---------
 2 files changed, 13 insertions(+), 9 deletions(-)

--- a/drivers/usb/chipidea/Kconfig
+++ b/drivers/usb/chipidea/Kconfig
@@ -31,4 +31,15 @@ config USB_CHIPIDEA_DEBUG
 	help
 	  Say Y here to enable debugging output of the ChipIdea driver.
 
+config USB_CHIPIDEA_PCI
+	bool "ChipIdea PCI support"
+	depends on PCI
+	help
+	  This option enables ChipIdea support on PCI.
+
+config USB_CHIPIDEA_IMX
+	bool "ChipIdea IMX support"
+	depends on OF_DEVICE
+	help
+	  This option enables ChipIdea support on IMX.
 endif
--- a/drivers/usb/chipidea/Makefile
+++ b/drivers/usb/chipidea/Makefile
@@ -8,12 +8,5 @@ ci_hdrc-$(CONFIG_USB_CHIPIDEA_DEBUG)	+=
 # Glue/Bridge layers go here
 
 obj-$(CONFIG_USB_CHIPIDEA)	+= ci13xxx_msm.o
-
-# PCI doesn't provide stubs, need to check
-ifneq ($(CONFIG_PCI),)
-	obj-$(CONFIG_USB_CHIPIDEA)	+= ci13xxx_pci.o
-endif
-
-ifneq ($(CONFIG_OF_DEVICE),)
-	obj-$(CONFIG_USB_CHIPIDEA)	+= ci13xxx_imx.o
-endif
+obj-$(CONFIG_USB_CHIPIDEA_PCI)	+= ci13xxx_pci.o
+obj-$(CONFIG_USB_CHIPIDEA_IMX)	+= ci13xxx_imx.o

-- 
Jeff Mahoney
SUSE Labs
