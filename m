Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab0EUXi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 19:38:59 -0400
Received: from p01c11o144.mxlogic.net ([208.65.144.67]:46115 "EHLO
	p01c11o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758779Ab0EUXi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 19:38:58 -0400
X-MXL-Hash: 4bf719922e301ffa-2d1aebaca2c932f9d27986eb51292c4533c13b5a
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: "wim@iguana.be" <wim@iguana.be>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Date: Fri, 21 May 2010 18:38:52 -0500
Subject: [PATCH] wdt_pci.c: move ids to pci_ids.h
Thread-Topic: [PATCH] wdt_pci.c: move ids to pci_ids.h
Thread-Index: Acr5PsU8L8KJvtYdRACL2RN3BxJo5g==
Message-ID: <0D753D10438DA54287A00B0270842697636F3238B3@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010051701)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [(unknown)]
X-AnalysisOut: [v=1.0 c=1 a=3BEioSk0_CgA:10 a=ADBQPqJMlbwA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=IkcTkHD0fZMA:10 a=MfCJKx98tC58LqYwCYfhJw==:17 a=i0]
X-AnalysisOut: [0gxMtYAAAA:8 a=TBVoxVdAAAAA:8 a=Oe8o0G3DOOa1TpYyVlwA:9 a=5]
X-AnalysisOut: [iMklOEM7Jib23Me2wYLxT-wFOsA:4 a=QEXdDO2ut3YA:10 a=x1WnkoZA]
X-AnalysisOut: [wusA:10 a=rW6DTWptwo0A:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4LNd7aS006071

Move the VENDOR/DEVICE ids to pci_ids.h.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>

---

diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index 7b22e3c..6130c88 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -60,19 +60,6 @@
 
 #define PFX "wdt_pci: "
 
-/*
- * Until Access I/O gets their application for a PCI vendor ID approved,
- * I don't think that it's appropriate to move these constants into the
- * regular pci_ids.h file. -- JPN 2000/01/18
- */
-
-#ifndef PCI_VENDOR_ID_ACCESSIO
-#define PCI_VENDOR_ID_ACCESSIO 0x494f
-#endif
-#ifndef PCI_DEVICE_ID_WDG_CSM
-#define PCI_DEVICE_ID_WDG_CSM 0x22c0
-#endif
-
 /* We can only use 1 card due to the /dev/watchdog restriction */
 static int dev_count;
 
@@ -743,7 +730,7 @@ static void __devexit wdtpci_remove_one(struct pci_dev *pdev)
 static struct pci_device_id wdtpci_pci_tbl[] = {
 	{
 		.vendor	   = PCI_VENDOR_ID_ACCESSIO,
-		.device	   = PCI_DEVICE_ID_WDG_CSM,
+		.device	   = PCI_DEVICE_ID_ACCESSIO_WDG_CSM,
 		.subvendor = PCI_ANY_ID,
 		.subdevice = PCI_ANY_ID,
 	},
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 9f688d2..e4551f0 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2367,6 +2367,9 @@
 #define PCI_VENDOR_ID_AKS		0x416c
 #define PCI_DEVICE_ID_AKS_ALADDINCARD	0x0100
 
+#define PCI_VENDOR_ID_ACCESSIO		0x494f
+#define PCI_DEVICE_ID_ACCESSIO_WDG_CSM	0x22c0
+
 #define PCI_VENDOR_ID_S3		0x5333
 #define PCI_DEVICE_ID_S3_TRIO		0x8811
 #define PCI_DEVICE_ID_S3_868		0x8880
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
