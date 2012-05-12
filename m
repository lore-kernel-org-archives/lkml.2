Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2ELUkA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 16:40:00 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:39949 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab2ELUjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 16:39:22 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: [PATCH 3/4] sh: Setup CROSS_COMPILE at the top
Date: Sat, 12 May 2012 22:39:07 +0200
Message-Id: <1336855148-18817-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336855148-18817-1-git-send-email-geert@linux-m68k.org>
References: <1336855148-18817-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CROSS_COMPILE must be setup before using e.g. cc-option (and a few other
as-*, cc-*, ld-* macros), else they will check against the wrong compiler
when cross-compiling, and may invoke the cross compiler with wrong or
suboptimal compiler options.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
---
 arch/sh/Makefile |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/sh/Makefile b/arch/sh/Makefile
index 46edf07..0d7bbaf 100644
--- a/arch/sh/Makefile
+++ b/arch/sh/Makefile
@@ -9,6 +9,12 @@
 # License.  See the file "COPYING" in the main directory of this archive
 # for more details.
 #
+ifneq ($(SUBARCH),$(ARCH))
+  ifeq ($(CROSS_COMPILE),)
+    CROSS_COMPILE := $(call cc-cross-prefix, $(UTS_MACHINE)-linux-  $(UTS_MACHINE)-linux-gnu-  $(UTS_MACHINE)-unknown-linux-gnu-)
+  endif
+endif
+
 isa-y					:= any
 isa-$(CONFIG_SH_DSP)			:= sh
 isa-$(CONFIG_CPU_SH2)			:= sh2
@@ -106,12 +112,6 @@ LDFLAGS_vmlinux		+= --defsym phys_stext=_stext-$(CONFIG_PAGE_OFFSET) \
 KBUILD_DEFCONFIG	:= cayman_defconfig
 endif
 
-ifneq ($(SUBARCH),$(ARCH))
-  ifeq ($(CROSS_COMPILE),)
-    CROSS_COMPILE := $(call cc-cross-prefix, $(UTS_MACHINE)-linux-  $(UTS_MACHINE)-linux-gnu-  $(UTS_MACHINE)-unknown-linux-gnu-)
-  endif
-endif
-
 ifdef CONFIG_CPU_LITTLE_ENDIAN
 ld-bfd			:= elf32-$(UTS_MACHINE)-linux
 LDFLAGS_vmlinux		+= --defsym 'jiffies=jiffies_64' --oformat $(ld-bfd)
-- 
1.7.0.4

