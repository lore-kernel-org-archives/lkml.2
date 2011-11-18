Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab1KRKHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:07:36 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43218 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757462Ab1KRKHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:07:31 -0500
Date: Fri, 18 Nov 2011 15:11:18 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH x86 2/2] Cleanup do_int3
Message-ID: <20111118094118.GA8311@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111025141812.GA21225@linux.vnet.ibm.com>
 <20111025142159.GB21225@linux.vnet.ibm.com>
 <4EAA0A3D.90102@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4EAA0A3D.90102@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11111810-9360-0000-0000-000000B8CF25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> (2011/10/25 23:21), Srikar Dronamraju wrote:
> > Since there is a possibility of !KPROBES int3 listeners and since
> > DIE_TRAP is currently not being used by anybody, notify all listeners
> > with DIE_INT3.
> 
> I'm not sure why this CONFIG_KPROBES dependency had been introduced,
> but it's the time to fix it. do_int3 should send DIE_INT3 always.
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Thank you!
> 


Hi Ingo, 

Is there a reason for not taking this patch?
Oleg, Masami, Alexander(who was the last to modify this code) have
all been in favour of this patch.


I didnt get any response from you for the other patch in this series
too.

--
Thanks and Regards
Srikar


> > 
> > Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> > ---
> >  arch/x86/kernel/traps.c |    7 +------
> >  1 files changed, 1 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> > index 6913369..c9a4be5 100644
> > --- a/arch/x86/kernel/traps.c
> > +++ b/arch/x86/kernel/traps.c
> > @@ -461,15 +461,10 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
> >  			== NOTIFY_STOP)
> >  		return;
> >  #endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
> > -#ifdef CONFIG_KPROBES
> > +
> >  	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
> >  			== NOTIFY_STOP)
> >  		return;
> > -#else
> > -	if (notify_die(DIE_TRAP, "int3", regs, error_code, 3, SIGTRAP)
> > -			== NOTIFY_STOP)
> > -		return;
> > -#endif
> >  
> >  	preempt_conditional_sti(regs);
> >  	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> -- 
> Masami HIRAMATSU
> Software Platform Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
> 

