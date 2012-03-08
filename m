Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab2CHKkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 05:40:09 -0500
Received: from damascus.uab.es ([158.109.168.135]:40280 "EHLO damascus.uab.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134Ab2CHKkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 05:40:03 -0500
Date: Thu, 08 Mar 2012 12:40:31 +0100
From: Davidlohr Bueso <dave@gnu.org>
Subject: Re: [PATCH] KVM: x86: add paging gcc optimization
In-reply-to: <4F587FB6.1070803@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Message-id: <1331206831.28711.0.camel@offworld>
Organization: GNU
MIME-version: 1.0
X-Mailer: Evolution 3.0.3-2
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
X-Spam-Tests: ALL_TRUSTED=-1
X-imss-version: 2.054
X-imss-result: Passed
X-imss-scanInfo: M:P L:N SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:6.5.1024(18760.006)
X-imss-scores: Clean:99.90000 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:3 C:3 M:3 S:3 R:3 (0.5000 0.5000)
References: <1331150569.25969.1.camel@offbook> <4F587FB6.1070803@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 11:45 +0200, Avi Kivity wrote:
> On 03/07/2012 10:02 PM, Davidlohr Bueso wrote:
> > From: Davidlohr Bueso <dave@gnu.org>
> >
> > Since most guests will have paging enabled for memory management, add likely() and unlikely()
> > optimizations around is_paging() checks.
> >
> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> > ---
> >  arch/x86/kvm/mmu.c |    6 +++---
> >  arch/x86/kvm/svm.c |    6 +++---
> >  arch/x86/kvm/vmx.c |   16 ++++++++--------
> >  arch/x86/kvm/x86.c |    8 ++++----
> >  4 files changed, 18 insertions(+), 18 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> > index 4cb1642..84f1e95 100644
> > --- a/arch/x86/kvm/mmu.c
> > +++ b/arch/x86/kvm/mmu.c
> > @@ -3320,7 +3320,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
> >  	context->get_pdptr = kvm_pdptr_read;
> >  	context->inject_page_fault = kvm_inject_page_fault;
> >  
> > -	if (!is_paging(vcpu)) {
> > +	if (unlikely(!is_paging(vcpu))) {
> >
> 
> Just change is_paging itself():

Ok, yes, makes more sense. I'll resend the patch. 

Thanks.

> 
>  static inline int is_paging(struct kvm_vcpu *vcpu)
>  {
> -    return kvm_read_cr0_bits(vcpu, X86_CR0_PG);
> +    return likely(kvm_read_cr0_bits(vcpu, X86_CR0_PG));
>   }
> 


