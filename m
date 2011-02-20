Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab1BTQfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 11:35:19 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60411 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab1BTQfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 11:35:16 -0500
From: Borislav Petkov <bp@alien8.de>
To: Michal Marek <mmarek@suse.cz>
Cc: <torvalds@linux-foundation.org>, <x86@kernel.org>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kbuild@vger.kernel.org
Subject: [PATCH] kbuild: Add extra gcc checks
Date: Sun, 20 Feb 2011 17:35:10 +0100
Message-Id: <1298219710-9846-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.7.4.1.48.g5673d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a 'W=1' Makefile switch which adds additional checking per build
object.

The idea behind this option is targeted at developers who, in the
process of writing their code, want to do the occasional

make W=1 [target.o]

and let gcc do more extensive code checking for them. Then, they
could eyeball the output for valid gcc warnings about various
bugs/discrepancies which are not reported during the normal build
process.

For more background information and a use case, read through this
thread: http://marc.info/?i=20110218091716.GA4384@bicker

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 Makefile |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index c9c8c8f..a783a69 100644
--- a/Makefile
+++ b/Makefile
@@ -102,6 +102,10 @@ ifeq ("$(origin O)", "command line")
   KBUILD_OUTPUT := $(O)
 endif
 
+ifeq ("$(origin W)", "command line")
+  KBUILD_ENABLE_EXTRA_WARNINGS = 1
+endif
+
 # That's our default target when none is given on the command line
 PHONY := _all
 _all:
@@ -363,6 +367,32 @@ KBUILD_AFLAGS_MODULE  := -DMODULE
 KBUILD_CFLAGS_MODULE  := -DMODULE
 KBUILD_LDFLAGS_MODULE := -T $(srctree)/scripts/module-common.lds
 
+ifdef KBUILD_ENABLE_EXTRA_WARNINGS
+KBUILD_CFLAGS += -Wextra -Wno-unused
+KBUILD_CFLAGS += -Waggregate-return
+KBUILD_CFLAGS += -Wbad-function-cast
+KBUILD_CFLAGS += -Wcast-qual
+KBUILD_CFLAGS += -Wcast-align
+KBUILD_CFLAGS += -Wconversion
+KBUILD_CFLAGS += -Wdisabled-optimization
+KBUILD_CFLAGS += -Wlogical-op
+KBUILD_CFLAGS += -Wmissing-declarations
+KBUILD_CFLAGS += -Wmissing-format-attribute
+KBUILD_CFLAGS += -Wmissing-include-dirs
+KBUILD_CFLAGS += -Wmissing-prototypes
+KBUILD_CFLAGS += -Wnested-externs
+KBUILD_CFLAGS += -Wold-style-definition
+KBUILD_CFLAGS += -Woverlength-strings
+KBUILD_CFLAGS += -Wpacked
+KBUILD_CFLAGS += -Wpacked-bitfield-compat
+KBUILD_CFLAGS += -Wpadded
+KBUILD_CFLAGS += -Wpointer-arith
+KBUILD_CFLAGS += -Wredundant-decls
+KBUILD_CFLAGS += -Wshadow
+KBUILD_CFLAGS += -Wswitch-default
+KBUILD_CFLAGS += -Wvla
+endif
+
 # Read KERNELRELEASE from include/config/kernel.release (if it exists)
 KERNELRELEASE = $(shell cat include/config/kernel.release 2> /dev/null)
 KERNELVERSION = $(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
@@ -1262,6 +1292,7 @@ help:
 	@echo  '  make O=dir [targets] Locate all output files in "dir", including .config'
 	@echo  '  make C=1   [targets] Check all c source with $$CHECK (sparse by default)'
 	@echo  '  make C=2   [targets] Force check of all c source with $$CHECK'
+	@echo  '  make W=1   [targets] Enable extra gcc checks'
 	@echo  ''
 	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
 	@echo  'For further info see the ./README file'
-- 
1.7.4.1.48.g5673d

