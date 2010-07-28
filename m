Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab0G1S3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 14:29:01 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:46826 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab0G1S27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 14:28:59 -0400
Date: Wed, 28 Jul 2010 20:28:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/3] frv: clean up arch/frv/Makefile
Message-ID: <20100728182858.GC29232@merkur.ravnborg.org>
References: <20100728182523.GA29198@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100728182523.GA29198@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2193dfaff6e2260a3ac1d2f578616640d601db55 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 28 Jul 2010 19:33:00 +0200
Subject: [PATCH 3/3] frv: clean up arch/frv/Makefile

- removed a lot of unused variable assignmnets
- removed unused bootstrap target
- replaced ARCHMODFLAGS with proper KBUILD_{A,C}FLAGS_MODULE assignmnets

The resuting Makefile has not been tested due to lack of toolchain,
but these were all trivial changes.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/Makefile |   22 ++--------------------
 1 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/arch/frv/Makefile b/arch/frv/Makefile
index 310c47a..7ff8457 100644
--- a/arch/frv/Makefile
+++ b/arch/frv/Makefile
@@ -23,20 +23,14 @@
 # Copyright (C) 1994 by Hamish Macdonald
 #
 
-CCSPECS	:= $(shell $(CC) -v 2>&1 | grep "^Reading specs from " | head -1 | cut -c20-)
-CCDIR	:= $(strip $(patsubst %/specs,%,$(CCSPECS)))
-CPUCLASS := fr400
-
-# test for cross compiling
-COMPILE_ARCH = $(shell uname -m)
-
 ifdef CONFIG_MMU
 UTS_SYSNAME = -DUTS_SYSNAME=\"Linux\"
 else
 UTS_SYSNAME = -DUTS_SYSNAME=\"uClinux\"
 endif
 
-ARCHMODFLAGS	+= -G0 -mlong-calls
+KBUILD_AFLAGS_MODULE += -G0 -mlong-calls
+KBUILD_CFLAGS_MODULE += -G0 -mlong-calls
 
 ifdef CONFIG_GPREL_DATA_8
 KBUILD_CFLAGS	+= -G8
@@ -54,7 +48,6 @@ endif
 
 ifdef CONFIG_GC_SECTIONS
 KBUILD_CFLAGS	+= -ffunction-sections -fdata-sections
-LINKFLAGS	+= --gc-sections
 endif
 
 ifndef CONFIG_FRAME_POINTER
@@ -64,16 +57,13 @@ endif
 ifdef CONFIG_CPU_FR451_COMPILE
 KBUILD_CFLAGS	+= -mcpu=fr450
 KBUILD_AFLAGS	+= -mcpu=fr450
-ASFLAGS		+= -mcpu=fr450
 else
 ifdef CONFIG_CPU_FR551_COMPILE
 KBUILD_CFLAGS	+= -mcpu=fr550
 KBUILD_AFLAGS	+= -mcpu=fr550
-ASFLAGS		+= -mcpu=fr550
 else
 KBUILD_CFLAGS	+= -mcpu=fr400
 KBUILD_AFLAGS	+= -mcpu=fr400
-ASFLAGS		+= -mcpu=fr400
 endif
 endif
 
@@ -83,14 +73,12 @@ endif
 KBUILD_CFLAGS	+= -mno-fdpic -mgpr-32 -msoft-float -mno-media
 KBUILD_CFLAGS	+= -ffixed-fcc3 -ffixed-cc3 -ffixed-gr15 -ffixed-icc2
 KBUILD_AFLAGS	+= -mno-fdpic
-ASFLAGS		+= -mno-fdpic
 
 # make sure the .S files get compiled with debug info
 # and disable optimisations that are unhelpful whilst debugging
 ifdef CONFIG_DEBUG_INFO
 #KBUILD_CFLAGS	+= -O1
 KBUILD_AFLAGS	+= -Wa,--gdwarf2
-ASFLAGS		+= -Wa,--gdwarf2
 endif
 
 head-y		:= arch/frv/kernel/head.o arch/frv/kernel/init_task.o
@@ -105,11 +93,5 @@ all: Image
 Image: vmlinux
 	$(Q)$(MAKE) $(build)=arch/frv/boot $@
 
-bootstrap:
-	$(Q)$(MAKEBOOT) bootstrap
-
 archclean:
 	$(Q)$(MAKE) $(clean)=arch/frv/boot
-
-archdep: scripts/mkdep symlinks
-	$(Q)$(MAKE) $(build)=arch/frv/boot dep
-- 
1.6.0.6

