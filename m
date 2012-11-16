Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab2KPIyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:54:52 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41425 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2KPIxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:53:37 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 2/9] x86: Add macro for 64bit entry for bzImage
Date: Fri, 16 Nov 2012 00:53:02 -0800
Message-Id: <1353055989-31939-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353055989-31939-1-git-send-email-yinghai@kernel.org>
References: <1353055989-31939-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will use it with bzImage header.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/head_64.S |    2 +-
 arch/x86/include/asm/boot.h        |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 4c8af67..0733638 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -197,7 +197,7 @@ no_longmode:
 	 * it may change in the future.
 	 */
 	.code64
-	.org 0x208
+	.org BOOT_CODE64_START_OFFSET
 ENTRY(startup_64)
 	/*
 	 * We come here either from startup_32 or directly from a
diff --git a/arch/x86/include/asm/boot.h b/arch/x86/include/asm/boot.h
index b13fe63..bcae405 100644
--- a/arch/x86/include/asm/boot.h
+++ b/arch/x86/include/asm/boot.h
@@ -38,8 +38,10 @@
 
 #ifdef CONFIG_X86_64
 #define BOOT_STACK_SIZE	0x4000
+#define BOOT_CODE64_START_OFFSET 0x208
 #else
 #define BOOT_STACK_SIZE	0x1000
+#define BOOT_CODE64_START_OFFSET 0
 #endif
 
 #endif /* __KERNEL__ */
-- 
1.7.7

