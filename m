Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab2B1Jua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:50:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51504 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330Ab2B1Ju2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:50:28 -0500
Date: Tue, 28 Feb 2012 01:49:41 -0800
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-8bd69c2d5f9c0b5237c632d1b21dbfe4fd16ba6b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, hjl.tools@gmail.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, mingo@elte.hu,
        hjl.tools@gmail.com
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] x86/x32: Fix the binutils auto-detect
Git-Commit-ID: 8bd69c2d5f9c0b5237c632d1b21dbfe4fd16ba6b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 28 Feb 2012 01:50:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8bd69c2d5f9c0b5237c632d1b21dbfe4fd16ba6b
Gitweb:     http://git.kernel.org/tip/8bd69c2d5f9c0b5237c632d1b21dbfe4fd16ba6b
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 28 Feb 2012 10:35:06 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 28 Feb 2012 10:35:06 +0100

x86/x32: Fix the binutils auto-detect

Fix:

 arch/x86/Makefile:96: *** recipe commences before first target.  Stop.

Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: H. J. Lu <hjl.tools@gmail.com>
Link: http://lkml.kernel.org/r/1329696488-16970-1-git-send-email-hpa@zytor.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Makefile |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 31bb1eb..968dbe2 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -88,13 +88,13 @@ ifdef CONFIG_X86_X32
 			$(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" - && \
 			$(OBJCOPY) -O elf32-x86-64 "$$TMP" "$$TMPO" && \
 			$(LD) -m elf32_x86_64 "$$TMPO" -o "$$TMP",y,n)
-	ifeq ($(x32_ld_ok),y)
-		CONFIG_X86_X32_ABI := y
-		KBUILD_AFLAGS += -DCONFIG_X86_X32_ABI
-		KBUILD_CFLAGS += -DCONFIG_X86_X32_ABI
-	else
-		$(warning CONFIG_X86_X32 enabled but no binutils support)
-	endif
+        ifeq ($(x32_ld_ok),y)
+                CONFIG_X86_X32_ABI := y
+                KBUILD_AFLAGS += -DCONFIG_X86_X32_ABI
+                KBUILD_CFLAGS += -DCONFIG_X86_X32_ABI
+        else
+                $(warning CONFIG_X86_X32 enabled but no binutils support)
+        endif
 endif
 export CONFIG_X86_X32_ABI
 
