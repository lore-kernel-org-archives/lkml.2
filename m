Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0G0MNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 08:13:41 -0400
Received: from verein.lst.de ([213.95.11.210]:41593 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab0G0MNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 08:13:39 -0400
Date: Tue, 27 Jul 2010 14:13:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@lst.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/irq] x86: Always use irq stacks
Message-ID: <20100727121313.GA19976@lst.de>
References: <20100630074434.GA25509@elte.hu> <20100630075212.GA24658@lst.de> <20100630075818.GB25509@elte.hu> <20100630080453.GA14371@elte.hu> <20100708204251.GA13569@elte.hu> <20100708205302.GA23961@lst.de> <20100714151215.GA31825@lst.de> <alpine.LFD.2.00.1007141719130.3321@localhost.localdomain> <20100714154746.GA2074@lst.de> <1279131672.4190.18.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279131672.4190.18.camel@localhost>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, can you test this patch implementing Steve's suggestion?
Unfortunately I'm not able to reproduce the bug on my setup anymore.

---

From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] x86-32: align irq stacks properly

As suggested by Steven Rostedt we need to align the irq stacks on the
stack size, not just the page size to make them work for stack traces
with 8k stacks.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-tip/arch/x86/kernel/irq_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/irq_32.c	2010-07-27 14:06:50.634494682 +0200
+++ linux-2.6-tip/arch/x86/kernel/irq_32.c	2010-07-27 14:06:58.031494680 +0200
@@ -55,7 +55,7 @@ static inline void print_stack_overflow(
 union irq_ctx {
 	struct thread_info      tinfo;
 	u32                     stack[THREAD_SIZE/sizeof(u32)];
-} __attribute__((aligned(PAGE_SIZE)));
+} __attribute__((aligned(THREAD_SIZE)));
 
 static DEFINE_PER_CPU(union irq_ctx *, hardirq_ctx);
 static DEFINE_PER_CPU(union irq_ctx *, softirq_ctx);
