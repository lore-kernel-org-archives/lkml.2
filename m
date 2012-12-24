Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab2LXMLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 07:11:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:18900 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab2LXMKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 07:10:38 -0500
X-IronPort-AV: E=Sophos;i="4.84,347,1355068800"; 
   d="scan'208";a="6464040"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, tangchen@cn.fujitsu.com, hpa@zytor.com,
        linfeng@cn.fujitsu.com, laijs@cn.fujitsu.com, mgorman@suse.de,
        yinghai@kernel.org
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org
Subject: [PATCH v5 11/14] memory-hotplug: Integrated __remove_section() of CONFIG_SPARSEMEM_VMEMMAP.
Date: Mon, 24 Dec 2012 20:09:21 +0800
Message-Id: <1356350964-13437-12-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1356350964-13437-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1356350964-13437-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/24 20:10:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/24 20:10:16,
	Serialize complete at 2012/12/24 20:10:16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently __remove_section for SPARSEMEM_VMEMMAP does nothing. But even if
we use SPARSEMEM_VMEMMAP, we can unregister the memory_section.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 mm/memory_hotplug.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c12bd55..71cb656 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -430,16 +430,6 @@ static int __meminit __add_section(int nid, struct zone *zone,
 	return register_new_memory(nid, __pfn_to_section(phys_start_pfn));
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-static int __remove_section(struct zone *zone, struct mem_section *ms)
-{
-	/*
-	 * XXX: Freeing memmap with vmemmap is not implement yet.
-	 *      This should be removed later.
-	 */
-	return -EBUSY;
-}
-#else
 static int __remove_section(struct zone *zone, struct mem_section *ms)
 {
 	int ret = -EINVAL;
@@ -454,7 +444,6 @@ static int __remove_section(struct zone *zone, struct mem_section *ms)
 	sparse_remove_one_section(zone, ms);
 	return 0;
 }
-#endif
 
 /*
  * Reasonably generic function for adding memory.  It is
-- 
1.7.1

