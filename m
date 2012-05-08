Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab2EHWSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:18:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34465 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2EHWSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:18:37 -0400
Date: Tue, 8 May 2012 15:18:19 -0700
From: tip-bot for Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Message-ID: <tip-c9b77ccb52a5c77233b0e557b7d4417b00ef4012@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jarkko.sakkinen@intel.com, tglx@linutronix.de, rjw@sisk.pl,
        hpa@linux.intel.com, len.brown@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jarkko.sakkinen@intel.com, hpa@linux.intel.com,
        rjw@sisk.pl, len.brown@intel.com
In-Reply-To: <1336501366-28617-7-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-7-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode:
  Move ACPI wakeup to unified realmode code
Git-Commit-ID: c9b77ccb52a5c77233b0e557b7d4417b00ef4012
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 15:18:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9b77ccb52a5c77233b0e557b7d4417b00ef4012
Gitweb:     http://git.kernel.org/tip/c9b77ccb52a5c77233b0e557b7d4417b00ef4012
Author:     Jarkko Sakkinen <jarkko.sakkinen@intel.com>
AuthorDate: Tue, 8 May 2012 21:22:29 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 8 May 2012 11:46:05 -0700

x86, realmode: Move ACPI wakeup to unified realmode code

Migrated ACPI wakeup code to the real-mode blob.
Code existing in .x86_trampoline  can be completely
removed. Static descriptor table in wakeup_asm.S is
courtesy of H. Peter Anvin.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Link: http://lkml.kernel.org/r/1336501366-28617-7-git-send-email-jarkko.sakkinen@intel.com
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/acpi.h                        |    2 -
 arch/x86/include/asm/realmode.h                    |    4 +
 arch/x86/include/asm/trampoline.h                  |   39 -----
 arch/x86/kernel/Makefile                           |    1 -
 arch/x86/kernel/acpi/Makefile                      |    9 +-
 arch/x86/kernel/acpi/realmode/Makefile             |   59 -------
 arch/x86/kernel/acpi/realmode/wakeup.lds.S         |   62 -------
 arch/x86/kernel/acpi/sleep.c                       |   33 +----
 arch/x86/kernel/acpi/sleep.h                       |    2 +-
 arch/x86/kernel/acpi/wakeup_rm.S                   |   12 --
 arch/x86/kernel/head32.c                           |    1 -
 arch/x86/kernel/head64.c                           |    1 -
 arch/x86/kernel/mpparse.c                          |    1 -
 arch/x86/kernel/setup.c                            |    2 -
 arch/x86/kernel/tboot.c                            |    5 +-
 arch/x86/kernel/trampoline.c                       |   42 -----
 arch/x86/kernel/trampoline_32.S                    |   83 ----------
 arch/x86/kernel/trampoline_64.S                    |  171 --------------------
 arch/x86/kernel/vmlinux.lds.S                      |   12 --
 arch/x86/realmode/rm/Makefile                      |    4 +
 arch/x86/realmode/rm/header.S                      |    5 +
 arch/x86/realmode/rm/realmode.lds.S                |    4 +
 .../realmode => realmode/rm/wakeup}/.gitignore     |    0
 arch/x86/realmode/rm/wakeup/Makefile               |   33 ++++
 .../realmode => realmode/rm/wakeup}/bioscall.S     |    0
 .../acpi/realmode => realmode/rm/wakeup}/copy.S    |    0
 .../acpi/realmode => realmode/rm/wakeup}/regs.c    |    0
 .../realmode => realmode/rm/wakeup}/video-bios.c   |    0
 .../realmode => realmode/rm/wakeup}/video-mode.c   |    0
 .../realmode => realmode/rm/wakeup}/video-vesa.c   |    0
 .../realmode => realmode/rm/wakeup}/video-vga.c    |    0
 .../realmode => realmode/rm/wakeup}/wakemain.c     |    3 +-
 .../acpi/realmode => realmode/rm/wakeup}/wakeup.h  |    9 +-
 .../wakeup.S => realmode/rm/wakeup/wakeup_asm.S}   |   69 +++++---
 drivers/acpi/sleep.c                               |    8 +-
 35 files changed, 111 insertions(+), 565 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 610001d..724aa44 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -29,7 +29,6 @@
 #include <asm/processor.h>
 #include <asm/mmu.h>
 #include <asm/mpspec.h>
-#include <asm/trampoline.h>
 
 #define COMPILER_DEPENDENT_INT64   long long
 #define COMPILER_DEPENDENT_UINT64  unsigned long long
@@ -118,7 +117,6 @@ static inline void acpi_disable_pci(void)
 extern int acpi_suspend_lowlevel(void);
 
 extern const unsigned char acpi_wakeup_code[];
-#define acpi_wakeup_address (__pa(TRAMPOLINE_SYM(acpi_wakeup_code)))
 
 /* early initialization routine */
 extern void acpi_reserve_wakeup_memory(void);
diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index 9b4a5da..1bfc74d 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -24,6 +24,10 @@ struct real_mode_header {
 	u32	level3_ident_pgt;
 	u32	level3_kernel_pgt;
 #endif
+#ifdef CONFIG_ACPI_SLEEP
+	u32	wakeup_start;
+	u32	wakeup_header;
+#endif
 } __attribute__((__packed__));
 
 extern struct real_mode_header real_mode_header;
