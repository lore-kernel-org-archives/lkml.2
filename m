Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab2HQFPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 01:15:34 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56677 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2HQFPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 01:15:32 -0400
Date: Fri, 17 Aug 2012 10:43:07 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        michael@ellerman.id.au, Ingo Molnar <mingo@elte.hu>,
        peterz@infradead.org, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 2/2] powerpc: Uprobes port to powerpc
Message-ID: <20120817051307.GA4782@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20120726051902.GA29466@in.ibm.com> <20120726052029.GB29466@in.ibm.com> <20120815165931.GA10059@redhat.com> <1345066913.11751.4.camel@pasglop> <20120816050030.GA12060@in.ibm.com> <20120816152112.GA8874@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816152112.GA8874@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081705-6148-0000-0000-000008B4B49F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 05:21:12PM +0200, Oleg Nesterov wrote:

...

> > So, the arch agnostic code itself
> > takes care of this case...
> 
> Yes. I forgot about install_breakpoint()->is_swbp_insn() check which
> returns -ENOTSUPP, somehow I thought arch_uprobe_analyze_insn() does
> this.
> 
> > or am I missing something?
> 
> No, it is me.
> 
> > However, I see that we need a powerpc specific is_swbp_insn()
> > implementation since we will have to take care of all the trap variants.
> 
> Hmm, I am not sure. is_swbp_insn(insn), as it is used in the arch agnostic
> code, should only return true if insn == UPROBE_SWBP_INSN (just in case,
> this logic needs more fixes but this is offtopic).

I think it does...

> If powerpc has another insn(s) which can trigger powerpc's do_int3()
> counterpart, they should be rejected by arch_uprobe_analyze_insn().
> I think.

The insn that gets passed to arch_uprobe_analyze_insn() is copy_insn()'s
version, which is the file copy of the instruction. We should also take
care of the in-memory copy, in case gdb had inserted a breakpoint at the
same location, right? Updating is_swbp_insn() per-arch where needed will
take care of both the cases, 'cos it gets called before
arch_analyze_uprobe_insn() too.

> > I will need to update the patches based on changes being made by Oleg
> > and Sebastien for the single-step issues.
> 
> Perhaps you can do this in a separate change?
> 
> We need some (simple) changes in the arch agnostic code first, they
> should not break poweppc. These changes are still under discussion.
> Once we have "__weak  arch_uprobe_step*" you can reimplement these
> hooks and fix the problems with single-stepping.

OK. Agreed.

Ananth

