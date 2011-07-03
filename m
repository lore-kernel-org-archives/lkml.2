Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab1GCVWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 17:22:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:52034 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab1GCVWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 17:22:39 -0400
Date: Sun, 3 Jul 2011 21:22:27 GMT
From: tip-bot for Matthieu CASTET <castet.matthieu@free.fr>
Message-ID: <tip-fd5ed43f54270c0a6aedcaf9e46c15cfa1f27a73@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        castet.matthieu@free.fr, tglx@linutronix.de, hpa@linux.intel.com,
        rjw@sisk.pl
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, tglx@linutronix.de, rjw@sisk.pl,
        hpa@linux.intel.com
In-Reply-To: <1309628621-23107-2-git-send-email-castet.matthieu@free.fr>
References: <1309628621-23107-2-git-send-email-castet.matthieu@free.fr>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, suspend: Clean acpi wakeup code after merge
Git-Commit-ID: fd5ed43f54270c0a6aedcaf9e46c15cfa1f27a73
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 03 Jul 2011 21:22:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd5ed43f54270c0a6aedcaf9e46c15cfa1f27a73
Gitweb:     http://git.kernel.org/tip/fd5ed43f54270c0a6aedcaf9e46c15cfa1f27a73
Author:     Matthieu CASTET <castet.matthieu@free.fr>
AuthorDate: Sat, 2 Jul 2011 19:43:41 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 3 Jul 2011 11:46:14 -0700

x86, suspend: Clean acpi wakeup code after merge

This remove unsued pmode_* entry in wakeup header and saved_*dt
in wakeup_32.

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
Link: http://lkml.kernel.org/r/1309628621-23107-2-git-send-email-castet.matthieu@free.fr
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/acpi/realmode/wakeup.S |    8 --------
 arch/x86/kernel/acpi/realmode/wakeup.h |   11 +----------
 arch/x86/kernel/acpi/sleep.c           |    2 --
 arch/x86/kernel/acpi/wakeup_32.S       |   24 +-----------------------
 4 files changed, 2 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kernel/acpi/realmode/wakeup.S b/arch/x86/kernel/acpi/realmode/wakeup.S
index 150a734..aefa400 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.S
@@ -20,14 +20,6 @@ _start:
 		.globl	wakeup_header
 wakeup_header:
 video_mode:	.short	0	/* Video mode number */
-pmode_return:	.byte	0x66, 0xea	/* ljmpl */
-		.long	0	/* offset goes here */
-		.short	__KERNEL_CS
-pmode_cr0:	.long	0	/* Saved %cr0 */
-pmode_cr3:	.long	0	/* Saved %cr3 */
-pmode_cr4:	.long	0	/* Saved %cr4 */
-pmode_efer:	.quad	0	/* Saved EFER */
-pmode_gdt:	.quad	0
 realmode_flags:	.long	0
 real_magic:	.long	0
 trampoline_segment:	.word 0
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.h b/arch/x86/kernel/acpi/realmode/wakeup.h
index e1828c0..5f302e1 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.h
+++ b/arch/x86/kernel/acpi/realmode/wakeup.h
@@ -12,18 +12,9 @@
 /* This must match data at wakeup.S */
 struct wakeup_header {
 	u16 video_mode;		/* Video mode number */
-	u16 _jmp1;		/* ljmpl opcode, 32-bit only */
-	u32 pmode_entry;	/* Protected mode resume point, 32-bit only */
-	u16 _jmp2;		/* CS value, 32-bit only */
-	u32 pmode_cr0;		/* Protected mode cr0 */
-	u32 pmode_cr3;		/* Protected mode cr3 */
-	u32 pmode_cr4;		/* Protected mode cr4 */
-	u32 pmode_efer_low;	/* Protected mode EFER */
-	u32 pmode_efer_high;
-	u64 pmode_gdt;
 	u32 realmode_flags;
 	u32 real_magic;
-	u16 trampoline_segment;	/* segment with trampoline code, 64-bit only */
+	u16 trampoline_segment;	/* segment with trampoline code */
 	u8  _pad1;
 	u8  wakeup_jmp;
 	u16 wakeup_jmp_off;
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 96719ad..c1d322d 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -67,8 +67,6 @@ int acpi_suspend_lowlevel(void)
 	header->wakeup_gdt[2] =
 		GDT_ENTRY(0x8093, acpi_wakeup_address, 0xfffff);
 
-	header->pmode_cr0 = read_cr0();
-	header->pmode_cr4 = read_cr4_safe();
 	header->realmode_flags = acpi_realmode_flags;
 	header->real_magic = 0x12345678;
 	header->trampoline_segment = trampoline_address() >> 4;
diff --git a/arch/x86/kernel/acpi/wakeup_32.S b/arch/x86/kernel/acpi/wakeup_32.S
index 13ab720..56f8de4 100644
--- a/arch/x86/kernel/acpi/wakeup_32.S
+++ b/arch/x86/kernel/acpi/wakeup_32.S
@@ -17,17 +17,7 @@ wakeup_pmode_return:
 	movw	%ax, %fs
 	movw	%ax, %gs
 
-	# reload the gdt, as we need the full 32 bit address
-	lgdt	saved_gdt
-	lidt	saved_idt
-	lldt	saved_ldt
-	ljmp	$(__KERNEL_CS), $1f
-1:
-	movl	%cr3, %eax
-	movl	%eax, %cr3
-	wbinvd
-
-	# and restore the stack ... but you need gdt for this to work
+	# and restore the stack ...
 	movl	saved_context_esp, %esp
 
 	movl	%cs:saved_magic, %eax
@@ -44,11 +34,6 @@ bogus_magic:
 
 
 save_registers:
-	sgdt	saved_gdt
-	sidt	saved_idt
-	sldt	saved_ldt
-	str	saved_tss
-
 	leal	4(%esp), %eax
 	movl	%eax, saved_context_esp
 	movl	%ebx, saved_context_ebx
@@ -91,10 +76,3 @@ ret_point:
 ALIGN
 ENTRY(saved_magic)	.long	0
 ENTRY(saved_eip)	.long	0
-
-# saved registers
-saved_gdt:	.long	0,0
-saved_idt:	.long	0,0
-saved_ldt:	.long	0
-saved_tss:	.long	0
-