diff --git a/arch/x86/include/asm/trampoline.h b/arch/x86/include/asm/trampoline.h
deleted file mode 100644
index feca311..0000000
--- a/arch/x86/include/asm/trampoline.h
+++ /dev/null
@@ -1,39 +0,0 @@
-#ifndef _ASM_X86_TRAMPOLINE_H
-#define _ASM_X86_TRAMPOLINE_H
-
-#ifndef __ASSEMBLY__
-
-#include <linux/types.h>
-#include <asm/io.h>
-
-/*
- * Trampoline 80x86 program as an array.  These are in the init rodata
- * segment, but that's okay, because we only care about the relative
- * addresses of the symbols.
- */
-extern const unsigned char x86_trampoline_start [];
-extern const unsigned char x86_trampoline_end   [];
-extern unsigned char *x86_trampoline_base;
-
-extern unsigned long init_rsp;
-extern unsigned long initial_code;
-extern unsigned long initial_gs;
-
-extern void __init setup_trampolines(void);
-
-extern const unsigned char trampoline_data[];
-extern const unsigned char trampoline_status[];
-
-#define TRAMPOLINE_SYM(x)						\
-	((void *)(x86_trampoline_base +					\
-		  ((const unsigned char *)(x) - x86_trampoline_start)))
-
-/* Address of the SMP trampoline */
-static inline unsigned long trampoline_address(void)
-{
-	return virt_to_phys(TRAMPOLINE_SYM(trampoline_data));
-}
-
-#endif /* __ASSEMBLY__ */
-
-#endif /* _ASM_X86_TRAMPOLINE_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index b71ef35..4a20f44 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -35,7 +35,6 @@ obj-y			+= tsc.o io_delay.o rtc.o
 obj-y			+= pci-iommu_table.o
 obj-y			+= resource.o
 
-obj-y				+= trampoline.o trampoline_$(BITS).o
 obj-y				+= realmode.o
 obj-y				+= process.o
 obj-y				+= i387.o xsave.o
diff --git a/arch/x86/kernel/acpi/Makefile b/arch/x86/kernel/acpi/Makefile
index 6f35260..163b225 100644
--- a/arch/x86/kernel/acpi/Makefile
+++ b/arch/x86/kernel/acpi/Makefile
@@ -1,14 +1,7 @@
-subdir-				:= realmode
-
 obj-$(CONFIG_ACPI)		+= boot.o
-obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup_rm.o wakeup_$(BITS).o
+obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup_$(BITS).o
 
 ifneq ($(CONFIG_ACPI_PROCESSOR),)
 obj-y				+= cstate.o
 endif
 
-$(obj)/wakeup_rm.o:    $(obj)/realmode/wakeup.bin
-
-$(obj)/realmode/wakeup.bin: FORCE
-	$(Q)$(MAKE) $(build)=$(obj)/realmode
-
diff --git a/arch/x86/kernel/acpi/realmode/Makefile b/arch/x86/kernel/acpi/realmode/Makefile
deleted file mode 100644
index 6a564ac..0000000
--- a/arch/x86/kernel/acpi/realmode/Makefile
+++ /dev/null
@@ -1,59 +0,0 @@
-#
-# arch/x86/kernel/acpi/realmode/Makefile
-#
-# This file is subject to the terms and conditions of the GNU General Public
-# License.  See the file "COPYING" in the main directory of this archive
-# for more details.
-#
-
-always		:= wakeup.bin
-targets		:= wakeup.elf wakeup.lds
-
-wakeup-y	+= wakeup.o wakemain.o video-mode.o copy.o bioscall.o regs.o
-
-# The link order of the video-*.o modules can matter.  In particular,
-# video-vga.o *must* be listed first, followed by video-vesa.o.
-# Hardware-specific drivers should follow in the order they should be
-# probed, and video-bios.o should typically be last.
-wakeup-y	+= video-vga.o
-wakeup-y	+= video-vesa.o
-wakeup-y	+= video-bios.o
-
-targets		+= $(wakeup-y)
-
-bootsrc		:= $(src)/../../../boot
-
-# ---------------------------------------------------------------------------
-
-# How to compile the 16-bit code.  Note we always compile for -march=i386,
-# that way we can complain to the user if the CPU is insufficient.
-# Compile with _SETUP since this is similar to the boot-time setup code.
-KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D_WAKEUP -D__KERNEL__ \
-		   -I$(srctree)/$(bootsrc) \
-		   $(cflags-y) \
-		   -Wall -Wstrict-prototypes \
-		   -march=i386 -mregparm=3 \
-		   -include $(srctree)/$(bootsrc)/code16gcc.h \
-		   -fno-strict-aliasing -fomit-frame-pointer \
-		   $(call cc-option, -ffreestanding) \
-		   $(call cc-option, -fno-toplevel-reorder,\
-			$(call cc-option, -fno-unit-at-a-time)) \
-		   $(call cc-option, -fno-stack-protector) \
-		   $(call cc-option, -mpreferred-stack-boundary=2)
-KBUILD_CFLAGS	+= $(call cc-option, -m32)
-KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
-GCOV_PROFILE := n
-
-WAKEUP_OBJS = $(addprefix $(obj)/,$(wakeup-y))
-
-LDFLAGS_wakeup.elf	:= -T
-
-CPPFLAGS_wakeup.lds += -P -C
-
-$(obj)/wakeup.elf: $(obj)/wakeup.lds $(WAKEUP_OBJS) FORCE
-	$(call if_changed,ld)
-
-OBJCOPYFLAGS_wakeup.bin	:= -O binary
-
-$(obj)/wakeup.bin: $(obj)/wakeup.elf FORCE
-	$(call if_changed,objcopy)
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.lds.S b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
deleted file mode 100644
index d4f8010..0000000
--- a/arch/x86/kernel/acpi/realmode/wakeup.lds.S
+++ /dev/null
@@ -1,62 +0,0 @@
-/*
- * wakeup.ld
- *
- * Linker script for the real-mode wakeup code
- */
-#undef i386
-#include "wakeup.h"
-
-OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
-OUTPUT_ARCH(i386)
-ENTRY(_start)
-
-SECTIONS
-{
-	. = 0;
-	.jump	: {
-		*(.jump)
-	} = 0x90909090
-
-	. = WAKEUP_HEADER_OFFSET;
-	.header : {
-		*(.header)
-	}
-
-	. = ALIGN(16);
-	.text : {
-		 *(.text*)
-	} = 0x90909090
-
-	. = ALIGN(16);
-	.rodata : {
-		*(.rodata*)
-	}
-
-	.videocards : {
-		video_cards = .;
-		*(.videocards)
-		video_cards_end = .;
-	}
-
-	. = ALIGN(16);
-	.data : {
-		 *(.data*)
-	}
-
-	. = ALIGN(16);
-	.bss :	{
-		__bss_start = .;
-		*(.bss)
-		__bss_end = .;
-	}
-
-	.signature : {
-		*(.signature)
-	}
-
-	_end = .;
-
-	/DISCARD/ : {
-		*(.note*)
-	}
-}
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 146a49c..d941b62 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -14,8 +14,9 @@
 #include <asm/desc.h>
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
+#include <asm/realmode.h>
 
