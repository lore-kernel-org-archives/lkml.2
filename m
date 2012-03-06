Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab2CFHP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:15:26 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:31553 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260Ab2CFHPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:15:19 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 05/23] PCI: clean up rescan_bus_bridge_resize
Date: Mon,  5 Mar 2012 23:13:42 -0800
Message-Id: <1331018040-30725-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F55B985.0102,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should only use it with bridge instead of bus.
it could get new subordinate. so can not use it with reguar bus.

in that case, use may need to make all children devices get removed already.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci-sysfs.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index d5c8ffb..2049b2f 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -337,7 +337,7 @@ dev_bridge_rescan_store(struct device *dev, struct device_attribute *attr,
 
 	if (val) {
 		mutex_lock(&pci_remove_rescan_mutex);
-		pci_rescan_bus(pdev->subordinate);
+		pci_rescan_bus_bridge_resize(pdev);
 		mutex_unlock(&pci_remove_rescan_mutex);
 	}
 	return count;
@@ -387,10 +387,7 @@ dev_bus_rescan_store(struct device *dev, struct device_attribute *attr,
 
 	if (val) {
 		mutex_lock(&pci_remove_rescan_mutex);
-		if (!pci_is_root_bus(bus) && list_empty(&bus->devices))
-			pci_rescan_bus_bridge_resize(bus->self);
-		else
-			pci_rescan_bus(bus);
+		pci_rescan_bus(bus);
 		mutex_unlock(&pci_remove_rescan_mutex);
 	}
 	return count;
-- 
1.7.7

