Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab0GGNH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:07:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850Ab0GGNHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:07:24 -0400
Date: Wed, 7 Jul 2010 10:07:05 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 8/9] KVM: MMU: combine guest pte read between fetch
 and pte prefetch
Message-ID: <20100707130705.GA4293@amt.cnet>
References: <4C330918.6040709@cn.fujitsu.com>
 <4C330A9A.9030106@cn.fujitsu.com>
 <20100706195254.GA4311@amt.cnet>
 <4C33D703.4090208@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C33D703.4090208@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 09:23:15AM +0800, Xiao Guangrong wrote:
> 
> 
> Marcelo Tosatti wrote:
> 
> >> -
> >> -	first_pte_gpa = gfn_to_gpa(sp->gfn) +
> >> -				(offset + i) * sizeof(pt_element_t);
> >> -
> >> -	if (kvm_read_guest_atomic(vcpu->kvm, first_pte_gpa, gptep,
> >> -					sizeof(gptep)) < 0)
> >> -		return;
> >> +	gptep = gw->prefetch_ptes;
> > 
> > Where do you reread the gpte in the prefetch path?
> > 
> 
> Marcelo,
> 
> Thanks for your review.
> 
> Below codes read gptes in the prefetch path:
> 
> 	index = sptep - sp->spt;
> 	i = index & ~(PTE_PREFETCH_NUM - 1);
> 	max = index | (PTE_PREFETCH_NUM - 1);
> 
> 	if (PTTYPE == 32)
> 		offset = sp->role.quadrant << PT64_LEVEL_BITS;
> 
> 	first_pte_gpa = gfn_to_gpa(sp->gfn) +
> 				(offset + i) * sizeof(pt_element_t);
> 
> 	if (kvm_read_guest_atomic(vcpu->kvm, first_pte_gpa, gptep,
> 					sizeof(gptep)) < 0)
> 		return;
> 
> It reads the 16 aligned items around sptep's corresponding gpte and this gpte
> is also in this area. :-)

But you removed that in patch 8?
