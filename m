Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab1GVVkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 17:40:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:58446 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269Ab1GVVka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 17:40:30 -0400
Date: Fri, 22 Jul 2011 21:39:56 GMT
From: tip-bot for Richard Weinberger <richard@nod.at>
Message-ID: <tip-a03fc8c375511b6ab43184ab191af3218a919646@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        richard@nod.at, sfr@canb.auug.org.au, rdunlap@xenotime.net,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        richard@nod.at, tglx@linutronix.de, rdunlap@xenotime.net,
        sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <201107222055.35341.richard@nod.at>
References: <201107222055.35341.richard@nod.at>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] um: Make rwsem.S depend on CONFIG_RWSEM_XCHGADD_ALGORITHM
Git-Commit-ID: a03fc8c375511b6ab43184ab191af3218a919646
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Jul 2011 21:39:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a03fc8c375511b6ab43184ab191af3218a919646
Gitweb:     http://git.kernel.org/tip/a03fc8c375511b6ab43184ab191af3218a919646
Author:     Richard Weinberger <richard@nod.at>
AuthorDate: Fri, 22 Jul 2011 20:55:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Jul 2011 23:06:30 +0200

um: Make rwsem.S depend on CONFIG_RWSEM_XCHGADD_ALGORITHM

rwsem.S can only be used with CONFIG_RWSEM_XCHGADD_ALGORITHM.
This unbreaks the UML build on i386.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: user-mode-linux-devel@lists.sourceforge.net
Cc: JBeulich@novell.com
Link: http://lkml.kernel.org/r/201107222055.35341.richard@nod.at
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/um/sys-i386/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/um/sys-i386/Makefile b/arch/um/sys-i386/Makefile
index 15587ed..87b659d 100644
--- a/arch/um/sys-i386/Makefile
+++ b/arch/um/sys-i386/Makefile
@@ -8,7 +8,8 @@ obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
 
 obj-$(CONFIG_BINFMT_ELF) += elfcore.o
 
-subarch-obj-y = lib/rwsem.o lib/string_32.o
+subarch-obj-y = lib/string_32.o
+subarch-obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += lib/rwsem.o
 subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem_32.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module.o
 
