Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab2LMWGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:06:40 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26694 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab2LMWCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:02:54 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v6 19/27] x86, boot: update comments about entries for 64bit image
Date: Thu, 13 Dec 2012 14:02:13 -0800
Message-Id: <1355436141-8668-20-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now 64bit entry is fixed on 0x200, can not be changed anymore.

Update the comments to reflect that.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/compressed/head_64.S |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 5c80b94..5ba0c95 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -37,6 +37,12 @@
 	__HEAD
 	.code32
 ENTRY(startup_32)
+	/*
+	 * 32bit entry is 0, could not be changed!
+	 * If we come here directly from a bootloader,
+	 * kernel(text+data+bss+brk) ramdisk, zero_page, command line
+	 * all need to be under 4G limit.
+	 */
 	cld
 	/*
 	 * Test KEEP_SEGMENTS flag to see if the bootloader is asking
@@ -182,20 +188,18 @@ ENTRY(startup_32)
 	lret
 ENDPROC(startup_32)
 
-	/*
-	 * Be careful here startup_64 needs to be at a predictable
-	 * address so I can export it in an ELF header.  Bootloaders
-	 * should look at the ELF header to find this address, as
-	 * it may change in the future.
-	 */
 	.code64
 	.org 0x200
 ENTRY(startup_64)
 	/*
+	 * 64bit entry is 0x200, could not be changed!
 	 * We come here either from startup_32 or directly from a
-	 * 64bit bootloader.  If we come here from a bootloader we depend on
-	 * an identity mapped page table being provied that maps our
-	 * entire text+data+bss and hopefully all of memory.
+	 * 64bit bootloader.
+	 * If we come here from a bootloader, kernel(text+data+bss+brk),
+	 * ramdisk, zero_page, command line could be above 4G.
+	 * We depend on an identity mapped page table being provided
+	 * that maps our entire kernel(text+data+bss+brk), and hopefully
+	 * all of memory.
 	 */
 #ifdef CONFIG_EFI_STUB
 	/*
-- 
1.7.10.4

