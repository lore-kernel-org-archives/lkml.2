Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161424Ab2CSFr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:47:58 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29411 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161366Ab2CSFry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:47:54 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 21/47] PCI: Move pci_stop_and_remove_behind_bridge() down
Date: Sun, 18 Mar 2012 22:46:10 -0700
Message-Id: <1332135996-13860-22-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F66C886.00F0,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Later it will use pci_stop_bus_devices instead of pci_stop_behind_bridge.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/remove.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index bf4b46b..3f540ce 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -128,21 +128,6 @@ static void pci_stop_behind_bridge(struct pci_dev *dev)
 			pci_stop_bus_device(pci_dev_b(l));
 }
 
-/**
- * pci_stop_and_remove_behind_bridge - stop and remove all devices behind
- *					 a PCI bridge
- * @dev: PCI bridge device
- *
- * Remove all devices on the bus, except for the parent bridge.
- * This also removes any child buses, and any devices they may
- * contain in a depth-first manner.
- */
-void pci_stop_and_remove_behind_bridge(struct pci_dev *dev)
-{
-	pci_stop_behind_bridge(dev);
-	__pci_remove_behind_bridge(dev);
-}
-
 static void pci_stop_bus_devices(struct pci_bus *bus)
 {
 	struct list_head *l, *n;
@@ -162,6 +147,21 @@ static void pci_stop_bus_devices(struct pci_bus *bus)
 }
 
 /**
+ * pci_stop_and_remove_behind_bridge - stop and remove all devices behind
+ *					 a PCI bridge
+ * @dev: PCI bridge device
+ *
+ * Remove all devices on the bus, except for the parent bridge.
+ * This also removes any child buses, and any devices they may
+ * contain in a depth-first manner.
+ */
+void pci_stop_and_remove_behind_bridge(struct pci_dev *dev)
+{
+	pci_stop_behind_bridge(dev);
+	__pci_remove_behind_bridge(dev);
+}
+
+/**
  * pci_stop_bus_device - stop a PCI device and any children
  * @dev: the device to stop
  *
-- 
1.7.7

