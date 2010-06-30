Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0F3N1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:27:41 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:52874 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab0F3N1k convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 30 Jun 2010 09:27:40 -0400
Message-Id: <4C2B62880200007800008D59@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Jun 2010 14:28:08 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
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

Signed-off-by: Jan Beulich <jbeulich@novell.com>

--- linux-2.6.35-rc3/arch/x86/kernel/entry_64.S
+++ 2.6.35-rc3-x86_64-unwind-annotations/arch/x86/kernel/entry_64.S
@@ -1442,7 +1441,6 @@ error_swapgs:
 error_sti:
 	TRACE_IRQS_OFF
 	ret
-	CFI_ENDPROC
 
 /*
  * There are two places in the kernel that can potentially fault with
@@ -1467,6 +1465,7 @@ bstep_iret:
 	/* Fix truncated RIP */
 	movq %rcx,RIP+8(%rsp)
 	jmp error_swapgs
+	CFI_ENDPROC
 END(error_entry)
 
 



