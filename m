Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab2GIVgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:36:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab2GIVgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:36:35 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 3/8] PCI: Adjust section annotations of various quirks
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, ralf@linux-mips.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 15:36:14 -0600
Message-ID: <20120709213614.8975.28410.stgit@amt.stowe>
In-Reply-To: <20120709213554.8975.60552.stgit@amt.stowe>
References: <20120709213554.8975.60552.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI's quirk types 'pci_fixup_enable', 'pci_fixup_resume',
'pci_fixup_suspend', and 'pci_fixup_resume_early' can not be __init or
__devinit; they must be in normal text because they can be called at any
time.

This patch removes the '__init' section annotation of such quirks.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/quirks.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 8b2d553..8014091 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1039,7 +1039,7 @@ static void quirk_disable_pxb(struct pci_dev *pdev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82454NX,	quirk_disable_pxb);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82454NX,	quirk_disable_pxb);
 
-static void __devinit quirk_amd_ide_mode(struct pci_dev *pdev)
+static void quirk_amd_ide_mode(struct pci_dev *pdev)
 {
 	/* set SBX00/Hudson-2 SATA in IDE mode to AHCI mode */
 	u8 tmp;
@@ -2104,7 +2104,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
 			PCI_DEVICE_ID_NX2_5709S,
 			quirk_brcm_570x_limit_vpd);
 
-static void __devinit quirk_brcm_5719_limit_mrrs(struct pci_dev *dev)
+static void quirk_brcm_5719_limit_mrrs(struct pci_dev *dev)
 {
 	u32 rev;
 
@@ -2217,7 +2217,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x9601, quirk_amd_780_apc_msi);
 
 /* Go through the list of Hypertransport capabilities and
  * return 1 if a HT MSI capability is found and enabled */
-static int __devinit msi_ht_cap_enabled(struct pci_dev *dev)
+static int msi_ht_cap_enabled(struct pci_dev *dev)
 {
 	int pos, ttl = 48;
 
@@ -2241,7 +2241,7 @@ static int __devinit msi_ht_cap_enabled(struct pci_dev *dev)
 }
 
 /* Check the hypertransport MSI mapping to know whether MSI is enabled or not */
-static void __devinit quirk_msi_ht_cap(struct pci_dev *dev)
+static void quirk_msi_ht_cap(struct pci_dev *dev)
 {
 	if (dev->subordinate && !msi_ht_cap_enabled(dev)) {
 		dev_warn(&dev->dev, "MSI quirk detected; "
@@ -2255,7 +2255,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT2
 /* The nVidia CK804 chipset may have 2 HT MSI mappings.
  * MSI are supported if the MSI capability set in any of these mappings.
  */
-static void __devinit quirk_nvidia_ck804_msi_ht_cap(struct pci_dev *dev)
+static void quirk_nvidia_ck804_msi_ht_cap(struct pci_dev *dev)
 {
 	struct pci_dev *pdev;
 
@@ -2279,7 +2279,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_CK804_PCIE,
 			quirk_nvidia_ck804_msi_ht_cap);
 
 /* Force enable MSI mapping capability on HT bridges */
-static void __devinit ht_enable_msi_mapping(struct pci_dev *dev)
+static void ht_enable_msi_mapping(struct pci_dev *dev)
 {
 	int pos, ttl = 48;
 
@@ -2359,7 +2359,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA,
 			PCI_DEVICE_ID_NVIDIA_MCP55_BRIDGE_V4,
 			nvbridge_check_legacy_irq_routing);
 
-static int __devinit ht_check_msi_mapping(struct pci_dev *dev)
+static int ht_check_msi_mapping(struct pci_dev *dev)
 {
 	int pos, ttl = 48;
 	int found = 0;
@@ -2387,7 +2387,7 @@ static int __devinit ht_check_msi_mapping(struct pci_dev *dev)
 	return found;
 }
 
-static int __devinit host_bridge_with_leaf(struct pci_dev *host_bridge)
+static int host_bridge_with_leaf(struct pci_dev *host_bridge)
 {
 	struct pci_dev *dev;
 	int pos;
@@ -2421,7 +2421,7 @@ static int __devinit host_bridge_with_leaf(struct pci_dev *host_bridge)
 #define PCI_HT_CAP_SLAVE_CTRL0     4    /* link control */
 #define PCI_HT_CAP_SLAVE_CTRL1     8    /* link control to */
 
-static int __devinit is_end_of_ht_chain(struct pci_dev *dev)
+static int is_end_of_ht_chain(struct pci_dev *dev)
 {
 	int pos, ctrl_off;
 	int end = 0;
@@ -2445,7 +2445,7 @@ out:
 	return end;
 }
 
-static void __devinit nv_ht_enable_msi_mapping(struct pci_dev *dev)
+static void nv_ht_enable_msi_mapping(struct pci_dev *dev)
 {
 	struct pci_dev *host_bridge;
 	int pos;
@@ -2484,7 +2484,7 @@ out:
 	pci_dev_put(host_bridge);
 }
 
-static void __devinit ht_disable_msi_mapping(struct pci_dev *dev)
+static void ht_disable_msi_mapping(struct pci_dev *dev)
 {
 	int pos, ttl = 48;
 
@@ -2504,7 +2504,7 @@ static void __devinit ht_disable_msi_mapping(struct pci_dev *dev)
 	}
 }
 
-static void __devinit __nv_msi_ht_cap_quirk(struct pci_dev *dev, int all)
+static void __nv_msi_ht_cap_quirk(struct pci_dev *dev, int all)
 {
 	struct pci_dev *host_bridge;
 	int pos;
@@ -2555,12 +2555,12 @@ out:
 	pci_dev_put(host_bridge);
 }
 
-static void __devinit nv_msi_ht_cap_quirk_all(struct pci_dev *dev)
+static void nv_msi_ht_cap_quirk_all(struct pci_dev *dev)
 {
 	return __nv_msi_ht_cap_quirk(dev, 1);
 }
 
-static void __devinit nv_msi_ht_cap_quirk_leaf(struct pci_dev *dev)
+static void nv_msi_ht_cap_quirk_leaf(struct pci_dev *dev)
 {
 	return __nv_msi_ht_cap_quirk(dev, 0);
 }

