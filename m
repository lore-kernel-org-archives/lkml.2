Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab2AXArx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:47:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:19871 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab2AXArv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:47:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="99804739"
From: Seth Heasley <seth.heasley@intel.com>
To: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org
Subject: [PATCH 6/6] pci: irq and pci_ids patch for Intel Lynx Point DeviceIDs
Date: Mon, 23 Jan 2012 16:46:24 -0800
User-Agent: KMail/1.13.6 (Linux/2.6.35.12-88.fc14.x86_64; KDE/4.6.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, james.d.ralston@intel.com,
        seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201231646.24194.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the LPC Controller DeviceIDs for the Intel Lynx Point PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
---
 arch/x86/pci/irq.c      |    4 +++-
 include/linux/pci_ids.h |    2 ++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 372e9b8..22468b6 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -604,7 +604,9 @@ static __init int intel_router_probe(struct irq_router *r, struct pci_dev *route
 	||  (device >= PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MIN &&
 	     device <= PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MAX)
 	||  (device >= PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MIN &&
-	     device <= PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MAX)) {
+	     device <= PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MAX)
+	||  (device >= PCI_DEVICE_ID_INTEL_LYNXPOINT_LPC_MIN &&
+	     device <= PCI_DEVICE_ID_INTEL_LYNXPOINT_LPC_MAX)) {
 		r->name = "PIIX/ICH";
 		r->get = pirq_piix_get;
 		r->set = pirq_piix_set;
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 31d77af..6a0359a 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2800,6 +2800,8 @@
 #define PCI_DEVICE_ID_INTEL_82454NX     0x84cb
 #define PCI_DEVICE_ID_INTEL_84460GX	0x84ea
 #define PCI_DEVICE_ID_INTEL_IXP4XX	0x8500
+#define PCI_DEVICE_ID_INTEL_LYNXPOINT_LPC_MIN	0x8c40
+#define PCI_DEVICE_ID_INTEL_LYNXPOINT_LPC_MAX	0x8c5f
 #define PCI_DEVICE_ID_INTEL_IXP2800	0x9004
 #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
 
-- 
1.7.4.4

