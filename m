Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab2EFRXY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 13:23:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34638 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab2EFRXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 13:23:22 -0400
Date: Sun, 6 May 2012 10:23:04 -0700
From: tip-bot for Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <tip-2be8e9ec677d6dfd4268b80e1ccd7d21777b86e3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        viro@ZenIV.linux.org.uk, tglx@linutronix.de, viro@ZenIV.linux.org.uk
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, tglx@linutronix.de, viro@ZenIV.linux.org.uk
In-Reply-To: <20120506162000.GT6871@ZenIV.linux.org.uk>
References: <20120506162000.GT6871@ZenIV.linux.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, compat: Correct broken TASK_SIZE for ia32 a.
 out binaries
Git-Commit-ID: 2be8e9ec677d6dfd4268b80e1ccd7d21777b86e3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 06 May 2012 10:23:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2be8e9ec677d6dfd4268b80e1ccd7d21777b86e3
Gitweb:     http://git.kernel.org/tip/2be8e9ec677d6dfd4268b80e1ccd7d21777b86e3
Author:     Al Viro <viro@ZenIV.linux.org.uk>
AuthorDate: Sun, 6 May 2012 17:20:00 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sun, 6 May 2012 09:53:15 -0700

x86, compat: Correct broken TASK_SIZE for ia32 a.out binaries

Setting TIF_IA32 in load_aout_binary() used to be enough; these days
TASK_SIZE is controlled by TIF_ADDR32 and that one doesn't get set
there.  Switch to use of set_personality_ia32()...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Link: http://lkml.kernel.org/r/20120506162000.GT6871@ZenIV.linux.org.uk
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/ia32/ia32_aout.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index d511d95..4c979cf 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -296,8 +296,7 @@ static int load_aout_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 
 	/* OK, This is the point of no return */
 	set_personality(PER_LINUX);
-	set_thread_flag(TIF_IA32);
-	current->mm->context.ia32_compat = 1;
+	set_personality_ia32(false);
 
 	setup_new_exec(bprm);
 
