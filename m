Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab0D0Qz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 12:55:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab0D0Qz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 12:55:28 -0400
Date: Tue, 27 Apr 2010 13:55:25 -0300
From: Glauber Costa <glommer@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH 4/6] export new cpuid KVM_CAP
Message-ID: <20100427165525.GP16166@mothafucka.localdomain>
References: <1272303988-21929-1-git-send-email-glommer@redhat.com>
 <1272303988-21929-2-git-send-email-glommer@redhat.com>
 <1272303988-21929-3-git-send-email-glommer@redhat.com>
 <1272303988-21929-4-git-send-email-glommer@redhat.com>
 <1272303988-21929-5-git-send-email-glommer@redhat.com>
 <20100427133048.GC18410@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100427133048.GC18410@amt.cnet>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 10:30:48AM -0300, Marcelo Tosatti wrote:
> On Mon, Apr 26, 2010 at 01:46:26PM -0400, Glauber Costa wrote:
> > Since we're changing the msrs kvmclock uses, we have to communicate
> > that to the guest, through cpuid. We can add a new KVM_CAP to the
> > hypervisor, and then patch userspace to recognize it.
> > 
> > And if we ever add a new cpuid bit in the future, we have to do that again,
> > which create some complexity and delay in feature adoption.
> > 
> > Instead, what I'm proposing in this patch is a new capability, called
> > KVM_CAP_X86_CPUID_FEATURE_LIST, that returns the current feature list
> > currently supported by the hypervisor. If we ever want to add or remove
> > some feature, we only need to tweak into the HV, leaving userspace untouched.
> > 
> > Signed-off-by: Glauber Costa <glommer@redhat.com>
> > ---
> >  arch/x86/include/asm/kvm_para.h |    4 ++++
> >  arch/x86/kvm/x86.c              |    6 ++++++
> >  include/linux/kvm.h             |    1 +
> >  3 files changed, 11 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> > index 9734808..f019f8c 100644
> > --- a/arch/x86/include/asm/kvm_para.h
> > +++ b/arch/x86/include/asm/kvm_para.h
> > @@ -16,6 +16,10 @@
> >  #define KVM_FEATURE_CLOCKSOURCE		0
> >  #define KVM_FEATURE_NOP_IO_DELAY	1
> >  #define KVM_FEATURE_MMU_OP		2
> > +/* This indicates that the new set of kvmclock msrs
> > + * are available. The use of 0x11 and 0x12 is deprecated
> > + */
> > +#define KVM_FEATURE_CLOCKSOURCE2        3
> >  
> >  #define MSR_KVM_WALL_CLOCK  0x11
> >  #define MSR_KVM_SYSTEM_TIME 0x12
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index a2ead7f..04f04aa 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1545,6 +1545,12 @@ int kvm_dev_ioctl_check_extension(long ext)
> >  	case KVM_CAP_MCE:
> >  		r = KVM_MAX_MCE_BANKS;
> >  		break;
> > +	case KVM_CAP_X86_CPUID_FEATURE_LIST:
> > +		r = (1 << KVM_FEATURE_CLOCKSOURCE) |
> > +		(1 << KVM_FEATURE_NOP_IO_DELAY) |
> > +		(1 << KVM_FEATURE_MMU_OP) |
> 
> Remove this flag, it has been deprecated.

Ok, sorry. My bad here.

at a quick glance, I did not realize you were commenting on this
patch specifically. KVM_CAP_X86_CPUID_FEATURE_LIST is a new
entity, so there is no need to return a deprecated feature.

I will remove that.

