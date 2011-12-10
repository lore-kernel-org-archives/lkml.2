Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab1LJCiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 21:38:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48780 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1LJCiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 21:38:20 -0500
Date: Fri, 9 Dec 2011 18:38:11 -0800
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-f7d7d01be53cb47e0ae212c4e968aa28b82d2138@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com,
        matt.fleming@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        matt.fleming@intel.com, hpa@linux.intel.com
In-Reply-To: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86: Don't use magic strings for EFI loader signature
Git-Commit-ID: f7d7d01be53cb47e0ae212c4e968aa28b82d2138
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Dec 2011 18:38:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7d7d01be53cb47e0ae212c4e968aa28b82d2138
Gitweb:     http://git.kernel.org/tip/f7d7d01be53cb47e0ae212c4e968aa28b82d2138
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Tue, 15 Nov 2011 12:56:14 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 Dec 2011 17:35:38 -0800

x86: Don't use magic strings for EFI loader signature

Introduce a symbol, EFI_LOADER_SIGNATURE instead of using the magic
strings, which also helps to reduce the amount of ifdeffery.

Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1318848017-12301-1-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/efi.h |    4 ++++
 arch/x86/kernel/setup.c    |    7 +------
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index b8d8bfc..26d8c18 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -3,6 +3,8 @@
 
 #ifdef CONFIG_X86_32
 
+#define EFI_LOADER_SIGNATURE	"EL32"
+
 extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
 #define efi_call_phys0(f)		efi_call_phys(f)
@@ -35,6 +37,8 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
 #else /* !CONFIG_X86_32 */
 
+#define EFI_LOADER_SIGNATURE	"EL64"
+
 extern u64 efi_call0(void *fp);
 extern u64 efi_call1(void *fp, u64 arg1);
 extern u64 efi_call2(void *fp, u64 arg1, u64 arg2);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9a9e40f..4d5243c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -752,12 +752,7 @@ void __init setup_arch(char **cmdline_p)
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
