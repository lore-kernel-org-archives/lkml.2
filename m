Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab2KEU2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:28:18 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22274 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab2KEU2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:28:16 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 40/42] x86, mm: kill numa_64.h
Date: Mon,  5 Nov 2012 12:27:41 -0800
Message-Id: <1352147263-20383-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1352147263-20383-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWUiNqv-fd_4Y79eq+-w6wU34nEwn76+QJ7TWw7uCLaaQ@mail.gmail.com>
 <1352147263-20383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/numa.h    |    2 --
 arch/x86/include/asm/numa_64.h |    4 ----
 arch/x86/kernel/acpi/boot.c    |    1 -
 arch/x86/kernel/cpu/amd.c      |    1 -
 arch/x86/kernel/cpu/intel.c    |    1 -
 arch/x86/kernel/setup.c        |    3 ---
 6 files changed, 0 insertions(+), 12 deletions(-)
 delete mode 100644 arch/x86/include/asm/numa_64.h

diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index 49119fc..52560a2 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -54,8 +54,6 @@ static inline int numa_cpu_node(int cpu)
 
 #ifdef CONFIG_X86_32
 # include <asm/numa_32.h>
-#else
-# include <asm/numa_64.h>
 #endif
 
 #ifdef CONFIG_NUMA
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
deleted file mode 100644
index fe4d2d4..0000000
--- a/arch/x86/include/asm/numa_64.h
+++ /dev/null
@@ -1,4 +0,0 @@
-#ifndef _ASM_X86_NUMA_64_H
-#define _ASM_X86_NUMA_64_H
-
-#endif /* _ASM_X86_NUMA_64_H */
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index e651f7a..4b23aa1 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -51,7 +51,6 @@ EXPORT_SYMBOL(acpi_disabled);
 
 #ifdef	CONFIG_X86_64
 # include <asm/proto.h>
-# include <asm/numa_64.h>
 #endif				/* X86 */
 
 #define BAD_MADT_ENTRY(entry, end) (					    \
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 9619ba6..913f94f 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -12,7 +12,6 @@
 #include <asm/pci-direct.h>
 
 #ifdef CONFIG_X86_64
-# include <asm/numa_64.h>
 # include <asm/mmconfig.h>
 # include <asm/cacheflush.h>
 #endif
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 198e019..3b547cc 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -17,7 +17,6 @@
 
 #ifdef CONFIG_X86_64
 #include <linux/topology.h>
-#include <asm/numa_64.h>
 #endif
 
 #include "cpu.h"
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 457de1d..8b0fb6fd 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -108,9 +108,6 @@
 #include <asm/topology.h>
 #include <asm/apicdef.h>
 #include <asm/amd_nb.h>
-#ifdef CONFIG_X86_64
-#include <asm/numa_64.h>
-#endif
 #include <asm/mce.h>
 #include <asm/alternative.h>
 #include <asm/prom.h>
-- 
1.7.7

