Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab2DFMri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 08:47:38 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:32917 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab2DFMrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 08:47:37 -0400
Date: Fri, 6 Apr 2012 14:47:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] x86: drop obsolete ARCH_BOOTMEM support
Message-ID: <20120406124735.GA6920@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ae6cdc767f973f39cb205af4b80ff13f35a1b66e Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 6 Apr 2012 13:37:08 +0200
Subject: [PATCH] x86: drop obsolete ARCH_BOOTMEM support

x86 unconditionally uses NO_BOOTMEM so there is no use
of the HAVE_ARCH_BOOTMEM support as mm/bootmem.c is the
only file referencing this symbol.

bootmem_arch_preferred_node() is the function referred
in the mm/bootmem.c code and can thuis be dropped too.

x86 was the sole user of HAVE_ARCH_BOOTMEM - so there is
an opportunity to clean up a little in mm/bootmem.c too
if we do not expect other users to emerge.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tejun Heo <tj@kernel.org>
---

I found this while browsing the bootmem code for other reasons.
Build tested on x86-32

	Sam

 arch/x86/Kconfig                 |    4 ----
 arch/x86/include/asm/mmzone_32.h |    6 ------
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d14cc6..553f15e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1239,10 +1239,6 @@ config NODES_SHIFT
 	  Specify the maximum number of NUMA Nodes available on the target
 	  system.  Increases memory reserved to accommodate various tables.
 
-config HAVE_ARCH_BOOTMEM
-	def_bool y
-	depends on X86_32 && NUMA
-
 config HAVE_ARCH_ALLOC_REMAP
 	def_bool y
 	depends on X86_32 && NUMA
diff --git a/arch/x86/include/asm/mmzone_32.h b/arch/x86/include/asm/mmzone_32.h
index 55728e1..eb05fb3 100644
--- a/arch/x86/include/asm/mmzone_32.h
+++ b/arch/x86/include/asm/mmzone_32.h
@@ -61,10 +61,4 @@ static inline int pfn_valid(int pfn)
 
 #endif /* CONFIG_DISCONTIGMEM */
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
-/* always use node 0 for bootmem on this numa platform */
-#define bootmem_arch_preferred_node(__bdata, size, align, goal, limit)	\
-	(NODE_DATA(0)->bdata)
-#endif /* CONFIG_NEED_MULTIPLE_NODES */
-
 #endif /* _ASM_X86_MMZONE_32_H */
-- 
1.6.0.6

