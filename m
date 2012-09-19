Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047Ab2ISTAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:00:36 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19698 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab2ISSza (ORCPT
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
Subject: [PATCH 23/40] PCI, ACPI: Pass device instead of handle when config root bridge
Date: Wed, 19 Sep 2012 11:54:37 -0700
Message-Id: <1348080894-23412-24-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348080894-23412-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com>
 <1348080894-23412-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we can avoid one calling of acpi_pci_find_root().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/pci_root_hp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/pci_root_hp.c b/drivers/acpi/pci_root_hp.c
index e07c31b..eb4344c 100644
--- a/drivers/acpi/pci_root_hp.c
+++ b/drivers/acpi/pci_root_hp.c
@@ -102,9 +102,9 @@ static void alloc_acpi_root_hp_work(acpi_handle handle, u32 type,
 }
 
 /* Program resources in newly inserted bridge */
-static void acpi_root_configure_bridge(acpi_handle handle)
+static void acpi_root_configure_bridge(struct acpi_device *device)
 {
-	struct acpi_pci_root *root = acpi_pci_find_root(handle);
+	struct acpi_pci_root *root = acpi_driver_data(device);
 
 	pcibios_resource_survey_bus(root->bus);
 	pci_assign_unassigned_bus_resources(root->bus);
@@ -138,7 +138,7 @@ static void handle_root_bridge_insertion(acpi_handle handle)
 		printk(KERN_ERR "cannot add bridge to acpi list\n");
 		return;
 	}
-	acpi_root_configure_bridge(handle);
+	acpi_root_configure_bridge(device);
 	if (acpi_bus_start(device))
 		printk(KERN_ERR "cannot start bridge\n");
 }
-- 
1.7.7

