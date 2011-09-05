Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab1IEGX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 02:23:58 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:62575 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab1IEGXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 02:23:50 -0400
Date: Mon, 05 Sep 2011 06:22:57 +0000
From: Shen Canquan <shencanquan@huawei.com>
Subject: Re : [PATCH] acpi: Fix hot cpu remove problem on acpi subsystem
X-Originating-IP: [10.166.80.171]
To: "lenb@kernel.org" <lenb@kernel.org>,
        "rui.zhao@intel.com" <rui.zhao@intel.com>,
        "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "yakui.zhao@intel.com" <yakui.zhao@intel.com>
Cc: "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>,
        hanweidong <hanweidong@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Message-id: <F1F5DF04259F1B4A82BD6BDE1C479F74098285B0@szxeml527-mbx.china.huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-language: zh-CN
Accept-Language: zh-CN, en-US
Thread-topic: Re : [PATCH] acpi: Fix hot cpu remove problem on acpi subsystem
Thread-index: AQHMa5Klrt6dbiK1O0qkk0+xwbGW1w==
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p856O9Q7006282

Hi Len,
    I have tested more than 10000 times of cpu remove and  add function in the latest kernel. The result of test is ok. The flow of  my test program is bellow:
    (1)  get random number of cpu .
    (2)  call xm vcpu-set <n> . depend on current cpu number. it simulate the function of add or remove cpu at random.
    (3) get the random number between 1 and 10.  
    (4) sleep random seconds which get from step 3.
    (5) repeat from step 1 to step 4.

   what's your opinion of this patch?

--
shencanquan
________________________________________
·¢¼şÈË: linux-kernel-owner@vger.kernel.org [linux-kernel-owner@vger.kernel.org] ´ú±í Shen Canquan [shencanquan@huawei.com]
·¢ËÍÊ±¼ä: 2011Äê8ÔÂ30ÈÕ 14:35
µ½: lenb@kernel.org; rui.zhao@intel.com; shemminger@vyatta.com; yakui.zhao@intel.com
Cc: xiaowei.yang@huawei.com; hanweidong; linux-kernel@vger.kernel.org; i@vger.kernel.org
Ö÷Ìâ: [PATCH] acpi: Fix hot cpu remove problem on acpi subsystem

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
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
