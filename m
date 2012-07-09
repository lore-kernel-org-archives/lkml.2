Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab2GIKgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:36:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37142 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab2GIKgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:36:18 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FFAB406.1020002@jp.fujitsu.com>
Date: Mon, 9 Jul 2012 19:35:50 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>
CC: <rientjes@google.com>, <liuj97@gmail.com>, <len.brown@intel.com>,
        <benh@kernel.crashing.org>, <paulus@samba.org>, <cl@linux.com>,
        <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: [RFC PATCH v3 13/13] memory-hotplug : remove sysfs file of node
References: <4FFAB0A2.8070304@jp.fujitsu.com>
In-Reply-To: <4FFAB0A2.8070304@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds node_set_offline() and unregister_one_node() to remove_memory()
for removing sysfs file of node.

CC: David Rientjes <rientjes@google.com>
CC: Jiang Liu <liuj97@gmail.com>
CC: Len Brown <len.brown@intel.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

---
 mm/memory_hotplug.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-3.5-rc4/mm/memory_hotplug.c
===================================================================
--- linux-3.5-rc4.orig/mm/memory_hotplug.c	2012-07-03 14:22:21.012982694 +0900
+++ linux-3.5-rc4/mm/memory_hotplug.c	2012-07-03 14:22:25.405925554 +0900
@@ -702,6 +702,11 @@ int remove_memory(int nid, u64 start, u6
 	/* remove memmap entry */
 	firmware_map_remove(start, start + size - 1, "System RAM");

+	if (!node_present_pages(nid)) {
+		node_set_offline(nid);
+		unregister_one_node(nid);
+	}
+
 	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT);
 	unlock_memory_hotplug();
 	return 0;

