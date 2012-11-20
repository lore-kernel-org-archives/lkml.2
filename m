Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2KTUxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:53:45 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:13257 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab2KTUxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:53:40 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org, rjw@sisk.pl, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, vijaymohan.pandarathil@hp.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v6 4/5] ACPI: Update Container hotplug error messages
Date: Tue, 20 Nov 2012 13:44:53 -0700
Message-Id: <1353444294-25575-5-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353444294-25575-1-git-send-email-toshi.kani@hp.com>
References: <1353444294-25575-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated Container hotplug error messages with acpi_handle_<level>()
and pr_<level>().  Removed an unnecessary check to the device arg
in acpi_container_add().

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/container.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
index 69e2d6b..811910b 100644
--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -110,12 +110,6 @@ static int acpi_container_add(struct acpi_device *device)
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
@@ -177,7 +171,7 @@ static void container_notify_cb(acpi_handle handle, u32 type, void *context)
 	case ACPI_NOTIFY_BUS_CHECK:
 		/* Fall through */
 	case ACPI_NOTIFY_DEVICE_CHECK:
-		printk(KERN_WARNING "Container driver received %s event\n",
+		pr_debug("Container driver received %s event\n",
 		       (type == ACPI_NOTIFY_BUS_CHECK) ?
 		       "ACPI_NOTIFY_BUS_CHECK" : "ACPI_NOTIFY_DEVICE_CHECK");
 
@@ -198,7 +192,7 @@ static void container_notify_cb(acpi_handle handle, u32 type, void *context)
 
 		result = container_device_add(&device, handle);
 		if (result) {
-			printk(KERN_WARNING "Failed to add container\n");
+			acpi_handle_warn(handle, "Failed to add container\n");
 			break;
 		}
 
-- 
1.7.11.7

