Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab1ILOgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:36:50 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:54415 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757257Ab1ILOfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:35:03 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 03/10] x86: Don't use magic strings for EFI loader signature
Date: Mon, 12 Sep 2011 15:34:47 +0100
Message-Id: <1315838094-2307-4-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
References: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Introduce a symbol, EFI_LOADER_SIGNATURE instead of using the magic
strings, which also helps to reduce the amount of ifdeffery.

Cc: Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/include/asm/efi.h |    4 ++++
 arch/x86/kernel/setup.c    |    7 +------
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 7093e4a..844f735 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -3,6 +3,8 @@
 
 #ifdef CONFIG_X86_32
 
+#define EFI_LOADER_SIGNATURE	"EL32"
+
 extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
 #define efi_call_phys0(f)		efi_call_phys(f)
@@ -37,6 +39,8 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
 #else /* !CONFIG_X86_32 */
 
+#define EFI_LOADER_SIGNATURE	"EL64"
+
 extern u64 efi_call0(void *fp);
 extern u64 efi_call1(void *fp, u64 arg1);
 extern u64 efi_call2(void *fp, u64 arg1, u64 arg2);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index afaf384..eca164b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -750,12 +750,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #ifdef CONFIG_EFI
 	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-#ifdef CONFIG_X86_32
-		     "EL32",
-#else
-		     "EL64",
-#endif
-	 4)) {
+		     EFI_LOADER_SIGNATURE, 4)) {
 		efi_enabled = 1;
 		efi_memblock_x86_reserve_range();
 	}
-- 
1.7.4.4

