Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab0IWGwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:52:07 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:44286 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753992Ab0IWGwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:52:03 -0400
From: matt mooney <mfm@muteddisk.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, Avi Kivity <avi@redhat.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 12/20] powerpc: change to new flag variables
Date: Wed, 22 Sep 2010 23:51:09 -0700
Message-Id: <1285224669-29865-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y and EXTRA_AFLAGS with asflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 arch/powerpc/kernel/vdso32/Makefile     |    6 +++---
 arch/powerpc/kernel/vdso64/Makefile     |    6 +++---
 arch/powerpc/kvm/Makefile               |    2 +-
 arch/powerpc/lib/Makefile               |    4 +---
 arch/powerpc/math-emu/Makefile          |    2 +-
 arch/powerpc/mm/Makefile                |    4 +---
 arch/powerpc/oprofile/Makefile          |    4 +---
 arch/powerpc/platforms/iseries/Makefile |    2 +-
 arch/powerpc/platforms/pseries/Makefile |   11 +++--------
 arch/powerpc/sysdev/Makefile            |    4 +---
 arch/powerpc/xmon/Makefile              |    4 +---
 11 files changed, 17 insertions(+), 32 deletions(-)

diff --git a/arch/powerpc/kernel/vdso32/Makefile b/arch/powerpc/kernel/vdso32/Makefile
index 51ead52..9a7946c 100644
--- a/arch/powerpc/kernel/vdso32/Makefile
+++ b/arch/powerpc/kernel/vdso32/Makefile
@@ -14,10 +14,10 @@ obj-vdso32 := $(addprefix $(obj)/, $(obj-vdso32))
 
 GCOV_PROFILE := n
 
-EXTRA_CFLAGS := -shared -fno-common -fno-builtin
-EXTRA_CFLAGS += -nostdlib -Wl,-soname=linux-vdso32.so.1 \
+ccflags-y := -shared -fno-common -fno-builtin
+ccflags-y += -nostdlib -Wl,-soname=linux-vdso32.so.1 \
 		$(call cc-ldoption, -Wl$(comma)--hash-style=sysv)
-EXTRA_AFLAGS := -D__VDSO32__ -s
+asflags-y := -D__VDSO32__ -s
 
 obj-y += vdso32_wrapper.o
 extra-y += vdso32.lds
diff --git a/arch/powerpc/kernel/vdso64/Makefile b/arch/powerpc/kernel/vdso64/Makefile
index 79da65d..8c500d8 100644
--- a/arch/powerpc/kernel/vdso64/Makefile
+++ b/arch/powerpc/kernel/vdso64/Makefile
@@ -9,10 +9,10 @@ obj-vdso64 := $(addprefix $(obj)/, $(obj-vdso64))
 
 GCOV_PROFILE := n
 
-EXTRA_CFLAGS := -shared -fno-common -fno-builtin
-EXTRA_CFLAGS += -nostdlib -Wl,-soname=linux-vdso64.so.1 \
+ccflags-y := -shared -fno-common -fno-builtin
+ccflags-y += -nostdlib -Wl,-soname=linux-vdso64.so.1 \
 		$(call cc-ldoption, -Wl$(comma)--hash-style=sysv)
-EXTRA_AFLAGS := -D__VDSO64__ -s
+asflags-y := -D__VDSO64__ -s
 
 obj-y += vdso64_wrapper.o
 extra-y += vdso64.lds
diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index d45c818..4d68638 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -4,7 +4,7 @@
 
 subdir-ccflags-$(CONFIG_PPC_WERROR) := -Werror
 
-EXTRA_CFLAGS += -Ivirt/kvm -Iarch/powerpc/kvm
+ccflags-y := -Ivirt/kvm -Iarch/powerpc/kvm
 
 common-objs-y = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o)
 
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 5bb89c8..e4b0c07 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -4,9 +4,7 @@
 
 subdir-ccflags-$(CONFIG_PPC_WERROR) := -Werror
 
-ifeq ($(CONFIG_PPC64),y)
-EXTRA_CFLAGS		+= -mno-minimal-toc
-endif
+ccflags-$(CONFIG_PPC64)	:= -mno-minimal-toc
 
 CFLAGS_REMOVE_code-patching.o = -pg
 CFLAGS_REMOVE_feature-fixups.o = -pg
diff --git a/arch/powerpc/math-emu/Makefile b/arch/powerpc/math-emu/Makefile
index 0c16ab9..7d1dba0 100644
--- a/arch/powerpc/math-emu/Makefile
+++ b/arch/powerpc/math-emu/Makefile
@@ -15,4 +15,4 @@ obj-$(CONFIG_SPE)		+= math_efp.o
 CFLAGS_fabs.o = -fno-builtin-fabs
 CFLAGS_math.o = -fno-builtin-fabs
 
