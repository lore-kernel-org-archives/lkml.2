Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab2BYVzv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 16:55:51 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:23654 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab2BYVyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 16:54:50 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/4] PCI: Rename pci_remove_bus_device to pci_stop_and_remove_bus_device
Date: Sat, 25 Feb 2012 13:54:20 -0800
Message-Id: <1330206863-31381-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330206863-31381-1-git-send-email-yinghai@kernel.org>
References: <1330206863-31381-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090205.4F4958A6.0039,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

old pci_remove_bus_device actually do stop and remove.

Make the name reflect that, and less confusing.

This patch is done by sed scripts and change back __pci_remove_bus_device for
some wrong change.

Suggested-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/arm/mach-ixp2000/ixdp2400.c           |    4 ++--
 arch/arm/mach-ixp2000/ixdp2800.c           |    4 ++--
 arch/arm/mach-ixp2000/ixdp2x00.c           |    4 ++--
 arch/powerpc/platforms/pseries/pci_dlpar.c |    2 +-
 drivers/message/fusion/mptbase.c           |    2 +-
 drivers/pci/hotplug/acpiphp_glue.c         |    4 ++--
 drivers/pci/hotplug/cpci_hotplug_pci.c     |    2 +-
 drivers/pci/hotplug/cpqphp_pci.c           |    2 +-
 drivers/pci/hotplug/fakephp.c              |    2 +-
 drivers/pci/hotplug/ibmphp_core.c          |    2 +-
 drivers/pci/hotplug/pciehp_pci.c           |    2 +-
 drivers/pci/hotplug/rpadlpar_core.c        |    2 +-
 drivers/pci/hotplug/sgi_hotplug.c          |    2 +-
 drivers/pci/hotplug/shpchp_pci.c           |    2 +-
 drivers/pci/iov.c                          |    4 ++--
 drivers/pci/pci-sysfs.c                    |    2 +-
 drivers/pci/remove.c                       |    8 ++++----
 drivers/pci/xen-pcifront.c                 |    4 ++--
 drivers/platform/x86/asus-wmi.c            |    2 +-
 drivers/platform/x86/eeepc-laptop.c        |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c        |    2 +-
 include/linux/pci.h                        |    2 +-
 22 files changed, 31 insertions(+), 31 deletions(-)

Index: linux-2.6/arch/arm/mach-ixp2000/ixdp2400.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp2000/ixdp2400.c
+++ linux-2.6/arch/arm/mach-ixp2000/ixdp2400.c
@@ -134,11 +134,11 @@ static void ixdp2400_pci_postinit(void)
 
 	if (ixdp2x00_master_npu()) {
 		dev = pci_get_bus_and_slot(1, IXDP2400_SLAVE_ENET_DEVFN);
-		pci_remove_bus_device(dev);
+		pci_stop_and_remove_bus_device(dev);
 		pci_dev_put(dev);
 	} else {
 		dev = pci_get_bus_and_slot(1, IXDP2400_MASTER_ENET_DEVFN);
-		pci_remove_bus_device(dev);
+		pci_stop_and_remove_bus_device(dev);
 		pci_dev_put(dev);
 
 		ixdp2x00_slave_pci_postinit();
Index: linux-2.6/arch/arm/mach-ixp2000/ixdp2800.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp2000/ixdp2800.c
+++ linux-2.6/arch/arm/mach-ixp2000/ixdp2800.c
@@ -262,14 +262,14 @@ int __init ixdp2800_pci_init(void)
 		pci_common_init(&ixdp2800_pci);
 		if (ixdp2x00_master_npu()) {
 			dev = pci_get_bus_and_slot(1, IXDP2800_SLAVE_ENET_DEVFN);
-			pci_remove_bus_device(dev);
+			pci_stop_and_remove_bus_device(dev);
 			pci_dev_put(dev);
 
 			ixdp2800_master_enable_slave();
 			ixdp2800_master_wait_for_slave_bus_scan();
 		} else {
 			dev = pci_get_bus_and_slot(1, IXDP2800_MASTER_ENET_DEVFN);
-			pci_remove_bus_device(dev);
+			pci_stop_and_remove_bus_device(dev);
 			pci_dev_put(dev);
 		}
 	}
