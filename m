Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab0CYXRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 19:17:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:38261 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab0CYXRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 19:17:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,310,1267430400"; 
   d="scan'208";a="258807111"
From: Seth Heasley <seth.heasley@intel.com>
Organization: Intel Corporation
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, khali@linux-fr.org
Subject: [PATCH linux-next.git] irq: irq and pci_ids patch for additional Intel Cougar Point DeviceIDs
Date: Thu, 25 Mar 2010 16:11:37 -0700
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-wdt; KDE/4.1.3; x86_64; ; )
Cc: seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003251611.37706.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds additional LPC Controller DeviceIDs for the Intel Cougar Point PCH.

The DeviceIDs are defined and referenced as a range of values, the same way Ibex Peak was implemented.

This patch was built against the linux-next.git tree.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- include/linux/pci_ids.h.orig	2010-03-25 15:42:47.000000000 -0700
+++ include/linux/pci_ids.h	2010-03-25 16:00:31.000000000 -0700
@@ -2419,8 +2419,8 @@
 #define PCI_DEVICE_ID_INTEL_82845_HB	0x1a30
 #define PCI_DEVICE_ID_INTEL_IOAT	0x1a38
 #define PCI_DEVICE_ID_INTEL_CPT_SMBUS	0x1c22
-#define PCI_DEVICE_ID_INTEL_CPT_LPC1	0x1c42
-#define PCI_DEVICE_ID_INTEL_CPT_LPC2	0x1c43
+#define PCI_DEVICE_ID_INTEL_CPT_LPC_MIN	0x1c41
+#define PCI_DEVICE_ID_INTEL_CPT_LPC_MAX	0x1c5f
 #define PCI_DEVICE_ID_INTEL_82801AA_0	0x2410
 #define PCI_DEVICE_ID_INTEL_82801AA_1	0x2411
 #define PCI_DEVICE_ID_INTEL_82801AA_3	0x2413
--- arch/x86/pci/irq.c.orig	2010-03-25 15:42:36.000000000 -0700
+++ arch/x86/pci/irq.c	2010-03-25 16:00:31.000000000 -0700
@@ -590,8 +590,6 @@
 	case PCI_DEVICE_ID_INTEL_ICH10_1:
 	case PCI_DEVICE_ID_INTEL_ICH10_2:
 	case PCI_DEVICE_ID_INTEL_ICH10_3:
-	case PCI_DEVICE_ID_INTEL_CPT_LPC1:
-	case PCI_DEVICE_ID_INTEL_CPT_LPC2:
 		r->name = "PIIX/ICH";
 		r->get = pirq_piix_get;
 		r->set = pirq_piix_set;
@@ -606,6 +604,13 @@
 		return 1;
 	}
 
+	if ((device >= PCI_DEVICE_ID_INTEL_CPT_LPC_MIN) && 
+		(device <= PCI_DEVICE_ID_INTEL_CPT_LPC_MAX)) {
+		r->name = "PIIX/ICH";
+		r->get = pirq_piix_get;
+		r->set = pirq_piix_set;
+		return 1;
+	}
 	return 0;
 }
