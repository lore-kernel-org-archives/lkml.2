Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320Ab1GYMJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:09:42 -0400
Received: from szxga04-in.huawei.com ([119.145.14.67]:53720 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1GYMJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:09:37 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jul 2011 08:09:37 EDT
Date: Mon, 25 Jul 2011 12:04:34 +0000
From: Shen Canquan <shencanquan@huawei.com>
Subject: [Patch 1/1] Hot cpu remove patch
X-Originating-IP: [10.166.80.171]
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <F1F5DF04259F1B4A82BD6BDE1C479F7452CA25@szxeml527-mbs.china.huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-2022-jp
Content-language: zh-CN
Content-transfer-encoding: 7BIT
Accept-Language: zh-CN, en-US
Thread-topic: [Patch 1/1] Hot cpu remove patch
Thread-index: AcxKwwTscly5Ni+pSyGATuH8x4jTLg==
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello，
   Recently, I test the cpu hot add and remove function. It is ok for cpu hot add. but it is failure on cpu hot remove . If I modify the source code(Please see the following patch content). It is successful on cpu hot remove.
patch content:
 
--- linux-2.6.39.3_modify/drivers/acpi/processor_driver.c       2011-07-25 09:11:51.000000000 +0800
+++ linux-2.6.39.3/drivers/acpi/processor_driver.c      2011-07-09 14:16:06.000000000 +0800
@@ -677,11 +677,6 @@
                                    "Driver data is NULL, dropping EJECT\n");
                        return;
                }
-               /*The alternative way of modify is add the following code:
-                       kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
-               */
-               /*async execute the acip_bus_hot_remove_device*/
-               acpi_os_hotplug_execute(acpi_bus_hot_remove_device, handle);
                break;
        default:
                ACPI_DEBUG_PRINT((ACPI_DB_INFO,
diff -u -r linux-2.6.39.3_modify/drivers/acpi/scan.c linux-2.6.39.3/drivers/acpi/scan.c
--- linux-2.6.39.3_modify/drivers/acpi/scan.c   2011-07-20 15:28:52.000000000 +0800
+++ linux-2.6.39.3/drivers/acpi/scan.c  2011-07-09 14:16:06.000000000 +0800
@@ -83,7 +83,7 @@
 }
 static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
- void acpi_bus_hot_remove_device(void *context)
+static void acpi_bus_hot_remove_device(void *context)
 {
        struct acpi_device *device;
        acpi_handle handle = context;
diff -u -r linux-2.6.39.3_modify/include/acpi/acpi_bus.h linux-2.6.39.3/include/acpi/acpi_bus.h
--- linux-2.6.39.3_modify/include/acpi/acpi_bus.h       2011-07-20 15:30:04.000000000 +0800
+++ linux-2.6.39.3/include/acpi/acpi_bus.h      2011-07-09 14:16:06.000000000 +0800
@@ -342,7 +342,7 @@
                          const struct acpi_device_id *ids);
 int acpi_create_dir(struct acpi_device *);
 void acpi_remove_dir(struct acpi_device *);
-void acpi_bus_hot_remove_device(void *context);
+
 /*
  * Bind physical devices with ACPI devices
                                               
 */
 
 
Jason.shen
2011-07-25
