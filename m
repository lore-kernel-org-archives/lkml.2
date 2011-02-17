Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab1BQIVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 03:21:55 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41606 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630Ab1BQIVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 03:21:53 -0500
X-Sasl-enc: eu2P+ubGtCpIEIDnoaqa4zar7pfvabZ3YveWiojkryyh 1297930911
Message-ID: <4D5CDAD0.7030006@ladisch.de>
Date: Thu, 17 Feb 2011 09:22:40 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: (k10temp) add support for AMD Family 12h/14h CPUs
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the PCI ID to support the internal temperature sensor of the
AMD "Llano" and "Brazos" processor families.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 Documentation/hwmon/k10temp |    8 +++++++-
 drivers/hwmon/Kconfig       |    6 +++---
 drivers/hwmon/k10temp.c     |    5 +++--
 3 files changed, 13 insertions(+), 6 deletions(-)

--- a/Documentation/hwmon/k10temp
+++ b/Documentation/hwmon/k10temp
@@ -9,6 +9,8 @@ Supported chips:
   Socket S1G3: Athlon II, Sempron, Turion II
 * AMD Family 11h processors:
   Socket S1G2: Athlon (X2), Sempron (X2), Turion X2 (Ultra)
+* AMD Family 12h processors: "Llano"
+* AMD Family 14h processors: "Brazos" (C/E/G-Series)
 
   Prefix: 'k10temp'
   Addresses scanned: PCI space
@@ -17,10 +19,14 @@ Supported chips:
     http://support.amd.com/us/Processor_TechDocs/31116.pdf
   BIOS and Kernel Developer's Guide (BKDG) for AMD Family 11h Processors:
     http://support.amd.com/us/Processor_TechDocs/41256.pdf
+  BIOS and Kernel Developer's Guide (BKDG) for AMD Family 14h Models 00h-0Fh Processors:
+    http://support.amd.com/us/Processor_TechDocs/43170.pdf
   Revision Guide for AMD Family 10h Processors:
     http://support.amd.com/us/Processor_TechDocs/41322.pdf
   Revision Guide for AMD Family 11h Processors:
     http://support.amd.com/us/Processor_TechDocs/41788.pdf
+  Revision Guide for AMD Family 14h Models 00h-0Fh Processors:
+    http://support.amd.com/us/Processor_TechDocs/47534.pdf
   AMD Family 11h Processor Power and Thermal Data Sheet for Notebooks:
     http://support.amd.com/us/Processor_TechDocs/43373.pdf
   AMD Family 10h Server and Workstation Processor Power and Thermal Data Sheet:
@@ -34,7 +40,7 @@ Description
 -----------
 
 This driver permits reading of the internal temperature sensor of AMD
-Family 10h and 11h processors.
+Family 10h/11h/12h/14h processors.
 
 All these processors have a sensor, but on those for Socket F or AM2+,
 the sensor may return inconsistent values (erratum 319).  The driver
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -238,13 +238,13 @@ config SENSORS_K8TEMP
 	  will be called k8temp.
 
 config SENSORS_K10TEMP
-	tristate "AMD Phenom/Sempron/Turion/Opteron temperature sensor"
+	tristate "AMD Family 10h/11h/12h/14h temperature sensor"
 	depends on X86 && PCI
 	help
 	  If you say yes here you get support for the temperature
 	  sensor(s) inside your CPU. Supported are later revisions of
-	  the AMD Family 10h and all revisions of the AMD Family 11h
-	  microarchitectures.
+	  the AMD Family 10h and all revisions of the AMD Family 11h,
+	  12h (Llano), and 14h (Brazos) microarchitectures.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called k10temp.
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -1,5 +1,5 @@
 /*
- * k10temp.c - AMD Family 10h/11h processor hardware monitoring
+ * k10temp.c - AMD Family 10h/11h/12h/14h processor hardware monitoring
  *
  * Copyright (c) 2009 Clemens Ladisch <clemens@ladisch.de>
  *
@@ -25,7 +25,7 @@
 #include <linux/pci.h>
 #include <asm/processor.h>
 
-MODULE_DESCRIPTION("AMD Family 10h/11h CPU core temperature monitor");
+MODULE_DESCRIPTION("AMD Family 10h/11h/12h/14h CPU core temperature monitor");
 MODULE_AUTHOR("Clemens Ladisch <clemens@ladisch.de>");
 MODULE_LICENSE("GPL");
 
@@ -208,6 +208,7 @@ static void __devexit k10temp_remove(str
 static const struct pci_device_id k10temp_id_table[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_11H_NB_MISC) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_CNB17H_F3) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, k10temp_id_table);
