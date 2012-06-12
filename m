Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab2FLFEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 01:04:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45860 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab2FLFEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 01:04:36 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: [PATCH] arch/powerpc/: fix kernel-doc warning
Date: Tue, 12 Jun 2012 13:04:27 +0800
Message-Id: <1339477467-8211-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Warning(arch/powerpc/kernel/pci_of_scan.c:210): Excess function parameter 'node' description in 'of_scan_pci_bridge'
Warning(arch/powerpc/kernel/vio.c:636): No description found for parameter 'desired'
Warning(arch/powerpc/kernel/vio.c:636): Excess function parameter 'new_desired' description in 'vio_cmo_set_dev_desired'
Warning(arch/powerpc/kernel/vio.c:1270): No description found for parameter 'viodrv'
Warning(arch/powerpc/kernel/vio.c:1270): Excess function parameter 'drv' description in '__vio_register_driver'
Warning(arch/powerpc/kernel/vio.c:1289): No description found for parameter 'viodrv'
Warning(arch/powerpc/kernel/vio.c:1289): Excess function parameter 'driver' description in 'vio_unregister_driver'


Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/pci_of_scan.c |    1 -
 arch/powerpc/kernel/vio.c         |    6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
index 89dde17..d7dd42b 100644
--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -198,7 +198,6 @@ EXPORT_SYMBOL(of_create_pci_dev);
 
 /**
  * of_scan_pci_bridge - Set up a PCI bridge and scan for child nodes
- * @node: device tree node of bridge
  * @dev: pci_dev structure for the bridge
  *
  * of_scan_bus() calls this routine for each PCI bridge that it finds, and
diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index cb87301..06cbc30 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -625,7 +625,7 @@ struct dma_map_ops vio_dma_mapping_ops = {
  * vio_cmo_set_dev_desired - Set desired entitlement for a device
  *
  * @viodev: struct vio_dev for device to alter
- * @new_desired: new desired entitlement level in bytes
+ * @desired: new desired entitlement level in bytes
  *
  * For use by devices to request a change to their entitlement at runtime or
  * through sysfs.  The desired entitlement level is changed and a balancing
@@ -1262,7 +1262,7 @@ static int vio_bus_remove(struct device *dev)
 
 /**
  * vio_register_driver: - Register a new vio driver
- * @drv:	The vio_driver structure to be registered.
+ * @viodrv:	The vio_driver structure to be registered.
  */
 int __vio_register_driver(struct vio_driver *viodrv, struct module *owner,
 			  const char *mod_name)
@@ -1282,7 +1282,7 @@ EXPORT_SYMBOL(__vio_register_driver);
 
 /**
  * vio_unregister_driver - Remove registration of vio driver.
- * @driver:	The vio_driver struct to be removed form registration
+ * @viodrv:	The vio_driver struct to be removed form registration
  */
 void vio_unregister_driver(struct vio_driver *viodrv)
 {
-- 
1.7.9.5

