Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab2H1TJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 15:09:52 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:37127 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab2H1TJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 15:09:38 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, vijaymohan.pandarathil@hp.com,
        shaohua.li@intel.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v5 4/5] ACPI: Update Container hotplug error messages
Date: Tue, 28 Aug 2012 13:03:00 -0600
Message-Id: <1346180581-12641-5-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1346180581-12641-1-git-send-email-toshi.kani@hp.com>
References: <1346180581-12641-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated Container hotplug error messages with acpi_pr_<level>()
and pr_<level>().  Removed an unnecessary check to device pointer
in acpi_container_add().

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/container.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
index 1f9f7d7..519c1d6 100644
--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -97,12 +97,6 @@ static int acpi_container_add(struct acpi_device *device)
 {
 	struct acpi_container *container;
 
-
-	if (!device) {
-		printk(KERN_ERR PREFIX "device is NULL\n");
-		return -EINVAL;
-	}
-
 	container = kzalloc(sizeof(struct acpi_container), GFP_KERNEL);
 	if (!container)
 		return -ENOMEM;
@@ -164,7 +158,7 @@ static void container_notify_cb(acpi_handle handle, u32 type, void *context)
 	case ACPI_NOTIFY_BUS_CHECK:
 		/* Fall through */
 	case ACPI_NOTIFY_DEVICE_CHECK:
-		printk(KERN_WARNING "Container driver received %s event\n",
+		pr_debug("Container driver received %s event\n",
 		       (type == ACPI_NOTIFY_BUS_CHECK) ?
 		       "ACPI_NOTIFY_BUS_CHECK" : "ACPI_NOTIFY_DEVICE_CHECK");
 
@@ -185,7 +179,7 @@ static void container_notify_cb(acpi_handle handle, u32 type, void *context)
 
 		result = container_device_add(&device, handle);
 		if (result) {
-			printk(KERN_WARNING "Failed to add container\n");
+			acpi_pr_warn(handle, "Failed to add container\n");
 			break;
 		}
 
-- 
1.7.7.6

