Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab2FZJRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:17:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49768 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab2FZJRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:17:31 -0400
X-IronPort-AV: E=Sophos;i="4.77,476,1336320000"; 
   d="scan'208";a="5266089"
Message-ID: <4FE97F34.9090209@cn.fujitsu.com>
Date: Tue, 26 Jun 2012 17:21:56 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: [PATCH 6/8] bind the memory device when the driver is being loaded
References: <4FE97DD5.6030205@cn.fujitsu.com>
In-Reply-To: <4FE97DD5.6030205@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/26 17:17:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/26 17:17:44,
	Serialize complete at 2012/06/26 17:17:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We introduce acpi_hotmem_initialized to avoid strange add_memory fail message.
The stranged add_memory fail message is printed in register_memory_resource().
We have removed this message in the previous patch, so we can remove
it(it is very useful to the next patch).

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/acpi/acpi_memhotplug.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 2e5d5ab..148c88a 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -87,8 +87,6 @@ struct acpi_memory_device {
 	struct list_head res_list;
 };
 
-static int acpi_hotmem_initialized;
-
 static acpi_status
 acpi_memory_get_resource(struct acpi_resource *resource, void *context)
 {
@@ -463,15 +461,6 @@ static int acpi_memory_device_add(struct acpi_device *device)
 
 	printk(KERN_DEBUG "%s \n", acpi_device_name(device));
 
-	/*
-	 * Early boot code has recognized memory area by EFI/E820.
-	 * If DSDT shows these memory devices on boot, hotplug is not necessary
-	 * for them. So, it just returns until completion of this driver's
-	 * start up.
-	 */
-	if (!acpi_hotmem_initialized)
-		return 0;
-
 	if (!acpi_memory_check_device(mem_device)) {
 		/* call add_memory func */
 		result = acpi_memory_enable_device(mem_device);
@@ -578,7 +567,6 @@ static int __init acpi_memory_device_init(void)
 		return -ENODEV;
 	}
 
-	acpi_hotmem_initialized = 1;
 	return 0;
 }
 
-- 
1.7.1

