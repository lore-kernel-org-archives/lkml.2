Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab1AJVSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:18:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:39919 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab1AJVSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:18:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,303,1291622400"; 
   d="scan'208";a="695402788"
From: Seth Heasley <seth.heasley@intel.com>
Organization: Intel Corporation
To: jbarnes@virtuousgeek.org
Subject: [PATCH 2.6.37] lpc: irq and pci_ids patch for Intel DH89xxCC DeviceIDs
Date: Mon, 10 Jan 2011 13:08:37 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        khali@linux-fr.org, seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101101308.37805.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the LPC Controller DeviceIDs for the Intel DH89xxCC PCH.

The code for capturing ranges of LPC Controller DeviceIDs has also been updated.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.37/include/linux/pci_ids.h.orig	2011-01-04 16:50:19.000000000 -0800
+++ linux-2.6.37/include/linux/pci_ids.h	2011-01-10 11:23:19.000000000 -0800
@@ -2469,6 +2469,9 @@
 #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX	0x1c5f
 #define PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS	0x1d22
 #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC	0x1d40
+#define PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MIN	0x2310
+#define PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MAX	0x231f
+#define PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS	0x2330
 #define PCI_DEVICE_ID_INTEL_82801AA_0	0x2410
 #define PCI_DEVICE_ID_INTEL_82801AA_1	0x2411
 #define PCI_DEVICE_ID_INTEL_82801AA_3	0x2413
--- linux-2.6.37/arch/x86/pci/irq.c.orig	2011-01-04 16:50:19.000000000 -0800
+++ linux-2.6.37/arch/x86/pci/irq.c	2011-01-10 11:31:02.000000000 -0800
@@ -596,21 +596,18 @@
 		return 1;
 	}
 
-	if ((device >= PCI_DEVICE_ID_INTEL_5_3400_SERIES_LPC_MIN) && 
-		(device <= PCI_DEVICE_ID_INTEL_5_3400_SERIES_LPC_MAX)) {
+	if ((device >= PCI_DEVICE_ID_INTEL_5_3400_SERIES_LPC_MIN && 
+	     device <= PCI_DEVICE_ID_INTEL_5_3400_SERIES_LPC_MAX) 
+	||  (device >= PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN && 
+	     device <= PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX)
+	||  (device >= PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MIN &&
+	     device <= PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MAX)) {
 		r->name = "PIIX/ICH";
 		r->get = pirq_piix_get;
 		r->set = pirq_piix_set;
 		return 1;
 	}
 
-	if ((device >= PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN) && 
-		(device <= PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX)) {
-		r->name = "PIIX/ICH";
-		r->get = pirq_piix_get;
-		r->set = pirq_piix_set;
-		return 1;
-	}
 	return 0;
 }
 
