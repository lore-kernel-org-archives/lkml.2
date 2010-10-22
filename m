Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab0JVH7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:59:45 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:39028 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab0JVH7n convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Fri, 22 Oct 2010 03:59:43 -0400
Message-Id: <4CC157DB020000780001E8A2@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 22 Oct 2010 08:22:35 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <heukelum@fastmail.fm>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: restore parentheses around one pushl_cfi
	 argument
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These were (intentionally) stripped by "fix CFI macro invocations to
deal with shortcomings in gas" to expose problems with unexpected
splitting of arguments by older gas also on newer versions, but as it
turns out there is at least one distro (Ubuntu 6.06) where even not
having *any* spaces in a macro argument doesn't reliably prevent
splitting into multiple arguments.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>

---
 arch/x86/kernel/entry_32.S        |    2 +-
 1 files changed, 1 insertion, 1 deletion

--- 2.6.36-x86-cfi.orig/arch/x86/kernel/entry_32.S
+++ 2.6.36-x86-cfi/arch/x86/kernel/entry_32.S
@@ -395,7 +395,7 @@ sysenter_past_esp:
 	 * A tiny bit of offset fixup is necessary - 4*4 means the 4 words
 	 * pushed above; +8 corresponds to copy_thread's esp0 setting.
 	 */
-	pushl_cfi TI_sysenter_return-THREAD_SIZE_asm+8+4*4(%esp)
+	pushl_cfi (TI_sysenter_return-THREAD_SIZE_asm+8+4*4)(%esp)
 	CFI_REL_OFFSET eip, 0
 
 	pushl_cfi %eax