Index: linux-2.6/arch/arm/mach-ixp2000/ixdp2x00.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp2000/ixdp2x00.c
+++ linux-2.6/arch/arm/mach-ixp2000/ixdp2x00.c
@@ -239,12 +239,12 @@ void ixdp2x00_slave_pci_postinit(void)
 	 * Remove PMC device is there is one
 	 */
 	if((dev = pci_get_bus_and_slot(1, IXDP2X00_PMC_DEVFN))) {
-		pci_remove_bus_device(dev);
+		pci_stop_and_remove_bus_device(dev);
 		pci_dev_put(dev);
 	}
 
 	dev = pci_get_bus_and_slot(0, IXDP2X00_21555_DEVFN);
-	pci_remove_bus_device(dev);
+	pci_stop_and_remove_bus_device(dev);
 	pci_dev_put(dev);
 }
 
Index: linux-2.6/arch/powerpc/platforms/pseries/pci_dlpar.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/pseries/pci_dlpar.c
+++ linux-2.6/arch/powerpc/platforms/pseries/pci_dlpar.c
@@ -84,7 +84,7 @@ void pcibios_remove_pci_devices(struct p
 	list_for_each_entry_safe(dev, tmp, &bus->devices, bus_list) {
 		pr_debug("     * Removing %s...\n", pci_name(dev));
 		eeh_remove_bus_device(dev);
- 		pci_remove_bus_device(dev);
+ 		pci_stop_and_remove_bus_device(dev);
  	}
 }
 EXPORT_SYMBOL_GPL(pcibios_remove_pci_devices);
Index: linux-2.6/drivers/message/fusion/mptbase.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptbase.c
+++ linux-2.6/drivers/message/fusion/mptbase.c
@@ -346,7 +346,7 @@ static int mpt_remove_dead_ioc_func(void
 	if ((pdev == NULL))
 		return -1;
 
-	pci_remove_bus_device(pdev);
+	pci_stop_and_remove_bus_device(pdev);
 	return 0;
 }
 
Index: linux-2.6/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-2.6/drivers/pci/hotplug/acpiphp_glue.c
@@ -910,7 +910,7 @@ static int disable_device(struct acpiphp
 				disable_bridges(pdev->subordinate);
 				pci_disable_device(pdev);
 			}
-			pci_remove_bus_device(pdev);
+			pci_stop_and_remove_bus_device(pdev);
 			pci_dev_put(pdev);
 		}
 	}
@@ -1067,7 +1067,7 @@ static void acpiphp_sanitize_bus(struct
 					res->end) {
 				/* Could not assign a required resources
 				 * for this device, remove it */
-				pci_remove_bus_device(dev);
+				pci_stop_and_remove_bus_device(dev);
 				break;
 			}
 		}
Index: linux-2.6/drivers/pci/hotplug/cpci_hotplug_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/cpci_hotplug_pci.c
+++ linux-2.6/drivers/pci/hotplug/cpci_hotplug_pci.c
@@ -341,7 +341,7 @@ int cpci_unconfigure_slot(struct slot* s
 		dev = pci_get_slot(slot->bus,
 				    PCI_DEVFN(PCI_SLOT(slot->devfn), i));
 		if (dev) {
-			pci_remove_bus_device(dev);
+			pci_stop_and_remove_bus_device(dev);
 			pci_dev_put(dev);
 		}
 	}
Index: linux-2.6/drivers/pci/hotplug/cpqphp_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/cpqphp_pci.c
+++ linux-2.6/drivers/pci/hotplug/cpqphp_pci.c
@@ -127,7 +127,7 @@ int cpqhp_unconfigure_device(struct pci_
 		struct pci_dev* temp = pci_get_bus_and_slot(func->bus, PCI_DEVFN(func->device, j));
 		if (temp) {
 			pci_dev_put(temp);
-			pci_remove_bus_device(temp);
+			pci_stop_and_remove_bus_device(temp);
 		}
 	}
 	return 0;
