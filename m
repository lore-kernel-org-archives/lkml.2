Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab2JCKDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 06:03:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57396 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab2JCKDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 06:03:11 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <506C0D45.3050909@jp.fujitsu.com>
Date: Wed, 3 Oct 2012 19:02:45 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <x86@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>
CC: <rientjes@google.com>, <liuj97@gmail.com>, <len.brown@intel.com>,
        <cl@linux.com>, <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: [PATCH 2/4] acpi,memory-hotplug : rename remove_memory() to offline_memory()
References: <506C0AE8.40702@jp.fujitsu.com>
In-Reply-To: <506C0AE8.40702@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

add_memory() hot adds a physical memory. But remove_memory does not
hot remove a phsical memory. It only offlines memory. The name
confuse us.

So the patch renames remove_memory() to offline_memory(). We will
use rename_memory() for hot removing memory.

CC: David Rientjes <rientjes@google.com>
CC: Jiang Liu <liuj97@gmail.com>
CC: Len Brown <len.brown@intel.com>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> 
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/acpi/acpi_memhotplug.c |    2 +-
 include/linux/memory_hotplug.h |    2 +-
 mm/memory_hotplug.c            |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-3.6/drivers/acpi/acpi_memhotplug.c
===================================================================
--- linux-3.6.orig/drivers/acpi/acpi_memhotplug.c	2012-10-03 18:17:29.291244669 +0900
+++ linux-3.6/drivers/acpi/acpi_memhotplug.c	2012-10-03 18:17:41.494247869 +0900
@@ -316,7 +316,7 @@ acpi_memory_remove_memory(struct acpi_me
 		if (!info->enabled)
 			return -EBUSY;
 
-		result = remove_memory(info->start_addr, info->length);
+		result = offline_memory(info->start_addr, info->length);
 		if (result)
 			return result;
 
Index: linux-3.6/include/linux/memory_hotplug.h
===================================================================
--- linux-3.6.orig/include/linux/memory_hotplug.h	2012-10-03 18:17:01.863247694 +0900
+++ linux-3.6/include/linux/memory_hotplug.h	2012-10-03 18:17:41.496247872 +0900
@@ -236,7 +236,7 @@ extern int add_memory(int nid, u64 start
 extern int arch_add_memory(int nid, u64 start, u64 size);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
 extern int offline_memory_block(struct memory_block *mem);
-extern int remove_memory(u64 start, u64 size);
+extern int offline_memory(u64 start, u64 size);
 extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
 								int nr_pages);
 extern void sparse_remove_one_section(struct zone *zone, struct mem_section *ms);
Index: linux-3.6/mm/memory_hotplug.c
===================================================================
--- linux-3.6.orig/mm/memory_hotplug.c	2012-10-03 18:17:01.861247692 +0900
+++ linux-3.6/mm/memory_hotplug.c	2012-10-03 18:17:41.503247876 +0900
@@ -1003,7 +1003,7 @@ int offline_pages(unsigned long start_pf
 	return __offline_pages(start_pfn, start_pfn + nr_pages, 120 * HZ);
 }
 
-int remove_memory(u64 start, u64 size)
+int offline_memory(u64 start, u64 size)
 {
 	struct memory_block *mem = NULL;
 	struct mem_section *section;
@@ -1047,9 +1047,9 @@ int offline_pages(unsigned long start_pf
 {
 	return -EINVAL;
 }
-int remove_memory(u64 start, u64 size)
+int offline_memory(u64 start, u64 size)
 {
 	return -EINVAL;
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
-EXPORT_SYMBOL_GPL(remove_memory);
+EXPORT_SYMBOL_GPL(offline_memory);

