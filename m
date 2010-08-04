Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab0HDMmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:42:25 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:57210 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932778Ab0HDMmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:42:21 -0400
Date: Wed, 4 Aug 2010 14:42:19 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Greg Ungerer <gerg@uclinux.org>, Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@lst.de>,
        Maxim Kuvyrkov <maxim@codesourcery.com>, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 7/9] arch/m68knommu: Removing dead M68KFPU_EMU config option
Message-ID: <d50dec9634694830ef13259acaf086180cc6e38c.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_M68KFPU_EMU doesn't exist in Kconfig, therefore removing
all references to it from the source. This Flags seems to exist only
on m68k with mmu, and this dead blocks are copy paste.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/m68knommu/kernel/ptrace.c |   18 ------------------
 arch/m68knommu/kernel/traps.c  |   13 -------------
 2 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/arch/m68knommu/kernel/ptrace.c b/arch/m68knommu/kernel/ptrace.c
index f6be124..a32e2de 100644
--- a/arch/m68knommu/kernel/ptrace.c
+++ b/arch/m68knommu/kernel/ptrace.c
@@ -134,14 +134,6 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 					tmp >>= 16;
 			} else if (addr >= 21 && addr < 49) {
 				tmp = child->thread.fp[addr - 21];
-#ifdef CONFIG_M68KFPU_EMU
-				/* Convert internal fpu reg representation
-				 * into long double format
-				 */
-				if (FPU_IS_EMU && (addr < 45) && !(addr % 3))
-					tmp = ((tmp & 0xffff0000) << 15) |
-					      ((tmp & 0x0000ffff) << 16);
-#endif
 			} else if (addr == 49) {
 				tmp = child->mm->start_code;
 			} else if (addr == 50) {
@@ -175,16 +167,6 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			}
 			if (addr >= 21 && addr < 48)
 			{
-#ifdef CONFIG_M68KFPU_EMU
-				/* Convert long double format
-				 * into internal fpu reg representation
-				 */
-				if (FPU_IS_EMU && (addr < 45) && !(addr % 3)) {
-					data = (unsigned long)data << 15;
-					data = (data & 0xffff0000) |
-					       ((data & 0x0000ffff) >> 1);
-				}
-#endif
 				child->thread.fp[addr - 21] = data;
 				ret = 0;
 			}
diff --git a/arch/m68knommu/kernel/traps.c b/arch/m68knommu/kernel/traps.c
index 3739c8f..e8b813d 100644
--- a/arch/m68knommu/kernel/traps.c
+++ b/arch/m68knommu/kernel/traps.c
@@ -360,16 +360,3 @@ void show_stack(struct task_struct *task, unsigned long *stack)
 	else
 		__show_stack(task, stack);
 }
-
-#ifdef CONFIG_M68KFPU_EMU
-asmlinkage void fpemu_signal(int signal, int code, void *addr)
-{
-	siginfo_t info;
-
-	info.si_signo = signal;
-	info.si_errno = 0;
-	info.si_code = code;
-	info.si_addr = addr;
-	force_sig_info(signal, &info, current);
-}
-#endif
-- 
1.7.0.4

