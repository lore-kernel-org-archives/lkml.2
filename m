Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab1JRHwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 03:52:07 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:48808 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253Ab1JRHwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 03:52:06 -0400
Date: Tue, 18 Oct 2011 09:51:45 +0200
From: Borislav Petkov <bp@amd64.org>
To: David Rientjes <rientjes@google.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] x86, microcode: Correct microcode revision format
Message-ID: <20111018075145.GB16100@aftab>
References: <1318865115-9904-1-git-send-email-bp@amd64.org>
 <1318865115-9904-2-git-send-email-bp@amd64.org>
 <alpine.DEB.2.00.1110172349590.8959@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110172349590.8959@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 02:50:27AM -0400, David Rientjes wrote:
> On Mon, 17 Oct 2011, Borislav Petkov wrote:
> 
> > diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> > index 8af6fa4..ad8d897 100644
> > --- a/arch/x86/kernel/cpu/mcheck/mce.c
> > +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> > @@ -221,7 +221,7 @@ static void print_mce(struct mce *m)
> >  	 * Note this output is parsed by external tools and old fields
> >  	 * should not be changed.
> >  	 */
> > -	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x microcode %u\n",
> > +	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x microcode %x\n",
> >  		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid,
> >  		cpu_data(m->extcpu).microcode);
> >  
> 
> Any reason why this isn't prefixed with "0x"?

Well, no strong reason except that APIC is without '0x' and I leaned
towards the same for 'microcode'. And since this output format is legacy
and MCE stanzas are being parsed by scripts, keeping the format for new
fields sounded like the right thing to do, IMHO.

> 
> > diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
> > index 6254fda..14b2314 100644
> > --- a/arch/x86/kernel/cpu/proc.c
> > +++ b/arch/x86/kernel/cpu/proc.c
> > @@ -86,7 +86,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
> >  	else
> >  		seq_printf(m, "stepping\t: unknown\n");
> >  	if (c->microcode)
> > -		seq_printf(m, "microcode\t: %u\n", c->microcode);
> > +		seq_printf(m, "microcode\t: 0x%x\n", c->microcode);
> >  
> >  	if (cpu_has(c, X86_FEATURE_TSC)) {
> >  		unsigned int freq = cpufreq_quick_get(cpu);
> 
> When here it is?

This needed to explicitly state that it is a hex number because the rest
of the /proc/cpuinfo fields are decimals.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
