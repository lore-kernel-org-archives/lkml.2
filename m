Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab2IBHrc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 03:47:32 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40957 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab2IBHr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 03:47:27 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 04/13] x86, mm: Revert back good_end setting for 64bit
Date: Sun,  2 Sep 2012 00:46:50 -0700
Message-Id: <1346572019-15806-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
References: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we could put page table high again for 64bit.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 15a6a38..cca9b7d 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -76,8 +76,8 @@ static void __init find_early_table_space(struct map_range *mr,
 #ifdef CONFIG_X86_32
 	/* for fixmap */
 	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
-#endif
 	good_end = max_pfn_mapped << PAGE_SHIFT;
+#endif
 
 	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
 	if (!base)
-- 
1.7.7

