Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab2G0KYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 06:24:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34862 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751839Ab2G0KYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 06:24:00 -0400
X-IronPort-AV: E=Sophos;i="4.77,666,1336320000"; 
   d="scan'208";a="5496360"
Message-ID: <50126D69.50409@cn.fujitsu.com>
Date: Fri, 27 Jul 2012 18:28:57 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com
CC: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: [RFC PATCH v5 06/19] memory-hotplug: export the function acpi_bus_remove()
References: <50126B83.3050201@cn.fujitsu.com>
In-Reply-To: <50126B83.3050201@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/27 18:24:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/27 18:24:28,
	Serialize complete at 2012/07/27 18:24:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function acpi_bus_remove() can remove a acpi device from acpi device.
When a acpi device is removed, we need to call this function to remove
the acpi device from acpi bus. So export this function.

CC: David Rientjes <rientjes@google.com>
CC: Jiang Liu <liuj97@gmail.com>
CC: Len Brown <len.brown@intel.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/acpi/scan.c     |    3 ++-
 include/acpi/acpi_bus.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index d1ecca2..1cefc34 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1224,7 +1224,7 @@ static int acpi_device_set_context(struct acpi_device *device)
 	return -ENODEV;
 }
 
-static int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
+int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
 {
 	if (!dev)
 		return -EINVAL;
@@ -1246,6 +1246,7 @@ static int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
 
 	return 0;
 }
+EXPORT_SYMBOL(acpi_bus_remove);
 
 static int acpi_add_single_object(struct acpi_device **child,
 				  acpi_handle handle, int type,
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index bde976e..2ccf109 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -360,6 +360,7 @@ bool acpi_bus_power_manageable(acpi_handle handle);
 bool acpi_bus_can_wakeup(acpi_handle handle);
 int acpi_power_resource_register_device(struct device *dev, acpi_handle handle);
 void acpi_power_resource_unregister_device(struct device *dev, acpi_handle handle);
+int acpi_bus_remove(struct acpi_device *dev, int rmdevice);
 #ifdef CONFIG_ACPI_PROC_EVENT
 int acpi_bus_generate_proc_event(struct acpi_device *device, u8 type, int data);
 int acpi_bus_generate_proc_event4(const char *class, const char *bid, u8 type, int data);
-- 
1.7.1

