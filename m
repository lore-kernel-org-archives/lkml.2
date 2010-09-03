Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab0ICGgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 02:36:45 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:60262 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab0ICGgo convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Fri, 3 Sep 2010 02:36:44 -0400
Message-Id: <4C80B39B02000078000141B9@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 03 Sep 2010 07:36:43 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <heukelum@fastmail.fm>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix CFI coverage for error_entry()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scope should really extend to the end of the function, not the
return location.

(Subject was wrong in the variant I sent yesterday.)

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>

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
 
 



