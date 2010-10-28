Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934016Ab0J1RWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:22:22 -0400
Received: from www.tglx.de ([62.245.132.106]:35824 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933942Ab0J1RWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:22:17 -0400
Date: Thu, 28 Oct 2010 19:21:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86/platform for 2.6.37
Message-ID: <alpine.LFD.2.00.1010281859152.2692@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-platform-for-linus

This is a pure code move, which moves the various platform files from
arch/x86/kernel into subdirectories in arch/x86/platform. That's
necessary to keep some structure with the incoming x86 SoC platform
flood :)

And this is the perfect time, as all pending patches for .37 touching
these files are in your tree already.

Thanks,

	tglx

------------------>
Thomas Gleixner (8):
      x86: Add platform directory
      x86: Move sfi to platform
      x86: Move efi to platform
      x86: Move visws to platform
      x86: Move scx200 to platform
      x86: Move mrst to platform
      x86: Move uv to platform
      x86: Move olpc to platform


 arch/x86/Kbuild                                    |    1 +
 arch/x86/kernel/Makefile                           |   12 ------------
 arch/x86/platform/Makefile                         |    8 ++++++++
 arch/x86/platform/efi/Makefile                     |    1 +
 arch/x86/{kernel => platform/efi}/efi.c            |    0
 arch/x86/{kernel => platform/efi}/efi_32.c         |    0
 arch/x86/{kernel => platform/efi}/efi_64.c         |    0
 arch/x86/{kernel => platform/efi}/efi_stub_32.S    |    0
 arch/x86/{kernel => platform/efi}/efi_stub_64.S    |    0
 arch/x86/platform/mrst/Makefile                    |    1 +
 arch/x86/{kernel => platform/mrst}/mrst.c          |    0
 arch/x86/platform/olpc/Makefile                    |    3 +++
 arch/x86/{kernel => platform/olpc}/olpc-xo1.c      |    0
 arch/x86/{kernel => platform/olpc}/olpc.c          |    0
 arch/x86/{kernel => platform/olpc}/olpc_ofw.c      |    0
 arch/x86/platform/scx200/Makefile                  |    2 ++
 arch/x86/{kernel => platform/scx200}/scx200_32.c   |    0
 arch/x86/platform/sfi/Makefile                     |    1 +
 arch/x86/{kernel => platform/sfi}/sfi.c            |    0
 arch/x86/platform/uv/Makefile                      |    1 +
 arch/x86/{kernel => platform/uv}/bios_uv.c         |    0
 arch/x86/{kernel => platform/uv}/tlb_uv.c          |    0
 arch/x86/{kernel => platform/uv}/uv_irq.c          |    0
 arch/x86/{kernel => platform/uv}/uv_sysfs.c        |    0
 arch/x86/{kernel => platform/uv}/uv_time.c         |    0
 arch/x86/platform/visws/Makefile                   |    1 +
 arch/x86/{kernel => platform/visws}/visws_quirks.c |    0
 27 files changed, 19 insertions(+), 12 deletions(-)
 create mode 100644 arch/x86/platform/Makefile
 create mode 100644 arch/x86/platform/efi/Makefile
 rename arch/x86/{kernel => platform/efi}/efi.c (100%)
 rename arch/x86/{kernel => platform/efi}/efi_32.c (100%)
 rename arch/x86/{kernel => platform/efi}/efi_64.c (100%)
 rename arch/x86/{kernel => platform/efi}/efi_stub_32.S (100%)
 rename arch/x86/{kernel => platform/efi}/efi_stub_64.S (100%)
 create mode 100644 arch/x86/platform/mrst/Makefile
 rename arch/x86/{kernel => platform/mrst}/mrst.c (100%)
 create mode 100644 arch/x86/platform/olpc/Makefile
 rename arch/x86/{kernel => platform/olpc}/olpc-xo1.c (100%)
 rename arch/x86/{kernel => platform/olpc}/olpc.c (100%)
 rename arch/x86/{kernel => platform/olpc}/olpc_ofw.c (100%)
 create mode 100644 arch/x86/platform/scx200/Makefile
 rename arch/x86/{kernel => platform/scx200}/scx200_32.c (100%)
 create mode 100644 arch/x86/platform/sfi/Makefile
 rename arch/x86/{kernel => platform/sfi}/sfi.c (100%)
 create mode 100644 arch/x86/platform/uv/Makefile
 rename arch/x86/{kernel => platform/uv}/bios_uv.c (100%)
 rename arch/x86/{kernel => platform/uv}/tlb_uv.c (100%)
 rename arch/x86/{kernel => platform/uv}/uv_irq.c (100%)
 rename arch/x86/{kernel => platform/uv}/uv_sysfs.c (100%)
 rename arch/x86/{kernel => platform/uv}/uv_time.c (100%)
 create mode 100644 arch/x86/platform/visws/Makefile
 rename arch/x86/{kernel => platform/visws}/visws_quirks.c (100%)

diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
index ad8ec35..0e10323 100644
--- a/arch/x86/Kbuild
+++ b/arch/x86/Kbuild
@@ -14,3 +14,4 @@ obj-y += crypto/
 obj-y += vdso/
 obj-$(CONFIG_IA32_EMULATION) += ia32/
 
+obj-y += platform/
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 2c833d8..9e13763 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -36,7 +36,6 @@ obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time.o ioport.o ldt.o dumpstack.o
 obj-y			+= setup.o x86_init.o i8259.o irqinit.o jump_label.o
 obj-$(CONFIG_IRQ_WORK)  += irq_work.o
-obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
@@ -58,7 +57,6 @@ obj-$(CONFIG_INTEL_TXT)		+= tboot.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
 obj-y				+= acpi/
-obj-$(CONFIG_SFI)		+= sfi.o
 obj-y				+= reboot.o
 obj-$(CONFIG_MCA)		+= mca_32.o
 obj-$(CONFIG_X86_MSR)		+= msr.o
@@ -82,7 +80,6 @@ obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_MODULES)		+= module.o
-obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_VM86)		+= vm86_32.o
@@ -104,14 +101,6 @@ obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
 
 obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
 
-obj-$(CONFIG_SCx200)		+= scx200.o
-scx200-y			+= scx200_32.o
-
-obj-$(CONFIG_OLPC)		+= olpc.o
-obj-$(CONFIG_OLPC_XO1)		+= olpc-xo1.o
-obj-$(CONFIG_OLPC_OPENFIRMWARE)	+= olpc_ofw.o
-obj-$(CONFIG_X86_MRST)		+= mrst.o
-
 microcode-y				:= microcode_core.o
 microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
 microcode-$(CONFIG_MICROCODE_AMD)	+= microcode_amd.o
@@ -124,7 +113,6 @@ obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
-	obj-$(CONFIG_X86_UV)		+= tlb_uv.o bios_uv.o uv_irq.o uv_sysfs.o uv_time.o
 	obj-$(CONFIG_AUDIT)		+= audit_64.o
 
 	obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
