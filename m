Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab2KVU6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:58:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964820Ab2KVS62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:28 -0500
Date: Wed, 21 Nov 2012 18:22:23 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-c074eaac2ab264c94520efff7e896b771de885ae@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-44-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-44-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: kill numa_64.h
Git-Commit-ID: c074eaac2ab264c94520efff7e896b771de885ae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:22:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c074eaac2ab264c94520efff7e896b771de885ae
Gitweb:     http://git.kernel.org/tip/c074eaac2ab264c94520efff7e896b771de885ae
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:20 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:47 -0800

x86, mm: kill numa_64.h

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-44-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/numa.h    | 2 --
 arch/x86/include/asm/numa_64.h | 4 ----
 arch/x86/kernel/acpi/boot.c    | 1 -
 arch/x86/kernel/cpu/amd.c      | 1 -
 arch/x86/kernel/cpu/intel.c    | 1 -
 arch/x86/kernel/setup.c        | 3 ---
 6 files changed, 12 deletions(-)

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
index 85b62f1..6d29d1f 100644
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
