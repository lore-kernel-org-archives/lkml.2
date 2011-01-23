Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab1AWSEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 13:04:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:56111 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab1AWSEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 13:04:37 -0500
Date: Sun, 23 Jan 2011 18:03:25 GMT
From: tip-bot for matthieu castet <castet.matthieu@free.fr>
Cc: sliakh.lkml@gmail.com, mingo@redhat.com, torvalds@linux-foundation.org,
        rusty@rustcorp.com.au, a.p.zijlstra@chello.nl, jiang@cs.ncsu.edu,
        fweisbec@gmail.com, akpm@linux-foundation.org, rostedt@goodmis.org,
        kees.cook@canonical.com, tglx@linutronix.de, jbaron@redhat.com,
        xtfeng@gmail.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jmorris@namei.org, arjan@linux.intel.com, davej@redhat.com,
        castet.matthieu@free.fr, mingo@elte.hu
Reply-To: mingo@redhat.com, sliakh.lkml@gmail.com, a.p.zijlstra@chello.nl,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        jiang@cs.ncsu.edu, fweisbec@gmail.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, kees.cook@canonical.com, jbaron@redhat.com,
        tglx@linutronix.de, xtfeng@gmail.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, jmorris@namei.org, arjan@linux.intel.com,
        davej@redhat.com, castet.matthieu@free.fr, mingo@elte.hu
In-Reply-To: <4D3C3F20.7030203@free.fr>
References: <4D3C3F20.7030203@free.fr>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix jump label with RO/NX module protection crash
Message-ID: <tip-8969691343354bdd80eff5405a0f879edbf013d6@git.kernel.org>
Git-Commit-ID: 8969691343354bdd80eff5405a0f879edbf013d6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 23 Jan 2011 18:03:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8969691343354bdd80eff5405a0f879edbf013d6
Gitweb:     http://git.kernel.org/tip/8969691343354bdd80eff5405a0f879edbf013d6
Author:     matthieu castet <castet.matthieu@free.fr>
AuthorDate: Sun, 23 Jan 2011 15:45:52 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 23 Jan 2011 16:12:45 +0100

x86: Fix jump label with RO/NX module protection crash

If we use jump table in module init, there are marked
as removed in __jump_table section after init is done.

But we already applied ro permissions on the module, so
we can't modify a read only section (crash in
remove_jump_label_module_init).

Make the __jump_table section rw.

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
Cc: Xiaotian Feng <xtfeng@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: Xuxian Jiang <jiang@cs.ncsu.edu>
Cc: James Morris <jmorris@namei.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dave Jones <davej@redhat.com>
Cc: Kees Cook <kees.cook@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4D3C3F20.7030203@free.fr>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/jump_label.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index f52d42e..574dbc2 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -14,7 +14,7 @@
 	do {							\
 		asm goto("1:"					\
 			JUMP_LABEL_INITIAL_NOP			\
-			".pushsection __jump_table,  \"a\" \n\t"\
+			".pushsection __jump_table,  \"aw\" \n\t"\
 			_ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
 			".popsection \n\t"			\
 			: :  "i" (key) :  : label);		\
