Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab2KRHMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 02:12:35 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:17139 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2KRHJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 02:09:53 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v2 03/13] x86: Add macro for 64bit entry startup_64
Date: Sat, 17 Nov 2012 23:09:21 -0800
Message-Id: <1353222571-31544-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353222571-31544-1-git-send-email-yinghai@kernel.org>
References: <1353222571-31544-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will add one 64bit entry for bzImage in boot header struct.

the contents in that field will be offset of startup_64.

Add macro for offset of startup_64 to keep two places consistent.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/head_64.S |    2 +-
 arch/x86/include/asm/boot.h        |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 375af23..e4964dd 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -195,7 +195,7 @@ no_longmode:
 	 * it may change in the future.
 	 */
 	.code64
-	.org 0x200
+	.org BOOT_CODE64_START_OFFSET
 ENTRY(startup_64)
 	/*
 	 * We come here either from startup_32 or directly from a
diff --git a/arch/x86/include/asm/boot.h b/arch/x86/include/asm/boot.h
index b13fe63..ef36497 100644
--- a/arch/x86/include/asm/boot.h
+++ b/arch/x86/include/asm/boot.h
@@ -38,8 +38,10 @@
 
 #ifdef CONFIG_X86_64
 #define BOOT_STACK_SIZE	0x4000
+#define BOOT_CODE64_START_OFFSET 0x200
 #else
 #define BOOT_STACK_SIZE	0x1000
+#define BOOT_CODE64_START_OFFSET 0
 #endif
 
 #endif /* __KERNEL__ */
-- 
1.7.7

