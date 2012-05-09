Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282Ab2EIVVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 17:21:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51186 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759161Ab2EIVV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 17:21:28 -0400
Date: Thu, 10 May 2012 00:21:17 +0300
From: Ido Yariv <ido@wizery.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@ScaleMP.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ravikiran Thirumalai <kiran.thirumalai@gmail.com>
Subject: Re: [PATCH v2 2/2] vsmp: Ignore IOAPIC IRQ affinity if possible
Message-ID: <20120509212117.GA32594@NoteStation.guest.lab126.com>
References: <1333715987-26059-2-git-send-email-ido@wizery.com>
 <1334561976-13965-1-git-send-email-ido@wizery.com>
 <1334561976-13965-2-git-send-email-ido@wizery.com>
 <20120507131943.GI23858@gmail.com>
 <9B14D1490DDECA4E974F6B9FC9EBAB317D0A62A08B@VMBX108.ihostexchange.net>
 <20120509091827.GB8585@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509091827.GB8585@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Wed, May 09, 2012 at 11:18:27AM +0200, Ingo Molnar wrote:
> 
> * Shai Fultheim (Shai@ScaleMP.com) <Shai@ScaleMP.com> wrote:
> 
> > Ingo Molnar <mingo.kernel.org@gmail.com> wrote:
> > > * Ido Yariv <ido@wizery.com> wrote:
> > 
> > > > @@ -51,6 +60,7 @@ void __init default_setup_apic_routing(void)
> > > >  	if (is_vsmp_box()) {
> > > >  		/* need to update phys_pkg_id */
> > > >  		apic->phys_pkg_id = apicid_phys_pkg_id;
> > > > +		apic->vector_allocation_domain =
> > > fill_vector_allocation_domain;
> > > >  	}
> > > >  }
> > > 
> > > This is_vsmp_box() special case should really move into its own
> > > apic handler.
> > > 
> > > Thanks,
> > 
> > Ingo,
> > 
> > vSMP Foundation virtualize multiple systems as one.  The Guest 
> > OS is using the underlying hardware APIC driver, and therefore 
> > we must allow the various APIC drivers to kick in.  When using 
> > vSMP Foundation APIC driver is selected by the kernel based on 
> > the hardware that is being virtualized, and that can be APIC, 
> > X2APIC phys, X2APIC cluster, summit, etc.
> > 
> > If we would to implement an APIC handler, we would not be able 
> > to use the native hardware APIC driver (unless we do an ugly 
> > hack).
> 
> If you need a callback on that level then there's a cleaner 
> mechanism than open-coding vsmp handlers into generic code:
> 
>  - create a new platform callback in x86_platform_ops
>  - call it from apic_64.c if set
>  - fill in the vSMP specific handler from the vSMP init code

Sounds good.

We'll look into it and post an alternative patch to this one.

Thanks,
Ido.
