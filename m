Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab2CARSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:18:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:49300 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015Ab2CARSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:18:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="131782934"
Date: Thu, 01 Mar 2012 17:18:32 +0000
From: tadeusz.struk@intel.com
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, tadeusz.struk@intel.com
Subject: [PATCH] Fix warning
Message-ID: <4f4faf68.hZnY8LUXJWXvhCtG%tadeusz.struk@intel.com>
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 268c5427305d59c1f6f6c1ce8047f6e32a7edcac Mon Sep 17 00:00:00 2001
From: Tadeusz Struk <tadeusz.struk@intel.com>
Date: Mon, 14 Feb 2011 14:38:18 +0000
Subject: [PATCH] Fixed warning

This patch fixes the following warning.
# virsh start fedora16-64
kernel: [  133.324565] pci-stub 0000:02:01.1: claimed by stub
kernel: [  134.163769] pci-stub 0000:02:01.1: enabling device (0000 -> 0002)
kernel: [  164.282679] ------------[ cut here ]------------
kernel: [  164.282685] WARNING: at drivers/pci/search.c:46 pci_find_upstream_pcie_bridge+0x87/0x9f()
kernel: [  164.282687] Hardware name: SandyBridge Platform
kernel: [  164.282689] Modules linked in: sha512_generic sha256_generic icp_qa_al(O) nfs fscache auth_rpcgss nfs_acl mga drm ip6table_filter ip6_tables ebtable_nat ebtables lockd ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_CHECKSUM iptable_mangle tun bridge stp llc sunrpc btrfs zlib_deflate libcrc32c virtio_net kvm_intel kvm uinput matroxfb_base matroxfb_DAC1064 matroxfb_accel matroxfb_Ti3026 matroxfb_g450 g450_pll matroxfb_misc e1000e iTCO_wdt iTCO_vendor_support igb microcode i2c_i801 shpchp serio_raw i2c_core pcspkr dca [last unloaded: scsi_wait_scan]
kernel: [  164.282724] Pid: 1233, comm: qemu-kvm Tainted: G           O 3.2.5 #10
kernel: [  164.282726] Call Trace:
kernel: [  164.282732]  [<ffffffff8104eac6>] warn_slowpath_common+0x83/0x9b
kernel: [  164.282735]  [<ffffffff8104eaf8>] warn_slowpath_null+0x1a/0x1c
kernel: [  164.282737]  [<ffffffff8123e028>] pci_find_upstream_pcie_bridge+0x87/0x9f
kernel: [  164.282741]  [<ffffffff813bf5eb>] domain_context_mapping+0x50/0xe6
kernel: [  164.282744]  [<ffffffff813bf6c5>] domain_add_dev_info+0x44/0xe3
kernel: [  164.282747]  [<ffffffff813bfcda>] intel_iommu_attach_device+0x14f/0x15c
kernel: [  164.282750]  [<ffffffff813bb48b>] iommu_attach_device+0x1c/0x1e
kernel: [  164.282764]  [<ffffffffa00f43aa>] kvm_assign_device+0x4a/0x114 [kvm]
kernel: [  164.282773]  [<ffffffffa00f3963>] kvm_vm_ioctl_assigned_device+0x434/0xb25 [kvm]
kernel: [  164.282777]  [<ffffffff810f0fee>] ? __do_fault+0x351/0x38b
kernel: [  164.282781]  [<ffffffff8107c05b>] ? arch_local_irq_save+0x15/0x1b
kernel: [  164.282784]  [<ffffffff814b26e4>] ? _raw_spin_unlock_irqrestore+0x17/0x19
kernel: [  164.282787]  [<ffffffff813c0f35>] ? pci_conf1_read+0xe1/0xee
kernel: [  164.282794]  [<ffffffffa00f07df>] kvm_vm_ioctl+0x377/0x3ac [kvm]
kernel: [  164.282797]  [<ffffffff8123eb7c>] ? pci_read_config+0xa2/0x1bd
kernel: [  164.282801]  [<ffffffff8110edc2>] ? virt_to_head_page+0xe/0x31
kernel: [  164.282804]  [<ffffffff8112f210>] do_vfs_ioctl+0x45d/0x49e
kernel: [  164.282808]  [<ffffffff811208da>] ? fsnotify_access+0x5f/0x67
kernel: [  164.282811]  [<ffffffff8112f2a7>] sys_ioctl+0x56/0x7b
kernel: [  164.282814]  [<ffffffff814b8e42>] system_call_fastpath+0x16/0x1b
kernel: [  164.282816] ---[ end trace 6a834ec5ac21cba8 ]---

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

---
 drivers/pci/search.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 9d75dc8..7847c6b 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -26,6 +26,7 @@ struct pci_dev *
 pci_find_upstream_pcie_bridge(struct pci_dev *pdev)
 {
 	struct pci_dev *tmp = NULL;
+	struct pci_dev *vf = pdev;
 
 	if (pci_is_pcie(pdev))
 		return NULL;
@@ -40,8 +41,10 @@ pci_find_upstream_pcie_bridge(struct pci_dev *pdev)
 		}
 		/* PCI device should connect to a PCIe bridge */
 		if (pdev->pcie_type != PCI_EXP_TYPE_PCI_BRIDGE) {
-			/* Busted hardware? */
-			WARN_ON_ONCE(1);
+			if (!vf->is_virtfn) {
+				/* Busted hardware? */
+				WARN_ON_ONCE(1);
+			}
 			return NULL;
 		}
 		return pdev;
-- 
1.7.7.6

--------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). Any review or distribution by others is strictly prohibited. If you are not the intended recipient, please contact the sender and delete all copies.


