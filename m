Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab1KFVMr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 16:12:47 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:34285 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750789Ab1KFVMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 16:12:46 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/VdXklm4XV6blfnaLHmrxU3J9JhOMosKizprAJVG
	kAZG7HvzTJuMFT
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/gma500: Convert pci_table entries to PCI_DEVICE (if PCI_ANY_ID is used)
Date: Sun,  6 Nov 2011 22:12:44 +0100
Message-Id: <1320613964-22916-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts pci_table entries to use the PCI_DEVICE macro,
if .subvendor and .subdevice are set to PCI_ANY_ID,
and thus improves readability.

And while at it changed the hardcoded 0x8086 to PCI_VENDOR_ID_INTEL

KernelVersion: Staging-20111106
---
 drivers/staging/gma500/psb_drv.c |   52 +++++++++++++++++++-------------------
 1 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index dc676c2..f5eebcb 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -50,37 +50,37 @@ module_param_named(trap_pagefaults, drm_psb_trap_pagefaults, int, 0600);
 
 
 static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
-	{ 0x8086, 0x8108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &psb_chip_ops },
-	{ 0x8086, 0x8109, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &psb_chip_ops },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8108), 0, 0, (long) &psb_chip_ops },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8109), 0, 0, (long) &psb_chip_ops },
 #if defined(CONFIG_DRM_PSB_MRST)
-	{ 0x8086, 0x4100, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mrst_chip_ops},
-	{ 0x8086, 0x4101, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mrst_chip_ops},
-	{ 0x8086, 0x4102, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mrst_chip_ops},
-	{ 0x8086, 0x4103, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mrst_chip_ops},
-	{ 0x8086, 0x4104, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mrst_chip_ops},
-	{ 0x8086, 0x4105, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mrst_chip_ops},
-	{ 0x8086, 0x4106, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mrst_chip_ops},
-	{ 0x8086, 0x4107, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mrst_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4100), 0, 0, (long) &mrst_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4101), 0, 0, (long) &mrst_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4102), 0, 0, (long) &mrst_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4103), 0, 0, (long) &mrst_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4104), 0, 0, (long) &mrst_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4105), 0, 0, (long) &mrst_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4106), 0, 0, (long) &mrst_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4107), 0, 0, (long) &mrst_chip_ops},
 #endif
 #if defined(CONFIG_DRM_PSB_MFLD)
-	{ 0x8086, 0x0130, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mdfld_chip_ops},
-	{ 0x8086, 0x0131, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mdfld_chip_ops},
-	{ 0x8086, 0x0132, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mdfld_chip_ops},
-	{ 0x8086, 0x0133, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mdfld_chip_ops},
-	{ 0x8086, 0x0134, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mdfld_chip_ops},
-	{ 0x8086, 0x0135, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mdfld_chip_ops},
-	{ 0x8086, 0x0136, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mdfld_chip_ops},
-	{ 0x8086, 0x0137, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mdfld_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0130), 0, 0, (long) &mdfld_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0131), 0, 0, (long) &mdfld_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0132), 0, 0, (long) &mdfld_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0133), 0, 0, (long) &mdfld_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0134), 0, 0, (long) &mdfld_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0135), 0, 0, (long) &mdfld_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0136), 0, 0, (long) &mdfld_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0137), 0, 0, (long) &mdfld_chip_ops},
 #endif
 #if defined(CONFIG_DRM_PSB_CDV)
-	{ 0x8086, 0x0be0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
-	{ 0x8086, 0x0be1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
-	{ 0x8086, 0x0be2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
-	{ 0x8086, 0x0be3, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
-	{ 0x8086, 0x0be4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
-	{ 0x8086, 0x0be5, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
-	{ 0x8086, 0x0be6, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
-	{ 0x8086, 0x0be7, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0be0), 0, 0, (long) &cdv_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0be1), 0, 0, (long) &cdv_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0be2), 0, 0, (long) &cdv_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0be3), 0, 0, (long) &cdv_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0be4), 0, 0, (long) &cdv_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0be5), 0, 0, (long) &cdv_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0be6), 0, 0, (long) &cdv_chip_ops},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0be7), 0, 0, (long) &cdv_chip_ops},
 #endif
 	{ 0, 0, 0}
 };
-- 
1.7.3.4

