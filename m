Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab0HSBAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 21:00:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43734 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab0HSBAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 21:00:46 -0400
Date: Thu, 19 Aug 2010 11:00:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the sh tree with Linus' tree
Message-Id: <20100819110040.9b65bf5e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the sh tree got a conflict in
arch/sh/kernel/process_32.c between commit
d7627467b7a8dd6944885290a03a07ceb28c10eb ("Make do_execve() take a const
filename pointer") from Linus' tree and commit
d5b7fb7bb8a014ee96cd39b410fc57a7dc239a91 ("sh: fix up fallout from
syscall arg constification") from the sh tree.

I used the version from Linus' tree as it was more complete.

I also applied this merge fixup patch to make the header file prototype
match:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 19 Aug 2010 10:56:12 +1000
Subject: [PATCH] sh: fix prototype of sys_execve to match the new one

Commit d7627467b7 ("Make do_execve() take a const filename pointer")
missed some.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sh/include/asm/syscalls_32.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/sh/include/asm/syscalls_32.h b/arch/sh/include/asm/syscalls_32.h
index be201fd..6089a4e 100644
--- a/arch/sh/include/asm/syscalls_32.h
+++ b/arch/sh/include/asm/syscalls_32.h
@@ -19,9 +19,10 @@ asmlinkage int sys_clone(unsigned long clone_flags, unsigned long newsp,
 asmlinkage int sys_vfork(unsigned long r4, unsigned long r5,
 			 unsigned long r6, unsigned long r7,
 			 struct pt_regs __regs);
-asmlinkage int sys_execve(const char __user *ufilename, char __user * __user *uargv,
-			  char __user * __user *uenvp, unsigned long r7,
-			  struct pt_regs __regs);
+asmlinkage int sys_execve(const char __user *ufilename,
+			  const char __user * const __user *uargv,
+			  const char __user * const __user *uenvp,
+			  unsigned long r7, struct pt_regs __regs);
 asmlinkage int sys_sigsuspend(old_sigset_t mask, unsigned long r5,
 			      unsigned long r6, unsigned long r7,
 			      struct pt_regs __regs);
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
