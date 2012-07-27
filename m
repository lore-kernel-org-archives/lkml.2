Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab2G0DLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 23:11:03 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:16943 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab2G0DLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 23:11:00 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v4 4/4] ACPI: Update Container hotplug messages
Date: Thu, 26 Jul 2012 21:05:44 -0600
Message-Id: <1343358344-31517-5-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1343358344-31517-1-git-send-email-toshi.kani@hp.com>
References: <1343358344-31517-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated Container hotplug log messages with acpi_pr_<level>()
and pr_<level>().  Removed unnecessary check to device pointer.

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

