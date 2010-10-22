Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab0JVJ4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 05:56:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:42353 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab0JVJ4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 05:56:35 -0400
Date: Fri, 22 Oct 2010 09:56:13 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, heukelum@fastmail.fm, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, JBeulich@novell.com, heukelum@fastmail.fm,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4CC157DB020000780001E8A2@vpn.id2.novell.com>
References: <4CC157DB020000780001E8A2@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86, asm: Restore parentheses around one pushl_cfi argument
Message-ID: <tip-07bd8516a2f967aa67904c68ab97bb896a448b09@git.kernel.org>
Git-Commit-ID: 07bd8516a2f967aa67904c68ab97bb896a448b09
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Oct 2010 09:56:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07bd8516a2f967aa67904c68ab97bb896a448b09
Gitweb:     http://git.kernel.org/tip/07bd8516a2f967aa67904c68ab97bb896a448b09
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Fri, 22 Oct 2010 08:22:35 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Oct 2010 10:51:44 +0200

x86, asm: Restore parentheses around one pushl_cfi argument

These were (intentionally) stripped by "fix CFI macro
invocations to deal with shortcomings in gas" to expose problems
with unexpected splitting of arguments by older gas also on
newer versions, but as it turns out there is at least one distro
(Ubuntu 6.06) where even not having *any* spaces in a macro
argument doesn't reliably prevent splitting into multiple
arguments.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
LKML-Reference: <4CC157DB020000780001E8A2@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/entry_32.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index f73a4b8..59e175e 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -395,7 +395,7 @@ sysenter_past_esp:
 	 * A tiny bit of offset fixup is necessary - 4*4 means the 4 words
 	 * pushed above; +8 corresponds to copy_thread's esp0 setting.
 	 */
-	pushl_cfi TI_sysenter_return-THREAD_SIZE_asm+8+4*4(%esp)
+	pushl_cfi (TI_sysenter_return-THREAD_SIZE_asm+8+4*4)(%esp)
 	CFI_REL_OFFSET eip, 0
 
 	pushl_cfi %eax
