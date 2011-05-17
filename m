Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab1EQKrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 06:47:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40289 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab1EQKrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 06:47:23 -0400
Date: Tue, 17 May 2011 12:46:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 0/4] Enable SMEP CPU Feature
Message-ID: <20110517104654.GN22093@elte.hu>
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com>
 <4DD19C81.8000902@zytor.com>
 <20110517070527.GD22305@elte.hu>
 <4DD23CB6.3050503@redhat.com>
 <20110517092903.GJ22093@elte.hu>
 <4DD2409F.4030800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD2409F.4030800@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 05/17/2011 12:29 PM, Ingo Molnar wrote:
> >* Avi Kivity<avi@redhat.com>  wrote:
> >
> >>  >  Some programmable configurability seems necessary on the KVM side, as KVM
> >>  >  has no control over how sane the guest kernel is.
> >>
> >>  We should simply expose the cpuid bit and cr4.smep.  If the guest kernel
> >>  feels it is up to it, it can enable smep itself.
> >
> > Well, given that there's lots of legacy installations around it would be a 
> > neat KVM feature if it was possible to enable SMEP even if the guest kernel 
> > does not enable it. As an additional (optional) layer of security.
> >
> > For example legacy Linux guests will work just fine, even if they do not 
> > enable SMEP themselves.
> 
> It's certainly possible (set CR4.SMEP transparently and hide it from the 
> guest).  But there's no way to tell if it doesn't break something wierd.  The 
> host might not even know if the guest is Linux or something else.
> 
> We could support it as a non-default feature, but that reduces its utility.

It would be a nice touch for tools/kvm/: we would use KVM_GET_SREGS and 
KVM_GET_SREGS to twiddle CR4.SMEP, even without the guest explicitly doing it.

A quick glance suggests that it could be done straight away in 
tools/kvm/kvm-cpu.c::kvm_cpu__setup_sregs() during vcpu setup, and hopefully 
that cr4 value survives boot and ends up in the guest kernel's mmu_cr4_features 
mask shadow register.

Thanks,

	Ingo
