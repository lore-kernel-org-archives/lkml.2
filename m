Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2IFNLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:11:42 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:43775 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab2IFNL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:11:29 -0400
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: [PATCH 1/8] thp, x86: introduce HAVE_ARCH_TRANSPARENT_HUGEPAGE
Date: Thu,  6 Sep 2012 15:10:36 +0200
Message-Id: <1346937043-28208-2-git-send-email-gerald.schaefer@de.ibm.com>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <1346937043-28208-1-git-send-email-gerald.schaefer@de.ibm.com>
References: <1346937043-28208-1-git-send-email-gerald.schaefer@de.ibm.com>
x-cbid: 12090613-0342-0000-0000-000002C50F30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup patch in preparation for transparent hugepage support on s390.
Adding new architectures to the TRANSPARENT_HUGEPAGE config option can
make the "depends" line rather ugly, like "depends on
(X86 || (S390 && 64BIT)) && MMU".
This patch adds a HAVE_ARCH_TRANSPARENT_HUGEPAGE instead. x86 already
has MMU "def_bool y", so the MMU check is superfluous there and
HAVE_ARCH_TRANSPARENT_HUGEPAGE can be selected in arch/x86/Kconfig.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---
 arch/Kconfig     | 3 +++
 arch/x86/Kconfig | 1 +
 mm/Kconfig       | 2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 72f2fa1..04de2d2 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -281,4 +281,7 @@ config SECCOMP_FILTER
 
 	  See Documentation/prctl/seccomp_filter.txt for details.
 
+config HAVE_ARCH_TRANSPARENT_HUGEPAGE
+	bool
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ec3a1a..0b9bb7b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -97,6 +97,7 @@ config X86
 	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS || UPROBES)
diff --git a/mm/Kconfig b/mm/Kconfig
index d5c8019..3322342 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -318,7 +318,7 @@ config NOMMU_INITIAL_TRIM_EXCESS
 
 config TRANSPARENT_HUGEPAGE
 	bool "Transparent Hugepage Support"
-	depends on X86 && MMU
+	depends on HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select COMPACTION
 	help
 	  Transparent Hugepages allows the kernel to use huge pages and
-- 
1.7.11.5

