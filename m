Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab0GRWLa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 18:11:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757384Ab0GRWL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 18:11:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: kprobes: fix swapped segment registers in kretprobe
X-Fcc: ~/Mail/linus
X-Windows: live the nightmare.
Message-Id: <20100718221111.19BC24B2C9@magilla.sf.frob.com>
Date: Sun, 18 Jul 2010 15:11:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit bea9a6d239cb2aa2ced4dcb0a05e1827ce61fa3d:

  Merge branch 'upstream-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2 (2010-07-18 10:09:25 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git x86/kprobes

Roland McGrath (1):
      x86: kprobes: fix swapped segment registers in kretprobe

 arch/x86/kernel/kprobes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


Thanks,
Roland
---
[PATCH] x86: kprobes: fix swapped segment registers in kretprobe

In commit f007ea26, the order of the %es and %ds segment registers
got accidentally swapped, so synthesized 'struct pt_regs' frames
have the two values inverted.  It's almost sure that these values
never matter, and that they also never differ.  But wrong is wrong.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/kprobes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 345a4b1..675879b 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -640,8 +640,8 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 	/* Skip cs, ip, orig_ax and gs. */	\
 	"	subl $16, %esp\n"	\
 	"	pushl %fs\n"		\
-	"	pushl %ds\n"		\
 	"	pushl %es\n"		\
+	"	pushl %ds\n"		\
 	"	pushl %eax\n"		\
 	"	pushl %ebp\n"		\
 	"	pushl %edi\n"		\
