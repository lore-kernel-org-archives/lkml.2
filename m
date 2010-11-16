Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344Ab0KPEpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 23:45:35 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:50168 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784Ab0KPEpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 23:45:34 -0500
X-Nat-Received: from [202.181.97.72]:52565 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1289882716.2201
Message-Id: <201011160445.oAG4jGif079860@www262.sakura.ne.jp>
Subject: [PATCH 2.6.37-rc2] x86, asm: Add parentheses around one pushl_cfi argument
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: jbeulich@novell.com, heukelum@fastmail.fm, mingo@elte.hu,
        hpa@linux.intel.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 16 Nov 2010 13:45:16 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 15112010 #4290337, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ed935c12f0b2b09c1586d22925261378e0d7eb83 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 16 Nov 2010 13:33:07 +0900
Subject: [PATCH] x86, asm: Add parentheses around one pushl_cfi argument

Commit df5d1874 "x86: Use {push,pop}{l,q}_cfi in more places" caused GNU
assembler 2.15 (Debian Sarge) to fail. It is still failing as of commit
07bd8516 "x86, asm: Restore parentheses around one pushl_cfi argument".
This patch solves build failure with GNU assembler 2.15.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 arch/x86/kernel/entry_32.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 59e175e..591e601 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -395,7 +395,7 @@ sysenter_past_esp:
 	 * A tiny bit of offset fixup is necessary - 4*4 means the 4 words
 	 * pushed above; +8 corresponds to copy_thread's esp0 setting.
 	 */
-	pushl_cfi (TI_sysenter_return-THREAD_SIZE_asm+8+4*4)(%esp)
+	pushl_cfi ((TI_sysenter_return)-THREAD_SIZE_asm+8+4*4)(%esp)
 	CFI_REL_OFFSET eip, 0
 
 	pushl_cfi %eax
-- 
1.7.1

