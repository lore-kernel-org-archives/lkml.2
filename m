Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab1JSCs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 22:48:58 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:34778 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab1JSCs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 22:48:56 -0400
From: pingfank@linux.vnet.ibm.com
To: linux-acpi@vger.kernel.org, seabios@seabios.org, lenb@kernel.org,
        shaohua.li@intel.com
Cc: linux-kernel@vger.kernel.org, qemu-devel@nongnu.org, aliguori@us.ibm.com,
        dave@linux.vnet.ibm.com, Liu Ping Fan <pingfank@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ACPI: Call ACPI remove handler when handling ACPI eject event
Date: Wed, 19 Oct 2011 10:47:50 +0800
Message-Id: <1318992470-10195-2-git-send-email-pingfank@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318992470-10195-1-git-send-email-pingfank@linux.vnet.ibm.com>
References: <1318992470-10195-1-git-send-email-pingfank@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

Call the remove handler for ACPI_NOTIFY_EJECT_REQUEST

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 drivers/acpi/bus.c      |    2 +-
 drivers/acpi/scan.c     |    2 +-
 include/acpi/acpi_bus.h |    2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 437ddbf..d06ec6d 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -764,7 +764,7 @@ static void acpi_bus_notify(acpi_handle handle, u32 type, void *data)
 		break;
 
 	case ACPI_NOTIFY_EJECT_REQUEST:
-		/* TBD */
+		acpi_os_hotplug_execute(acpi_bus_hot_remove_device, handle);
 		break;
 
 	case ACPI_NOTIFY_DEVICE_CHECK_LIGHT:
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 449c556..3b97b61 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -83,7 +83,7 @@ acpi_device_modalias_show(struct device *dev, struct device_attribute *attr, cha
 }
 static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
 
-static void acpi_bus_hot_remove_device(void *context)
+void acpi_bus_hot_remove_device(void *context)
 {
 	struct acpi_device *device;
 	acpi_handle handle = context;
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 6cd5b64..b19c09d 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -310,6 +310,8 @@ extern int unregister_acpi_notifier(struct notifier_block *);
 
 extern int register_acpi_bus_notifier(struct notifier_block *nb);
 extern void unregister_acpi_bus_notifier(struct notifier_block *nb);
+extern void acpi_bus_hot_remove_device(void *context);
+
 /*
  * External Functions
  */
-- 
1.7.4.4

