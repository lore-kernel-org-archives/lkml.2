Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454Ab2EUWuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 18:50:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab2EUWuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 18:50:17 -0400
Date: Tue, 22 May 2012 01:50:12 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
Message-ID: <20120521225010.GN17031@redhat.com>
References: <20120521163727.GA13337@redhat.com>
 <alpine.LFD.2.02.1205211940030.3231@ionos>
 <20120521215127.GH17031@redhat.com>
 <alpine.LFD.2.02.1205220012020.3231@ionos>
 <20120521222449.GJ17031@redhat.com>
 <alpine.LFD.2.02.1205220029480.3231@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1205220029480.3231@ionos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 12:44:39AM +0200, Thomas Gleixner wrote:
> Michael,
> 
> On Tue, 22 May 2012, Michael S. Tsirkin wrote:
> > On Tue, May 22, 2012 at 12:14:18AM +0200, Thomas Gleixner wrote:
> > > On Tue, 22 May 2012, Michael S. Tsirkin wrote:
> > > 
> > > > On Mon, May 21, 2012 at 11:04:25PM +0200, Thomas Gleixner wrote:
> > > > > > @@ -242,6 +262,25 @@ static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
> > > > > >  		apic->irr_pending = true;
> > > > > >  }
> > > > > >  
> > > > > > +static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
> > > > > > +{
> > > > > > +	if (!__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
> > > > > > +		++apic->isr_count;
> > > > > > +	ASSERT(apic->isr_count > MAX_APIC_VECTOR);
> > > > > 
> > > > > I'm really curious what you observed when defining DEBUG in that file.
> > > > > 
> > > > > Clearly you never did.
> > > > 
> > > > Sorry :(
> > > > Yes clearly silly, thanks for pointing this out.
> > > 
> > > That's all you have a reply for? That's the least of the problems ....
> > 
> > Others are not my fault :)
> 
> Interesting. The other changes you added are not your fault?
> 
> So you provided a patch which you didn't author completely. You merily
> added the bogus ASSERTs, right ?
> 
> Can you please explain why there is only your SOB on that patch?
> 
> Thanks,
> 
> 	tglx

I authored the patch, sorry if I didn't make it clear:
the bitmap data-structure that you noted as inefficient
is part of Linux, I merely keep it as it is upstream.

I'll reply to the original mail, it's easier.