-#include "realmode/wakeup.h"
+#include "../../realmode/rm/wakeup/wakeup.h"
 #include "sleep.h"
 
 unsigned long acpi_realmode_flags;
@@ -36,13 +37,9 @@ asmlinkage void acpi_enter_s3(void)
  */
 int acpi_suspend_lowlevel(void)
 {
-	struct wakeup_header *header;
-	/* address in low memory of the wakeup routine. */
-	char *acpi_realmode;
+	struct wakeup_header *header =
+		(struct wakeup_header *) __va(real_mode_header.wakeup_header);
 
-	acpi_realmode = TRAMPOLINE_SYM(acpi_wakeup_code);
-
-	header = (struct wakeup_header *)(acpi_realmode + WAKEUP_HEADER_OFFSET);
 	if (header->signature != WAKEUP_HEADER_SIGNATURE) {
 		printk(KERN_ERR "wakeup header does not match\n");
 		return -EINVAL;
@@ -50,27 +47,6 @@ int acpi_suspend_lowlevel(void)
 
 	header->video_mode = saved_video_mode;
 
-	header->wakeup_jmp_seg = acpi_wakeup_address >> 4;
-
-	/*
-	 * Set up the wakeup GDT.  We set these up as Big Real Mode,
-	 * that is, with limits set to 4 GB.  At least the Lenovo
-	 * Thinkpad X61 is known to need this for the video BIOS
-	 * initialization quirk to work; this is likely to also
-	 * be the case for other laptops or integrated video devices.
-	 */
-
-	/* GDT[0]: GDT self-pointer */
-	header->wakeup_gdt[0] =
-		(u64)(sizeof(header->wakeup_gdt) - 1) +
-		((u64)__pa(&header->wakeup_gdt) << 16);
-	/* GDT[1]: big real mode-like code segment */
-	header->wakeup_gdt[1] =
-		GDT_ENTRY(0x809b, acpi_wakeup_address, 0xfffff);
-	/* GDT[2]: big real mode-like data segment */
-	header->wakeup_gdt[2] =
-		GDT_ENTRY(0x8093, acpi_wakeup_address, 0xfffff);
-
 #ifndef CONFIG_64BIT
 	store_gdt((struct desc_ptr *)&header->pmode_gdt);
 
@@ -95,7 +71,6 @@ int acpi_suspend_lowlevel(void)
 	header->pmode_cr3 = (u32)__pa(&initial_page_table);
 	saved_magic = 0x12345678;
 #else /* CONFIG_64BIT */
-	header->trampoline_segment = trampoline_address() >> 4;
 #ifdef CONFIG_SMP
 	stack_start = (unsigned long)temp_stack + sizeof(temp_stack);
 	early_gdt_descr.address =
diff --git a/arch/x86/kernel/acpi/sleep.h b/arch/x86/kernel/acpi/sleep.h
index d68677a..5653a57 100644
--- a/arch/x86/kernel/acpi/sleep.h
+++ b/arch/x86/kernel/acpi/sleep.h
@@ -2,8 +2,8 @@
  *	Variables and functions used by the code in sleep.c
  */
 
-#include <asm/trampoline.h>
 #include <linux/linkage.h>
+#include <asm/realmode.h>
 
 extern unsigned long saved_video_mode;
 extern long saved_magic;
diff --git a/arch/x86/kernel/acpi/wakeup_rm.S b/arch/x86/kernel/acpi/wakeup_rm.S
deleted file mode 100644
index 63b8ab5..0000000
--- a/arch/x86/kernel/acpi/wakeup_rm.S
+++ /dev/null
@@ -1,12 +0,0 @@
-/*
- * Wrapper script for the realmode binary as a transport object
- * before copying to low memory.
- */
-#include <asm/page_types.h>
-
-	.section ".x86_trampoline","a"
-	.balign PAGE_SIZE
-	.globl	acpi_wakeup_code
-acpi_wakeup_code:
-	.incbin	"arch/x86/kernel/acpi/realmode/wakeup.bin"
-	.size	acpi_wakeup_code, .-acpi_wakeup_code
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 51ff186..c18f59d 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -14,7 +14,6 @@
 #include <asm/sections.h>
 #include <asm/e820.h>
 #include <asm/page.h>
-#include <asm/trampoline.h>
 #include <asm/apic.h>
 #include <asm/io_apic.h>
 #include <asm/bios_ebda.h>
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 3a3b779..037df57 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -24,7 +24,6 @@
 #include <asm/sections.h>
 #include <asm/kdebug.h>
 #include <asm/e820.h>
-#include <asm/trampoline.h>
 #include <asm/bios_ebda.h>
 
 static void __init zap_identity_mappings(void)
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index ca470e4..f44d311 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -27,7 +27,6 @@
 #include <asm/proto.h>
 #include <asm/bios_ebda.h>
 #include <asm/e820.h>
-#include <asm/trampoline.h>
 #include <asm/setup.h>
 #include <asm/smp.h>
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 56e4124..7a14fec 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -73,7 +73,6 @@
 
 #include <asm/mtrr.h>
 #include <asm/apic.h>
-#include <asm/trampoline.h>
 #include <asm/realmode.h>
 #include <asm/e820.h>
 #include <asm/mpspec.h>
@@ -918,7 +917,6 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_DEBUG "initial memory mapped : 0 - %08lx\n",
 			max_pfn_mapped<<PAGE_SHIFT);
 
-	setup_trampolines();
 	setup_real_mode();
 
 	init_gbpages();
diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index 6410744..c136e23 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -32,7 +32,7 @@
 #include <linux/mm.h>
 #include <linux/tboot.h>
 
-#include <asm/trampoline.h>
+#include <asm/realmode.h>
 #include <asm/processor.h>
 #include <asm/bootparam.h>
 #include <asm/pgtable.h>
@@ -201,7 +201,8 @@ static int tboot_setup_sleep(void)
 		add_mac_region(e820.map[i].addr, e820.map[i].size);
 	}
 
