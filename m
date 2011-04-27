Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080Ab1D0PXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:23:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:34646 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932465Ab1D0PXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:23:49 -0400
Date: Wed, 27 Apr 2011 15:23:35 GMT
From: tip-bot for Jason Baron <jbaron@redhat.com>
Message-ID: <tip-ef64789413c73f32faa5e5f1bc393e5843b0aa51@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, tglx@linutronix.de, jbaron@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, tglx@linutronix.de, jbaron@redhat.com
In-Reply-To: <e119fbd060c9452c56063ea6148ba1070e7434cc.1300299760.git.jbaron@redhat.com>
References: <e119fbd060c9452c56063ea6148ba1070e7434cc.1300299760.git.jbaron@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] jump label: Add _ASM_ALIGN for x86 and x86_64
Git-Commit-ID: ef64789413c73f32faa5e5f1bc393e5843b0aa51
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 15:23:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef64789413c73f32faa5e5f1bc393e5843b0aa51
Gitweb:     http://git.kernel.org/tip/ef64789413c73f32faa5e5f1bc393e5843b0aa51
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Wed, 16 Mar 2011 15:58:27 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 4 Apr 2011 13:42:51 -0400

jump label: Add _ASM_ALIGN for x86 and x86_64

The linker should not be adding holes to word size aligned pointers, but
out of paranoia we are explicitly specifying that alignment. I have not
seen any holes in the jump label section in practice.

Signed-off-by: Jason Baron <jbaron@redhat.com>
LKML-Reference: <e119fbd060c9452c56063ea6148ba1070e7434cc.1300299760.git.jbaron@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/jump_label.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index f217cee..a32b18c 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -16,6 +16,7 @@ static __always_inline bool arch_static_branch(struct jump_label_key *key)
 	asm goto("1:"
 		JUMP_LABEL_INITIAL_NOP
 		".pushsection __jump_table,  \"aw\" \n\t"
+		_ASM_ALIGN "\n\t"
 		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
 		".popsection \n\t"
 		: :  "i" (key) : : l_yes);
