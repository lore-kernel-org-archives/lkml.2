Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab1DSXnC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 19:43:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:11898 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab1DSXnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 19:43:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,242,1301900400"; 
   d="scan'208";a="735771370"
From: Seth Heasley <seth.heasley@intel.com>
To: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, khali@linux-fr.org,
        seth.heasley@intel.com
Subject: [PATCH 2.6.39-rc3] lpc: irq and pci_ids patch for Intel Panther Point DeviceIDs
Date: Tue, 19 Apr 2011 16:35:15 -0700
User-Agent: KMail/1.13.6 (Linux/2.6.35.6-45.fc14.x86_64; KDE/4.6.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104191635.16141.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the LPC Controller DeviceIDs for the Intel Panther Point PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.39-rc3/include/linux/pci_ids.h.orig	2011-04-11 
17:21:51.000000000 -0700
+++ linux-2.6.39-rc3/include/linux/pci_ids.h	2011-03-29 15:55:13.000000000 
-0700
@@ -2480,6 +2480,9 @@
 #define PCI_DEVICE_ID_INTEL_COUGARPOINT_SMBUS	0x1c22
 #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN	0x1c41
 #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX	0x1c5f
+#define PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS	0x1e22
+#define PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MIN	0x1e40
+#define PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MAX	0x1e5f
 #define PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS	0x1d22
 #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_0	0x1d40
 #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_1	0x1d41
--- linux-2.6.39-rc3/arch/x86/pci/irq.c.orig	2011-04-11 17:21:51.000000000 
-0700
+++ linux-2.6.39-rc3/arch/x86/pci/irq.c	2011-04-14 12:15:47.000000000 -0700
@@ -602,7 +602,9 @@
 	||  (device >= PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN && 
 	     device <= PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX)
 	||  (device >= PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MIN &&
-	     device <= PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MAX)) {
+	     device <= PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MAX)
+	||  (device >= PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MIN &&
+	     device <= PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MAX)) {
 		r->name = "PIIX/ICH";
 		r->get = pirq_piix_get;
 		r->set = pirq_piix_set;