-	tboot->acpi_sinfo.kernel_s3_resume_vector = acpi_wakeup_address;
+	tboot->acpi_sinfo.kernel_s3_resume_vector =
+		real_mode_header.wakeup_start;
 
 	return 0;
 }
diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
deleted file mode 100644
index a73b610..0000000
--- a/arch/x86/kernel/trampoline.c
+++ /dev/null
@@ -1,42 +0,0 @@
-#include <linux/io.h>
-#include <linux/memblock.h>
-
-#include <asm/trampoline.h>
-#include <asm/cacheflush.h>
-#include <asm/pgtable.h>
-
-unsigned char *x86_trampoline_base;
-
-void __init setup_trampolines(void)
-{
-	phys_addr_t mem;
-	size_t size = PAGE_ALIGN(x86_trampoline_end - x86_trampoline_start);
-
-	/* Has to be in very low memory so we can execute real-mode AP code. */
-	mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
-	if (!mem)
-		panic("Cannot allocate trampoline\n");
-
-	x86_trampoline_base = __va(mem);
-	memblock_reserve(mem, size);
-
-	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
-	       x86_trampoline_base, (unsigned long long)mem, size);
-
-	memcpy(x86_trampoline_base, x86_trampoline_start, size);
-}
-
-/*
- * setup_trampolines() gets called very early, to guarantee the
- * availability of low memory.  This is before the proper kernel page
- * tables are set up, so we cannot set page permissions in that
- * function.  Thus, we use an arch_initcall instead.
- */
-static int __init configure_trampolines(void)
-{
-	size_t size = PAGE_ALIGN(x86_trampoline_end - x86_trampoline_start);
-
-	set_memory_x((unsigned long)x86_trampoline_base, size >> PAGE_SHIFT);
-	return 0;
-}
-arch_initcall(configure_trampolines);
diff --git a/arch/x86/kernel/trampoline_32.S b/arch/x86/kernel/trampoline_32.S
deleted file mode 100644
index 451c0a7..0000000
--- a/arch/x86/kernel/trampoline_32.S
+++ /dev/null
@@ -1,83 +0,0 @@
-/*
- *
- *	Trampoline.S	Derived from Setup.S by Linus Torvalds
- *
- *	4 Jan 1997 Michael Chastain: changed to gnu as.
- *
- *	This is only used for booting secondary CPUs in SMP machine
- *
- *	Entry: CS:IP point to the start of our code, we are 
- *	in real mode with no stack, but the rest of the 
- *	trampoline page to make our stack and everything else
- *	is a mystery.
- *
- *	We jump into arch/x86/kernel/head_32.S.
- *
- *	On entry to trampoline_data, the processor is in real mode
- *	with 16-bit addressing and 16-bit data.  CS has some value
- *	and IP is zero.  Thus, data addresses need to be absolute
- *	(no relocation) and are taken with regard to r_base.
- *
- *	If you work on this file, check the object module with
- *	objdump --reloc to make sure there are no relocation
- *	entries except for:
- *
- *	TYPE              VALUE
- *	R_386_32          startup_32_smp
- *	R_386_32          boot_gdt
- */
-
-#include <linux/linkage.h>
-#include <linux/init.h>
-#include <asm/segment.h>
-#include <asm/page_types.h>
-
-#ifdef CONFIG_SMP
-
-	.section ".x86_trampoline","a"
-	.balign PAGE_SIZE
-	.code16
-
-ENTRY(trampoline_data)
-r_base = .
-	wbinvd			# Needed for NUMA-Q should be harmless for others
-	mov	%cs, %ax	# Code and data in the same place
-	mov	%ax, %ds
-
-	cli			# We should be safe anyway
-
-	movl	$0xA5A5A5A5, trampoline_status - r_base
-				# write marker for master knows we're running
-
-	/* GDT tables in non default location kernel can be beyond 16MB and
-	 * lgdt will not be able to load the address as in real mode default
-	 * operand size is 16bit. Use lgdtl instead to force operand size
-	 * to 32 bit.
-	 */
-
-	lidtl	boot_idt_descr - r_base	# load idt with 0, 0
-	lgdtl	boot_gdt_descr - r_base	# load gdt with whatever is appropriate
-
-	xor	%ax, %ax
-	inc	%ax		# protected mode (PE) bit
-	lmsw	%ax		# into protected mode
-	# flush prefetch and jump to startup_32_smp in arch/i386/kernel/head.S
-	ljmpl	$__BOOT_CS, $(startup_32_smp-__PAGE_OFFSET)
-
-	# These need to be in the same 64K segment as the above;
-	# hence we don't use the boot_gdt_descr defined in head.S
-boot_gdt_descr:
-	.word	__BOOT_DS + 7			# gdt limit
-	.long	boot_gdt - __PAGE_OFFSET	# gdt base
-
-boot_idt_descr:
-	.word	0				# idt limit = 0
-	.long	0				# idt base = 0L
-
-ENTRY(trampoline_status)
-	.long	0
-
-.globl trampoline_end
-trampoline_end:
-
-#endif /* CONFIG_SMP */
diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
deleted file mode 100644
index 09ff517..0000000
--- a/arch/x86/kernel/trampoline_64.S
+++ /dev/null
@@ -1,171 +0,0 @@
-/*
- *
- *	Trampoline.S	Derived from Setup.S by Linus Torvalds
- *
- *	4 Jan 1997 Michael Chastain: changed to gnu as.
- *	15 Sept 2005 Eric Biederman: 64bit PIC support
- *
- *	Entry: CS:IP point to the start of our code, we are 
- *	in real mode with no stack, but the rest of the 
- *	trampoline page to make our stack and everything else
- *	is a mystery.
- *
- *	On entry to trampoline_data, the processor is in real mode
- *	with 16-bit addressing and 16-bit data.  CS has some value
- *	and IP is zero.  Thus, data addresses need to be absolute
- *	(no relocation) and are taken with regard to r_base.
- *
- *	With the addition of trampoline_level4_pgt this code can
- *	now enter a 64bit kernel that lives at arbitrary 64bit
- *	physical addresses.
- *
- *	If you work on this file, check the object module with objdump
- *	--full-contents --reloc to make sure there are no relocation
- *	entries.
- */
-
-#include <linux/linkage.h>
-#include <linux/init.h>
-#include <asm/pgtable_types.h>
-#include <asm/page_types.h>
-#include <asm/msr.h>
-#include <asm/segment.h>
-#include <asm/processor-flags.h>
-
-	.section ".x86_trampoline","a"
-	.balign PAGE_SIZE
-	.code16
-
-ENTRY(trampoline_data)
-r_base = .
-	cli			# We should be safe anyway
-	wbinvd
-	mov	%cs, %ax	# Code and data in the same place
-	mov	%ax, %ds
-	mov	%ax, %es
-	mov	%ax, %ss
-
-
-	movl	$0xA5A5A5A5, trampoline_status - r_base
-				# write marker for master knows we're running
-
-					# Setup stack
-	movw	$(trampoline_stack_end - r_base), %sp
-
-	call	verify_cpu		# Verify the cpu supports long mode
-	testl   %eax, %eax		# Check for return code
-	jnz	no_longmode
-
-	mov	%cs, %ax
-	movzx	%ax, %esi		# Find the 32bit trampoline location
-	shll	$4, %esi
-
-					# Fixup the absolute vectors
-	leal	(startup_32 - r_base)(%esi), %eax
-	movl	%eax, startup_32_vector - r_base
-	leal	(startup_64 - r_base)(%esi), %eax
-	movl	%eax, startup_64_vector - r_base
-	leal	(tgdt - r_base)(%esi), %eax
-	movl	%eax, (tgdt + 2 - r_base)
-
-	/*
-	 * GDT tables in non default location kernel can be beyond 16MB and
-	 * lgdt will not be able to load the address as in real mode default
-	 * operand size is 16bit. Use lgdtl instead to force operand size
-	 * to 32 bit.
-	 */
-
-	lidtl	tidt - r_base	# load idt with 0, 0
-	lgdtl	tgdt - r_base	# load gdt with whatever is appropriate
-
-	mov	$X86_CR0_PE, %ax	# protected mode (PE) bit
-	lmsw	%ax			# into protected mode
-
-	# flush prefetch and jump to startup_32
-	ljmpl	*(startup_32_vector - r_base)
-
-	.code32
-	.balign 4
-startup_32:
-	movl	$__KERNEL_DS, %eax	# Initialize the %ds segment register
-	movl	%eax, %ds
-
-	movl	$X86_CR4_PAE, %eax
-	movl	%eax, %cr4		# Enable PAE mode
-
-					# Setup trampoline 4 level pagetables
-	leal	(trampoline_level4_pgt - r_base)(%esi), %eax
-	movl	%eax, %cr3
-
-	movl	$MSR_EFER, %ecx
-	movl	$(1 << _EFER_LME), %eax	# Enable Long Mode
-	xorl	%edx, %edx
-	wrmsr
-
-	# Enable paging and in turn activate Long Mode
-	# Enable protected mode
-	movl	$(X86_CR0_PG | X86_CR0_PE), %eax
-	movl	%eax, %cr0
-
-	/*
-	 * At this point we're in long mode but in 32bit compatibility mode
-	 * with EFER.LME = 1, CS.L = 0, CS.D = 1 (and in turn
-	 * EFER.LMA = 1). Now we want to jump in 64bit mode, to do that we use
-	 * the new gdt/idt that has __KERNEL_CS with CS.L = 1.
-	 */
-	ljmp	*(startup_64_vector - r_base)(%esi)
-
-	.code64
-	.balign 4
-startup_64:
-	# Now jump into the kernel using virtual addresses
-	movq	$secondary_startup_64, %rax
-	jmp	*%rax
-
-	.code16
-no_longmode:
-	hlt
-	jmp no_longmode
-#include "verify_cpu.S"
-
-	.balign 4
-	# Careful these need to be in the same 64K segment as the above;
-tidt:
-	.word	0			# idt limit = 0
-	.word	0, 0			# idt base = 0L
-
-	# Duplicate the global descriptor table
-	# so the kernel can live anywhere
-	.balign 4
-tgdt:
-	.short	tgdt_end - tgdt		# gdt limit
-	.long	tgdt - r_base
-	.short 0
-	.quad	0x00cf9b000000ffff	# __KERNEL32_CS
-	.quad	0x00af9b000000ffff	# __KERNEL_CS
-	.quad	0x00cf93000000ffff	# __KERNEL_DS
-tgdt_end:
-
-	.balign 4
-startup_32_vector:
-	.long	startup_32 - r_base
-	.word	__KERNEL32_CS, 0
-
-	.balign 4
-startup_64_vector:
-	.long	startup_64 - r_base
-	.word	__KERNEL_CS, 0
-
-	.balign 4
-ENTRY(trampoline_status)
-	.long	0
-
-trampoline_stack:
-	.org 0x1000
-trampoline_stack_end:
-ENTRY(trampoline_level4_pgt)
-	.quad	level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
-	.fill	510,8,0
-	.quad	level3_kernel_pgt - __START_KERNEL_map + _KERNPG_TABLE
-
-ENTRY(trampoline_end)
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 0f703f1..22a1530 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -197,18 +197,6 @@ SECTIONS
 
 	INIT_DATA_SECTION(16)
 
