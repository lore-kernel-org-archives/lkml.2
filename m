Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab1HVUnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:43:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233Ab1HVUnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:43:00 -0400
Date: Mon, 22 Aug 2011 17:42:10 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 03/11] KVM: x86: retry non-page-table writing instruction
Message-ID: <20110822204209.GA3490@amt.cnet>
References: <4E4A10E8.5090705@cn.fujitsu.com>
 <4E4A113F.5090404@cn.fujitsu.com>
 <20110822195929.GA2662@amt.cnet>
 <4E52BA31.4030203@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E52BA31.4030203@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 04:21:05AM +0800, Xiao Guangrong wrote:
> On 08/23/2011 03:59 AM, Marcelo Tosatti wrote:
> 
> >> +	if (!vcpu->arch.mmu.direct_map && !mmu_is_nested(vcpu))
> >> +		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
> > 
> > Why write? 
> > 
> 
> Since the fault is caused by page table written, and the 'gpa' can
> be written after instruction is retied.
> 
> >> +	kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
> >> +
> >> +	/*
> >> +	 * The shadow pages have been zapped, then we call the page
> >> +	 * fault path to change the mapping to writable.
> >> +	 */
> >> +	vcpu->arch.mmu.page_fault(vcpu, cr2, PFERR_WRITE_MASK, true);
> > 
> > I don't see why is this necessary. Just allowing the instruction to
> > proceed should be enough?
> > 
> 
> It used to avoid later VM-exit, since we will retry the instruction
> but the mapped is still read-only. So we can it to let the mapping become
> writable to avoid page fault again.

Its not like this case is performance sensitive. Usually optimizing
things without the need for it leads to bad results. So please drop 
this.

