Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab2EDLpC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 07:45:02 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:35547 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab2EDLpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 07:45:00 -0400
Date: Fri, 4 May 2012 17:14:49 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: peterz@infradead.org, mingo@elte.hu, jeremy@goop.org, mtosatti@redhat.com,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        avi@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
Message-ID: <20120504114449.GB25659@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20120427161727.27082.43096.stgit@abhimanyu>
 <20120427162401.27082.59387.stgit@abhimanyu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120427162401.27082.59387.stgit@abhimanyu>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12050411-8256-0000-0000-0000023F6D1E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com> [2012-04-27 21:54:37]:

> @@ -1549,6 +1549,11 @@ static void kvm_set_vcpu_state(struct kvm_vcpu *vcpu)
>  		return;
> 
>  	vs->state = 1;
> +	if (vs->flush_on_enter) {
> +		kvm_mmu_flush_tlb(vcpu);
> +		vs->flush_on_enter = 0;
> +	}
> +
>  	kvm_write_guest_cached(vcpu->kvm, ghc, vs, 2*sizeof(__u32));

Reading flush_on_enter before writing ->state (=1) is racy afaics (and
may cause vcpu to miss a TLB flush request).

- vatsa

