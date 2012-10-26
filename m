Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab2JZKsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 06:48:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:21852 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758250Ab2JZKsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 06:48:12 -0400
X-IronPort-AV: E=Sophos;i="4.80,654,1344182400"; 
   d="scan'208";a="6078657"
From: wency@cn.fujitsu.com
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: liuj97@gmail.com, len.brown@intel.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        rjw@sisk.pl, laijs@cn.fujitsu.com, Wen Congyang <wency@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Christoph Lameter <cl@linux.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v3 1/3] acpi,memory-hotplug: call acpi_bus_trim() to remove memory device
Date: Fri, 26 Oct 2012 18:31:01 +0800
Message-Id: <1351247463-5653-2-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351247463-5653-1-git-send-email-wency@cn.fujitsu.com>
References: <1351247463-5653-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/26 18:24:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/26 18:24:54,
	Serialize complete at 2012/10/26 18:24:54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

The memory device has been ejected and powoffed, so we can call
acpi_bus_trim() to remove the memory device from acpi bus.

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
 drivers/acpi/acpi_memhotplug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 24c807f..1e90e8f 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -401,8 +401,9 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 		}
 
 		/*
-		 * TBD: Invoke acpi_bus_remove to cleanup data structures
+		 * Invoke acpi_bus_trim() to remove memory device
 		 */
+		acpi_bus_trim(device, 1);
 
 		/* _EJ0 succeeded; _OST is not necessary */
 		return;
-- 
1.8.0

