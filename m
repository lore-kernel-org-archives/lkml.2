Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab2K1Vtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:49:42 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37298 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab2K1VtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:49:10 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v9 45/46] mm: Kill NO_BOOTMEM version free_all_bootmem_node()
Date: Wed, 28 Nov 2012 13:47:56 -0800
Message-Id: <1354139277-17376-46-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
References: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now NO_BOOTMEM version free_all_bootmem_node() does not really
do free_bootmem at all, and it only call register_page_bootmem_info_node
for online nodes instead.

That is confusing.

We can kill that free_all_bootmem_node(), after we kill two callings
in x86 and sparc.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 mm/nobootmem.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 714d5d6..f22c228 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -141,20 +141,6 @@ unsigned long __init free_low_memory_core_early(int nodeid)
 }
 
 /**
- * free_all_bootmem_node - release a node's free pages to the buddy allocator
- * @pgdat: node to be released
- *
- * Returns the number of pages actually released.
- */
-unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
-{
-	register_page_bootmem_info_node(pgdat);
-
-	/* free_low_memory_core_early(MAX_NUMNODES) will be called later */
-	return 0;
-}
-
-/**
  * free_all_bootmem - release free pages to the buddy allocator
  *
  * Returns the number of pages actually released.
-- 
1.7.7

