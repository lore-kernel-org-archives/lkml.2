Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915Ab1CaKxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 06:53:33 -0400
Received: from ist.d-labs.de ([213.239.218.44]:33906 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab1CaKxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 06:53:32 -0400
Date: Thu, 31 Mar 2011 12:53:05 +0200
From: Florian Mickler <florian@mickler.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, mingo@elte.hu, rjw@sisk.pl,
        sedat.dilek@gmail.com, zersaa@gmail.com, stable@kernel.org
Subject: Re: [PATCH][POKE] Skip looking for ioapic overrides when ioapics
 are not present
Message-ID: <20110331125305.1e8c70ba@schatten.dmk.lab>
In-Reply-To: <1301561386.1904.15.camel@t41.thuisdomein>
References: <1301558489-4198-1-git-send-email-florian@mickler.org>
	<1301561386.1904.15.camel@t41.thuisdomein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 10:48:43 +0200
Paul Bolle <pebolle@tiscali.nl> wrote:

> On Thu, 2011-03-31 at 10:01 +0200, Florian Mickler wrote:
> > diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> > index 68df09b..3940103 100644
> > --- a/arch/x86/kernel/apic/io_apic.c
> > +++ b/arch/x86/kernel/apic/io_apic.c
> > @@ -3789,6 +3789,9 @@ int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
> >  {
> >  	int ioapic, pin, idx;
> >  
> > +	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
> > +		return -1;
> > +
> >  	if (skip_ioapic_setup)
> >  		return -1;
> >  
> 
> Seems to have the same goal as commit
> 678301ecadec24ff77ab310eebf8a32ccddb1850 ("x86, ioapic: Don't warn about
> non-existing IOAPICs if we have none"), which got merged in the v2.6.38
> cycle (authored by me, signed off by Ingo Molnar). Maybe Eric's patch is
> more correct. I can't say as I was happy with the effect of my patch
> (ie, make an uninteresting error disappear) and didn't investigate any
> further. I have also no desire to dive into this matter again.
> 
> 
> Paul
> 

Thanks for letting me know. Sedat, did you actually test with 2.6.38?

Regards,
Flo
