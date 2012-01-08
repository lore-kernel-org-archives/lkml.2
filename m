Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab2AHEll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 23:41:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37196 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2AHElj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 23:41:39 -0500
Date: Sat, 7 Jan 2012 20:39:01 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-426932909093e4e7729777a0e2beed4b54911361@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, jbeulich@suse.com,
        akpm@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4F05D9F9020000780006AA0D@nat28.tlf.novell.com>
References: <4F05D9F9020000780006AA0D@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64: Slightly shorten copy_page()
Git-Commit-ID: 426932909093e4e7729777a0e2beed4b54911361
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 07 Jan 2012 20:39:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  426932909093e4e7729777a0e2beed4b54911361
Gitweb:     http://git.kernel.org/tip/426932909093e4e7729777a0e2beed4b54911361
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Thu, 5 Jan 2012 16:12:25 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Jan 2012 12:25:37 +0100

x86-64: Slightly shorten copy_page()

%r13 got saved and restored without ever getting touched, so
there's no need to do so.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/4F05D9F9020000780006AA0D@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/copy_page_64.S |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
index 01c805b..6b34d04 100644
--- a/arch/x86/lib/copy_page_64.S
+++ b/arch/x86/lib/copy_page_64.S
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
