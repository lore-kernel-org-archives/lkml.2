Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab0EFOtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 10:49:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:19980 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab0EFOtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 10:49:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wEPQX45SSVSVKMJ8cG736qbEAppuVIzbu/kNBdmdmHFDXKVKPYiS/b/K+vMdyQw0oW
         A61wNeymhuZzkkF9nn9+Al9zTrzyPedCZVnhaUzoxHE+zuEY1Z6LBMA+vIJsfxpozZqq
         6zeScMUqSL7jYyZjHQyDEBE/p0t1T3ORaZ5zU=
Date: Thu, 6 May 2010 18:48:54 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -tip] x86,perf: P4 PMU -- protect sensible procedures
	from preemption
Message-ID: <20100506144854.GB5583@lenovo>
References: <20100505150740.GB5686@lenovo> <20100505165731.GA6320@nowhere> <20100505174234.GH5686@lenovo> <20100506064453.GI1172@elte.hu> <w2vaa79d98a1005060039ua7dd1b0t952fcd8662d4d759@mail.gmail.com> <20100506074231.GA8625@elte.hu> <n2maa79d98a1005060045ke0f87f4aw8b86da0440a019b3@mail.gmail.com> <1273153525.22438.39.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273153525.22438.39.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 09:45:24AM -0400, Steven Rostedt wrote:
...
> > > We want the one with the least runtime overhead. These are instrumentation
> > > routines, so we want to optimize them as much as possible.
> 
> 
> Yeah, my point was either disable preemption or keep the checks. In
> other words, if you don't disable preemption, do not use
> raw_smp_procesor_id(), because then we will not catch it if it changes
> in the future.
> 
> > ok, Ingo, dont apply this patch then for a while.
> 
> Send another patch, I'll test it again ;-)
> 
> -- Steve
> 
> 

Ingo, Steven, it seems we have potential preemtion available
in perf_event.c:validate_group:x86_pmu.schedule_events() which
is reached via syscall from userspace perf_event_open() call,
so get_cpu is still needed. But I'm a bit messed with call
graph at the moment :(

	-- Cyrill
