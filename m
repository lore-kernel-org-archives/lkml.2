Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966451Ab2FBHo2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 03:44:28 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:39624 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966435Ab2FBHo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 03:44:26 -0400
Date: Sat, 2 Jun 2012 09:44:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: David Miller <davem@davemloft.net>, tglx@linutronix.de,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        nikunj@linux.vnet.ibm.com, vapier@gentoo.org, konrad@gaisler.com,
        tkhai@yandex.ru, sparclinux@vger.kernel.org
Subject: Re: [UPDATED PATCH 21/27] sparc32, smpboot: Use generic SMP
	booting infrastructure
Message-ID: <20120602074424.GA19690@merkur.ravnborg.org>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091503.31979.52537.stgit@srivatsabhat.in.ibm.com> <20120601.135612.699120609738854050.davem@davemloft.net> <20120601185448.GA19148@merkur.ravnborg.org> <4FC94693.5050707@linux.vnet.ibm.com> <20120602065249.GA19558@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120602065249.GA19558@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2012 at 08:52:49AM +0200, Sam Ravnborg wrote:
> Hi Srivatsa.
> 
> I cannot see how this would work for sparc32...
> [Did not notice before...]
> 
> > --- a/arch/sparc/kernel/leon_smp.c
> > +++ b/arch/sparc/kernel/leon_smp.c
> 
> > +void __cpuinit __cpu_pre_starting(void *unused)
> > +{
> > +	unsigned int cpuid = hard_smp_processor_id();
> >  
> > diff --git a/arch/sparc/kernel/sun4d_smp.c b/arch/sparc/kernel/sun4d_smp.c
> > index ddaea31..cd5367a 100644
> > --- a/arch/sparc/kernel/sun4d_smp.c
> > +++ b/arch/sparc/kernel/sun4d_smp.c
> 
> > +void __cpuinit __cpu_pre_starting(void *unused)
> > +{
> > +	unsigned int cpuid = hard_smp_processor_id();
> >  
> > diff --git a/arch/sparc/kernel/sun4m_smp.c b/arch/sparc/kernel/sun4m_smp.c
> > index 128af73..ed05f54 100644
> > --- a/arch/sparc/kernel/sun4m_smp.c
> > +++ b/arch/sparc/kernel/sun4m_smp.c
> 
> > +void __cpuinit __cpu_pre_starting(void *unused)
> > +{
> > +	unsigned int cpuid = hard_smp_processor_id();
> 
> See how you define a function with the same name three times.
> On sparc32 we include all of the above files in the kernel,
> and uses various tricks to determine at run-time
> which variant to use.
> 
> We need to define these general functions in smp_32.c and
> then take relevant action depending on sparc_cpu_model.

I took a short look at this.
And it is a bit complicated :-(

leon is the odd-one here. For reasons I do not understand
we have a call from head_32.S to leon_smp_cpu_startup:
in trampoline_32.S.

But sun4m and sun4d uses the normal path via start_kernel() etc.

This has the side-effect that sparc_cpu_model is not set
when we call leon_smp_cpu_startup.

I will try to dive into this and see if I on the sparc32 side
can make leon behave like the other platforms, and then 
unify some of the smp cpu boot stuff such that we then
can introduce the generalization from your patch.

	Sam
