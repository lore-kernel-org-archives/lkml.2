Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784Ab0EUXYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 19:24:11 -0400
Received: from p01c12o143.mxlogic.net ([208.65.145.66]:39007 "EHLO
	p01c12o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab0EUXYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 19:24:09 -0400
X-MXL-Hash: 4bf71618106a37c7-646bf185a69a352feb4793746de611a9eba575d3
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: David Woodhouse <dwmw2@infradead.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Date: Fri, 21 May 2010 18:24:01 -0500
Subject: [PATCH] pcm551.c: use pci_ids.h defines
Thread-Topic: [PATCH] pcm551.c: use pci_ids.h defines
Thread-Index: Acr5PLIYPRa7gtvBSi2DZTvqvNOK4g==
Message-ID: <0D753D10438DA54287A00B0270842697636F3238A0@AUSP01VMBX24.collaborationhost.net>
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
X-AnalysisOut: [v=1.0 c=1 a=bGEChy1aIgcA:10 a=ADBQPqJMlbwA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=IkcTkHD0fZMA:10 a=qhvANl0glaz90f+3g7Keqg==:17 a=i0]
X-AnalysisOut: [0gxMtYAAAA:8 a=JfrnYn6hAAAA:8 a=TBVoxVdAAAAA:8 a=XR5_ixuXc]
X-AnalysisOut: [PEkrMFIIi0A:9 a=dliwEEcqzyye4HVIaZfdKKSYY30A:4 a=QEXdDO2ut]
X-AnalysisOut: [3YA:10 a=x1WnkoZAwusA:10 a=3Rfx1nUSh_UA:10 a=rW6DTWptwo0A:]
X-AnalysisOut: [10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4LNOFaS005997

Move the DEVICE id to pci_ids.h and then use the VENDOR/DEVICE ids provided
in pci_ids.h instead of creating local ids.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>

---

diff --git a/drivers/mtd/devices/pmc551.c b/drivers/mtd/devices/pmc551.c
index fc8ea0a..f648e2b 100644
--- a/drivers/mtd/devices/pmc551.c
+++ b/drivers/mtd/devices/pmc551.c
@@ -697,8 +697,8 @@ static int __init init_pmc551(void)
 	 */
 	for (;;) {
 
-		if ((PCI_Device = pci_get_device(PCI_VENDOR_ID_V3_SEMI,
-						  PCI_DEVICE_ID_V3_SEMI_V370PDC,
+		if ((PCI_Device = pci_get_device(PCI_VENDOR_ID_V3,
+						  PCI_DEVICE_ID_V3_V370PDC,
 						  PCI_Device)) == NULL) {
 			break;
 		}
diff --git a/include/linux/mtd/pmc551.h b/include/linux/mtd/pmc551.h
index 27ad40a..bc68a9d 100644
--- a/include/linux/mtd/pmc551.h
+++ b/include/linux/mtd/pmc551.h
@@ -41,18 +41,6 @@ static int pmc551_read(struct mtd_info *, loff_t, size_t, size_t *, u_char *);
 static int pmc551_write(struct mtd_info *, loff_t, size_t, size_t *, const u_char *);
 
 
-/*
- * Define the PCI ID's if the kernel doesn't define them for us
- */
-#ifndef PCI_VENDOR_ID_V3_SEMI
-#define PCI_VENDOR_ID_V3_SEMI             0x11b0
-#endif
-
-#ifndef PCI_DEVICE_ID_V3_SEMI_V370PDC
-#define PCI_DEVICE_ID_V3_SEMI_V370PDC     0x0200
-#endif
-
-
 #define PMC551_PCI_MEM_MAP0	0x50
 #define PMC551_PCI_MEM_MAP1	0x54
 #define PMC551_PCI_MEM_MAP_MAP_ADDR_MASK	0x3ff00000
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 9f688d2..3987d96 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1565,6 +1565,7 @@
 #define PCI_VENDOR_ID_V3		0x11b0
 #define PCI_DEVICE_ID_V3_V960		0x0001
 #define PCI_DEVICE_ID_V3_V351		0x0002
+#define PCI_DEVICE_ID_V3_V370PDC	0x0200
 
 #define PCI_VENDOR_ID_ATT		0x11c1
 #define PCI_DEVICE_ID_ATT_VENUS_MODEM	0x480
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
