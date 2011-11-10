Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934764Ab1KJOEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 09:04:37 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:44256 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab1KJOEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 09:04:35 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Dike <jdike@addtoit.com>, Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 2/3] mm,x86,um: move CMPXCHG_LOCAL config option
Date: Thu, 10 Nov 2011 15:04:19 +0100
Message-Id: <1320933860-15588-3-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1320933860-15588-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1320933860-15588-1-git-send-email-heiko.carstens@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move CMPXCHG_LOCAL and rename it to HAVE_CMPXCHG_LOCAL so architectures can
simply select the option if it is supported.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/Kconfig         |    3 +++
 arch/x86/Kconfig     |    1 +
 arch/x86/Kconfig.cpu |    3 ---
 arch/x86/um/Kconfig  |    4 ----
 mm/vmstat.c          |    2 +-
 5 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 4b4a140..f5e749b 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -189,4 +189,7 @@ config HAVE_ALIGNED_STRUCT_PAGE
 	  on a struct page for better performance. However selecting this
 	  might increase the size of a struct page by a word.
 
+config HAVE_CMPXCHG_LOCAL
+	bool
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5115ce4..71aebf5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -76,6 +76,7 @@ config X86
 	select CLKEVT_I8253
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB && !M386
+	select HAVE_CMPXCHG_LOCAL if !M386
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index e3ca7e0..99d2ab8 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -309,9 +309,6 @@ config X86_INTERNODE_CACHE_SHIFT
 config X86_CMPXCHG
 	def_bool X86_64 || (X86_32 && !M386)
 
-config CMPXCHG_LOCAL
-	def_bool X86_64 || (X86_32 && !M386)
-
 config CMPXCHG_DOUBLE
 	def_bool y
 
diff --git a/arch/x86/um/Kconfig b/arch/x86/um/Kconfig
index 1d97bd8..a62bfc6 100644
--- a/arch/x86/um/Kconfig
+++ b/arch/x86/um/Kconfig
@@ -6,10 +6,6 @@ menu "UML-specific options"
 
 menu "Host processor type and features"
 
-config CMPXCHG_LOCAL
-	bool
-	default n
-
 config CMPXCHG_DOUBLE
 	bool
 	default n
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 8fd603b..f600557 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -295,7 +295,7 @@ void __dec_zone_page_state(struct page *page, enum zone_stat_item item)
 }
 EXPORT_SYMBOL(__dec_zone_page_state);
 
-#ifdef CONFIG_CMPXCHG_LOCAL
+#ifdef CONFIG_HAVE_CMPXCHG_LOCAL
 /*
  * If we have cmpxchg_local support then we do not need to incur the overhead
  * that comes with local_irq_save/restore if we use this_cpu_cmpxchg.
-- 
1.7.7.1

