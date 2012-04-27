Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760490Ab2D0PUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:20:09 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:38951 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760473Ab2D0PUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:20:06 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v2 01/19] PCI: introduce pci_bus_get()/pci_bus_put() to hide PCI implementation details
Date: Fri, 27 Apr 2012 23:16:42 +0800
Message-Id: <1335539820-11232-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
References: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Introduce pci_bus_get()/pci_bus_put() to hide PCI implementation details.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/bus.c   |   15 +++++++++++++++
 include/linux/pci.h |    2 ++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 4ce5ef2..50f9c5d 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -35,6 +35,21 @@ void pci_add_resource_offset(struct list_head *resources, struct resource *res,
 }
 EXPORT_SYMBOL(pci_add_resource_offset);
 
+struct pci_bus *pci_bus_get(struct pci_bus *bus)
+{
+	if (bus)
+		get_device(&bus->dev);
+	return bus;
+}
+EXPORT_SYMBOL(pci_bus_get);
+
+void pci_bus_put(struct pci_bus *bus)
+{
+	if (bus)
+		put_device(&bus->dev);
+}
+EXPORT_SYMBOL(pci_bus_put);
+
 void pci_add_resource(struct list_head *resources, struct resource *res)
 {
 	pci_add_resource_offset(resources, res, 0);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index e444f5b..0603a60 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -912,6 +912,8 @@ int pci_request_selected_regions_exclusive(struct pci_dev *, int, const char *);
 void pci_release_selected_regions(struct pci_dev *, int);
 
 /* drivers/pci/bus.c */
+struct pci_bus *pci_bus_get(struct pci_bus *bus);
+void pci_bus_put(struct pci_bus *bus);
 void pci_add_resource(struct list_head *resources, struct resource *res);
 void pci_add_resource_offset(struct list_head *resources, struct resource *res,
 			     resource_size_t offset);
-- 
1.7.5.4

