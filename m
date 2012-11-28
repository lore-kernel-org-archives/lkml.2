Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab2K1Vs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:48:59 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45052 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab2K1Vsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:48:54 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v9 25/46] x86, mm: Move min_pfn_mapped back to mm/init.c
Date: Wed, 28 Nov 2012 13:47:36 -0800
Message-Id: <1354139277-17376-26-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
References: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also change it to static.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/page_types.h |    1 -
 arch/x86/kernel/setup.c           |    1 -
 arch/x86/mm/init.c                |    2 ++
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 9f6f3e6..54c9787 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -45,7 +45,6 @@ extern int devmem_is_allowed(unsigned long pagenr);
 
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
-extern unsigned long min_pfn_mapped;
 
 static inline phys_addr_t get_max_mapped(void)
 {
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f7634092..2015194 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -124,7 +124,6 @@
  */
 unsigned long max_low_pfn_mapped;
 unsigned long max_pfn_mapped;
-unsigned long min_pfn_mapped;
 
 #ifdef CONFIG_DMI
 RESERVE_BRK(dmi_alloc, 65536);
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 20db3fd..a80b112 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -23,6 +23,8 @@ unsigned long __initdata pgt_buf_start;
 unsigned long __meminitdata pgt_buf_end;
 unsigned long __meminitdata pgt_buf_top;
 
+static unsigned long min_pfn_mapped;
+
 __ref void *alloc_low_page(void)
 {
 	unsigned long pfn;
-- 
1.7.7

