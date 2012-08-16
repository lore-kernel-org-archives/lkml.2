Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab2HPLXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 07:23:51 -0400
Received: from ozlabs.org ([203.10.76.45]:47569 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab2HPLXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 07:23:50 -0400
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: K Prasad <prasad@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: powerpc/perf: hw breakpoints return ENOSPC
In-reply-to: <1345102812.31459.114.camel@twins>
References: <28857.1345091034@neuling.org> <1345102812.31459.114.camel@twins>
Comments: In-reply-to Peter Zijlstra <a.p.zijlstra@chello.nl>
   message dated "Thu, 16 Aug 2012 09:40:12 +0200."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Thu, 16 Aug 2012 21:17:29 +1000
Message-ID: <20344.1345115849@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

> > On this second syscall, fetch_bp_busy_slots() sets slots.pinned to be 1,
> > despite there being no breakpoint on this CPU.  This is because the call
> > the task_bp_pinned, checks all CPUs, rather than just the current CPU.
> > POWER7 only has one hardware breakpoint per CPU (ie. HBP_NUM=1), so we
> > return ENOSPC.
> 
> I think this comes from the ptrace legacy, we register a breakpoint on
> all cpus because when we migrate a task it cannot fail to migrate the
> breakpoint.
> 
> Its one of the things I hate most about the hwbp stuff as it relates to
> perf.
> 
> Frederic knows more...

Maybe I should wait for Frederic to respond but I'm not sure I
understand what you're saying.

I can see how using ptrace hw breakpoints and perf hw breakpoints at the
same time could be a problem, but I'm not sure how this would stop it.

Are you saying that we need to keep at least 1 slot free at all times,
so that we can use it for ptrace?

Is "perf record -e mem:0x10000000 true" ever going to be able to work on
POWER7 with only one hw breakpoint resource per CPU?  

Thanks,
Mikey
