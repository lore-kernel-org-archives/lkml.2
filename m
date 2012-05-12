Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab2ELUjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 16:39:18 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:50580 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab2ELUjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 16:39:17 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH 1/4] [-next] Makefile: Do not call cc-option before including the arch's Makefile
Date: Sat, 12 May 2012 22:39:05 +0200
Message-Id: <1336855148-18817-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On architectures that setup CROSS_COMPILE in their arch/*/Makefile
(blackfin, h8300, m68k, mips, parisc, score, sh, tile, unicore32, xtensa),
cc-option may check against the wrong compiler, causing errors like

cc1: error: unrecognized command line option "-fno-ipa-cp-clone"

if the host gcc supports -fno-ipa-cp-clone, while the cross compiler
doesn't support that option.

Move the CONFIG_READABLE_ASM section below the inclusion of the arch's
Makefile to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index d17a616..77355ba 100644
--- a/Makefile
+++ b/Makefile
@@ -561,6 +561,8 @@ else
 KBUILD_CFLAGS	+= -O2
 endif
 
+include $(srctree)/arch/$(SRCARCH)/Makefile
+
 ifdef CONFIG_READABLE_ASM
 # Disable optimizations that make assembler listings hard to read.
 # reorder blocks reorders the control in the function
@@ -571,8 +573,6 @@ KBUILD_CFLAGS += $(call cc-option,-fno-reorder-blocks,) \
                  $(call cc-option,-fno-partial-inlining)
 endif
 
-include $(srctree)/arch/$(SRCARCH)/Makefile
-
 ifneq ($(CONFIG_FRAME_WARN),0)
 KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
 endif
-- 
1.7.0.4

