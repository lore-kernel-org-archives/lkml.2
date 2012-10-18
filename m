Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab2JRUve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:51:34 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24800 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab2JRUvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:51:13 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 14/19] x86, mm: Move back pgt_buf_* to mm/init.c
Date: Thu, 18 Oct 2012 13:50:25 -0700
Message-Id: <1350593430-24470-18-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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
index 4eece3c..3fcdfa9 100644
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

