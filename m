Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab2K1Vu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:50:26 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45189 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030208Ab2K1VtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:49:05 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v9 40/46] x86, mm: Move after_bootmem to mm_internel.h
Date: Wed, 28 Nov 2012 13:47:51 -0800
Message-Id: <1354139277-17376-41-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
References: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it is only used in arch/x86/mm/init*.c

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/mm/mm_internal.h |    2 ++
 include/linux/mm.h        |    1 -
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/mm_internal.h b/arch/x86/mm/mm_internal.h
index dc79ac1..6b563a1 100644
--- a/arch/x86/mm/mm_internal.h
+++ b/arch/x86/mm/mm_internal.h
@@ -14,4 +14,6 @@ unsigned long kernel_physical_mapping_init(unsigned long start,
 					     unsigned long page_size_mask);
 void zone_sizes_init(void);
 
+extern int after_bootmem;
+
 #endif	/* __X86_MM_INTERNAL_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index fa06804..390bd14 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1355,7 +1355,6 @@ extern void __init mmap_init(void);
 extern void show_mem(unsigned int flags);
 extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
-extern int after_bootmem;
 
 extern __printf(3, 4)
 void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...);
-- 
1.7.7

