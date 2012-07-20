Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab2GTHCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 03:02:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48482 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab2GTHB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 03:01:56 -0400
From: Jon Mason <jdmason@kudzu.us>
To: trivial@kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>
Subject: [trivial PATCH resend 2/2] ixgbe: use PCI_VENDOR_ID_INTEL
Date: Fri, 20 Jul 2012 00:02:09 -0700
Message-Id: <1342767729-17788-3-git-send-email-jdmason@kudzu.us>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342767729-17788-1-git-send-email-jdmason@kudzu.us>
References: <1342767729-17788-1-git-send-email-jdmason@kudzu.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI_VENDOR_ID_INTEL from pci_ids.h instead of creating its own
vendor ID #define.

Signed-off-by: Jon Mason <jdmason@kudzu.us>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Bruce Allan <bruce.w.allan@intel.com>
Cc: Carolyn Wyborny <carolyn.wyborny@intel.com>
Cc: Don Skidmore <donald.c.skidmore@intel.com>
Cc: Greg Rose <gregory.v.rose@intel.com>
Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Cc: Alex Duyck <alexander.h.duyck@intel.com>
Cc: John Ronciak <john.ronciak@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  |    4 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c |    8 ++++----
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h  |    3 ---
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 18ca3bc..8a3fafb 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -7516,11 +7516,11 @@ static pci_ers_result_t ixgbe_io_error_detected(struct pci_dev *pdev,
 		}
 
 		/* Find the pci device of the offending VF */
-		vfdev = pci_get_device(IXGBE_INTEL_VENDOR_ID, device_id, NULL);
+		vfdev = pci_get_device(PCI_VENDOR_ID_INTEL, device_id, NULL);
 		while (vfdev) {
 			if (vfdev->devfn == (req_id & 0xFF))
 				break;
-			vfdev = pci_get_device(IXGBE_INTEL_VENDOR_ID,
+			vfdev = pci_get_device(PCI_VENDOR_ID_INTEL,
 					       device_id, vfdev);
 		}
 		/*
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 2d971d1..28018d4 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -65,13 +65,13 @@ static int ixgbe_find_enabled_vfs(struct ixgbe_adapter *adapter)
 	}
 
 	vf_devfn = pdev->devfn + 0x80;
-	pvfdev = pci_get_device(IXGBE_INTEL_VENDOR_ID, device_id, NULL);
+	pvfdev = pci_get_device(PCI_VENDOR_ID_INTEL, device_id, NULL);
 	while (pvfdev) {
 		if (pvfdev->devfn == vf_devfn &&
 		    (pvfdev->bus->number >= pdev->bus->number))
 			vfs_found++;
 		vf_devfn += 2;
-		pvfdev = pci_get_device(IXGBE_INTEL_VENDOR_ID,
+		pvfdev = pci_get_device(PCI_VENDOR_ID_INTEL,
 					device_id, pvfdev);
 	}
 
@@ -488,11 +488,11 @@ int ixgbe_vf_configuration(struct pci_dev *pdev, unsigned int event_mask)
 			break;
 		}
 
-		pvfdev = pci_get_device(IXGBE_INTEL_VENDOR_ID, device_id, NULL);
+		pvfdev = pci_get_device(PCI_VENDOR_ID_INTEL, device_id, NULL);
 		while (pvfdev) {
 			if (pvfdev->devfn == thisvf_devfn)
 				break;
-			pvfdev = pci_get_device(IXGBE_INTEL_VENDOR_ID,
+			pvfdev = pci_get_device(PCI_VENDOR_ID_INTEL,
 						device_id, pvfdev);
 		}
 		if (pvfdev)
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
index 204848d..c8d8040 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
@@ -32,9 +32,6 @@
 #include <linux/mdio.h>
 #include <linux/netdevice.h>
 
-/* Vendor ID */
-#define IXGBE_INTEL_VENDOR_ID   0x8086
-
 /* Device IDs */
 #define IXGBE_DEV_ID_82598               0x10B6
 #define IXGBE_DEV_ID_82598_BX            0x1508
-- 
1.7.9.5

