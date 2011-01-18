Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1ARTEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:04:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:52924 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab1ARTEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:04:52 -0500
Date: Tue, 18 Jan 2011 19:03:53 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, arjan@linux.intel.com,
        brgerst@gmail.com, penberg@kernel.org, tglx@linutronix.de,
        linux@merz-ka.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, arjan@linux.intel.com,
        torvalds@linux-foundation.org, penberg@kernel.org, tglx@linutronix.de,
        linux@merz-ka.de, mingo@elte.hu
In-Reply-To: <AANLkTimyKXfJ1x8tgwrr1hYnNLrPfgE1NTe4z7L6tUDm@mail.gmail.com>
References: <AANLkTimyKXfJ1x8tgwrr1hYnNLrPfgE1NTe4z7L6tUDm@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Clear irqstack thread_info
Message-ID: <tip-7b698ea377e10b074ceef0d79218e6622d618421@git.kernel.org>
Git-Commit-ID: 7b698ea377e10b074ceef0d79218e6622d618421
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 Jan 2011 19:03:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7b698ea377e10b074ceef0d79218e6622d618421
Gitweb:     http://git.kernel.org/tip/7b698ea377e10b074ceef0d79218e6622d618421
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Mon, 17 Jan 2011 07:32:10 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Jan 2011 14:58:37 +0100

x86: Clear irqstack thread_info

Mathias Merz reported that v2.6.37 failed to boot on his
system.

Make sure that the thread_info part of the irqstack is
initialized to zeroes.

Reported-and-Tested-by: Matthias Merz <linux@merz-ka.de>
Signed-off-by: Brian Gerst <brgerst@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <AANLkTimyKXfJ1x8tgwrr1hYnNLrPfgE1NTe4z7L6tUDm@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/irq_32.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 96656f2..5206bb9 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -129,8 +129,7 @@ void __cpuinit irq_ctx_init(int cpu)
 	irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
 					       THREAD_FLAGS,
 					       THREAD_ORDER));
-	irqctx->tinfo.task		= NULL;
-	irqctx->tinfo.exec_domain	= NULL;
+	memset(&irqctx->tinfo, 0, sizeof(struct thread_info));
 	irqctx->tinfo.cpu		= cpu;
 	irqctx->tinfo.preempt_count	= HARDIRQ_OFFSET;
 	irqctx->tinfo.addr_limit	= MAKE_MM_SEG(0);
@@ -140,10 +139,8 @@ void __cpuinit irq_ctx_init(int cpu)
 	irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
 					       THREAD_FLAGS,
 					       THREAD_ORDER));
-	irqctx->tinfo.task		= NULL;
-	irqctx->tinfo.exec_domain	= NULL;
+	memset(&irqctx->tinfo, 0, sizeof(struct thread_info));
 	irqctx->tinfo.cpu		= cpu;
-	irqctx->tinfo.preempt_count	= 0;
 	irqctx->tinfo.addr_limit	= MAKE_MM_SEG(0);
 
 	per_cpu(softirq_ctx, cpu) = irqctx;
