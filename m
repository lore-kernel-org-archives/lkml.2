Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab2KVUy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:54:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337Ab2KVS6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:34 -0500
Date: Wed, 21 Nov 2012 18:11:59 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-c8dcdb9ce463ad4a660099a74a850f4f6fc81c41@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-34-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-34-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm:
  Move function declaration into mm_internal.h
Git-Commit-ID: c8dcdb9ce463ad4a660099a74a850f4f6fc81c41
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:12:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c8dcdb9ce463ad4a660099a74a850f4f6fc81c41
Gitweb:     http://git.kernel.org/tip/c8dcdb9ce463ad4a660099a74a850f4f6fc81c41
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:10 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:38 -0800

x86, mm: Move function declaration into mm_internal.h

They are only for mm/init*.c.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-34-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/init.h | 16 +++-------------
 arch/x86/mm/mm_internal.h   |  7 +++++++
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
index 626ea8d..bac770b 100644
--- a/arch/x86/include/asm/init.h
+++ b/arch/x86/include/asm/init.h
@@ -1,15 +1,5 @@
-#ifndef _ASM_X86_INIT_32_H
-#define _ASM_X86_INIT_32_H
+#ifndef _ASM_X86_INIT_H
+#define _ASM_X86_INIT_H
 
-#ifdef CONFIG_X86_32
-extern void __init early_ioremap_page_table_range_init(void);
-#endif
 
-extern void __init zone_sizes_init(void);
-
-extern unsigned long __init
-kernel_physical_mapping_init(unsigned long start,
-			     unsigned long end,
-			     unsigned long page_size_mask);
-
-#endif /* _ASM_X86_INIT_32_H */
+#endif /* _ASM_X86_INIT_H */
diff --git a/arch/x86/mm/mm_internal.h b/arch/x86/mm/mm_internal.h
index 7e3b88e..dc79ac1 100644
--- a/arch/x86/mm/mm_internal.h
+++ b/arch/x86/mm/mm_internal.h
@@ -7,4 +7,11 @@ static inline void *alloc_low_page(void)
 	return alloc_low_pages(1);
 }
 
+void early_ioremap_page_table_range_init(void);
+
+unsigned long kernel_physical_mapping_init(unsigned long start,
+					     unsigned long end,
+					     unsigned long page_size_mask);
+void zone_sizes_init(void);
+
 #endif	/* __X86_MM_INTERNAL_H */
