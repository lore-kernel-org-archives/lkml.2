Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab2LKKSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 05:18:30 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57076 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab2LKKS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 05:18:29 -0500
Date: Tue, 11 Dec 2012 11:18:23 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/boot changes for v3.8
Message-ID: <20121211101823.GA25114@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-boot-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-boot-for-linus

   HEAD: 6e87f9b7e48e165cb8e6092b9abe682e7065614a arch/x86/Kconfig: Allow turning off CONFIG_X86_MPPARSE when either ACPI or SFI is present

Two small changes: a cleanup and allow CONFIG_X86_MPPARSE to be 
turned off on SFI as well.

 Thanks,

	Ingo

------------------>
Bin Gao (1):
      arch/x86/Kconfig: Allow turning off CONFIG_X86_MPPARSE when either ACPI or SFI is present

Kees Cook (1):
      x86/boot/doc: Fix grammar and typo in boot.txt


 Documentation/x86/boot.txt | 4 ++--
 arch/x86/Kconfig           | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 9efceff..f15cb74 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -1013,7 +1013,7 @@ boot_params as that of 16-bit boot protocol, the boot loader should
 also fill the additional fields of the struct boot_params as that
 described in zero-page.txt.
 
-After setupping the struct boot_params, the boot loader can load the
+After setting up the struct boot_params, the boot loader can load the
 32/64-bit kernel in the same way as that of 16-bit boot protocol.
 
 In 32-bit boot protocol, the kernel is started by jumping to the
@@ -1023,7 +1023,7 @@ In 32-bit boot protocol, the kernel is started by jumping to the
 At entry, the CPU must be in 32-bit protected mode with paging
 disabled; a GDT must be loaded with the descriptors for selectors
 __BOOT_CS(0x10) and __BOOT_DS(0x18); both descriptors must be 4G flat
-segment; __BOOS_CS must have execute/read permission, and __BOOT_DS
+segment; __BOOT_CS must have execute/read permission, and __BOOT_DS
 must have read/write permission; CS must be __BOOT_CS and DS, ES, SS
 must be __BOOT_DS; interrupt must be disabled; %esi must hold the base
 address of the struct boot_params; %ebp, %edi and %ebx must be zero.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 46c3bff..b1494bd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -310,7 +310,7 @@ config X86_X2APIC
 	  If you don't know what to do here, say N.
 
 config X86_MPPARSE
-	bool "Enable MPS table" if ACPI
+	bool "Enable MPS table" if ACPI || SFI
 	default y
 	depends on X86_LOCAL_APIC
 	---help---
