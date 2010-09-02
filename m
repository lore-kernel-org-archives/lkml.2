Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab0IBMwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 08:52:47 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:50590 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab0IBMwr convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Thu, 2 Sep 2010 08:52:47 -0400
Message-Id: <4C7FBA3D0200007800013F61@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 02 Sep 2010 13:52:45 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Resend: [PATCH] x86-64: fix unwind annotations in syscall
	 stubs
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the return address removed from the stack, these should really
refer to their caller's register state.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/entry_64.S |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- linux-2.6.36-rc3/arch/x86/kernel/entry_64.S
+++ 2.6.36-rc3-x86_64-stub-unwind-annotations/arch/x86/kernel/entry_64.S
@@ -714,9 +714,8 @@ END(ptregscall_common)
 
 ENTRY(stub_execve)
 	CFI_STARTPROC
-	popq %r11
-	CFI_ADJUST_CFA_OFFSET -8
-	CFI_REGISTER rip, r11
+	addq $8, %rsp
+	PARTIAL_FRAME 0
 	SAVE_REST
 	FIXUP_TOP_OF_STACK %r11
 	movq %rsp, %rcx
@@ -735,7 +734,7 @@ END(stub_execve)
 ENTRY(stub_rt_sigreturn)
 	CFI_STARTPROC
 	addq $8, %rsp
-	CFI_ADJUST_CFA_OFFSET	-8
+	PARTIAL_FRAME 0
 	SAVE_REST
 	movq %rsp,%rdi
 	FIXUP_TOP_OF_STACK %r11



