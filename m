Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab1GLJQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:16:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61601 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab1GLJQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:16:27 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, yinghai@kernel.org, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/13] memblock, x86: Make ARCH_DISCARD_MEMBLOCK a config option
Date: Tue, 12 Jul 2011 11:16:05 +0200
Message-Id: <1310462166-31469-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310462166-31469-1-git-send-email-tj@kernel.org>
References: <1310462166-31469-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make ARCH_DISCARD_MEMBLOCK a config option so that it can be handled
together with other MEMBLOCK options.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/Kconfig                |    1 +
 arch/x86/include/asm/memblock.h |    2 --
 include/linux/memblock.h        |    2 +-
 mm/Kconfig                      |    3 +++
 mm/memblock.c                   |    2 +-
 5 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 91aa1b4e..30f4571 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -26,6 +26,7 @@ config X86
 	select HAVE_KPROBES
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
+	select ARCH_DISCARD_MEMBLOCK
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_FRAME_POINTERS
 	select HAVE_DMA_ATTRS
diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
index 17a882e..bc56670 100644
--- a/arch/x86/include/asm/memblock.h
+++ b/arch/x86/include/asm/memblock.h
@@ -1,8 +1,6 @@
 #ifndef _X86_MEMBLOCK_H
 #define _X86_MEMBLOCK_H
 
-#define ARCH_DISCARD_MEMBLOCK
-
 void memblock_x86_reserve_range(u64 start, u64 end, char *name);
 void memblock_x86_free_range(u64 start, u64 end);
 
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 013dfe0..f2611d7 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -197,7 +197,7 @@ static inline unsigned long memblock_region_reserved_end_pfn(const struct memblo
 	     region++)
 
 
-#ifdef ARCH_DISCARD_MEMBLOCK
+#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
 #define __init_memblock __init
 #define __initdata_memblock __initdata
 #else
diff --git a/mm/Kconfig b/mm/Kconfig
index 30a5d47..7c56971 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -134,6 +134,9 @@ config HAVE_MEMBLOCK
 config HAVE_MEMBLOCK_NODE_MAP
 	boolean
 
+config ARCH_DISCARD_MEMBLOCK
+	boolean
+
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
diff --git a/mm/memblock.c b/mm/memblock.c
index 4d318bf..8971d06 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -958,7 +958,7 @@ static int __init early_memblock(char *p)
 }
 early_param("memblock", early_memblock);
 
-#if defined(CONFIG_DEBUG_FS) && !defined(ARCH_DISCARD_MEMBLOCK)
+#if defined(CONFIG_DEBUG_FS) && !defined(CONFIG_ARCH_DISCARD_MEMBLOCK)
 
 static int memblock_debug_show(struct seq_file *m, void *private)
 {
-- 
1.7.6

