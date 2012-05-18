Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031210Ab2ERXXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:23:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53122 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946504Ab2ERXFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:05:06 -0400
Message-Id: <20120518211603.940245440@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Grant Likely <grant.likely@secretlab.ca>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [ 49/54] pch_gpio: Support new device LAPIS Semiconductor ML7831 IOH
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit 868fea0507308b6548bba7debe5f5c2d5ca47fca upstream.

ML7831 is companion chip for Intel Atom E6xx series.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/Kconfig    |   11 ++++++-----
 drivers/gpio/pch_gpio.c |    1 +
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -350,18 +350,19 @@ config GPIO_LANGWELL
 	  Say Y here to support Intel Langwell/Penwell GPIO.
 
 config GPIO_PCH
-	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR ML7223 IOH GPIO"
+	tristate "Intel EG20T PCH/LAPIS Semiconductor IOH(ML7223/ML7831) GPIO"
 	depends on PCI && X86
 	help
 	  This driver is for PCH(Platform controller Hub) GPIO of Intel Topcliff
 	  which is an IOH(Input/Output Hub) for x86 embedded processor.
 	  This driver can access PCH GPIO device.
 
-	  This driver also can be used for OKI SEMICONDUCTOR IOH(Input/
-	  Output Hub), ML7223.
+	  This driver also can be used for LAPIS Semiconductor IOH(Input/
+	  Output Hub), ML7223 and ML7831.
 	  ML7223 IOH is for MP(Media Phone) use.
-	  ML7223 is companion chip for Intel Atom E6xx series.
-	  ML7223 is completely compatible for Intel EG20T PCH.
+	  ML7831 IOH is for general purpose use.
+	  ML7223/ML7831 is companion chip for Intel Atom E6xx series.
+	  ML7223/ML7831 is completely compatible for Intel EG20T PCH.
 
 config GPIO_ML_IOH
 	tristate "OKI SEMICONDUCTOR ML7213 IOH GPIO support"
--- a/drivers/gpio/pch_gpio.c
+++ b/drivers/gpio/pch_gpio.c
@@ -287,6 +287,7 @@ static int pch_gpio_resume(struct pci_de
 static DEFINE_PCI_DEVICE_TABLE(pch_gpio_pcidev_id) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8014) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8803) },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, pch_gpio_pcidev_id);


