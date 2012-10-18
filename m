Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab2JRUzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:55:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24766 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab2JRUvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:51:12 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/19] x86, mm: Move min_pfn_mapped back to mm/init.c
Date: Thu, 18 Oct 2012 13:50:21 -0700
Message-Id: <1350593430-24470-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also change it to static.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
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
index 73cb7ba..9cb2e27 100644
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
index c398b2c..2257727 100644
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

