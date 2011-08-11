Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab1HKLAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 07:00:01 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:53843 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827Ab1HKK7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 06:59:50 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 1/9] x86: Don't use magic strings for EFI loader signature
Date: Thu, 11 Aug 2011 11:59:38 +0100
Message-Id: <1313060386-4858-2-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313060386-4858-1-git-send-email-matt@console-pimps.org>
References: <1313060386-4858-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

Introduce a symbol, EFI_LOADER_SIGNATURE instead of using the magic
strings, which also helps to reduce the amount of ifdeffery.

Cc: Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
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

