Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab2GXBKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:10:21 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57351 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567Ab2GXBKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:10:18 -0400
X-AuditID: 9c93016f-b7b08ae00000790d-e8-500df5f6575e
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [PATCH 1/3] mips: zero out pg_data_t when it's allocated
Date: Tue, 24 Jul 2012 10:10:33 +0900
Message-Id: <1343092235-13399-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is ready for next patch which try to remove zero-out
of pg_data_t in core MM part. At a glance, all archs except this part
already have done it so this patch makes consistent with other archs.

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 arch/mips/sgi-ip27/ip27-memory.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/sgi-ip27/ip27-memory.c b/arch/mips/sgi-ip27/ip27-memory.c
index b105eca..cd8fcab 100644
--- a/arch/mips/sgi-ip27/ip27-memory.c
+++ b/arch/mips/sgi-ip27/ip27-memory.c
@@ -401,6 +401,7 @@ static void __init node_mem_init(cnodeid_t node)
 	 * Allocate the node data structures on the node first.
 	 */
 	__node_data[node] = __va(slot_freepfn << PAGE_SHIFT);
+	memset(__node_data[node], 0, PAGE_SIZE);
 
 	NODE_DATA(node)->bdata = &bootmem_node_data[node];
 	NODE_DATA(node)->node_start_pfn = start_pfn;
-- 
1.7.9.5

