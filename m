Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab2KRQKQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 11:10:16 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:64635 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab2KRQKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 11:10:12 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Wen Congyang <wency@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RFT PATCH v1 5/5] mm: increase totalram_pages when free pages allocated by bootmem allocator
Date: Mon, 19 Nov 2012 00:07:30 +0800
Message-Id: <1353254850-27336-6-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353254850-27336-1-git-send-email-jiang.liu@huawei.com>
References: <20121115112454.e582a033.akpm@linux-foundation.org>
 <1353254850-27336-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function put_page_bootmem() is used to free pages allocated by bootmem
allocator to the buddy system, so it should increase totalram_pages
when freeing pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 mm/memory_hotplug.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index acd3993..6b07e0c 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -119,6 +119,7 @@ void __ref put_page_bootmem(struct page *page)
 		mutex_lock(&ppb_lock);
 		__free_pages_bootmem(page, 0);
 		mutex_unlock(&ppb_lock);
+		totalram_pages++;
 	}
 
 }
-- 
1.7.9.5

