Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab0JNVQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:16:28 -0400
Received: from king.tilera.com ([72.1.168.226]:52863 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab0JNVQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:16:26 -0400
Message-Id: <5504f1e7b0666970dc0bdb2fa3714cb86d97ea0f.1287090288.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1287090280.git.cmetcalf@tilera.com>
References: <cover.1287090280.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 14 Oct 2010 16:39:42 -0400
Subject: [PATCH 11/14] arch/tile: minor whitespace/naming changes for string support files
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 14 Oct 2010 21:16:21.0606 (UTC) FILETIME=[0CC43860:01CB6BE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our internal process shares memcpy, memset, etc., with libc, and
we did some minor tweaking as part of moving from uclibc to glibc,
which is now reflected in the kernel versions of these files.

There are no semantic changes in this commit, just whitespace
(memcpy_32.S now properly uses tabs), naming (memmove.c instead
of memmove_32.c, since TILE-Gx shares the file with TILEPro),
and a couple of other minor tweaks.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/lib/Makefile                    |    4 +-
 arch/tile/lib/memcpy_32.S                 |  206 +++++++++++++++--------------
 arch/tile/lib/{memmove_32.c => memmove.c} |    0
 arch/tile/lib/memset_32.c                 |    1 +
 arch/tile/lib/strlen_32.c                 |    2 +
 5 files changed, 109 insertions(+), 104 deletions(-)
 rename arch/tile/lib/{memmove_32.c => memmove.c} (100%)

diff --git a/arch/tile/lib/Makefile b/arch/tile/lib/Makefile
index 746dc81..93122d5 100644
--- a/arch/tile/lib/Makefile
+++ b/arch/tile/lib/Makefile
@@ -3,8 +3,8 @@
 #
 
 lib-y = cacheflush.o checksum.o cpumask.o delay.o \
-	mb_incoherent.o uaccess.o \
-	memcpy_$(BITS).o memchr_$(BITS).o memmove_$(BITS).o memset_$(BITS).o \
+	mb_incoherent.o uaccess.o memmove.o \
+	memcpy_$(BITS).o memchr_$(BITS).o memset_$(BITS).o \
 	strchr_$(BITS).o strlen_$(BITS).o
 
 ifeq ($(CONFIG_TILEGX),y)
diff --git a/arch/tile/lib/memcpy_32.S b/arch/tile/lib/memcpy_32.S
index 30c3b7e..2a419a6 100644
--- a/arch/tile/lib/memcpy_32.S
+++ b/arch/tile/lib/memcpy_32.S
@@ -10,14 +10,16 @@
  *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
  *   NON INFRINGEMENT.  See the GNU General Public License for
  *   more details.
- *
- * This file shares the implementation of the userspace memcpy and
- * the kernel's memcpy, copy_to_user and copy_from_user.
  */
 
 #include <arch/chip.h>
 
 
+/*
+ * This file shares the implementation of the userspace memcpy and
+ * the kernel's memcpy, copy_to_user and copy_from_user.
+ */
+
 #include <linux/linkage.h>
 
 /* On TILE64, we wrap these functions via arch/tile/lib/memcpy_tile64.c */
@@ -53,9 +55,9 @@
  */
 ENTRY(__copy_from_user_inatomic)
 .type __copy_from_user_inatomic, @function
-        FEEDBACK_ENTER_EXPLICIT(__copy_from_user_inatomic, \
+	FEEDBACK_ENTER_EXPLICIT(__copy_from_user_inatomic, \
 	  .text.memcpy_common, \
-          .Lend_memcpy_common - __copy_from_user_inatomic)
+	  .Lend_memcpy_common - __copy_from_user_inatomic)
 	{ movei r29, IS_COPY_FROM_USER; j memcpy_common }
 	.size __copy_from_user_inatomic, . - __copy_from_user_inatomic
 
@@ -64,7 +66,7 @@ ENTRY(__copy_from_user_inatomic)
  */
 ENTRY(__copy_from_user_zeroing)
 .type __copy_from_user_zeroing, @function
-        FEEDBACK_REENTER(__copy_from_user_inatomic)
+	FEEDBACK_REENTER(__copy_from_user_inatomic)
 	{ movei r29, IS_COPY_FROM_USER_ZEROING; j memcpy_common }
 	.size __copy_from_user_zeroing, . - __copy_from_user_zeroing
 
@@ -74,13 +76,13 @@ ENTRY(__copy_from_user_zeroing)
  */
 ENTRY(__copy_to_user_inatomic)
 .type __copy_to_user_inatomic, @function
-        FEEDBACK_REENTER(__copy_from_user_inatomic)
+	FEEDBACK_REENTER(__copy_from_user_inatomic)
 	{ movei r29, IS_COPY_TO_USER; j memcpy_common }
 	.size __copy_to_user_inatomic, . - __copy_to_user_inatomic
 
 ENTRY(memcpy)
 .type memcpy, @function
-        FEEDBACK_REENTER(__copy_from_user_inatomic)
+	FEEDBACK_REENTER(__copy_from_user_inatomic)
 	{ movei r29, IS_MEMCPY }
 	.size memcpy, . - memcpy
 	/* Fall through */
@@ -157,35 +159,35 @@ EX:	{ sw r0, r3; addi r0, r0, 4; addi r2, r2, -4 }
 	{ addi r3, r1, 60; andi r9, r9, -64 }
 
 #if CHIP_HAS_WH64()
-        /* No need to prefetch dst, we'll just do the wh64
-         * right before we copy a line.
+	/* No need to prefetch dst, we'll just do the wh64
+	 * right before we copy a line.
 	 */
 #endif
 
 EX:	{ lw r5, r3; addi r3, r3, 64; movei r4, 1 }
-        /* Intentionally stall for a few cycles to leave L2 cache alone. */
-        { bnzt zero, .; move r27, lr }
+	/* Intentionally stall for a few cycles to leave L2 cache alone. */
+	{ bnzt zero, .; move r27, lr }
 EX:	{ lw r6, r3; addi r3, r3, 64 }
-        /* Intentionally stall for a few cycles to leave L2 cache alone. */
-        { bnzt zero, . }
+	/* Intentionally stall for a few cycles to leave L2 cache alone. */
+	{ bnzt zero, . }
 EX:	{ lw r7, r3; addi r3, r3, 64 }
 #if !CHIP_HAS_WH64()
-        /* Prefetch the dest */
-        /* Intentionally stall for a few cycles to leave L2 cache alone. */
-        { bnzt zero, . }
-        /* Use a real load to cause a TLB miss if necessary.  We aren't using
-         * r28, so this should be fine.
-         */
+	/* Prefetch the dest */
+	/* Intentionally stall for a few cycles to leave L2 cache alone. */
+	{ bnzt zero, . }
+	/* Use a real load to cause a TLB miss if necessary.  We aren't using
+	 * r28, so this should be fine.
+	 */
 EX:	{ lw r28, r9; addi r9, r9, 64 }
-        /* Intentionally stall for a few cycles to leave L2 cache alone. */
-        { bnzt zero, . }
-        { prefetch r9; addi r9, r9, 64 }
-        /* Intentionally stall for a few cycles to leave L2 cache alone. */
-        { bnzt zero, . }
-        { prefetch r9; addi r9, r9, 64 }
+	/* Intentionally stall for a few cycles to leave L2 cache alone. */
+	{ bnzt zero, . }
+	{ prefetch r9; addi r9, r9, 64 }
+	/* Intentionally stall for a few cycles to leave L2 cache alone. */
+	{ bnzt zero, . }
+	{ prefetch r9; addi r9, r9, 64 }
 #endif
-        /* Intentionally stall for a few cycles to leave L2 cache alone. */
-        { bz zero, .Lbig_loop2 }
+	/* Intentionally stall for a few cycles to leave L2 cache alone. */
+	{ bz zero, .Lbig_loop2 }
 
 	/* On entry to this loop:
 	 * - r0 points to the start of dst line 0
@@ -197,7 +199,7 @@ EX:	{ lw r28, r9; addi r9, r9, 64 }
 	 *   to some "safe" recently loaded address.
 	 * - r5 contains *(r1 + 60)       [i.e. last word of source line 0]
 	 * - r6 contains *(r1 + 64 + 60)  [i.e. last word of source line 1]
-         * - r9 contains ((r0 + 63) & -64)
+	 * - r9 contains ((r0 + 63) & -64)
 	 *     [start of next dst cache line.]
 	 */
 
@@ -208,137 +210,137 @@ EX:	{ lw r28, r9; addi r9, r9, 64 }
 	/* Copy line 0, first stalling until r5 is ready. */
 EX:	{ move r12, r5; lw r16, r1 }
 	{ bz r4, .Lcopy_8_check; slti_u r8, r2, 8 }
-        /* Prefetch several lines ahead. */
+	/* Prefetch several lines ahead. */
 EX:	{ lw r5, r3; addi r3, r3, 64 }
-        { jal .Lcopy_line }
+	{ jal .Lcopy_line }
 
 	/* Copy line 1, first stalling until r6 is ready. */
 EX:	{ move r12, r6; lw r16, r1 }
 	{ bz r4, .Lcopy_8_check; slti_u r8, r2, 8 }
-        /* Prefetch several lines ahead. */
+	/* Prefetch several lines ahead. */
 EX:	{ lw r6, r3; addi r3, r3, 64 }
 	{ jal .Lcopy_line }
 
 	/* Copy line 2, first stalling until r7 is ready. */
 EX:	{ move r12, r7; lw r16, r1 }
 	{ bz r4, .Lcopy_8_check; slti_u r8, r2, 8 }
-        /* Prefetch several lines ahead. */
+	/* Prefetch several lines ahead. */
 EX:	{ lw r7, r3; addi r3, r3, 64 }
-        /* Use up a caches-busy cycle by jumping back to the top of the
-         * loop. Might as well get it out of the way now.
-         */
-        { j .Lbig_loop }
+	/* Use up a caches-busy cycle by jumping back to the top of the
+	 * loop. Might as well get it out of the way now.
+	 */
+	{ j .Lbig_loop }
 
 
 	/* On entry:
 	 * - r0 points to the destination line.
 	 * - r1 points to the source line.
-         * - r3 is the next prefetch address.
+	 * - r3 is the next prefetch address.
 	 * - r9 holds the last address used for wh64.
 	 * - r12 = WORD_15
-         * - r16 = WORD_0.
-         * - r17 == r1 + 16.
-         * - r27 holds saved lr to restore.
+	 * - r16 = WORD_0.
+	 * - r17 == r1 + 16.
+	 * - r27 holds saved lr to restore.
 	 *
 	 * On exit:
 	 * - r0 is incremented by 64.
 	 * - r1 is incremented by 64, unless that would point to a word
-         *   beyond the end of the source array, in which case it is redirected
-         *   to point to an arbitrary word already in the cache.
+	 *   beyond the end of the source array, in which case it is redirected
+	 *   to point to an arbitrary word already in the cache.
 	 * - r2 is decremented by 64.
-         * - r3 is unchanged, unless it points to a word beyond the
-         *   end of the source array, in which case it is redirected
-         *   to point to an arbitrary word already in the cache.
-         *   Redirecting is OK since if we are that close to the end
-         *   of the array we will not come back to this subroutine
-         *   and use the contents of the prefetched address.
+	 * - r3 is unchanged, unless it points to a word beyond the
+	 *   end of the source array, in which case it is redirected
+	 *   to point to an arbitrary word already in the cache.
+	 *   Redirecting is OK since if we are that close to the end
+	 *   of the array we will not come back to this subroutine
+	 *   and use the contents of the prefetched address.
 	 * - r4 is nonzero iff r2 >= 64.
-         * - r9 is incremented by 64, unless it points beyond the
-         *   end of the last full destination cache line, in which
-         *   case it is redirected to a "safe address" that can be
-         *   clobbered (sp - 64)
+	 * - r9 is incremented by 64, unless it points beyond the
+	 *   end of the last full destination cache line, in which
+	 *   case it is redirected to a "safe address" that can be
+	 *   clobbered (sp - 64)
 	 * - lr contains the value in r27.
 	 */
 
 /* r26 unused */
 
 .Lcopy_line:
-        /* TODO: when r3 goes past the end, we would like to redirect it
-         * to prefetch the last partial cache line (if any) just once, for the
-         * benefit of the final cleanup loop. But we don't want to
-         * prefetch that line more than once, or subsequent prefetches
-         * will go into the RTF. But then .Lbig_loop should unconditionally
-         * branch to top of loop to execute final prefetch, and its
-         * nop should become a conditional branch.
-         */
-
-        /* We need two non-memory cycles here to cover the resources
-         * used by the loads initiated by the caller.
-         */
-        { add r15, r1, r2 }
+	/* TODO: when r3 goes past the end, we would like to redirect it
+	 * to prefetch the last partial cache line (if any) just once, for the
+	 * benefit of the final cleanup loop. But we don't want to
+	 * prefetch that line more than once, or subsequent prefetches
+	 * will go into the RTF. But then .Lbig_loop should unconditionally
+	 * branch to top of loop to execute final prefetch, and its
+	 * nop should become a conditional branch.
+	 */
+
+	/* We need two non-memory cycles here to cover the resources
+	 * used by the loads initiated by the caller.
+	 */
+	{ add r15, r1, r2 }
 .Lcopy_line2:
-        { slt_u r13, r3, r15; addi r17, r1, 16 }
+	{ slt_u r13, r3, r15; addi r17, r1, 16 }
 
-        /* NOTE: this will stall for one cycle as L1 is busy. */
+	/* NOTE: this will stall for one cycle as L1 is busy. */
 
-        /* Fill second L1D line. */
+	/* Fill second L1D line. */
 EX:	{ lw r17, r17; addi r1, r1, 48; mvz r3, r13, r1 } /* r17 = WORD_4 */
 
 #if CHIP_HAS_WH64()
-        /* Prepare destination line for writing. */
+	/* Prepare destination line for writing. */
 EX:	{ wh64 r9; addi r9, r9, 64 }
 #else
-        /* Prefetch dest line */
+	/* Prefetch dest line */
 	{ prefetch r9; addi r9, r9, 64 }
 #endif
-        /* Load seven words that are L1D hits to cover wh64 L2 usage. */
+	/* Load seven words that are L1D hits to cover wh64 L2 usage. */
 
-        /* Load the three remaining words from the last L1D line, which
-         * we know has already filled the L1D.
-         */
+	/* Load the three remaining words from the last L1D line, which
+	 * we know has already filled the L1D.
+	 */
 EX:	{ lw r4, r1;  addi r1, r1, 4;   addi r20, r1, 16 }   /* r4 = WORD_12 */
 EX:	{ lw r8, r1;  addi r1, r1, 4;   slt_u r13, r20, r15 }/* r8 = WORD_13 */
 EX:	{ lw r11, r1; addi r1, r1, -52; mvz r20, r13, r1 }  /* r11 = WORD_14 */
 
-        /* Load the three remaining words from the first L1D line, first
-         * stalling until it has filled by "looking at" r16.
-         */
+	/* Load the three remaining words from the first L1D line, first
+	 * stalling until it has filled by "looking at" r16.
+	 */
 EX:	{ lw r13, r1; addi r1, r1, 4; move zero, r16 }   /* r13 = WORD_1 */
 EX:	{ lw r14, r1; addi r1, r1, 4 }                   /* r14 = WORD_2 */
 EX:	{ lw r15, r1; addi r1, r1, 8; addi r10, r0, 60 } /* r15 = WORD_3 */
 
-        /* Load second word from the second L1D line, first
-         * stalling until it has filled by "looking at" r17.
-         */
+	/* Load second word from the second L1D line, first
+	 * stalling until it has filled by "looking at" r17.
+	 */
 EX:	{ lw r19, r1; addi r1, r1, 4; move zero, r17 }  /* r19 = WORD_5 */
 
-        /* Store last word to the destination line, potentially dirtying it
-         * for the first time, which keeps the L2 busy for two cycles.
-         */
+	/* Store last word to the destination line, potentially dirtying it
+	 * for the first time, which keeps the L2 busy for two cycles.
+	 */
 EX:	{ sw r10, r12 }                                 /* store(WORD_15) */
 
-        /* Use two L1D hits to cover the sw L2 access above. */
+	/* Use two L1D hits to cover the sw L2 access above. */
 EX:	{ lw r10, r1; addi r1, r1, 4 }                  /* r10 = WORD_6 */
 EX:	{ lw r12, r1; addi r1, r1, 4 }                  /* r12 = WORD_7 */
 
-        /* Fill third L1D line. */
+	/* Fill third L1D line. */
 EX:	{ lw r18, r1; addi r1, r1, 4 }                  /* r18 = WORD_8 */
 
-        /* Store first L1D line. */
+	/* Store first L1D line. */
 EX:	{ sw r0, r16; addi r0, r0, 4; add r16, r0, r2 } /* store(WORD_0) */
 EX:	{ sw r0, r13; addi r0, r0, 4; andi r16, r16, -64 } /* store(WORD_1) */
 EX:	{ sw r0, r14; addi r0, r0, 4; slt_u r16, r9, r16 } /* store(WORD_2) */
 #if CHIP_HAS_WH64()
 EX:	{ sw r0, r15; addi r0, r0, 4; addi r13, sp, -64 } /* store(WORD_3) */
 #else
-        /* Back up the r9 to a cache line we are already storing to
+	/* Back up the r9 to a cache line we are already storing to
 	 * if it gets past the end of the dest vector.  Strictly speaking,
 	 * we don't need to back up to the start of a cache line, but it's free
 	 * and tidy, so why not?
-         */
+	 */
 EX:	{ sw r0, r15; addi r0, r0, 4; andi r13, r0, -64 } /* store(WORD_3) */
 #endif
-        /* Store second L1D line. */
+	/* Store second L1D line. */
 EX:	{ sw r0, r17; addi r0, r0, 4; mvz r9, r16, r13 }/* store(WORD_4) */
 EX:	{ sw r0, r19; addi r0, r0, 4 }                  /* store(WORD_5) */
 EX:	{ sw r0, r10; addi r0, r0, 4 }                  /* store(WORD_6) */
@@ -348,30 +350,30 @@ EX:	{ lw r13, r1; addi r1, r1, 4; move zero, r18 }  /* r13 = WORD_9 */
 EX:	{ lw r14, r1; addi r1, r1, 4 }                  /* r14 = WORD_10 */
 EX:	{ lw r15, r1; move r1, r20   }                  /* r15 = WORD_11 */
 
-        /* Store third L1D line. */
+	/* Store third L1D line. */
 EX:	{ sw r0, r18; addi r0, r0, 4 }                  /* store(WORD_8) */
 EX:	{ sw r0, r13; addi r0, r0, 4 }                  /* store(WORD_9) */
 EX:	{ sw r0, r14; addi r0, r0, 4 }                  /* store(WORD_10) */
 EX:	{ sw r0, r15; addi r0, r0, 4 }                  /* store(WORD_11) */
 
-        /* Store rest of fourth L1D line. */
+	/* Store rest of fourth L1D line. */
 EX:	{ sw r0, r4;  addi r0, r0, 4 }                  /* store(WORD_12) */
-        {
+	{
 EX:	sw r0, r8                                       /* store(WORD_13) */
-        addi r0, r0, 4
+	addi r0, r0, 4
 	/* Will r2 be > 64 after we subtract 64 below? */
-        shri r4, r2, 7
-        }
-        {
+	shri r4, r2, 7
+	}
+	{
 EX:	sw r0, r11                                      /* store(WORD_14) */
-        addi r0, r0, 8
-        /* Record 64 bytes successfully copied. */
-        addi r2, r2, -64
-        }
+	addi r0, r0, 8
+	/* Record 64 bytes successfully copied. */
+	addi r2, r2, -64
+	}
 
 	{ jrp lr; move lr, r27 }
 
-        /* Convey to the backtrace library that the stack frame is size
+	/* Convey to the backtrace library that the stack frame is size
 	 * zero, and the real return address is on the stack rather than
 	 * in 'lr'.
 	 */
diff --git a/arch/tile/lib/memmove_32.c b/arch/tile/lib/memmove.c
similarity index 100%
rename from arch/tile/lib/memmove_32.c
rename to arch/tile/lib/memmove.c
diff --git a/arch/tile/lib/memset_32.c b/arch/tile/lib/memset_32.c
index d014c1f..57dbb3a 100644
--- a/arch/tile/lib/memset_32.c
+++ b/arch/tile/lib/memset_32.c
@@ -18,6 +18,7 @@
 #include <linux/string.h>
 #include <linux/module.h>
 
+#undef memset
 
 void *memset(void *s, int c, size_t n)
 {
diff --git a/arch/tile/lib/strlen_32.c b/arch/tile/lib/strlen_32.c
index f26f88e..4974292 100644
--- a/arch/tile/lib/strlen_32.c
+++ b/arch/tile/lib/strlen_32.c
@@ -16,6 +16,8 @@
 #include <linux/string.h>
 #include <linux/module.h>
 
+#undef strlen
+
 size_t strlen(const char *s)
 {
 	/* Get an aligned pointer. */
-- 
1.6.5.2

