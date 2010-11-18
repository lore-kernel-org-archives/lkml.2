Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab0KRQQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:16:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759487Ab0KRQP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:15:59 -0500
Date: Thu, 18 Nov 2010 13:43:49 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/6] KVM: MMU: remove 'clear_unsync' parameter
Message-ID: <20101118154349.GF14327@amt.cnet>
References: <4CE355A0.6020907@cn.fujitsu.com>
 <4CE3565D.4080004@cn.fujitsu.com>
 <20101117164903.GE18959@amt.cnet>
 <4CE4D8C9.90302@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE4D8C9.90302@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 03:42:01PM +0800, Xiao Guangrong wrote:
> On 11/18/2010 12:49 AM, Marcelo Tosatti wrote:
> 			    bool clear_unsync)
> >> +static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
> >>  {
> >>  	int i, offset, nr_present;
> >>  	bool host_writable;
> >> @@ -781,7 +780,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> >>  			u64 nonpresent;
> >>  
> >>  			if (rsvd_bits_set || is_present_gpte(gpte) ||
> >> -			      !clear_unsync)
> >> +			      sp->unsync)
> >>  				nonpresent = shadow_trap_nonpresent_pte;
> >>  			else
> >>  				nonpresent = shadow_notrap_nonpresent_pte;
> > 
> > Its better to keep this explicit as a parameter. 
> > 
> 
> But after patch 6 (KVM: MMU: cleanup update_pte, pte_prefetch and sync_page functions),
> this parameter is not used anymore... i don't have strong opinion on it :-)

On a second thought, using sp->unsync is fine.
