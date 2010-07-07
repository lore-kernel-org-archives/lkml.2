Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab0GGNxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:53:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755794Ab0GGNw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:52:58 -0400
Date: Wed, 7 Jul 2010 10:40:10 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 8/9] KVM: MMU: combine guest pte read between fetch
 and pte prefetch
Message-ID: <20100707134010.GA4566@amt.cnet>
References: <4C330918.6040709@cn.fujitsu.com>
 <4C330A9A.9030106@cn.fujitsu.com>
 <20100706195254.GA4311@amt.cnet>
 <4C33D703.4090208@cn.fujitsu.com>
 <20100707130705.GA4293@amt.cnet>
 <4C347D1C.9000100@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C347D1C.9000100@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 09:11:56PM +0800, Xiao Guangrong wrote:
> 
> 
> Marcelo Tosatti wrote:
> 
> >>
> >> Below codes read gptes in the prefetch path:
> >>
> >> 	index = sptep - sp->spt;
> >> 	i = index & ~(PTE_PREFETCH_NUM - 1);
> >> 	max = index | (PTE_PREFETCH_NUM - 1);
> >>
> >> 	if (PTTYPE == 32)
> >> 		offset = sp->role.quadrant << PT64_LEVEL_BITS;
> >>
> >> 	first_pte_gpa = gfn_to_gpa(sp->gfn) +
> >> 				(offset + i) * sizeof(pt_element_t);
> >>
> >> 	if (kvm_read_guest_atomic(vcpu->kvm, first_pte_gpa, gptep,
> >> 					sizeof(gptep)) < 0)
> >> 		return;
> >>
> >> It reads the 16 aligned items around sptep's corresponding gpte and this gpte
> >> is also in this area. :-)
> > 
> > But you removed that in patch 8?
> > 
> 
> Oh, i just want it good for review, you mean it's better let patch 7 and 8 in one patch?

I mean patch 7 is wrong because it removes rereading of gpte, with
mmu_lock held, in the prefetch patch.
