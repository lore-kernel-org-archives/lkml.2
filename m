Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab1CQTdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:33:05 -0400
Received: from www.tglx.de ([62.245.132.106]:44811 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab1CQTdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:33:03 -0400
Message-Id: <20110317192449.447932136@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 17 Mar 2011 19:32:46 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Feng Tang <feng.tang@intel.com>,
        Alek Du <alek.du@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [patch 1/5] gpio; Make Intel chipset gpio drivers depend on x86
References: <20110317192247.722047296@linutronix.de>
Content-Disposition: inline; filename=gpio-langwell-kconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of x86 can use that code.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/gpio/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-tip/drivers/gpio/Kconfig
===================================================================
--- linux-2.6-tip.orig/drivers/gpio/Kconfig
+++ linux-2.6-tip/drivers/gpio/Kconfig
@@ -101,7 +101,7 @@ config GPIO_VR41XX
 
 config GPIO_SCH
 	tristate "Intel SCH GPIO"
-	depends on GPIOLIB && PCI
+	depends on GPIOLIB && PCI && X86
 	select MFD_CORE
 	select LPC_SCH
 	help
@@ -321,13 +321,13 @@ config GPIO_BT8XX
 
 config GPIO_LANGWELL
 	bool "Intel Langwell/Penwell GPIO support"
-	depends on PCI
+	depends on PCI && X86
 	help
 	  Say Y here to support Intel Langwell/Penwell GPIO.
 
 config GPIO_PCH
 	tristate "PCH GPIO of Intel Topcliff"
-	depends on PCI
+	depends on PCI && X86
 	help
 	  This driver is for PCH(Platform controller Hub) GPIO of Intel Topcliff
 	  which is an IOH(Input/Output Hub) for x86 embedded processor.


