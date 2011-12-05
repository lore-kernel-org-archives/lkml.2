Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab1LEVqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:46:51 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:41174 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab1LEVqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:46:50 -0500
Date: Mon, 5 Dec 2011 22:46:39 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] mfd: Fix cs5535-mfd driver name
Message-ID: <20111205224639.13f1e95d@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix cs5535-mfd driver name to make CONFIG_DEBUG_SECTION_MISMATCH=y
happy:

WARNING: drivers/mfd/cs5535-mfd.o(.data+0x20): Section mismatch in reference from the variable cs5535_mfd_drv to the function .devinit.text:cs5535_mfd_probe()
The variable cs5535_mfd_drv references
the function __devinit cs5535_mfd_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/cs5535-mfd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-3.2-rc4.orig/drivers/mfd/cs5535-mfd.c	2011-07-22 04:17:23.000000000 +0200
+++ linux-3.2-rc4/drivers/mfd/cs5535-mfd.c	2011-12-05 18:51:49.000000000 +0100
@@ -179,7 +179,7 @@ static struct pci_device_id cs5535_mfd_p
 };
 MODULE_DEVICE_TABLE(pci, cs5535_mfd_pci_tbl);
 
-static struct pci_driver cs5535_mfd_drv = {
+static struct pci_driver cs5535_mfd_driver = {
 	.name = DRV_NAME,
 	.id_table = cs5535_mfd_pci_tbl,
 	.probe = cs5535_mfd_probe,
@@ -188,12 +188,12 @@ static struct pci_driver cs5535_mfd_drv
 
 static int __init cs5535_mfd_init(void)
 {
-	return pci_register_driver(&cs5535_mfd_drv);
+	return pci_register_driver(&cs5535_mfd_driver);
 }
 
 static void __exit cs5535_mfd_exit(void)
 {
-	pci_unregister_driver(&cs5535_mfd_drv);
+	pci_unregister_driver(&cs5535_mfd_driver);
 }
 
 module_init(cs5535_mfd_init);


-- 
Jean Delvare
