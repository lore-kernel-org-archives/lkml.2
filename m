Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab1HOFHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:07:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37521 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab1HOFHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:07:45 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        x86@kernel.org
Subject: [PATCH 04/11] arch/x86: do not use EXTRA_CFLAGS
Date: Mon, 15 Aug 2011 01:07:07 -0400
Message-Id: <1313384834-24433-5-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
In-Reply-To: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
References: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usage of these flags has been deprecated for nearly 4 years by:

    commit f77bf01425b11947eeb3b5b54685212c302741b8
    Author: Sam Ravnborg <sam@neptun.(none)>
    Date:   Mon Oct 15 22:25:06 2007 +0200

        kbuild: introduce ccflags-y, asflags-y and ldflags-y

Moreover, these flags (at least EXTRA_CFLAGS) have been documented for command
line use. By default, gmake(1) do not override command line setting, so this is
likely to result in build failure or unexpected behavior.

Replace their usage by Kbuild's `{as,cc,ld}flags-y'.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: x86@kernel.org
---
 arch/x86/math-emu/Makefile |    4 ++--
 arch/x86/pci/Makefile      |    4 +---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/math-emu/Makefile b/arch/x86/math-emu/Makefile
index 9b0c63b..60db1b8 100644
--- a/arch/x86/math-emu/Makefile
+++ b/arch/x86/math-emu/Makefile
@@ -5,8 +5,8 @@
 #DEBUG	= -DDEBUGGING
 DEBUG	=
 PARANOID = -DPARANOID
-EXTRA_CFLAGS	:= $(PARANOID) $(DEBUG) -fno-builtin $(MATH_EMULATION)
-EXTRA_AFLAGS	:= $(PARANOID)
+ccflags-y	:= $(PARANOID) $(DEBUG) -fno-builtin $(MATH_EMULATION)
+asflags-y	:= $(PARANOID)
 
 # From 'C' language sources:
 C_OBJS =fpu_entry.o errors.o \
diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index 6b8759f..aef971f 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -22,6 +22,4 @@ obj-y				+= amd_bus.o bus_numa.o
 
 obj-$(CONFIG_PCI_CNB20LE_QUIRK)	+= broadcom_bus.o
 
-ifeq ($(CONFIG_PCI_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_PCI_DEBUG) += -DDEBUG
-- 
1.7.6.153.g78432

