Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab2ELUjc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 16:39:32 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:50579 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213Ab2ELUjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 16:39:20 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
        linux-m68k@vger.kernel.org
Subject: [PATCH 2/4] m68k: Setup CROSS_COMPILE at the top
Date: Sat, 12 May 2012 22:39:06 +0200
Message-Id: <1336855148-18817-2-git-send-email-geert@linux-m68k.org>
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
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: linux-m68k@lists.linux-m68k.org
---
 arch/m68k/Makefile |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/m68k/Makefile b/arch/m68k/Makefile
index 804f139..b7f2e2d 100644
--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -16,6 +16,13 @@
 
 KBUILD_DEFCONFIG := multi_defconfig
 
+ifneq ($(SUBARCH),$(ARCH))
+	ifeq ($(CROSS_COMPILE),)
+		CROSS_COMPILE := $(call cc-cross-prefix, \
+			m68k-linux-gnu- m68k-linux- m68k-unknown-linux-gnu-)
+	endif
+endif
+
 #
 #	Enable processor type. Ordering of these is important - we want to
 #	use the minimum processor type of the range we support. The logic
@@ -62,12 +69,6 @@ endif
 
 LDFLAGS := -m m68kelf
 KBUILD_LDFLAGS_MODULE += -T $(srctree)/arch/m68k/kernel/module.lds
-ifneq ($(SUBARCH),$(ARCH))
-	ifeq ($(CROSS_COMPILE),)
-		CROSS_COMPILE := $(call cc-cross-prefix, \
-			m68k-linux-gnu- m68k-linux- m68k-unknown-linux-gnu-)
-	endif
-endif
 
 ifdef CONFIG_SUN3
 LDFLAGS_vmlinux = -N
-- 
1.7.0.4

