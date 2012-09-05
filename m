Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab2IEJUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:20:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:12823 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab2IEJUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:20:30 -0400
X-IronPort-AV: E=Sophos;i="4.80,373,1344182400"; 
   d="scan'208";a="5789084"
From: wency@cn.fujitsu.com
To: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org
Cc: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [RFC v9 PATCH 03/21] memory-hotplug: store the node id in acpi_memory_device
Date: Wed, 5 Sep 2012 17:25:37 +0800
Message-Id: <1346837155-534-4-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346837155-534-1-git-send-email-wency@cn.fujitsu.com>
References: <1346837155-534-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 17:20:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 17:20:03,
	Serialize complete at 2012/09/05 17:20:03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

The memory device has only one node id. Store the node id when
enable the memory device, and we can reuse it when removing the
memory device.

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
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 drivers/acpi/acpi_memhotplug.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 2a7beac..7873832 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -83,6 +83,7 @@ struct acpi_memory_info {
 struct acpi_memory_device {
 	struct acpi_device * device;
 	unsigned int state;	/* State of the memory device */
+	int nid;
 	struct list_head res_list;
 };
 
@@ -256,6 +257,9 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
 		info->enabled = 1;
 		num_enabled++;
 	}
+
+	mem_device->nid = node;
+
 	if (!num_enabled) {
 		printk(KERN_ERR PREFIX "add_memory failed\n");
 		mem_device->state = MEMORY_INVALID_STATE;
-- 
1.7.1

