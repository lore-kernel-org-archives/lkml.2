Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab0KCNow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 09:44:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab0KCNou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 09:44:50 -0400
Date: Wed, 3 Nov 2010 11:43:55 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH v2 7/7] KVM: KVM: don't break vcpu 'halt' state due
 to apfs
Message-ID: <20101103134355.GD16809@amt.cnet>
References: <4CCE8143.3090105@cn.fujitsu.com>
 <4CCE82BC.3090000@cn.fujitsu.com>
 <20101101125551.GD31722@redhat.com>
 <4CD12FC9.9070902@cn.fujitsu.com>
 <20101103094508.GG7881@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101103094508.GG7881@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 11:45:08AM +0200, Gleb Natapov wrote:
> On Wed, Nov 03, 2010 at 05:47:53PM +0800, Xiao Guangrong wrote:
> > On 11/01/2010 08:55 PM, Gleb Natapov wrote:
> > 
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 2cfdf2d..f7aed95 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -5295,8 +5295,9 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
> > >  			{
> > >  				switch(vcpu->arch.mp_state) {
> > >  				case KVM_MP_STATE_HALTED:
> > > -					vcpu->arch.mp_state =
> > > -						KVM_MP_STATE_RUNNABLE;
> > > +					if (list_empty_careful(&vcpu->async_pf.done))
> > > +						vcpu->arch.mp_state =
> > > +							KVM_MP_STATE_RUNNABLE;
> > >  				case KVM_MP_STATE_RUNNABLE:
> > >  					vcpu->arch.apf.halted = false;
> > >  					break;
> > > @@ -6279,6 +6280,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
> > >  		vcpu->arch.fault.error_code = 0;
> > >  		vcpu->arch.fault.address = work->arch.token;
> > >  		kvm_inject_page_fault(vcpu);
> > > +		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> > >  	}
> > >  }
> > >  
> > 
> > Tested with full virtualization guests, it works well for me. Thanks!
> Thank you. Will repost properly.

There is no need to optimize this. Current code is simpler, less
error-prone. Applied 1-6, thanks.

