Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab2EFQUE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 12:20:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58743 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab2EFQUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 12:20:02 -0400
Date: Sun, 6 May 2012 17:20:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] broken TASK_SIZE for ia32_aout
Message-ID: <20120506162000.GT6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting TIF_IA32 in load_aout_binary() used to be enough; these days
TASK_SIZE is controlled by TIF_ADDR32 and that one doesn't get set
there.  Switch to use of set_personality_ia32()...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index 4824fb4..07b3a68 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -294,8 +294,7 @@ static int load_aout_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 
 	/* OK, This is the point of no return */
 	set_personality(PER_LINUX);
-	set_thread_flag(TIF_IA32);
-	current->mm->context.ia32_compat = 1;
+	set_personality_ia32(false);
 
 	setup_new_exec(bprm);
 
