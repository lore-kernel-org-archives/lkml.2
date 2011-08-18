Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab1HRTHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:07:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47496 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab1HRTHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:07:50 -0400
Date: Thu, 18 Aug 2011 20:07:49 +0100
To: richard@nod.at
Subject: Subject: [PATCH 53/91] um: make flush_tlb_kernel_range_common()
 static
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7wT-0007oo-Nc@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/shared/tlb.h |    2 --
 arch/um/kernel/tlb.c         |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/um/include/shared/tlb.h b/arch/um/include/shared/tlb.h
index ecd2265..8a50ce1 100644
--- a/arch/um/include/shared/tlb.h
+++ b/arch/um/include/shared/tlb.h
@@ -9,7 +9,5 @@
 #include "um_mmu.h"
 
 extern void force_flush_all(void);
-extern int flush_tlb_kernel_range_common(unsigned long start,
-					 unsigned long end);
 
 #endif
diff --git a/arch/um/kernel/tlb.c b/arch/um/kernel/tlb.c
index d175d05..d1da8ac 100644
--- a/arch/um/kernel/tlb.c
+++ b/arch/um/kernel/tlb.c
@@ -287,7 +287,7 @@ void fix_range_common(struct mm_struct *mm, unsigned long start_addr,
 	}
 }
 
-int flush_tlb_kernel_range_common(unsigned long start, unsigned long end)
+static int flush_tlb_kernel_range_common(unsigned long start, unsigned long end)
 {
 	struct mm_struct *mm;
 	pgd_t *pgd;
-- 
1.7.2.5


