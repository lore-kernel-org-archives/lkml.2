Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab0GVFCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 01:02:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:37229 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab0GVFCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 01:02:01 -0400
Date: Thu, 22 Jul 2010 05:01:24 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        penberg@cs.helsinki.fi, brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, penberg@cs.helsinki.fi, tglx@linutronix.de
In-Reply-To: <1279371808-24804-3-git-send-email-brgerst@gmail.com>
References: <1279371808-24804-3-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64: Simplify loading initial_gs
Message-ID: <tip-650fb4393dff543bc980d361555c489fbdeed088@git.kernel.org>
Git-Commit-ID: 650fb4393dff543bc980d361555c489fbdeed088
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 22 Jul 2010 05:01:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  650fb4393dff543bc980d361555c489fbdeed088
Gitweb:     http://git.kernel.org/tip/650fb4393dff543bc980d361555c489fbdeed088
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Sat, 17 Jul 2010 09:03:28 -0400
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 21 Jul 2010 21:23:51 -0700

x86-64: Simplify loading initial_gs

Load initial_gs as two 32-bit values instead of splitting a 64-bit value.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1279371808-24804-3-git-send-email-brgerst@gmail.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/head_64.S |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 3d1e6f1..239046b 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -234,9 +234,8 @@ ENTRY(secondary_startup_64)
 	 * init data section till per cpu areas are set up.
 	 */
 	movl	$MSR_GS_BASE,%ecx
-	movq	initial_gs(%rip),%rax
-	movq    %rax,%rdx
-	shrq	$32,%rdx
+	movl	initial_gs(%rip),%eax
+	movl	initial_gs+4(%rip),%edx
 	wrmsr	
 
 	/* esi is pointer to real mode structure with interesting info.
