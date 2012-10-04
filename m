Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab2JDBsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:48:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33408 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2JDBs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:48:28 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <506CEADA.9060108@jp.fujitsu.com>
Date: Thu, 4 Oct 2012 10:48:10 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
CC: <len.brown@intel.com>, <wency@cn.fujitsu.com>
Subject: [PATCH 2/2] acpi,memory-hotplug : call acpi_bus_remo() to remove
 memory device
References: <506CE9F5.8020809@jp.fujitsu.com>
In-Reply-To: <506CE9F5.8020809@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

The memory device has been ejected and powoffed, so we can call
acpi_bus_remove() to remove the memory device from acpi bus.

CC: Len Brown <len.brown@intel.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/acpi/acpi_memhotplug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-3.6/drivers/acpi/acpi_memhotplug.c
===================================================================
--- linux-3.6.orig/drivers/acpi/acpi_memhotplug.c	2012-10-03 18:17:47.802249170 +0900
+++ linux-3.6/drivers/acpi/acpi_memhotplug.c	2012-10-03 18:17:52.471250299 +0900
@@ -424,8 +424,9 @@ static void acpi_memory_device_notify(ac
 		}
 
 		/*
-		 * TBD: Invoke acpi_bus_remove to cleanup data structures
+		 * Invoke acpi_bus_remove() to remove memory device
 		 */
+		acpi_bus_remove(device, 1);
 
 		/* _EJ0 succeeded; _OST is not necessary */
 		return;

