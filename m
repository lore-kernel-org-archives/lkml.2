Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab2GTBSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 21:18:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:64850 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab2GTBSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 21:18:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="168729936"
From: Alex Shi <alex.shi@intel.com>
To: hpa@zytor.com
Cc: tglx@linutronix.de, mingo@redhat.com, alex.shi@intel.com, tj@kernel.org,
        akpm@linux-foundation.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, bp@amd64.org,
        penguin-kernel@I-love.SAKURA.ne.jp
Subject: [PATCH] x86/tlb: fix allnoconfig building warning
Date: Fri, 20 Jul 2012 09:18:23 +0800
Message-Id: <1342747103-19765-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The incompatible parameter of flush_tlb_mm_range cause build warning.
Fix it by correct parameter.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/tlbflush.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 621b959..4fc8faf 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -105,10 +105,10 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
 		__flush_tlb();
 }
 
-static inline void flush_tlb_mm_range(struct vm_area_struct *vma,
+static inline void flush_tlb_mm_range(struct mm_struct *mm,
 	   unsigned long start, unsigned long end, unsigned long vmflag)
 {
-	if (vma->vm_mm == current->active_mm)
+	if (mm == current->active_mm)
 		__flush_tlb();
 }
 
-- 
1.7.5.4

