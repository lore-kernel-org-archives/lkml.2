Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab1JRJsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 05:48:52 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42701 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab1JRJsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 05:48:51 -0400
Date: Tue, 18 Oct 2011 11:48:32 +0200
From: Borislav Petkov <bp@amd64.org>
To: David Rientjes <rientjes@google.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] x86, microcode: Correct microcode revision format
Message-ID: <20111018094831.GB17076@aftab>
References: <1318865115-9904-1-git-send-email-bp@amd64.org>
 <1318865115-9904-2-git-send-email-bp@amd64.org>
 <alpine.DEB.2.00.1110172349590.8959@chino.kir.corp.google.com>
 <20111018075145.GB16100@aftab>
 <alpine.DEB.2.00.1110180108590.8959@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110180108590.8959@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 04:14:05AM -0400, David Rientjes wrote:
> On Tue, 18 Oct 2011, Borislav Petkov wrote:
> 
> > > > diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> > > > index 8af6fa4..ad8d897 100644
> > > > --- a/arch/x86/kernel/cpu/mcheck/mce.c
> > > > +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> > > > @@ -221,7 +221,7 @@ static void print_mce(struct mce *m)
> > > >  	 * Note this output is parsed by external tools and old fields
> > > >  	 * should not be changed.
> > > >  	 */
> > > > -	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x microcode %u\n",
> > > > +	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x microcode %x\n",
> > > >  		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid,
> > > >  		cpu_data(m->extcpu).microcode);
> > > >  
> > > 
> > > Any reason why this isn't prefixed with "0x"?
> > 
> > Well, no strong reason except that APIC is without '0x' and I leaned
> > towards the same for 'microcode'. And since this output format is legacy
> > and MCE stanzas are being parsed by scripts, keeping the format for new
> > fields sounded like the right thing to do, IMHO.
> > 
> 
> Anytime there's a string that prints decimal, then hex, then decimal, then 
> decimal, then hex, then hex, I think it's always better to include a 
> prefix where it's not clear.  It's printed here without the prefix and in 
> other places with the prefix, so I think it would be better to just be as 
> explicit as possible.

Why do I need to be explicit in the MCE stanza? I'm fine with what
you're saying but I don't see a compelling reason why, sorry. Especially
since it was defined crappy to begin with.

> And, the argument that scripts are parsing this is actually bogus
> since it would be expecting decimal there and you'd actually be doing
> them a favor by breaking if they can't handle the "0x" since you've
> changed it to hex. I know the comment says not to change old fields,
> but the microcode field hasn't hit Linus' tree yet, either.

Right, either way I don't seem to care too much. The only thing I care
about is having ucode revision in hex in all places, with or without the
"0x" prefix.

So what do the others think, let's take a poll here. :-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