-	/*
-	 * Code and data for a variety of lowlevel trampolines, to be
-	 * copied into base memory (< 1 MiB) during initialization.
-	 * Since it is copied early, the main copy can be discarded
-	 * afterwards.
-	 */
-	 .x86_trampoline : AT(ADDR(.x86_trampoline) - LOAD_OFFSET) {
-		x86_trampoline_start = .;
-		*(.x86_trampoline)
-		x86_trampoline_end = .;
-	}
-
 	.x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
 		__x86_cpu_dev_start = .;
 		*(.x86_cpu_dev.init)
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 56ec64f..2432acb 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -14,9 +14,13 @@ always := realmode.bin
 realmode-y			+= header.o
 realmode-$(CONFIG_X86_32)	+= reboot_32.o
 realmode-y			+= trampoline_$(BITS).o
+realmode-$(CONFIG_ACPI_SLEEP)	+= wakeup/wakeup.o
 
 targets	+= $(realmode-y)
 
+$(obj)/wakeup/wakeup.o: FORCE
+	$(Q)$(MAKE) $(build)=$(obj)/wakeup $@
+
 REALMODE_OBJS = $(addprefix $(obj)/,$(realmode-y))
 
 sed-pasyms := -n -r -e 's/^([0-9a-fA-F]+) [ABCDGRSTVW] (.+)$$/pa_\2 = \2;/p'
