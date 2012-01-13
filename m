Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab2AMM4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 07:56:08 -0500
Received: from caiajhbdccah.dreamhost.com ([208.97.132.207]:41618 "EHLO
	homiemail-a38.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753170Ab2AMM4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 07:56:05 -0500
X-Greylist: delayed 42481 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jan 2012 07:56:05 EST
Subject: Re: [PATCH] KVM: MMU: increment stats after event occurrence
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
In-Reply-To: <4F0F87BE.2020202@oss.ntt.co.jp>
References: <1326416880.3416.2.camel@offbook>
	 <4F0F87BE.2020202@oss.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Fri, 13 Jan 2012 13:56:00 +0100
Message-ID: <1326459360.3231.3.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-13 at 10:24 +0900, Takuya Yoshikawa wrote:
> (2012/01/13 10:08), Davidlohr Bueso wrote:
> > From: Davidlohr Bueso<dave@gnu.org>
> >
> > It makes more sense to actually increment statistics for tlb flushes and page table entry updates after such _events_ occur, instead of before.
> 
> Why?
> 
>From a logical point of view its better to increase stats once the event
is processed - usually because it can fail and therefore the stats would
be incorrect. 

> 	Takuya
> 
> >
> > Signed-off-by: Davidlohr Bueso<dave@gnu.org>
> > ---
> >   arch/x86/kvm/mmu.c |    4 ++--
> >   1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> > index 2a2a9b4..0b7008e 100644
> > --- a/arch/x86/kvm/mmu.c
> > +++ b/arch/x86/kvm/mmu.c
> > @@ -3130,8 +3130,8 @@ static int nonpaging_init_context(struct kvm_vcpu *vcpu,
> >
> >   void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu)
> >   {
> > -	++vcpu->stat.tlb_flush;
> >   	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> > +	++vcpu->stat.tlb_flush;
> >   }
> >
> >   static void paging_new_cr3(struct kvm_vcpu *vcpu)
> > @@ -3486,8 +3486,8 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
> >   		return;
> >           }
> >
> > -	++vcpu->kvm->stat.mmu_pte_updated;
> >   	vcpu->arch.mmu.update_pte(vcpu, sp, spte, new);
> > +	++vcpu->kvm->stat.mmu_pte_updated;
> >   }
> >
> >   static bool need_remote_flush(u64 old, u64 new)
> 
> 


