Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223Ab0KROGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:06:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:41188 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756591Ab0KROGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:06:40 -0500
Date: Thu, 18 Nov 2010 14:06:19 GMT
From: tip-bot for Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, penguin-kernel@I-love.SAKURA.ne.jp,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, penguin-kernel@I-love.SAKURA.ne.jp,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <201011160445.oAG4jGif079860@www262.sakura.ne.jp>
References: <201011160445.oAG4jGif079860@www262.sakura.ne.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, asm: Fix binutils 2.15 build failure
Message-ID: <tip-96e612ffc301372d3a3b94e2cb5d1e0c1c207dd1@git.kernel.org>
Git-Commit-ID: 96e612ffc301372d3a3b94e2cb5d1e0c1c207dd1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:06:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96e612ffc301372d3a3b94e2cb5d1e0c1c207dd1
Gitweb:     http://git.kernel.org/tip/96e612ffc301372d3a3b94e2cb5d1e0c1c207dd1
Author:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
AuthorDate: Tue, 16 Nov 2010 13:45:16 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 09:25:11 +0100

x86, asm: Fix binutils 2.15 build failure

Add parentheses around one pushl_cfi argument.

Commit df5d1874 "x86: Use {push,pop}{l,q}_cfi in more places"
caused GNU assembler 2.15 (Debian Sarge) to fail. It is still
failing as of commit 07bd8516 "x86, asm: Restore parentheses
around one pushl_cfi argument". This patch solves build failure
with GNU assembler 2.15.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Jan Beulich <jbeulich@novell.com>
Cc: heukelum@fastmail.fm
Cc: hpa@linux.intel.com
LKML-Reference: <201011160445.oAG4jGif079860@www262.sakura.ne.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
