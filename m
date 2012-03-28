Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab2C1GW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 02:22:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:29776 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab2C1GWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 02:22:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="122519264"
From: Lin Ming <ming.m.lin@intel.com>
To: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        Aaron Lu <aaron.lu@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-acpi <linux-acpi@vger.kernel.org>
Subject: [PATCH v3 3/7] libata-acpi: register/unregister device to/from power resource
Date: Wed, 28 Mar 2012 14:21:58 +0800
Message-Id: <1332915722-15963-4-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1332915722-15963-1-git-send-email-ming.m.lin@intel.com>
References: <1332915722-15963-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uses the interface introduced in earlier patch.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-acpi.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index ba9382a..81ef0f5 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -1033,16 +1033,48 @@ static void ata_acpi_remove_pm_notifier(struct ata_device *dev)
 	}
 }
 
+static void ata_acpi_register_power_resource(struct ata_device *dev)
+{
+	struct scsi_device *sdev = dev->sdev;
+	acpi_handle handle;
+	struct device *device;
+
+	handle = ata_dev_acpi_handle(dev);
+	if (!handle)
+		return;
+
+	device = &sdev->sdev_gendev;
+
+	acpi_power_resource_register_device(device, handle);
+}
+
+static void ata_acpi_unregister_power_resource(struct ata_device *dev)
+{
+	struct scsi_device *sdev = dev->sdev;
+	acpi_handle handle;
+	struct device *device;
+
+	handle = ata_dev_acpi_handle(dev);
+	if (!handle)
+		return;
+
+	device = &sdev->sdev_gendev;
+
+	acpi_power_resource_unregister_device(device, handle);
+}
+
 void ata_acpi_bind(struct ata_device *dev)
 {
 	ata_acpi_bind_dock(dev);
 	ata_acpi_add_pm_notifier(dev);
+	ata_acpi_register_power_resource(dev);
 }
 
 void ata_acpi_unbind(struct ata_device *dev)
 {
 	ata_acpi_unbind_dock(dev);
 	ata_acpi_remove_pm_notifier(dev);
+	ata_acpi_unregister_power_resource(dev);
 }
 
 static int is_pci_ata(struct device *dev)
-- 
1.7.2.5

