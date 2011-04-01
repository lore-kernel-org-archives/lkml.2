Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab1DAGrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 02:47:40 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:56759 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab1DAGrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 02:47:39 -0400
Date: Fri, 01 Apr 2011 02:47:30 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Ingo Molnar <mingo@elte.hu>
Cc: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, rjw@sisk.pl, sedat.dilek@gmail.com,
        stable@kernel.org, #.34+@schatten.dmk.lab
Subject: Re: [PATCH v2] x86, ioapic: Skip looking for ioapic overrides when
 ioapics are not present
In-reply-to: <20110401062006.GC32378@elte.hu>
Message-id: <alpine.LFD.2.02.1104010245290.2797@x980>
References: <20110331084342.GA30105@elte.hu>
 <1301621025-3858-1-git-send-email-florian@mickler.org>
 <20110401062006.GC32378@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > --- a/arch/x86/kernel/apic/io_apic.c
> > +++ b/arch/x86/kernel/apic/io_apic.c
> > @@ -3789,6 +3789,10 @@ int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
> >  {
> >  	int ioapic, pin, idx;
> >  
> > +#ifdef CONFIG_ACPI
> > +	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
> > +		return -1;
> > +#endif
> 
> That #ifdef is very ugly. Please introduce a suitable helper function in 
> arch/x86/include/asm/acpi.h - acpi_irq_ioapic_model() or so, which could be 
> used like this:
> 
> 	if (!acpi_irq_ioapic_model())
> 		return -1;
> 
> And would be defined in the !CONFIG_ACPI case as well.

It would be better to compile _none_ of acpi_get_override_irq() for !ACPI.

-Len

