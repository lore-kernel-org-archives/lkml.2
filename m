Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab2KLRT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:19:59 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46747 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab2KLRT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:19:58 -0500
From: Joonsoo Kim <js1304@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        Joonsoo Kim <js1304@gmail.com>, Alex Shi <alex.shi@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] x86/tlb: correct vmflag test for checking VM_HUGETLB
Date: Tue, 13 Nov 2012 02:17:36 +0900
Message-Id: <1352740656-19417-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 611ae8e3f5204f7480b3b405993b3352cfa16662('enable tlb flush range
support for x86') change flush_tlb_mm_range() considerably. After this,
we test whether vmflag equal to VM_HUGETLB and it may be always failed,
because vmflag usually has other flags simultaneously.
Our intention is to check whether this vma is for hughtlb, so correct it
according to this purpose.

Cc: Alex Shi <alex.shi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 0777f04..60f926c 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -197,7 +197,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 	}
 
 	if (end == TLB_FLUSH_ALL || tlb_flushall_shift == -1
-					|| vmflag == VM_HUGETLB) {
+					|| vmflag & VM_HUGETLB) {
 		local_flush_tlb();
 		goto flush_all;
 	}
-- 
1.7.9.5

