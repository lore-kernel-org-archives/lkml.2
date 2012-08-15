Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab2HOVmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 17:42:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:60581 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980Ab2HOVmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 17:42:36 -0400
Message-ID: <1345066913.11751.4.camel@pasglop>
Subject: Re: [PATCH v3 2/2] powerpc: Uprobes port to powerpc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        michael@ellerman.id.au, Ingo Molnar <mingo@elte.hu>,
        peterz@infradead.org, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Thu, 16 Aug 2012 07:41:53 +1000
In-Reply-To: <20120815165931.GA10059@redhat.com>
References: <20120726051902.GA29466@in.ibm.com>
	 <20120726052029.GB29466@in.ibm.com> <20120815165931.GA10059@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-15 at 18:59 +0200, Oleg Nesterov wrote:
> On 07/26, Ananth N Mavinakayanahalli wrote:
> >
> > From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> >
> > This is the port of uprobes to powerpc. Usage is similar to x86.
> 
> I am just curious why this series was ignored by powerpc maintainers...

Because it arrived too late for the previous merge window considering my
limited bandwidth for reviewing things and that nobody else seems to
have reviewed it :-)

It's still on track for the next one, and I'm hoping to dedicate most of
next week going through patches & doing a powerpc -next.

> Of course I can not review this code, I know nothing about powerpc,
> but the patches look simple/straightforward.
> 
> Paul, Benjamin?
> 
> Just one question... Shouldn't arch_uprobe_pre_xol() forbid to probe
> UPROBE_SWBP_INSN (at least) ?
> 
> (I assume that emulate_step() can't handle this case but of course I
>  do not understand arch/powerpc/lib/sstep.c)
> 
> Note that uprobe_pre_sstep_notifier() sets utask->state = UTASK_BP_HIT
> without any checks. This doesn't look right if it was UTASK_SSTEP...
> 
> But again, I do not know what powepc will actually do if we try to
> single-step over UPROBE_SWBP_INSN.

Ananth ?

Cheers,
Ben.


