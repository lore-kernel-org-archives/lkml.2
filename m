Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab1JRIOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 04:14:14 -0400
Received: from smtp-out.google.com ([74.125.121.67]:4645 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab1JRIOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 04:14:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=MsbChFA9Acs2L17qntNUUCiYdDKb2Wfu7xxjnfXy/nU18CX7oIU6TJ/8x41QT3Xez
	oAoMarreTihq3rbsa62wQ==
Date: Tue, 18 Oct 2011 01:14:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Borislav Petkov <bp@amd64.org>
cc: Ingo Molnar <mingo@elte.hu>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] x86, microcode: Correct microcode revision format
In-Reply-To: <20111018075145.GB16100@aftab>
Message-ID: <alpine.DEB.2.00.1110180108590.8959@chino.kir.corp.google.com>
References: <1318865115-9904-1-git-send-email-bp@amd64.org> <1318865115-9904-2-git-send-email-bp@amd64.org> <alpine.DEB.2.00.1110172349590.8959@chino.kir.corp.google.com> <20111018075145.GB16100@aftab>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Borislav Petkov wrote:

> > > diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> > > index 8af6fa4..ad8d897 100644
> > > --- a/arch/x86/kernel/cpu/mcheck/mce.c
> > > +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> > > @@ -221,7 +221,7 @@ static void print_mce(struct mce *m)
> > >  	 * Note this output is parsed by external tools and old fields
> > >  	 * should not be changed.
> > >  	 */
> > > -	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x microcode %u\n",
> > > +	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x microcode %x\n",
> > >  		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid,
> > >  		cpu_data(m->extcpu).microcode);
> > >  
> > 
> > Any reason why this isn't prefixed with "0x"?
> 
> Well, no strong reason except that APIC is without '0x' and I leaned
> towards the same for 'microcode'. And since this output format is legacy
> and MCE stanzas are being parsed by scripts, keeping the format for new
> fields sounded like the right thing to do, IMHO.
> 

Anytime there's a string that prints decimal, then hex, then decimal, then 
decimal, then hex, then hex, I think it's always better to include a 
prefix where it's not clear.  It's printed here without the prefix and in 
other places with the prefix, so I think it would be better to just be as 
explicit as possible.

And, the argument that scripts are parsing this is actually bogus since it 
would be expecting decimal there and you'd actually be doing them a favor 
by breaking if they can't handle the "0x" since you've changed it to hex.  
I know the comment says not to change old fields, but the microcode field 
hasn't hit Linus' tree yet, either.