diff --git a/arch/x86/realmode/rm/header.S b/arch/x86/realmode/rm/header.S
index a979004..730b131 100644
--- a/arch/x86/realmode/rm/header.S
+++ b/arch/x86/realmode/rm/header.S
@@ -27,4 +27,9 @@ ENTRY(real_mode_header)
 		.long	pa_level3_ident_pgt
 		.long	pa_level3_kernel_pgt
 #endif
+		/* ACPI sleep */
+#ifdef CONFIG_ACPI_SLEEP
+		.long	pa_wakeup_start
+		.long	pa_wakeup_header
+#endif
 END(real_mode_header)
diff --git a/arch/x86/realmode/rm/realmode.lds.S b/arch/x86/realmode/rm/realmode.lds.S
index c5b8a4f..91b83ea 100644
--- a/arch/x86/realmode/rm/realmode.lds.S
+++ b/arch/x86/realmode/rm/realmode.lds.S
@@ -25,6 +25,10 @@ SECTIONS
 	.rodata : {
 		*(.rodata)
 		*(.rodata.*)
+		. = ALIGN(16);
+		video_cards = .;
+		*(.videocards)
+		video_cards_end = .;
 	}
 
 	. = ALIGN(PAGE_SIZE);
diff --git a/arch/x86/kernel/acpi/realmode/.gitignore b/arch/x86/realmode/rm/wakeup/.gitignore
similarity index 100%
rename from arch/x86/kernel/acpi/realmode/.gitignore
rename to arch/x86/realmode/rm/wakeup/.gitignore
diff --git a/arch/x86/realmode/rm/wakeup/Makefile b/arch/x86/realmode/rm/wakeup/Makefile
new file mode 100644
index 0000000..4c85332
--- /dev/null
+++ b/arch/x86/realmode/rm/wakeup/Makefile
@@ -0,0 +1,33 @@
+#
+# arch/x86/kernel/acpi/realmode/Makefile
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+
+always		:= wakeup.o
+
+wakeup-y	+= wakeup_asm.o wakemain.o video-mode.o
+wakeup-y	+= copy.o bioscall.o regs.o
+
+# The link order of the video-*.o modules can matter.  In particular,
+# video-vga.o *must* be listed first, followed by video-vesa.o.
+# Hardware-specific drivers should follow in the order they should be
+# probed, and video-bios.o should typically be last.
+wakeup-y	+= video-vga.o
+wakeup-y	+= video-vesa.o
+wakeup-y	+= video-bios.o
+
+targets		+= $(wakeup-y)
+
+WAKEUP_OBJS = $(addprefix $(obj)/,$(wakeup-y))
+
+LDFLAGS_wakeup.o := -m elf_i386 -r
+$(obj)/wakeup.o: $(WAKEUP_OBJS) FORCE
+	$(call if_changed,ld)
+
+bootsrc := $(src)/../../../boot
+
+ccflags-y += -D_WAKEUP -I$(srctree)/$(bootsrc)
+asflags-y += -D_WAKEUP -I$(srctree)/$(bootsrc)
diff --git a/arch/x86/kernel/acpi/realmode/bioscall.S b/arch/x86/realmode/rm/wakeup/bioscall.S
similarity index 100%
rename from arch/x86/kernel/acpi/realmode/bioscall.S
rename to arch/x86/realmode/rm/wakeup/bioscall.S
diff --git a/arch/x86/kernel/acpi/realmode/copy.S b/arch/x86/realmode/rm/wakeup/copy.S
similarity index 100%
rename from arch/x86/kernel/acpi/realmode/copy.S
rename to arch/x86/realmode/rm/wakeup/copy.S
diff --git a/arch/x86/kernel/acpi/realmode/regs.c b/arch/x86/realmode/rm/wakeup/regs.c
similarity index 100%
rename from arch/x86/kernel/acpi/realmode/regs.c
rename to arch/x86/realmode/rm/wakeup/regs.c
diff --git a/arch/x86/kernel/acpi/realmode/video-bios.c b/arch/x86/realmode/rm/wakeup/video-bios.c
similarity index 100%
rename from arch/x86/kernel/acpi/realmode/video-bios.c
rename to arch/x86/realmode/rm/wakeup/video-bios.c
diff --git a/arch/x86/kernel/acpi/realmode/video-mode.c b/arch/x86/realmode/rm/wakeup/video-mode.c
similarity index 100%
rename from arch/x86/kernel/acpi/realmode/video-mode.c
rename to arch/x86/realmode/rm/wakeup/video-mode.c
diff --git a/arch/x86/kernel/acpi/realmode/video-vesa.c b/arch/x86/realmode/rm/wakeup/video-vesa.c
similarity index 100%
rename from arch/x86/kernel/acpi/realmode/video-vesa.c
rename to arch/x86/realmode/rm/wakeup/video-vesa.c
diff --git a/arch/x86/kernel/acpi/realmode/video-vga.c b/arch/x86/realmode/rm/wakeup/video-vga.c
similarity index 100%
rename from arch/x86/kernel/acpi/realmode/video-vga.c
rename to arch/x86/realmode/rm/wakeup/video-vga.c
diff --git a/arch/x86/kernel/acpi/realmode/wakemain.c b/arch/x86/realmode/rm/wakeup/wakemain.c
similarity index 98%
rename from arch/x86/kernel/acpi/realmode/wakemain.c
rename to arch/x86/realmode/rm/wakeup/wakemain.c
index 883962d..91405d5 100644
--- a/arch/x86/kernel/acpi/realmode/wakemain.c
+++ b/arch/x86/realmode/rm/wakeup/wakemain.c
@@ -65,7 +65,8 @@ void main(void)
 {
 	/* Kill machine if structures are wrong */
 	if (wakeup_header.real_magic != 0x12345678)
-		while (1);
+		while (1)
+			;
 
 	if (wakeup_header.realmode_flags & 4)
 		send_morse("...-");
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.h b/arch/x86/realmode/rm/wakeup/wakeup.h
similarity index 82%
rename from arch/x86/kernel/acpi/realmode/wakeup.h
rename to arch/x86/realmode/rm/wakeup/wakeup.h
index 97a29e1..2dfaf06 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.h
+++ b/arch/x86/realmode/rm/wakeup/wakeup.h
@@ -12,9 +12,8 @@
 /* This must match data at wakeup.S */
 struct wakeup_header {
 	u16 video_mode;		/* Video mode number */
-	u16 _jmp1;		/* ljmpl opcode, 32-bit only */
 	u32 pmode_entry;	/* Protected mode resume point, 32-bit only */
-	u16 _jmp2;		/* CS value, 32-bit only */
+	u16 pmode_cs;
 	u32 pmode_cr0;		/* Protected mode cr0 */
 	u32 pmode_cr3;		/* Protected mode cr3 */
 	u32 pmode_cr4;		/* Protected mode cr4 */
@@ -26,12 +25,6 @@ struct wakeup_header {
 	u32 pmode_behavior;	/* Wakeup routine behavior flags */
 	u32 realmode_flags;
 	u32 real_magic;
-	u16 trampoline_segment;	/* segment with trampoline code, 64-bit only */
-	u8  _pad1;
-	u8  wakeup_jmp;
-	u16 wakeup_jmp_off;
-	u16 wakeup_jmp_seg;
-	u64 wakeup_gdt[3];
 	u32 signature;		/* To check we have correct structure */
 } __attribute__((__packed__));
 
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.S b/arch/x86/realmode/rm/wakeup/wakeup_asm.S
similarity index 72%
rename from arch/x86/kernel/acpi/realmode/wakeup.S
rename to arch/x86/realmode/rm/wakeup/wakeup_asm.S
index b4fd836..b61126c 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.S
+++ b/arch/x86/realmode/rm/wakeup/wakeup_asm.S
@@ -8,21 +8,15 @@
 #include <asm/processor-flags.h>
 #include "wakeup.h"
 
-	.code16
-	.section ".jump", "ax"
-	.globl	_start
-_start:
-	cli
-	jmp	wakeup_code
+		.code16
 
 /* This should match the structure in wakeup.h */
-		.section ".header", "a"
+		.section ".data", "aw"
 		.globl	wakeup_header
 wakeup_header:
 video_mode:	.short	0	/* Video mode number */
-pmode_return:	.byte	0x66, 0xea	/* ljmpl */
-		.long	0	/* offset goes here */
-		.short	__KERNEL_CS
+pmode_entry:	.long	0
+pmode_cs:	.short	__KERNEL_CS
 pmode_cr0:	.long	0	/* Saved %cr0 */
 pmode_cr3:	.long	0	/* Saved %cr3 */
 pmode_cr4:	.long	0	/* Saved %cr4 */
@@ -32,19 +26,20 @@ pmode_misc_en:	.quad	0	/* Saved MISC_ENABLE MSR */
 pmode_behavior:	.long	0	/* Wakeup behavior flags */
 realmode_flags:	.long	0
 real_magic:	.long	0
-trampoline_segment:	.word 0
-_pad1:		.byte	0
-wakeup_jmp:	.byte	0xea	/* ljmpw */
-wakeup_jmp_off:	.word	3f
-wakeup_jmp_seg:	.word	0
-wakeup_gdt:	.quad	0, 0, 0
 signature:	.long	WAKEUP_HEADER_SIGNATURE
+		.size	wakeup_header, .-wakeup_header
 
 	.text
 	.code16
-wakeup_code:
+	.globl	wakeup_start
+wakeup_start:
+	cli
 	cld
 
+	.byte	0xea		/* ljmpw */
+	.word	3f
+	.word	real_mode_seg
+3:
 	/* Apparently some dimwit BIOS programmers don't know how to
 	   program a PM to RM transition, and we might end up here with
 	   junk in the data segment descriptor registers.  The only way
@@ -54,8 +49,7 @@ wakeup_code:
 	movl	%cr0, %eax
 	orb	$X86_CR0_PE, %al
 	movl	%eax, %cr0
-	jmp	1f
-1:	ljmpw	$8, $2f
+	ljmpw	$8, $2f
 2:
 	movw	%cx, %ds
 	movw	%cx, %es
@@ -65,7 +59,9 @@ wakeup_code:
 
 	andb	$~X86_CR0_PE, %al
 	movl	%eax, %cr0
-	jmp	wakeup_jmp
+	.byte	0xea		/* ljmpw */
+	.word	3f
+	.word	real_mode_seg
 3:
 	/* Set up segments */
 	movw	%cs, %ax
@@ -130,12 +126,9 @@ wakeup_code:
 	/* This really couldn't... */
 	movl	pmode_cr0, %eax
 	movl	%eax, %cr0
-	jmp	pmode_return
+	ljmpl	*pmode_entry
 #else
-	pushw	$0
-	pushw	trampoline_segment
-	pushw	$0
-	lret
+	jmp	trampoline_data
 #endif
 
 bogus_real_magic:
@@ -143,6 +136,32 @@ bogus_real_magic:
 	hlt
 	jmp	1b
 
+	.section ".rodata","a"
+
+	/*
+	 * Set up the wakeup GDT.  We set these up as Big Real Mode,
+	 * that is, with limits set to 4 GB.  At least the Lenovo
+	 * Thinkpad X61 is known to need this for the video BIOS
+	 * initialization quirk to work; this is likely to also
+	 * be the case for other laptops or integrated video devices.
+	 */
+
+	.globl	wakeup_gdt
+	.balign	16
+wakeup_gdt:
+	.word	3*8-1		/* Self-descriptor */
+	.long	pa_wakeup_gdt
+	.word	0
+
+	.word	0xffff		/* 16-bit code segment @ real_mode_base */
+	.long	0x9b000000 + pa_real_mode_base
+	.word	0x008f		/* big real mode */
+
+	.word	0xffff		/* 16-bit data segment @ real_mode_base */
+	.long	0x93000000 + pa_real_mode_base
+	.word	0x008f		/* big real mode */
+	.size	wakeup_gdt, .-wakeup_gdt
+
 	.data
 	.balign	8
 
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index eb6fd23..e77aa4a 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -25,6 +25,8 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
+#include <asm/realmode.h>
+
 #include "internal.h"
 #include "sleep.h"
 
@@ -91,13 +93,13 @@ static struct notifier_block tts_notifier = {
 static int acpi_sleep_prepare(u32 acpi_state)
 {
 #ifdef CONFIG_ACPI_SLEEP
+	unsigned long wakeup_pa = real_mode_header.wakeup_start;
 	/* do we have a wakeup address for S2 and S3? */
 	if (acpi_state == ACPI_STATE_S3) {
-		if (!acpi_wakeup_address) {
+		if (!wakeup_pa)
 			return -EFAULT;
-		}
 		acpi_set_firmware_waking_vector(
-				(acpi_physical_address)acpi_wakeup_address);
+				(acpi_physical_address)wakeup_pa);
 
 	}
 	ACPI_FLUSH_CPU_CACHE();
