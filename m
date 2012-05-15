Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965683Ab2EOCis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:38:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:49792 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964889Ab2EOCRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:49 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 134/179] xtensa: prevent arbitrary read in ptrace
Date: Mon, 14 May 2012 22:13:50 -0400
Message-ID: <1337048075-6132-135-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 0d0138ebe24b94065580bd2601f8bb7eb6152f56 upstream.

Prevent an arbitrary kernel read.  Check the user pointer with access_ok()
before copying data in.

[akpm@linux-foundation.org: s/EIO/EFAULT/]
Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Christian Zankel <chris@zankel.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/xtensa/kernel/ptrace.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
index 9d4e1ce..f0ccfc7 100644
--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -147,6 +147,9 @@ int ptrace_setxregs(struct task_struct *child, void __user *uregs)
 	elf_xtregs_t *xtregs = uregs;
 	int ret = 0;
 
+	if (!access_ok(VERIFY_READ, uregs, sizeof(elf_xtregs_t)))
+		return -EFAULT;
+
 #if XTENSA_HAVE_COPROCESSORS
 	/* Flush all coprocessors before we overwrite them. */
 	coprocessor_flush_all(ti);
-- 
1.7.9.6

