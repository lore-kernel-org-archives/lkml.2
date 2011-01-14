Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab1ANONY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:13:24 -0500
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:51795 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923Ab1ANONT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:13:19 -0500
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 02/27] alpha: change to new flag variables
Date: Fri, 14 Jan 2011 06:12:25 -0800
Message-Id: <b879a11b18fd11fa9c63b885c52aaa3af654a93f.1295006565.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <cover.1295006561.git.mfm@muteddisk.com>
References: <cover.1295006561.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y and EXTRA_AFLAGS with asflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
---
 arch/alpha/kernel/Makefile   |    4 ++--
 arch/alpha/lib/Makefile      |    4 ++--
 arch/alpha/math-emu/Makefile |    2 +-
 arch/alpha/mm/Makefile       |    2 +-
 arch/alpha/oprofile/Makefile |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/alpha/kernel/Makefile b/arch/alpha/kernel/Makefile
index 1ee9b5b..9bb7b85 100644
--- a/arch/alpha/kernel/Makefile
+++ b/arch/alpha/kernel/Makefile
@@ -3,8 +3,8 @@
 #
 
 extra-y		:= head.o vmlinux.lds
-EXTRA_AFLAGS	:= $(KBUILD_CFLAGS)
-EXTRA_CFLAGS	:= -Werror -Wno-sign-compare
+asflags-y	:= $(KBUILD_CFLAGS)
+ccflags-y	:= -Werror -Wno-sign-compare
 
 obj-y    := entry.o traps.o process.o init_task.o osf_sys.o irq.o \
 	    irq_alpha.o signal.o setup.o ptrace.o time.o \
diff --git a/arch/alpha/lib/Makefile b/arch/alpha/lib/Makefile
index 9b72c59..c0a83ab 100644
--- a/arch/alpha/lib/Makefile
+++ b/arch/alpha/lib/Makefile
@@ -2,8 +2,8 @@
 # Makefile for alpha-specific library files..
 #
 
-EXTRA_AFLAGS := $(KBUILD_CFLAGS)
-EXTRA_CFLAGS := -Werror
+asflags-y := $(KBUILD_CFLAGS)
+ccflags-y := -Werror
 
 # Many of these routines have implementations tuned for ev6.
 # Choose them iff we're targeting ev6 specifically.
diff --git a/arch/alpha/math-emu/Makefile b/arch/alpha/math-emu/Makefile
index 359ef08..7f46719 100644
--- a/arch/alpha/math-emu/Makefile
+++ b/arch/alpha/math-emu/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the FPU instruction emulation.
 #
 
-EXTRA_CFLAGS := -w
+ccflags-y := -w
 
 obj-$(CONFIG_MATHEMU) += math-emu.o
 
diff --git a/arch/alpha/mm/Makefile b/arch/alpha/mm/Makefile
index 09399c5..c993d3f 100644
--- a/arch/alpha/mm/Makefile
+++ b/arch/alpha/mm/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux alpha-specific parts of the memory manager.
 #
 
-EXTRA_CFLAGS := -Werror
+ccflags-y := -Werror
 
 obj-y	:= init.o fault.o extable.o
 
diff --git a/arch/alpha/oprofile/Makefile b/arch/alpha/oprofile/Makefile
index 4aa5624..3473de7 100644
--- a/arch/alpha/oprofile/Makefile
+++ b/arch/alpha/oprofile/Makefile
@@ -1,4 +1,4 @@
-EXTRA_CFLAGS := -Werror -Wno-sign-compare
+ccflags-y := -Werror -Wno-sign-compare
 
 obj-$(CONFIG_OPROFILE) += oprofile.o
 
-- 
1.7.3.4

