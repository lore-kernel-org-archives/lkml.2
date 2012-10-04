Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2JDBrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:47:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33347 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab2JDBrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:47:14 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <506CEA90.4020309@jp.fujitsu.com>
Date: Thu, 4 Oct 2012 10:46:56 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
CC: <len.brown@intel.com>, <wency@cn.fujitsu.com>
Subject: [PATCH 1/2] acpi,memory-hotplug : export the function acpi_bus_remove()
References: <506CE9F5.8020809@jp.fujitsu.com>
In-Reply-To: <506CE9F5.8020809@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

The function acpi_bus_remove() can remove a acpi device from acpi bus.
When a acpi device is removed, we need to call this function to remove
the acpi device from acpi bus. So export this function.

CC: Len Brown <len.brown@intel.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/acpi/scan.c     |    3 ++-
 include/acpi/acpi_bus.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-3.6/drivers/acpi/scan.c
===================================================================
--- linux-3.6.orig/drivers/acpi/scan.c	2012-10-03 18:16:57.206246798 +0900
+++ linux-3.6/drivers/acpi/scan.c	2012-10-03 18:17:49.974249714 +0900
@@ -1224,7 +1224,7 @@ static int acpi_device_set_context(struc
 	return -ENODEV;
 }
 
-static int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
+int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
 {
 	if (!dev)
 		return -EINVAL;
@@ -1246,6 +1246,7 @@ static int acpi_bus_remove(struct acpi_d
 
 	return 0;
 }
+EXPORT_SYMBOL(acpi_bus_remove);
 
 static int acpi_add_single_object(struct acpi_device **child,
 				  acpi_handle handle, int type,
Index: linux-3.6/include/acpi/acpi_bus.h
===================================================================
--- linux-3.6.orig/include/acpi/acpi_bus.h	2012-10-03 18:16:57.208246800 +0900
+++ linux-3.6/include/acpi/acpi_bus.h	2012-10-03 18:17:49.976249717 +0900
@@ -360,6 +360,7 @@ bool acpi_bus_power_manageable(acpi_hand
 bool acpi_bus_can_wakeup(acpi_handle handle);
 int acpi_power_resource_register_device(struct device *dev, acpi_handle handle);
 void acpi_power_resource_unregister_device(struct device *dev, acpi_handle handle);
+int acpi_bus_remove(struct acpi_device *dev, int rmdevice);
 #ifdef CONFIG_ACPI_PROC_EVENT
 int acpi_bus_generate_proc_event(struct acpi_device *device, u8 type, int data);
 int acpi_bus_generate_proc_event4(const char *class, const char *bid, u8 type, int data);

