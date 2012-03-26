Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab2CZKQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:16:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756759Ab2CZKQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:16:26 -0400
Message-ID: <4F7041EE.10305@redhat.com>
Date: Mon, 26 Mar 2012 12:16:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC dontapply] kvm_para: add mmio word store hypercall
References: <20120325220518.GA27879@redhat.com> <4F703536.3040904@redhat.com> <20120326100829.GA14506@redhat.com>
In-Reply-To: <20120326100829.GA14506@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 12:08 PM, Michael S. Tsirkin wrote:
>
> > > +		gpa = hc_gpa(vcpu, a1, a2);
> > > +		if (!write_mmio(vcpu, gpa, 2, &a0) && run) {
> > 
> > What's this && run thing?
>
> I'm not sure - copied this from another other place in emulation:
> arch/x86/kvm/x86.c:4953:                if (!write_mmio(vcpu, gpa, 2, &a0) && run)
>
> I assumed there's some way to trigger emulation while VCPU does not run.
> No?

Not the way you initialize run above.

>
> > 
> > > +			run->exit_reason = KVM_EXIT_MMIO;
> > > +			run->mmio.phys_addr = gpa;
> > > +			memcpy(run->mmio.data, &a0, 2);
> > > +			run->mmio.len = 2;
> > > +			run->mmio.is_write = 1;
> > > +                        r = 0;
> > > +		}
> > > +		goto noret;
> > 
> > What if the address is in RAM?
> > Note the guest can't tell if a piece of memory is direct mapped or
> > implemented as mmio.
>
> True but doing hypercalls for memory which can be
> mapped directly is bad for performance - it's
> the reverse of what we are trying to do here.

It's bad, but the guest can't tell.

Suppose someone implements virtio in hardware and we pass it through to
a guest.  It should continue working, no?

> The intent is to use this for virtio where we can explicitly let the
> guest know whether using a hypercall is safe.
>
> Acceptable?  What do you suggest?

It's iffy.

What's the performance gain from this thing?


-- 
error compiling committee.c: too many arguments to function

