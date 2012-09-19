Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab2ISTAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:00:43 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48035 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987Ab2ISSza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:55:30 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 26/40] PCI, ACPI: del root bus prt
Date: Wed, 19 Sep 2012 11:54:40 -0700
Message-Id: <1348080894-23412-27-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348080894-23412-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com>
 <1348080894-23412-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

corresponding to add path.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/pci_root.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 92ec5c9..b72c85c 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -650,6 +650,8 @@ static int acpi_pci_root_start(struct acpi_device *device)
 
 static int acpi_pci_root_remove(struct acpi_device *device, int type)
 {
+	acpi_status status;
+	acpi_handle handle;
 	struct acpi_pci_root *root = acpi_driver_data(device);
 
 	/* that root bus could be removed already */
@@ -664,6 +666,10 @@ static int acpi_pci_root_remove(struct acpi_device *device, int type)
 	device_set_run_wake(root->bus->bridge, false);
 	pci_acpi_remove_bus_pm_notifier(device);
 
+	status = acpi_get_handle(device->handle, METHOD_NAME__PRT, &handle);
+	if (ACPI_SUCCESS(status))
+		acpi_pci_irq_del_prt(root->bus);
+
 	dev_printk(KERN_DEBUG, &device->dev,
 		"freeing acpi_pci_root, will remove pci root bus at first");
 	pci_remove_root_bus(root->bus);
-- 
1.7.7