diff --git a/arch/x86/platform/Makefile b/arch/x86/platform/Makefile
new file mode 100644
index 0000000..7bf70b8
--- /dev/null
+++ b/arch/x86/platform/Makefile
@@ -0,0 +1,8 @@
+# Platform specific code goes here
+obj-y	+= efi/
+obj-y	+= mrst/
+obj-y	+= olpc/
+obj-y	+= scx200/
+obj-y	+= sfi/
+obj-y	+= visws/
+obj-y	+= uv/
diff --git a/arch/x86/platform/efi/Makefile b/arch/x86/platform/efi/Makefile
new file mode 100644
index 0000000..73b8be0
--- /dev/null
+++ b/arch/x86/platform/efi/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
diff --git a/arch/x86/kernel/efi.c b/arch/x86/platform/efi/efi.c
similarity index 100%
rename from arch/x86/kernel/efi.c
rename to arch/x86/platform/efi/efi.c
diff --git a/arch/x86/kernel/efi_32.c b/arch/x86/platform/efi/efi_32.c
similarity index 100%
rename from arch/x86/kernel/efi_32.c
rename to arch/x86/platform/efi/efi_32.c
diff --git a/arch/x86/kernel/efi_64.c b/arch/x86/platform/efi/efi_64.c
similarity index 100%
rename from arch/x86/kernel/efi_64.c
rename to arch/x86/platform/efi/efi_64.c
diff --git a/arch/x86/kernel/efi_stub_32.S b/arch/x86/platform/efi/efi_stub_32.S
similarity index 100%
rename from arch/x86/kernel/efi_stub_32.S
rename to arch/x86/platform/efi/efi_stub_32.S
diff --git a/arch/x86/kernel/efi_stub_64.S b/arch/x86/platform/efi/efi_stub_64.S
similarity index 100%
rename from arch/x86/kernel/efi_stub_64.S
rename to arch/x86/platform/efi/efi_stub_64.S
diff --git a/arch/x86/platform/mrst/Makefile b/arch/x86/platform/mrst/Makefile
new file mode 100644
index 0000000..efbbc55
--- /dev/null
+++ b/arch/x86/platform/mrst/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_X86_MRST)		+= mrst.o
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/platform/mrst/mrst.c
similarity index 100%
rename from arch/x86/kernel/mrst.c
rename to arch/x86/platform/mrst/mrst.c
diff --git a/arch/x86/platform/olpc/Makefile b/arch/x86/platform/olpc/Makefile
new file mode 100644
index 0000000..c31b8fc
--- /dev/null
+++ b/arch/x86/platform/olpc/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_OLPC)		+= olpc.o
+obj-$(CONFIG_OLPC_XO1)		+= olpc-xo1.o
+obj-$(CONFIG_OLPC_OPENFIRMWARE)	+= olpc_ofw.o
diff --git a/arch/x86/kernel/olpc-xo1.c b/arch/x86/platform/olpc/olpc-xo1.c
similarity index 100%
rename from arch/x86/kernel/olpc-xo1.c
rename to arch/x86/platform/olpc/olpc-xo1.c
diff --git a/arch/x86/kernel/olpc.c b/arch/x86/platform/olpc/olpc.c
similarity index 100%
rename from arch/x86/kernel/olpc.c
rename to arch/x86/platform/olpc/olpc.c
diff --git a/arch/x86/kernel/olpc_ofw.c b/arch/x86/platform/olpc/olpc_ofw.c
similarity index 100%
rename from arch/x86/kernel/olpc_ofw.c
rename to arch/x86/platform/olpc/olpc_ofw.c
diff --git a/arch/x86/platform/scx200/Makefile b/arch/x86/platform/scx200/Makefile
new file mode 100644
index 0000000..762b4c7
--- /dev/null
+++ b/arch/x86/platform/scx200/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_SCx200)		+= scx200.o
+scx200-y			+= scx200_32.o
diff --git a/arch/x86/kernel/scx200_32.c b/arch/x86/platform/scx200/scx200_32.c
similarity index 100%
rename from arch/x86/kernel/scx200_32.c
rename to arch/x86/platform/scx200/scx200_32.c
diff --git a/arch/x86/platform/sfi/Makefile b/arch/x86/platform/sfi/Makefile
new file mode 100644
index 0000000..cc5db11
--- /dev/null
+++ b/arch/x86/platform/sfi/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SFI)		+= sfi.o
diff --git a/arch/x86/kernel/sfi.c b/arch/x86/platform/sfi/sfi.c
similarity index 100%
rename from arch/x86/kernel/sfi.c
rename to arch/x86/platform/sfi/sfi.c
diff --git a/arch/x86/platform/uv/Makefile b/arch/x86/platform/uv/Makefile
new file mode 100644
index 0000000..6c40995
--- /dev/null
+++ b/arch/x86/platform/uv/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_X86_UV)		+= tlb_uv.o bios_uv.o uv_irq.o uv_sysfs.o uv_time.o
diff --git a/arch/x86/kernel/bios_uv.c b/arch/x86/platform/uv/bios_uv.c
similarity index 100%
rename from arch/x86/kernel/bios_uv.c
rename to arch/x86/platform/uv/bios_uv.c
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
similarity index 100%
rename from arch/x86/kernel/tlb_uv.c
rename to arch/x86/platform/uv/tlb_uv.c
diff --git a/arch/x86/kernel/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
similarity index 100%
rename from arch/x86/kernel/uv_irq.c
rename to arch/x86/platform/uv/uv_irq.c
diff --git a/arch/x86/kernel/uv_sysfs.c b/arch/x86/platform/uv/uv_sysfs.c
similarity index 100%
rename from arch/x86/kernel/uv_sysfs.c
rename to arch/x86/platform/uv/uv_sysfs.c
diff --git a/arch/x86/kernel/uv_time.c b/arch/x86/platform/uv/uv_time.c
similarity index 100%
rename from arch/x86/kernel/uv_time.c
rename to arch/x86/platform/uv/uv_time.c
diff --git a/arch/x86/platform/visws/Makefile b/arch/x86/platform/visws/Makefile
new file mode 100644
index 0000000..91bc17a
--- /dev/null
+++ b/arch/x86/platform/visws/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/platform/visws/visws_quirks.c
similarity index 100%
rename from arch/x86/kernel/visws_quirks.c
rename to arch/x86/platform/visws/visws_quirks.c
