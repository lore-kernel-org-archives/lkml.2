Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935339Ab0KQTVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 14:21:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:26948 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934924Ab0KQTVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 14:21:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,212,1288594800"; 
   d="scan'208";a="627772378"
From: Seth Heasley <seth.heasley@intel.com>
Organization: Intel Corporation
To: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.37-rc2] irq: irq and pci_ids patch for Intel Patsburg
Date: Wed, 17 Nov 2010 12:12:08 -0700
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201011171112.08712.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an additional LPC Controller DeviceID for the Intel Patsburg PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.37-rc2/include/linux/pci_ids.h.orig	2010-11-17 10:00:31.000000000 -0800
+++ linux-2.6.37-rc2/include/linux/pci_ids.h	2010-11-17 10:01:49.000000000 -0800
@@ -2466,7 +2466,8 @@
 #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN	0x1c41
 #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX	0x1c5f
 #define PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS	0x1d22
-#define PCI_DEVICE_ID_INTEL_PATSBURG_LPC	0x1d40
+#define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_0	0x1d40
+#define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_1	0x1d41
 #define PCI_DEVICE_ID_INTEL_82801AA_0	0x2410
 #define PCI_DEVICE_ID_INTEL_82801AA_1	0x2411
 #define PCI_DEVICE_ID_INTEL_82801AA_3	0x2413
--- linux-2.6.37-rc2/arch/x86/pci/irq.c.orig	2010-11-17 10:01:13.000000000 -0800
+++ linux-2.6.37-rc2/arch/x86/pci/irq.c	2010-11-17 10:01:33.000000000 -0800
@@ -589,7 +589,8 @@
 	case PCI_DEVICE_ID_INTEL_ICH10_1:
 	case PCI_DEVICE_ID_INTEL_ICH10_2:
 	case PCI_DEVICE_ID_INTEL_ICH10_3:
-	case PCI_DEVICE_ID_INTEL_PATSBURG_LPC:
+	case PCI_DEVICE_ID_INTEL_PATSBURG_LPC_0:
+	case PCI_DEVICE_ID_INTEL_PATSBURG_LPC_1:
 		r->name = "PIIX/ICH";
 		r->get = pirq_piix_get;
 		r->set = pirq_piix_set;
