Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab2BYVzt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 16:55:49 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:41818 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab2BYVyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 16:54:54 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/4] PCI: Rename pci_remove_behind_bridge to pci_stop_and_remove_behind_bridge
Date: Sat, 25 Feb 2012 13:54:22 -0800
Message-Id: <1330206863-31381-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330206863-31381-1-git-send-email-yinghai@kernel.org>
References: <1330206863-31381-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F4958A8.0076,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

old pci_remove_behind_bridge actually do stop and remove.

Make the name reflect that, and less confusing.

Suggested-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/remove.c     |    7 ++++---
 drivers/pcmcia/cardbus.c |    2 +-
 include/linux/pci.h      |    2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/pci/remove.c
===================================================================
--- linux-2.6.orig/drivers/pci/remove.c
+++ linux-2.6/drivers/pci/remove.c
@@ -127,14 +127,15 @@ static void pci_stop_behind_bridge(struc
 }
 
 /**
- * pci_remove_behind_bridge - remove all devices behind a PCI bridge
+ * pci_stop_and_remove_behind_bridge - stop and remove all devices behind
+ *					 a PCI bridge
  * @dev: PCI bridge device
  *
  * Remove all devices on the bus, except for the parent bridge.
  * This also removes any child buses, and any devices they may
  * contain in a depth-first manner.
  */
-void pci_remove_behind_bridge(struct pci_dev *dev)
+void pci_stop_and_remove_behind_bridge(struct pci_dev *dev)
 {
 	pci_stop_behind_bridge(dev);
 	__pci_remove_behind_bridge(dev);
@@ -175,5 +176,5 @@ void pci_stop_bus_device(struct pci_dev
 }
 
 EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
-EXPORT_SYMBOL(pci_remove_behind_bridge);
+EXPORT_SYMBOL(pci_stop_and_remove_behind_bridge);
 EXPORT_SYMBOL_GPL(pci_stop_bus_device);
Index: linux-2.6/drivers/pcmcia/cardbus.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/cardbus.c
+++ linux-2.6/drivers/pcmcia/cardbus.c
@@ -108,5 +108,5 @@ void cb_free(struct pcmcia_socket *s)
 	struct pci_dev *bridge = s->cb_dev;
 
 	if (bridge)
-		pci_remove_behind_bridge(bridge);
+		pci_stop_and_remove_behind_bridge(bridge);
 }
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -959,7 +959,7 @@ void pci_unregister_driver(struct pci_dr
 	module_driver(__pci_driver, pci_register_driver, \
 		       pci_unregister_driver)
 
-void pci_remove_behind_bridge(struct pci_dev *dev);
+void pci_stop_and_remove_behind_bridge(struct pci_dev *dev);
 struct pci_driver *pci_dev_driver(const struct pci_dev *dev);
 int pci_add_dynid(struct pci_driver *drv,
 		  unsigned int vendor, unsigned int device,
