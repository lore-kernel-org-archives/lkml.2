Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab2GEF4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 01:56:01 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:57913 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab2GEFz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 01:55:59 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: peterz@infradead.org, mingo@elte.hu, avi@redhat.com,
        raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Subject: Re: [PATCH v2 3/7] KVM: Add paravirt kvm_flush_tlb_others
In-Reply-To: <20120705020910.GB3652@amt.cnet>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com> <20120604050629.4560.85284.stgit@abhimanyu.in.ibm.com> <20120703075535.GA13291@amt.cnet> <87txxpcl3u.fsf@linux.vnet.ibm.com> <20120705020910.GB3652@amt.cnet>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Thu, 05 Jul 2012 11:25:23 +0530
Message-ID: <87mx3eah10.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12070505-8256-0000-0000-0000033101E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2012 23:09:10 -0300, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> On Tue, Jul 03, 2012 at 01:49:49PM +0530, Nikunj A Dadhania wrote:
> > On Tue, 3 Jul 2012 04:55:35 -0300, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > > > 
> > > >    if (!zero_mask)
> > > > 	   goto again;
> > > 
> > > Can you please measure increased vmentry/vmexit overhead? x86/vmexit.c 
> > > of git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git should 
> > > help.
> > >
> > Sure will get back with the result.
> > 
> > > > +	/* 
> > > > +	 * Guest might have seen us offline and would have set
> > > > +	 * flush_on_enter. 
> > > > +	 */
> > > > +	kvm_read_guest_cached(vcpu->kvm, ghc, vs, 2*sizeof(__u32));
> > > > +	if (vs->flush_on_enter) 
> > > > +		kvm_x86_ops->tlb_flush(vcpu);
> > > 
> > > 
> > > So flush_tlb_page which was an invlpg now flushes the entire TLB. Did
> > > you take that into account?
> > > 
> > When the vcpu is sleeping/pre-empted out, multiple request for flush_tlb
> > could have happened. And now when we are here, it is cleaning up all the
> > TLB.
> 
> Yes, cases where there are sufficient exits transforming one TLB entry
> invalidation into full TLB invalidation should go unnoticed.
> 
> > One other approach would be to queue the addresses, that brings us with
> > the question: how many request to queue? This would require us adding
> > more syncronization between guest and host for updating the area where
> > these addresses is shared.
> 
> Sounds unnecessarily complicated.
> 
Yes, I did give this a try earlier, but did not see much improvement
with the amount of complexity that it was bringing in.

Regards
Nikunj