Index: linux-2.6/drivers/pci/hotplug/fakephp.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/fakephp.c
+++ linux-2.6/drivers/pci/hotplug/fakephp.c
@@ -40,7 +40,7 @@ static ssize_t legacy_show(struct kobjec
 
 static void remove_callback(void *data)
 {
-	pci_remove_bus_device((struct pci_dev *)data);
+	pci_stop_and_remove_bus_device((struct pci_dev *)data);
 }
 
 static ssize_t legacy_store(struct kobject *kobj, struct attribute *attr,
Index: linux-2.6/drivers/pci/hotplug/ibmphp_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/ibmphp_core.c
+++ linux-2.6/drivers/pci/hotplug/ibmphp_core.c
@@ -721,7 +721,7 @@ static void ibm_unconfigure_device(struc
 	for (j = 0; j < 0x08; j++) {
 		temp = pci_get_bus_and_slot(func->busno, (func->device << 3) | j);
 		if (temp) {
-			pci_remove_bus_device(temp);
+			pci_stop_and_remove_bus_device(temp);
 			pci_dev_put(temp);
 		}
 	}
Index: linux-2.6/drivers/pci/hotplug/pciehp_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_pci.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_pci.c
@@ -141,7 +141,7 @@ int pciehp_unconfigure_device(struct slo
 				break;
 			}
 		}
-		pci_remove_bus_device(temp);
+		pci_stop_and_remove_bus_device(temp);
 		/*
 		 * Ensure that no new Requests will be generated from
 		 * the device.
Index: linux-2.6/drivers/pci/hotplug/rpadlpar_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/rpadlpar_core.c
+++ linux-2.6/drivers/pci/hotplug/rpadlpar_core.c
@@ -389,7 +389,7 @@ int dlpar_remove_pci_slot(char *drc_name
 	BUG_ON(!bus->self);
 	pr_debug("PCI: Now removing bridge device %s\n", pci_name(bus->self));
 	eeh_remove_bus_device(bus->self);
-	pci_remove_bus_device(bus->self);
+	pci_stop_and_remove_bus_device(bus->self);
 
 	return 0;
 }
Index: linux-2.6/drivers/pci/hotplug/sgi_hotplug.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/sgi_hotplug.c
+++ linux-2.6/drivers/pci/hotplug/sgi_hotplug.c
@@ -554,7 +554,7 @@ static int disable_slot(struct hotplug_s
 				   	     PCI_FUNC(func)));
 		if (dev) {
 			sn_bus_free_data(dev);
-			pci_remove_bus_device(dev);
+			pci_stop_and_remove_bus_device(dev);
 			pci_dev_put(dev);
 		}
 	}
Index: linux-2.6/drivers/pci/hotplug/shpchp_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/shpchp_pci.c
+++ linux-2.6/drivers/pci/hotplug/shpchp_pci.c
@@ -124,7 +124,7 @@ int shpchp_unconfigure_device(struct slo
 				break;
 			}
 		}
-		pci_remove_bus_device(temp);
+		pci_stop_and_remove_bus_device(temp);
 		pci_dev_put(temp);
 	}
 	return rc;
Index: linux-2.6/drivers/pci/iov.c
===================================================================
--- linux-2.6.orig/drivers/pci/iov.c
+++ linux-2.6/drivers/pci/iov.c
@@ -142,7 +142,7 @@ failed2:
 failed1:
 	pci_dev_put(dev);
 	mutex_lock(&iov->dev->sriov->lock);
-	pci_remove_bus_device(virtfn);
+	pci_stop_and_remove_bus_device(virtfn);
 	virtfn_remove_bus(dev->bus, virtfn_bus(dev, id));
 	mutex_unlock(&iov->dev->sriov->lock);
 
@@ -182,7 +182,7 @@ static void virtfn_remove(struct pci_dev
 		sysfs_remove_link(&virtfn->dev.kobj, "physfn");
 
 	mutex_lock(&iov->dev->sriov->lock);
-	pci_remove_bus_device(virtfn);
+	pci_stop_and_remove_bus_device(virtfn);
 	virtfn_remove_bus(dev->bus, virtfn_bus(dev, id));
 	mutex_unlock(&iov->dev->sriov->lock);
 
Index: linux-2.6/drivers/pci/pci-sysfs.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-sysfs.c
+++ linux-2.6/drivers/pci/pci-sysfs.c
@@ -330,7 +330,7 @@ static void remove_callback(struct devic
 	struct pci_dev *pdev = to_pci_dev(dev);
 
 	mutex_lock(&pci_remove_rescan_mutex);
-	pci_remove_bus_device(pdev);
+	pci_stop_and_remove_bus_device(pdev);
 	mutex_unlock(&pci_remove_rescan_mutex);
 }
 
Index: linux-2.6/drivers/pci/remove.c
===================================================================
--- linux-2.6.orig/drivers/pci/remove.c
+++ linux-2.6/drivers/pci/remove.c
@@ -79,7 +79,7 @@ EXPORT_SYMBOL(pci_remove_bus);
 
 static void __pci_remove_behind_bridge(struct pci_dev *dev);
 /**
- * pci_remove_bus_device - remove a PCI device and any children
+ * pci_stop_and_remove_bus_device - remove a PCI device and any children
  * @dev: the device to remove
  *
  * Remove a PCI device from the device lists, informing the drivers
@@ -102,7 +102,7 @@ static void __pci_remove_bus_device(stru
 
 	pci_destroy_dev(dev);
 }
-void pci_remove_bus_device(struct pci_dev *dev)
+void pci_stop_and_remove_bus_device(struct pci_dev *dev)
 {
 	pci_stop_bus_device(dev);
 	__pci_remove_bus_device(dev);
@@ -145,7 +145,7 @@ static void pci_stop_bus_devices(struct
 	struct list_head *l, *n;
 
 	/*
-	 * VFs could be removed by pci_remove_bus_device() in the
+	 * VFs could be removed by pci_stop_and_remove_bus_device() in the
 	 *  pci_stop_bus_devices() code path for PF.
 	 *  aka, bus->devices get updated in the process.
 	 * but VFs are inserted after PFs when SRIOV is enabled for PF,
@@ -174,6 +174,6 @@ void pci_stop_bus_device(struct pci_dev
 	pci_stop_dev(dev);
 }
 
-EXPORT_SYMBOL(pci_remove_bus_device);
+EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
 EXPORT_SYMBOL(pci_remove_behind_bridge);
 EXPORT_SYMBOL_GPL(pci_stop_bus_device);
Index: linux-2.6/drivers/pci/xen-pcifront.c
===================================================================
--- linux-2.6.orig/drivers/pci/xen-pcifront.c
+++ linux-2.6/drivers/pci/xen-pcifront.c
@@ -544,7 +544,7 @@ static void free_root_bus_devs(struct pc
 		dev = container_of(bus->devices.next, struct pci_dev,
 				   bus_list);
 		dev_dbg(&dev->dev, "removing device\n");
-		pci_remove_bus_device(dev);
+		pci_stop_and_remove_bus_device(dev);
 	}
 }
 
@@ -1044,7 +1044,7 @@ static int pcifront_detach_devices(struc
 				domain, bus, slot, func);
 			continue;
 		}
-		pci_remove_bus_device(pci_dev);
+		pci_stop_and_remove_bus_device(pci_dev);
 		pci_dev_put(pci_dev);
 
 		dev_dbg(&pdev->xdev->dev,
Index: linux-2.6/drivers/platform/x86/asus-wmi.c
===================================================================
--- linux-2.6.orig/drivers/platform/x86/asus-wmi.c
+++ linux-2.6/drivers/platform/x86/asus-wmi.c
@@ -571,7 +571,7 @@ static void asus_rfkill_hotplug(struct a
 		} else {
 			dev = pci_get_slot(bus, 0);
 			if (dev) {
-				pci_remove_bus_device(dev);
+				pci_stop_and_remove_bus_device(dev);
 				pci_dev_put(dev);
 			}
 		}
Index: linux-2.6/drivers/platform/x86/eeepc-laptop.c
===================================================================
--- linux-2.6.orig/drivers/platform/x86/eeepc-laptop.c
+++ linux-2.6/drivers/platform/x86/eeepc-laptop.c
@@ -646,7 +646,7 @@ static void eeepc_rfkill_hotplug(struct
 		} else {
 			dev = pci_get_slot(bus, 0);
 			if (dev) {
-				pci_remove_bus_device(dev);
+				pci_stop_and_remove_bus_device(dev);
 				pci_dev_put(dev);
 			}
 		}
Index: linux-2.6/drivers/scsi/mpt2sas/mpt2sas_base.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ linux-2.6/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -132,7 +132,7 @@ static int mpt2sas_remove_dead_ioc_func(
 		pdev = ioc->pdev;
 		if ((pdev == NULL))
 			return -1;
-		pci_remove_bus_device(pdev);
+		pci_stop_and_remove_bus_device(pdev);
 		return 0;
 }
 
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -686,7 +686,7 @@ u8 pci_common_swizzle(struct pci_dev *de
 extern struct pci_dev *pci_dev_get(struct pci_dev *dev);
 extern void pci_dev_put(struct pci_dev *dev);
 extern void pci_remove_bus(struct pci_bus *b);
-extern void pci_remove_bus_device(struct pci_dev *dev);
+extern void pci_stop_and_remove_bus_device(struct pci_dev *dev);
 extern void pci_stop_bus_device(struct pci_dev *dev);
 void pci_setup_cardbus(struct pci_bus *bus);
 extern void pci_sort_breadthfirst(void);
