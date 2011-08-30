Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab1H3Gfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 02:35:46 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:61551 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab1H3Gfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 02:35:45 -0400
Date: Tue, 30 Aug 2011 06:35:30 +0000
From: Shen Canquan <shencanquan@huawei.com>
Subject: [PATCH] acpi: Fix hot cpu remove problem on acpi subsystem
X-Originating-IP: [10.166.80.171]
To: "lenb@kernel.org" <lenb@kernel.org>,
        "rui.zhao@intel.com" <rui.zhao@intel.com>,
        "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "yakui.zhao@intel.com" <yakui.zhao@intel.com>
Cc: "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>,
        hanweidong <hanweidong@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "i@vger.kernel.org" <i@vger.kernel.org>
Message-id: <F1F5DF04259F1B4A82BD6BDE1C479F740981947A@szxeml527-mbs.china.huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: zh-CN
Content-transfer-encoding: 7BIT
Accept-Language: zh-CN, en-US
Thread-topic: [PATCH] acpi: Fix hot cpu remove problem on acpi subsystem
Thread-index: Acxm3pMuZngxJ3CxS9a2LSRB4DJDLg==
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Xen virtualization environment, When I used xen tools (xm vcpu-set vcpu_number ) to test the vcpu add and remove, I found it is failure on vcpu remove, I found the reason is that nothing to do when cpu remove in acpi_processor_hotplug_notify function, so I add the code of send the OFFLINE message to udev and add the rule of udev. it is ok on vcpu remove.
Signed-off-by: Shen canquan <shencanquan@huawei.com>
---
 drivers/acpi/processor_driver.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index a4e0f1b..a1c564f 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -677,6 +677,8 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
                                     "Driver data is NULL, dropping EJECT\n");
                         return;
                 }
+
+               kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
                 break;
         default:
                 ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-- 
1.7.6.msysgit.0
