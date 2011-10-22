Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab1JVHJv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 03:09:51 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42784 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab1JVHJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 03:09:50 -0400
Date: Sat, 22 Oct 2011 12:39:52 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/X] uprobes: x86: introduce abort_xol()
Message-ID: <20111022070952.GA24475@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20111015190007.GA30243@redhat.com> <20111019215139.GA16395@redhat.com> <20111019215326.GF16395@redhat.com> <20111021144207.GN11831@linux.vnet.ibm.com> <20111021162631.GB2552@in.ibm.com> <20111021164221.GA30770@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111021164221.GA30770@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 06:42:21PM +0200, Oleg Nesterov wrote:
> On 10/21, Ananth N Mavinakayanahalli wrote:

...

> > For instance, on x86, it points to the next
> > instruction,
> 
> No?

At exception entry, we'd not have done the following fixup...

> 	/**
> 	 * get_uprobe_bkpt_addr - compute address of bkpt given post-bkpt regs
> 	 * @regs: Reflects the saved state of the task after it has hit a breakpoint
> 	 * instruction.
> 	 * Return the address of the breakpoint instruction.
> 	 */
> 	unsigned long __weak get_uprobe_bkpt_addr(struct pt_regs *regs)
> 	{
> 		return instruction_pointer(regs) - UPROBES_BKPT_INSN_SIZE;
> 	}
> 
> Yes, initially regs->ip points to the next insn after int3, but
> utask->vaddr == get_uprobe_bkpt_addr() == addr of int3.
> 
> Right?

Yes, we fix it up so we point to the right (breakpoint) address.

> > while on powerpc, the nip points to the breakpoint vaddr
> > at the time of exception.
> 
> I think get_uprobe_bkpt_addr() should be consistent on every arch.
> That is why (I think) it is __weak.

Yes, that is the intention.

> Anyway, abort_xol() has to be arch-specific.

Agree.

Ananth
