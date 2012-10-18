Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab2JRUvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:51:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24686 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab2JRUvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:51:06 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 17/19] x86, mm: Move function declaration into mm_internal.h
Date: Thu, 18 Oct 2012 13:50:28 -0700
Message-Id: <1350593430-24470-21-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are only for mm/init*.c.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/init.h |   16 +++-------------
 arch/x86/mm/mm_internal.h   |    7 +++++++
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
-- 
1.7.7

