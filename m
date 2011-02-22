Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1BVWeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:34:23 -0500
Received: from kroah.org ([198.145.64.141]:46627 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab1BVWVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:38 2011
Message-Id: <20110222221838.655632404@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:16:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Brian Gerst <brgerst@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [16/70] x86: Clear irqstack thread_info
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Brian Gerst <brgerst@gmail.com>

commit 7b698ea377e10b074ceef0d79218e6622d618421 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/irq_32.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

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


