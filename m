Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab1BJOoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 09:44:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:46348 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756435Ab1BJOog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 09:44:36 -0500
Date: Thu, 10 Feb 2011 14:43:36 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, heukelum@fastmail.fm,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, torvalds@linux-foundation.org,
        JBeulich@novell.com, heukelum@fastmail.fm, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4D525CE60200007800030EE5@vpn.id2.novell.com>
References: <4D525CE60200007800030EE5@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Reduce back the alignment of the per-CPU data section
Message-ID: <tip-94d1ac8b55799be10487fff9766cce6d6628462a@git.kernel.org>
Git-Commit-ID: 94d1ac8b55799be10487fff9766cce6d6628462a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Feb 2011 14:43:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94d1ac8b55799be10487fff9766cce6d6628462a
Gitweb:     http://git.kernel.org/tip/94d1ac8b55799be10487fff9766cce6d6628462a
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Wed, 9 Feb 2011 08:22:46 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Feb 2011 13:31:36 +0100

x86: Reduce back the alignment of the per-CPU data section

This complements commit:

  47f19a0814e8: percpu: Remove the multi-page alignment facility

reverting one leftover of:

  fe8e0c25cad2: x86, 32-bit: Align percpu area and irq stacks to THREAD_SIZE

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <4D525CE60200007800030EE5@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/vmlinux.lds.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index bf47007..e9f7a3c 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -305,7 +305,7 @@ SECTIONS
 	}
 
 #if !defined(CONFIG_X86_64) || !defined(CONFIG_SMP)
-	PERCPU(THREAD_SIZE)
+	PERCPU(PAGE_SIZE)
 #endif
 
 	. = ALIGN(PAGE_SIZE);
