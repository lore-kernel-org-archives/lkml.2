Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0IWGwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:52:30 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:53902 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754014Ab0IWGw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:52:28 -0400
From: matt mooney <mfm@muteddisk.com>
To: Avi Kivity <avi@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 17/20] x86: change to new flag variables
Date: Wed, 22 Sep 2010 23:51:38 -0700
Message-Id: <1285224698-30035-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y and EXTRA_AFLAGS with asflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 arch/x86/kvm/Makefile      |    2 +-
 arch/x86/math-emu/Makefile |    4 ++--
 arch/x86/pci/Makefile      |    4 +---
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 31a7035..0feb536 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -1,5 +1,5 @@
 
-EXTRA_CFLAGS += -Ivirt/kvm -Iarch/x86/kvm
+ccflags-y := -Ivirt/kvm -Iarch/x86/kvm
 
 CFLAGS_x86.o := -I.
 CFLAGS_svm.o := -I.
diff --git a/arch/x86/math-emu/Makefile b/arch/x86/math-emu/Makefile
index 9b0c63b..a88eac2 100644
--- a/arch/x86/math-emu/Makefile
+++ b/arch/x86/math-emu/Makefile
@@ -5,8 +5,8 @@
 #DEBUG	= -DDEBUGGING
 DEBUG	=
 PARANOID = -DPARANOID
-EXTRA_CFLAGS	:= $(PARANOID) $(DEBUG) -fno-builtin $(MATH_EMULATION)
-EXTRA_AFLAGS	:= $(PARANOID)
+ccflags-y := $(PARANOID) $(DEBUG) -fno-builtin $(MATH_EMULATION)
+asflags-y := $(PARANOID)
 
 # From 'C' language sources:
 C_OBJS =fpu_entry.o errors.o \
diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index a0207a7..8e60497 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -20,6 +20,4 @@ obj-y				+= amd_bus.o bus_numa.o
 
 obj-$(CONFIG_PCI_CNB20LE_QUIRK)	+= broadcom_bus.o
 
-ifeq ($(CONFIG_PCI_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_PCI_DEBUG) := -DDEBUG
-- 
1.7.2.1

