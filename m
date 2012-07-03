Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023Ab2GCEAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 00:00:19 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:17695 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114Ab2GCD76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 23:59:58 -0400
From: Jiang Liu <jiang.liu@huawei.com>
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Mel Gorman <mgorman@suse.de>, Yinghai Lu <yinghai@kernel.org>
CC: Jiang Liu <jiang.liu@huawei.com>, Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH 4/4] mm: change slob's struct page definition to accomodate struct page changes
Date: Tue, 3 Jul 2012 11:57:17 +0800
Message-ID: <1341287837-7904-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.8.msysgit.0
In-Reply-To: <1341287837-7904-1-git-send-email-jiang.liu@huawei.com>
References: <1341287837-7904-1-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changeset fc9bb8c768abe7ae10861c3510e01a95f98d5933 "mm: Rearrange struct page"
rearranges fields in struct page, so change slob's "struct page" definition
to accomodate the changes.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 mm/slob.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slob.c b/mm/slob.c
index 2c1fa9c..e5515bb 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -100,10 +100,10 @@ struct slob_page {
 	union {
 		struct {
 			unsigned long flags;	/* mandatory */
-			atomic_t _count;	/* mandatory */
-			slobidx_t units;	/* free units left in page */
-			unsigned long pad[2];
+			unsigned long pad1;
 			slob_t *free;		/* first free slob_t in page */
+			slobidx_t units;	/* free units left in page */
+			atomic_t _count;	/* mandatory */
 			struct list_head list;	/* linked list of free pages */
 		};
 		struct page page;
-- 
1.7.1


