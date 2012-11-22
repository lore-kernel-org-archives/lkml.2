Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab2KVS6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:58:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964786Ab2KVS6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:25 -0500
Date: Wed, 21 Nov 2012 18:24:28 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-600cc5b7f6371706679490d7ee108015ae57ac2f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-46-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-46-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] mm: Kill NO_BOOTMEM version free_all_bootmem_node()
Git-Commit-ID: 600cc5b7f6371706679490d7ee108015ae57ac2f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:24:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  600cc5b7f6371706679490d7ee108015ae57ac2f
Gitweb:     http://git.kernel.org/tip/600cc5b7f6371706679490d7ee108015ae57ac2f
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:22 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:50 -0800

mm: Kill NO_BOOTMEM version free_all_bootmem_node()

Now NO_BOOTMEM version free_all_bootmem_node() does not really
do free_bootmem at all, and it only call register_page_bootmem_info_node
for online nodes instead.

That is confusing.

We can kill that free_all_bootmem_node(), after we kill two callings
in x86 and sparc.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-46-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 mm/nobootmem.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index bd82f6b..ecc2f13 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -138,20 +138,6 @@ unsigned long __init free_low_memory_core_early(int nodeid)
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
