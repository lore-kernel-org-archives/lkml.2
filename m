Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab1KNTMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 14:12:34 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43067 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab1KNTMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 14:12:32 -0500
From: Christian Gmeiner <christian.gmeiner@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] cs5535-mfd: fix section mismatch
Date: Mon, 14 Nov 2011 20:12:24 +0000
Message-ID: <4772540.dYKFp8bB6F@localhost>
User-Agent: KMail/4.7.3 (Linux/3.1.0; KDE/4.7.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silence following warnings:
WARNING: drivers/mfd/cs5535-mfd.o(.data+0x20): Section mismatch in reference from the variable cs5535_mfd_drv to the function .devinit.text:cs5535_mfd_probe()
The variable cs5535_mfd_drv references
the function __devinit cs5535_mfd_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

WARNING: drivers/mfd/cs5535-mfd.o(.data+0x28): Section mismatch in reference from the variable cs5535_mfd_drv to the function .devexit.text:cs5535_mfd_remove()
The variable cs5535_mfd_drv references
the function __devexit cs5535_mfd_remove()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Rename the variable from *_drv to *_driver so
modpost ignore the OK references to __devinit/__devexit
functions.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
--
diff --git a/drivers/mfd/cs5535-mfd.c b/drivers/mfd/cs5535-mfd.c
index 155fa04..e488a78 100644
--- a/drivers/mfd/cs5535-mfd.c
+++ b/drivers/mfd/cs5535-mfd.c
@@ -179,7 +179,7 @@ static struct pci_device_id cs5535_mfd_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, cs5535_mfd_pci_tbl);
 
-static struct pci_driver cs5535_mfd_drv = {
+static struct pci_driver cs5535_mfd_driver = {
        .name = DRV_NAME,
        .id_table = cs5535_mfd_pci_tbl,
        .probe = cs5535_mfd_probe,
@@ -188,12 +188,12 @@ static struct pci_driver cs5535_mfd_drv = {
 
 static int __init cs5535_mfd_init(void)
 {
-       return pci_register_driver(&cs5535_mfd_drv);
+       return pci_register_driver(&cs5535_mfd_driver);
 }
 
 static void __exit cs5535_mfd_exit(void)
 {
-       pci_unregister_driver(&cs5535_mfd_drv);
+       pci_unregister_driver(&cs5535_mfd_driver);
 }
 
 module_init(cs5535_mfd_init);
--
1.7.3.1
