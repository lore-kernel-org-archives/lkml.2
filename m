Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0K3Ie3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 03:34:29 -0500
Received: from twtpemsw2.wistron.com.tw ([220.128.88.32]:3460 "EHLO
	twtpemsw2.wistron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab0K3Ie2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 03:34:28 -0500
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Nov 2010 03:34:28 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] intel_mid_dma: Fix section mismatch warnings
Date: Tue, 30 Nov 2010 16:24:15 +0800
Message-ID: <C0A2BC8065D6AE4BA759B25FE7A3795E036E7186@WHQBEMAIL1.whq.wistron>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] intel_mid_dma: Fix section mismatch warnings
Thread-Index: AcuQZ/nYyrmoTPQoTOCOTL7hIxDOPw==
From: <Major_Lee@wistron.com>
To: <linux-kernel@vger.kernel.org>
Cc: <dan.j.williams@intel.com>, <vinod.koul@intel.com>
X-OriginalArrivalTime: 30 Nov 2010 08:24:22.0801 (UTC) FILETIME=[FE05B810:01CB9067]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following section mismatch warnings.

WARNING: drivers/built-in.o(.data+0xfa10): Section mismatch in reference
from the variable intel_mid_dma_pci to the function
.devinit.text:intel_mid_dma_probe()
The variable intel_mid_dma_pci references the function __devinit
intel_mid_dma_probe() If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the
variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
*_console, 

WARNING: drivers/built-in.o(.data+0xfa14): Section mismatch in reference
from the variable intel_mid_dma_pci to the function
.devexit.text:intel_mid_dma_remove()
The variable intel_mid_dma_pci references the function __devexit
intel_mid_dma_remove() If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
*_console, 

WARNING: vmlinux.o(.data+0x18490): Section mismatch in reference from
the variable intel_mid_dma_pci to the function
.devinit.text:intel_mid_dma_probe()
The variable intel_mid_dma_pci references the function __devinit
intel_mid_dma_probe() If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the
variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
*_console, 

WARNING: vmlinux.o(.data+0x18494): Section mismatch in reference from
the variable intel_mid_dma_pci to the function
.devexit.text:intel_mid_dma_remove()
The variable intel_mid_dma_pci references the function __devexit
intel_mid_dma_remove() If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
*_console, 

Signed-off-by: Major Lee <major_lee@wistron.com>
---
 intel_mid_dma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -uprN a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
--- a/drivers/dma/intel_mid_dma.c	2010-11-26 18:10:06.000000000
+0800
+++ b/drivers/dma/intel_mid_dma.c	2010-11-30 13:13:00.238892000
+0800
@@ -1222,7 +1222,7 @@ static void middma_shutdown(struct pci_d
  * Initilize the PCI device, map BARs, query driver data.
  * Call setup_dma to complete contoller and chan initilzation
  */
-static int __devinit intel_mid_dma_probe(struct pci_dev *pdev,
+static int intel_mid_dma_probe(struct pci_dev *pdev,
 					const struct pci_device_id *id)
 {
 	struct middma_device *device;
@@ -1306,7 +1306,7 @@ err_enable_device:
  * Free up all resources and data
  * Call shutdown_dma to complete contoller and chan cleanup
  */
-static void __devexit intel_mid_dma_remove(struct pci_dev *pdev)
+static void intel_mid_dma_remove(struct pci_dev *pdev)
 {
 	struct middma_device *device = pci_get_drvdata(pdev);
 	middma_shutdown(pdev);
