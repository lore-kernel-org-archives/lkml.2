Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab2EUWOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 18:14:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:33833 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab2EUWOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 18:14:21 -0400
Date: Tue, 22 May 2012 00:14:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
In-Reply-To: <20120521215127.GH17031@redhat.com>
Message-ID: <alpine.LFD.2.02.1205220012020.3231@ionos>
References: <20120521163727.GA13337@redhat.com> <alpine.LFD.2.02.1205211940030.3231@ionos> <20120521215127.GH17031@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Michael S. Tsirkin wrote:

> On Mon, May 21, 2012 at 11:04:25PM +0200, Thomas Gleixner wrote:
> > > @@ -242,6 +262,25 @@ static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
> > >  		apic->irr_pending = true;
> > >  }
> > >  
> > > +static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
> > > +{
> > > +	if (!__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
> > > +		++apic->isr_count;
> > > +	ASSERT(apic->isr_count > MAX_APIC_VECTOR);
> > 
> > I'm really curious what you observed when defining DEBUG in that file.
> > 
> > Clearly you never did.
> 
> Sorry :(
> Yes clearly silly, thanks for pointing this out.

That's all you have a reply for? That's the least of the problems ....
