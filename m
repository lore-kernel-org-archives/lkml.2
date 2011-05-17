Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab1EQLjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 07:39:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40690 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab1EQLjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 07:39:47 -0400
Date: Tue, 17 May 2011 13:38:51 +0200
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
Message-ID: <20110517113851.GD13475@elte.hu>
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com>
 <4DD19C81.8000902@zytor.com>
 <20110517070527.GD22305@elte.hu>
 <4DD23CB6.3050503@redhat.com>
 <20110517092903.GJ22093@elte.hu>
 <4DD2409F.4030800@redhat.com>
 <20110517104654.GN22093@elte.hu>
 <4DD25D29.9040008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD25D29.9040008@redhat.com>
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

> On 05/17/2011 01:46 PM, Ingo Molnar wrote:
> >>
> >>  We could support it as a non-default feature, but that reduces its utility.
> >
> >It would be a nice touch for tools/kvm/: we would use KVM_GET_SREGS and
> >KVM_GET_SREGS to twiddle CR4.SMEP, even without the guest explicitly doing it.
> >
> >A quick glance suggests that it could be done straight away in
> >tools/kvm/kvm-cpu.c::kvm_cpu__setup_sregs() during vcpu setup, and hopefully
> >that cr4 value survives boot and ends up in the guest kernel's mmu_cr4_features
> >mask shadow register.
> 
> Depends if the guest uses a read-modify-write pattern or not.  We could do it 
> transparently in kvm.ko, since the real cr4 need not corresponds to the guest 
> notion (for example, we often set cr0.wp or cr0.ts even though the guest 
> wants them clear).

Oh, being transparent is a nice touch when it comes to security measures 
(catching attackers who think there's no SMEP and such) - but that would need 
KVM support and a new ioctl to configure it, right?

Thanks,

	Ingo
