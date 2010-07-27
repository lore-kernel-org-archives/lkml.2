Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab0G0ShJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 14:37:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:58902 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab0G0ShG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 14:37:06 -0400
Date: Tue, 27 Jul 2010 18:36:48 GMT
From: tip-bot for Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, hch@lst.de,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hch@lst.de, tglx@linutronix.de
In-Reply-To: <20100727121313.GA19976@lst.de>
References: <20100727121313.GA19976@lst.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86-32: Align IRQ stacks properly
Message-ID: <tip-25897374297906eeebef8864299406bdcb5859c3@git.kernel.org>
Git-Commit-ID: 25897374297906eeebef8864299406bdcb5859c3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Jul 2010 18:36:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  25897374297906eeebef8864299406bdcb5859c3
Gitweb:     http://git.kernel.org/tip/25897374297906eeebef8864299406bdcb5859c3
Author:     Christoph Hellwig <hch@lst.de>
AuthorDate: Tue, 27 Jul 2010 14:13:13 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 27 Jul 2010 10:06:54 -0700

x86-32: Align IRQ stacks properly

As suggested by Steven Rostedt we need to align the IRQ stacks to the
stack size, not just the page size to make them work for stack traces
and other things that depend on finding the stack slot itself with 8k
stacks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
LKML-Reference: <20100727121313.GA19976@lst.de>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/irq_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 67f5f9f..3b5609f 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -55,7 +55,7 @@ static inline void print_stack_overflow(void) { }
 union irq_ctx {
 	struct thread_info      tinfo;
 	u32                     stack[THREAD_SIZE/sizeof(u32)];
-} __attribute__((aligned(PAGE_SIZE)));
+} __attribute__((aligned(THREAD_SIZE)));
 
 static DEFINE_PER_CPU(union irq_ctx *, hardirq_ctx);
 static DEFINE_PER_CPU(union irq_ctx *, softirq_ctx);
