Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab1LLIY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 03:24:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32858 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab1LLIY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 03:24:58 -0500
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Mon, 12 Dec 2011 09:16:47 +0100
Message-ID: <CAH9NwWdpRH-fsF0wAk-R1NDTv4C0nPeo6Zha_Q=8f2FSYFvabQ@mail.gmail.com>
Subject: [PATCH RESEND] cs5535-mfd: fix section mismatch
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: rpurdie@rpsys.net, dilinger@queued.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silence following warnings:
WARNING: drivers/mfd/cs5535-mfd.o(.data+0x20): Section mismatch in
reference from the variable cs5535_mfd_drv to the function
.devinit.text:cs5535_mfd_probe()
The variable cs5535_mfd_drv references
the function __devinit cs5535_mfd_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

WARNING: drivers/mfd/cs5535-mfd.o(.data+0x28): Section mismatch in
reference from the variable cs5535_mfd_drv to the function
.devexit.text:cs5535_mfd_remove()
The variable cs5535_mfd_drv references
the function __devexit cs5535_mfd_remove()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Rename the variable from *_drv to *_driver so
modpost ignore the OK references to __devinit/__devexit
functions.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Acked-by: Andres Salomon <dilinger@queued.net>
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
