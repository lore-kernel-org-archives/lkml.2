Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab2GRUqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 16:46:24 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:13363 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab2GRUqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 16:46:06 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 4/4] ACPI: Update Container hotplug messages
Date: Wed, 18 Jul 2012 14:40:27 -0600
Message-Id: <1342644027-19559-5-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342644027-19559-1-git-send-email-toshi.kani@hp.com>
References: <1342644027-19559-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated Container hotplug log messages with acpi_pr_<level>()
and pr_<level>().

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/container.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
index 01a986d..6672386 100644
--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -99,7 +99,7 @@ static int acpi_container_add(struct acpi_device *device)
 
 
 	if (!device) {
-		printk(KERN_ERR PREFIX "device is NULL\n");
+		pr_err(PREFIX "device is NULL\n");
 		return -EINVAL;
 	}
 
@@ -164,7 +164,7 @@ static void container_notify_cb(acpi_handle handle, u32 type, void *context)
 	case ACPI_NOTIFY_BUS_CHECK:
 		/* Fall through */
 	case ACPI_NOTIFY_DEVICE_CHECK:
-		printk(KERN_WARNING "Container driver received %s event\n",
+		acpi_pr_warn(handle, "Container driver received %s event\n",
 		       (type == ACPI_NOTIFY_BUS_CHECK) ?
 		       "ACPI_NOTIFY_BUS_CHECK" : "ACPI_NOTIFY_DEVICE_CHECK");
 
@@ -185,7 +185,7 @@ static void container_notify_cb(acpi_handle handle, u32 type, void *context)
 
 		result = container_device_add(&device, handle);
 		if (result) {
-			pr_warn("Failed to add container\n");
+			acpi_pr_warn(handle, "Failed to add container\n");
 			break;
 		}
 
-- 
1.7.7.6