-EXTRA_CFLAGS = -I. -Iinclude/math-emu -w
+ccflags-y = -I. -Iinclude/math-emu -w
diff --git a/arch/powerpc/mm/Makefile b/arch/powerpc/mm/Makefile
index ce68708..53102f3 100644
--- a/arch/powerpc/mm/Makefile
+++ b/arch/powerpc/mm/Makefile
@@ -4,9 +4,7 @@
 
 subdir-ccflags-$(CONFIG_PPC_WERROR) := -Werror
 
-ifeq ($(CONFIG_PPC64),y)
-EXTRA_CFLAGS	+= -mno-minimal-toc
-endif
+ccflags-$(CONFIG_PPC64)	:= -mno-minimal-toc
 
 obj-y				:= fault.o mem.o pgtable.o gup.o \
 				   init_$(CONFIG_WORD_SIZE).o \
diff --git a/arch/powerpc/oprofile/Makefile b/arch/powerpc/oprofile/Makefile
index e219ca4..73456c4 100644
--- a/arch/powerpc/oprofile/Makefile
+++ b/arch/powerpc/oprofile/Makefile
@@ -1,8 +1,6 @@
 subdir-ccflags-$(CONFIG_PPC_WERROR) := -Werror
 
-ifeq ($(CONFIG_PPC64),y)
-EXTRA_CFLAGS	+= -mno-minimal-toc
-endif
+ccflags-$(CONFIG_PPC64)	:= -mno-minimal-toc
 
 obj-$(CONFIG_OPROFILE) += oprofile.o
 
diff --git a/arch/powerpc/platforms/iseries/Makefile b/arch/powerpc/platforms/iseries/Makefile
index ce01492..a7602b1 100644
--- a/arch/powerpc/platforms/iseries/Makefile
+++ b/arch/powerpc/platforms/iseries/Makefile
@@ -1,4 +1,4 @@
-EXTRA_CFLAGS	+= -mno-minimal-toc
+ccflags-y	:= -mno-minimal-toc
 
 obj-y += exception.o
 obj-y += hvlog.o hvlpconfig.o lpardata.o setup.o dt.o mf.o lpevents.o \
diff --git a/arch/powerpc/platforms/pseries/Makefile b/arch/powerpc/platforms/pseries/Makefile
index 046ace9..7ee1599 100644
--- a/arch/powerpc/platforms/pseries/Makefile
+++ b/arch/powerpc/platforms/pseries/Makefile
@@ -1,10 +1,5 @@
-ifeq ($(CONFIG_PPC64),y)
-EXTRA_CFLAGS		+= -mno-minimal-toc
-endif
-
-ifeq ($(CONFIG_PPC_PSERIES_DEBUG),y)
-EXTRA_CFLAGS		+= -DDEBUG
-endif
+ccflags-$(CONFIG_PPC64)			:= -mno-minimal-toc
+ccflags-$(CONFIG_PPC_PSERIES_DEBUG)	+= -DDEBUG
 
 obj-y			:= lpar.o hvCall.o nvram.o reconfig.o \
 			   setup.o iommu.o event_sources.o ras.o \
@@ -23,7 +18,7 @@ obj-$(CONFIG_MEMORY_HOTPLUG)	+= hotplug-memory.o
 obj-$(CONFIG_HVC_CONSOLE)	+= hvconsole.o
 obj-$(CONFIG_HVCS)		+= hvcserver.o
 obj-$(CONFIG_HCALL_STATS)	+= hvCall_inst.o
-obj-$(CONFIG_PHYP_DUMP)	+= phyp_dump.o
+obj-$(CONFIG_PHYP_DUMP)		+= phyp_dump.o
 obj-$(CONFIG_CMM)		+= cmm.o
 obj-$(CONFIG_DTL)		+= dtl.o
 
diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
index 5642924..c20ad6d 100644
--- a/arch/powerpc/sysdev/Makefile
+++ b/arch/powerpc/sysdev/Makefile
@@ -1,8 +1,6 @@
 subdir-ccflags-$(CONFIG_PPC_WERROR) := -Werror
 
-ifeq ($(CONFIG_PPC64),y)
-EXTRA_CFLAGS			+= -mno-minimal-toc
-endif
+ccflags-$(CONFIG_PPC64)		:= -mno-minimal-toc
 
 mpic-msi-obj-$(CONFIG_PCI_MSI)	+= mpic_msi.o mpic_u3msi.o mpic_pasemi_msi.o
 obj-$(CONFIG_MPIC)		+= mpic.o $(mpic-msi-obj-y)
diff --git a/arch/powerpc/xmon/Makefile b/arch/powerpc/xmon/Makefile
index faa81b6..c168c54 100644
--- a/arch/powerpc/xmon/Makefile
+++ b/arch/powerpc/xmon/Makefile
@@ -4,9 +4,7 @@ subdir-ccflags-$(CONFIG_PPC_WERROR) := -Werror
 
 GCOV_PROFILE := n
 
-ifdef CONFIG_PPC64
-EXTRA_CFLAGS += -mno-minimal-toc
-endif
+ccflags-$(CONFIG_PPC64) := -mno-minimal-toc
 
 obj-y			+= xmon.o start.o nonstdio.o
 
-- 
1.7.2.1

