Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab2HPFAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 01:00:37 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57689 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab2HPFAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 01:00:35 -0400
Date: Thu, 16 Aug 2012 10:30:30 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>, michael@ellerman.id.au,
        Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 2/2] powerpc: Uprobes port to powerpc
Message-ID: <20120816050030.GA12060@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20120726051902.GA29466@in.ibm.com> <20120726052029.GB29466@in.ibm.com> <20120815165931.GA10059@redhat.com> <1345066913.11751.4.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345066913.11751.4.camel@pasglop>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081605-5930-0000-0000-00000AEC3B23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 07:41:53AM +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2012-08-15 at 18:59 +0200, Oleg Nesterov wrote:
> > On 07/26, Ananth N Mavinakayanahalli wrote:
> > >
> > > From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > >
> > > This is the port of uprobes to powerpc. Usage is similar to x86.
> > 
> > I am just curious why this series was ignored by powerpc maintainers...
> 
> Because it arrived too late for the previous merge window considering my
> limited bandwidth for reviewing things and that nobody else seems to
> have reviewed it :-)
> 
> It's still on track for the next one, and I'm hoping to dedicate most of
> next week going through patches & doing a powerpc -next.

Thanks Ben!

> > Of course I can not review this code, I know nothing about powerpc,
> > but the patches look simple/straightforward.
> > 
> > Paul, Benjamin?
> > 
> > Just one question... Shouldn't arch_uprobe_pre_xol() forbid to probe
> > UPROBE_SWBP_INSN (at least) ?
> > 
> > (I assume that emulate_step() can't handle this case but of course I
> >  do not understand arch/powerpc/lib/sstep.c)
> > 
> > Note that uprobe_pre_sstep_notifier() sets utask->state = UTASK_BP_HIT
> > without any checks. This doesn't look right if it was UTASK_SSTEP...
> > 
> > But again, I do not know what powepc will actually do if we try to
> > single-step over UPROBE_SWBP_INSN.
> 
> Ananth ?

set_swbp() will return -EEXIST to install_breakpoint if we are trying to
put a breakpoint on UPROBE_SWBP_INSN. So, the arch agnostic code itself
takes care of this case... or am I missing something?

However, I see that we need a powerpc specific is_swbp_insn()
implementation since we will have to take care of all the trap variants.

I will need to update the patches based on changes being made by Oleg
and Sebastien for the single-step issues. Will incorporate the powerpc
specific is_swbp_insn() change along with the changes required for the
single-step part and send out the next version.

Ananth

