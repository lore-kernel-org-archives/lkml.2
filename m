Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab2AEQLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 11:11:32 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:64706 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757630Ab2AEQLb convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 5 Jan 2012 11:11:31 -0500
Message-Id: <4F05D9F9020000780006AA0D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 05 Jan 2012 16:12:25 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: slightly shorten copy_page()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

%r13 got saved and restored without ever getting touched, so there's
no need to do so.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/lib/copy_page_64.S |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- 3.2/arch/x86/lib/copy_page_64.S
+++ 3.2-x86_64-copy_page/arch/x86/lib/copy_page_64.S
@@ -20,14 +20,12 @@ ENDPROC(copy_page_c)
 
 ENTRY(copy_page)
 	CFI_STARTPROC
-	subq	$3*8,%rsp
-	CFI_ADJUST_CFA_OFFSET 3*8
+	subq	$2*8,%rsp
+	CFI_ADJUST_CFA_OFFSET 2*8
 	movq	%rbx,(%rsp)
 	CFI_REL_OFFSET rbx, 0
 	movq	%r12,1*8(%rsp)
 	CFI_REL_OFFSET r12, 1*8
-	movq	%r13,2*8(%rsp)
-	CFI_REL_OFFSET r13, 2*8
 
 	movl	$(4096/64)-5,%ecx
 	.p2align 4
@@ -91,10 +89,8 @@ ENTRY(copy_page)
 	CFI_RESTORE rbx
 	movq	1*8(%rsp),%r12
 	CFI_RESTORE r12
-	movq	2*8(%rsp),%r13
-	CFI_RESTORE r13
-	addq	$3*8,%rsp
-	CFI_ADJUST_CFA_OFFSET -3*8
+	addq	$2*8,%rsp
+	CFI_ADJUST_CFA_OFFSET -2*8
 	ret
 .Lcopy_page_end:
 	CFI_ENDPROC



