Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab2HPXeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 19:34:11 -0400
Received: from ozlabs.org ([203.10.76.45]:38927 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab2HPXeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 19:34:09 -0400
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: K Prasad <prasad@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: powerpc/perf: hw breakpoints return ENOSPC
In-reply-to: <1345117498.29668.23.camel@twins>
References: <28857.1345091034@neuling.org> <1345102812.31459.114.camel@twins> <20344.1345115849@neuling.org> <1345117498.29668.23.camel@twins>
Comments: In-reply-to Peter Zijlstra <a.p.zijlstra@chello.nl>
   message dated "Thu, 16 Aug 2012 13:44:58 +0200."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Fri, 17 Aug 2012 09:34:07 +1000
Message-ID: <8649.1345160047@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > On this second syscall, fetch_bp_busy_slots() sets slots.pinned to be 1,
> > > > despite there being no breakpoint on this CPU.  This is because the call
> > > > the task_bp_pinned, checks all CPUs, rather than just the current CPU.
> > > > POWER7 only has one hardware breakpoint per CPU (ie. HBP_NUM=1), so we
> > > > return ENOSPC.
> > > 
> > > I think this comes from the ptrace legacy, we register a breakpoint on
> > > all cpus because when we migrate a task it cannot fail to migrate the
> > > breakpoint.
> > > 
> > > Its one of the things I hate most about the hwbp stuff as it relates to
> > > perf.
> > > 
> > > Frederic knows more...
> > 
> > Maybe I should wait for Frederic to respond but I'm not sure I
> > understand what you're saying.
> > 
> > I can see how using ptrace hw breakpoints and perf hw breakpoints at the
> > same time could be a problem, but I'm not sure how this would stop it.
> 
> ptrace uses perf for hwbp support so we're stuck with all kinds of
> stupid ptrace constraints.. or somesuch.

OK

> > Are you saying that we need to keep at least 1 slot free at all times,
> > so that we can use it for ptrace?
> 
> No, I'm saying perf-hwbp is weird because of ptrace, maybe the ptrace
> weirdness shouldn't live in perf-hwpb but in the ptrace-perf glue
> however..

OK.

> > Is "perf record -e mem:0x10000000 true" ever going to be able to work on
> > POWER7 with only one hw breakpoint resource per CPU?  
> 
> I think it should work... but I'm fairly sure it currently doesn't
> because of how things are done. 'perf record -ie mem:0x100... true'
> might just work.

Adding -i doesn't help. 

Mikey
