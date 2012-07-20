Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab2GTQ7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 12:59:34 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:2572 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab2GTQ7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 12:59:32 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v2 3/4] ACPI: Update Memory hotplug messages
Date: Fri, 20 Jul 2012 10:54:15 -0600
Message-Id: <1342803256-17514-4-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342803256-17514-1-git-send-email-toshi.kani@hp.com>
References: <1342803256-17514-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated Memory hotplug log messages with acpi_pr_<level>()
and pr_<level>().

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/acpi_memhotplug.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 06c55cd..dcc8f4d 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -170,7 +170,7 @@ acpi_memory_get_device(acpi_handle handle,
 	/* Get the parent device */
 	result = acpi_bus_get_device(phandle, &pdevice);
 	if (result) {
-		printk(KERN_WARNING PREFIX "Cannot get acpi bus device");
+		acpi_pr_warn(phandle, "Cannot get acpi bus device\n");
 		return -EINVAL;
 	}
 
@@ -180,14 +180,14 @@ acpi_memory_get_device(acpi_handle handle,
 	 */
 	result = acpi_bus_add(&device, pdevice, handle, ACPI_BUS_TYPE_DEVICE);
 	if (result) {
-		printk(KERN_WARNING PREFIX "Cannot add acpi bus");
+		acpi_pr_warn(handle, "Cannot add acpi bus\n");
 		return -EINVAL;
 	}
 
       end:
 	*mem_device = acpi_driver_data(device);
 	if (!(*mem_device)) {
-		printk(KERN_ERR "\n driver data not found");
+		acpi_pr_err(handle, "driver data not found\n");
 		return -ENODEV;
 	}
 
@@ -224,7 +224,7 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
 	/* Get the range from the _CRS */
 	result = acpi_memory_get_device_resources(mem_device);
 	if (result) {
-		printk(KERN_ERR PREFIX "get_device_resources failed\n");
+		pr_err(PREFIX "get_device_resources failed\n");
 		mem_device->state = MEMORY_INVALID_STATE;
 		return result;
 	}
@@ -257,7 +257,7 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
 		num_enabled++;
 	}
 	if (!num_enabled) {
-		printk(KERN_ERR PREFIX "add_memory failed\n");
+		acpi_pr_err(mem_device->device->handle, "add_memory failed\n");
 		mem_device->state = MEMORY_INVALID_STATE;
 		return -EINVAL;
 	}
@@ -353,7 +353,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 					  "\nReceived DEVICE CHECK notification for device\n"));
 		if (acpi_memory_get_device(handle, &mem_device)) {
-			printk(KERN_ERR PREFIX "Cannot find driver data\n");
+			acpi_pr_err(handle, "Cannot find driver data\n");
 			break;
 		}
 
@@ -361,7 +361,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 			break;
 
 		if (acpi_memory_enable_device(mem_device)) {
-			pr_err(PREFIX "Cannot enable memory device\n");
+			acpi_pr_err(handle, "Cannot enable memory device\n");
 			break;
 		}
 
@@ -373,12 +373,12 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 				  "\nReceived EJECT REQUEST notification for device\n"));
 
 		if (acpi_bus_get_device(handle, &device)) {
-			printk(KERN_ERR PREFIX "Device doesn't exist\n");
+			acpi_pr_err(handle, "Device doesn't exist\n");
 			break;
 		}
 		mem_device = acpi_driver_data(device);
 		if (!mem_device) {
-			printk(KERN_ERR PREFIX "Driver Data is NULL\n");
+			acpi_pr_err(handle, "Driver Data is NULL\n");
 			break;
 		}
 
@@ -389,7 +389,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 		 *      with generic sysfs driver
 		 */
 		if (acpi_memory_disable_device(mem_device)) {
-			pr_err(PREFIX "Disable memory device\n");
+			acpi_pr_err(handle, "Disable memory device\n");
 			/*
 			 * If _EJ0 was called but failed, _OST is not
 			 * necessary.
@@ -449,7 +449,7 @@ static int acpi_memory_device_add(struct acpi_device *device)
 	/* Set the device state */
 	mem_device->state = MEMORY_POWER_ON_STATE;
 
-	printk(KERN_DEBUG "%s \n", acpi_device_name(device));
+	pr_debug("%s\n", acpi_device_name(device));
 
 	/*
 	 * Early boot code has recognized memory area by EFI/E820.
@@ -464,7 +464,7 @@ static int acpi_memory_device_add(struct acpi_device *device)
 		/* call add_memory func */
 		result = acpi_memory_enable_device(mem_device);
 		if (result)
-			printk(KERN_ERR PREFIX
+			acpi_pr_err(device->handle,
 				"Error in acpi_memory_enable_device\n");
 	}
 	return result;
-- 
1.7.7.6

