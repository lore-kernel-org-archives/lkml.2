Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab0DBSpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:45:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38930 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab0DBSpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:45:14 -0400
Date: Fri, 2 Apr 2010 20:45:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Jan.Grossmann@kielnet.net" <Jan.Grossmann@kielnet.net>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Woodhouse, David" <david.woodhouse@intel.com>,
       "Han, Weidong" <weidong.han@intel.com>,
       "Song, Youquan" <youquan.song@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: null pointer deref in dmar_ir_support
Message-ID: <20100402184501.GA4775@elte.hu>
References: <4BAD1676.9090704@kielnet.net>
 <1270057394.2866.9.camel@sbs-t61.sc.intel.com>
 <4BB395B0.6090007@kielnet.net>
 <1270083887.7835.78.camel@sbs-t61.sc.intel.com>
 <20100402182034.GA27304@elte.hu>
 <1270232913.2870.60.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270232913.2870.60.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Fri, 2010-04-02 at 11:20 -0700, Ingo Molnar wrote:
> > * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > 
> > > @@ -1640,8 +1640,10 @@ int __init APIC_init_uniprocessor(void)
> > >  	}
> > >  #endif
> > >  
> > > +#ifndef CONFIG_SMP
> > >  	enable_IR_x2apic();
> > >  	default_setup_apic_routing();
> > > +#endif
> > 
> > Instead of adding yet another ugly #ifdef please hide these details 
> > properly, by making enable_IR_x2apic() and default_setup_apic_routing() a 
> > NOP on !SMP.
> 
> Ingo, These are not nops on !SMP. We should call these functions from 
> APIC_init_uniprocessor() only if it is a UP kernel. For SMP kernel they are 
> called from some where else.

Btw., that makes the cleanliness situation even worse ...

> With the current code, on SMP and with non SMP motherboard we were calling 
> these routines twice which cause problem.
> 
> I wanted to keep the patch simple for urgent/backport. I will clean this by 
> restructuring the init code for 2.6.35

Ok, fair enough, i'll queue up this fix.

The best structure would be to integrate these init details into the APIC 
driver methods and make UP-IOAPIC nothing particularly special.

Thanks,

	Ingo
