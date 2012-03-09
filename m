Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031328Ab2CITut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:50:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031314Ab2CITuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:50:46 -0500
Message-Id: <20120309190209.846261608@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Andres Salomon <dilinger@queued.net>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [ 94/95] mfd: Fix cs5535 section mismatch
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Gmeiner <christian.gmeiner@gmail.com>

commit 97e43c983c721a47546e6db3b7711dcd912a6481 upstream.

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
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/cs5535-mfd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mfd/cs5535-mfd.c
+++ b/drivers/mfd/cs5535-mfd.c
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


