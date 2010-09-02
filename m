Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0IBMxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 08:53:48 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:39238 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab0IBMxr convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Thu, 2 Sep 2010 08:53:47 -0400
Message-Id: <4C7FBA790200007800013F64@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 02 Sep 2010 13:53:45 +0100
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

The scope should really extend to the end of the function, not the
return location.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/entry_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.36-rc3/arch/x86/kernel/entry_64.S
+++ 2.6.36-rc3-x86_64-error_entry-unwind-scope/arch/x86/kernel/entry_64.S
@@ -1445,7 +1445,6 @@ error_swapgs:
 error_sti:
 	TRACE_IRQS_OFF
 	ret
-	CFI_ENDPROC
 
 /*
  * There are two places in the kernel that can potentially fault with
@@ -1470,6 +1469,7 @@ bstep_iret:
 	/* Fix truncated RIP */
 	movq %rcx,RIP+8(%rsp)
 	jmp error_swapgs
+	CFI_ENDPROC
 END(error_entry)
 
 



