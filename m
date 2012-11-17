Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab2KQDkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 22:40:41 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27455 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab2KQDkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 22:40:39 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 30/46] x86, mm: Move back pgt_buf_* to mm/init.c
Date: Fri, 16 Nov 2012 19:39:07 -0800
Message-Id: <1353123563-3103-31-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also change them to static.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/init.h |    4 ----
 arch/x86/mm/init.c          |    6 +++---
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
index 4f13998..626ea8d 100644
--- a/arch/x86/include/asm/init.h
+++ b/arch/x86/include/asm/init.h
@@ -12,8 +12,4 @@ kernel_physical_mapping_init(unsigned long start,
 			     unsigned long end,
 			     unsigned long page_size_mask);
 
-extern unsigned long __initdata pgt_buf_start;
-extern unsigned long __meminitdata pgt_buf_end;
-extern unsigned long __meminitdata pgt_buf_top;
-
 #endif /* _ASM_X86_INIT_32_H */
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index bed4888..3cadf10 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -19,9 +19,9 @@
 
 #include "mm_internal.h"
 
-unsigned long __initdata pgt_buf_start;
-unsigned long __meminitdata pgt_buf_end;
-unsigned long __meminitdata pgt_buf_top;
+static unsigned long __initdata pgt_buf_start;
+static unsigned long __initdata pgt_buf_end;
+static unsigned long __initdata pgt_buf_top;
 
 static unsigned long min_pfn_mapped;
 
-- 
1.7.7

