Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab1EMShz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:37:55 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:29847 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab1EMShy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:37:54 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-160.messagelabs.com!1305311867!13663289!15
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.32]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/gpio/Kconfig: remove redundant depends on GPIOLIB
Date: Fri, 13 May 2011 11:37:28 -0700
User-Agent: KMail/1.9.9
CC: <grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201105131137.28730.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since all the drivers are in a 'if GPIOLIB/endif block', the depends on GPIOLIB
is redundant so remove them.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Grant Likely <grant.likely@secretlab.ca>

---

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index b7fac15..fe12959 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -77,7 +77,6 @@ config GPIO_BASIC_MMIO
 
 config GPIO_IT8761E
 	tristate "IT8761E GPIO support"
-	depends on GPIOLIB
 	help
 	  Say yes here to support GPIO functionality of IT8761E super I/O chip.
 
@@ -101,7 +100,7 @@ config GPIO_VR41XX
 
 config GPIO_SCH
 	tristate "Intel SCH/TunnelCreek GPIO"
-	depends on GPIOLIB && PCI && X86
+	depends on PCI && X86
 	select MFD_CORE
 	select LPC_SCH
 	help
@@ -121,7 +120,7 @@ config GPIO_SCH
 
 config GPIO_U300
 	bool "ST-Ericsson U300 COH 901 335/571 GPIO"
-	depends on GPIOLIB && ARCH_U300
+	depends on ARCH_U300
 	help
 	  Say yes here to support GPIO interface on ST-Ericsson U300.
 	  The names of the two IP block variants supported are
@@ -130,7 +129,7 @@ config GPIO_U300
 
 config GPIO_NOMADIK
 	bool "ST-Ericsson Nomadik GPIO"
-	depends on GPIOLIB && (ARCH_U8500 || ARCH_NOMADIK)
+	depends on ARCH_U8500 || ARCH_NOMADIK
 	help
 	  Say yes here to support GPIO interface for ST-Ericsson Nomadik.
 	  This is found in the Nomadik NHK8815, DB8500, DB5500 SoCs
@@ -138,7 +137,7 @@ config GPIO_NOMADIK
 
 config GPIO_VX855
 	tristate "VIA VX855/VX875 GPIO"
-	depends on GPIOLIB && MFD_SUPPORT && PCI
+	depends on MFD_SUPPORT && PCI
 	select MFD_CORE
 	select MFD_VX855
 	help
@@ -364,13 +363,13 @@ config GPIO_ML_IOH
 
 config GPIO_TIMBERDALE
 	bool "Support for timberdale GPIO IP"
-	depends on MFD_TIMBERDALE && GPIOLIB && HAS_IOMEM
+	depends on MFD_TIMBERDALE && HAS_IOMEM
 	---help---
 	Add support for the GPIO IP in the timberdale FPGA.
 
 config GPIO_RDC321X
 	tristate "RDC R-321x GPIO support"
-	depends on PCI && GPIOLIB
+	depends on PCI
 	select MFD_SUPPORT
 	select MFD_CORE
 	select MFD_RDC321X
