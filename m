Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab0ECVWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 17:22:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:39918 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270Ab0ECVWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 17:22:51 -0400
Date: Mon, 3 May 2010 21:22:36 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1269176446-2489-5-git-send-email-brgerst@gmail.com>
References: <1269176446-2489-5-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86-32: Don't set ignore_fpu_irq in simd exception
Message-ID: <tip-250825008f1f94887bc039e9227a8adfb5ba366e@git.kernel.org>
Git-Commit-ID: 250825008f1f94887bc039e9227a8adfb5ba366e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 03 May 2010 21:22:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  250825008f1f94887bc039e9227a8adfb5ba366e
Gitweb:     http://git.kernel.org/tip/250825008f1f94887bc039e9227a8adfb5ba366e
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Sun, 21 Mar 2010 09:00:46 -0400
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 3 May 2010 13:39:32 -0700

x86-32: Don't set ignore_fpu_irq in simd exception

Any processor that supports simd will have an internal fpu, and the
irq13 handler will not be enabled.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1269176446-2489-5-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/traps.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 53ba86f..00516e1 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -675,10 +675,6 @@ dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 dotraplinkage void
 do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 {
-#ifdef CONFIG_X86_32
-	ignore_fpu_irq = 1;
-#endif
-
 	math_error(regs, error_code, 19);
 }
 
