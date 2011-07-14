Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1GNJqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 05:46:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60698 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab1GNJqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 05:46:08 -0400
Date: Thu, 14 Jul 2011 11:46:03 +0200
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, yinghai@kernel.org, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org
Subject: [PATCH UPDATED 12/13] memblock, x86: Make ARCH_DISCARD_MEMBLOCK a
 config option
Message-ID: <20110714094603.GH3455@htj.dyndns.org>
References: <1310462166-31469-1-git-send-email-tj@kernel.org>
 <1310462166-31469-13-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310462166-31469-13-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6839454ae63f1eb21e515c10229ca95c22955fec Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 14 Jul 2011 11:22:17 +0200

Make ARCH_DISCARD_MEMBLOCK a config option so that it can be handled
together with other MEMBLOCK options.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
Nothing really changed.  Just patch context update to resolve conflict
from updates earlier in the series.

Thanks.

 arch/x86/Kconfig                |    1 +
 arch/x86/include/asm/memblock.h |    2 --
 include/linux/memblock.h        |    2 +-
 mm/Kconfig                      |    3 +++
 mm/memblock.c                   |    2 +-
 5 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 97f0894..28116d4 100644
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
index 31def58..2491355 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -197,7 +197,7 @@ static inline unsigned long memblock_region_reserved_end_pfn(const struct memblo
 	     region++)
 
 
-#ifdef ARCH_DISCARD_MEMBLOCK
+#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
 #define __init_memblock __meminit
 #define __initdata_memblock __meminitdata
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
index c4a8750..ebc6119 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -959,7 +959,7 @@ static int __init early_memblock(char *p)
 }
 early_param("memblock", early_memblock);
 
-#if defined(CONFIG_DEBUG_FS) && !defined(ARCH_DISCARD_MEMBLOCK)
+#if defined(CONFIG_DEBUG_FS) && !defined(CONFIG_ARCH_DISCARD_MEMBLOCK)
 
 static int memblock_debug_show(struct seq_file *m, void *private)
 {
-- 
1.7.6

