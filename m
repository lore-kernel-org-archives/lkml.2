Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab2DUEpU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 00:45:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab2DUEpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 00:45:19 -0400
Date: Sat, 21 Apr 2012 01:22:08 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 4/9] KVM: MMU: introduce SPTE_ALLOW_WRITE bit
Message-ID: <20120421042208.GB2763@amt.cnet>
References: <4F911B74.4040305@linux.vnet.ibm.com>
 <4F911BE7.30206@linux.vnet.ibm.com>
 <20120420213925.GB13817@amt.cnet>
 <4F9229EF.4010506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9229EF.4010506@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 11:30:55AM +0800, Xiao Guangrong wrote:
> On 04/21/2012 05:39 AM, Marcelo Tosatti wrote:
> 
> 
> >> @@ -1177,9 +1178,8 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
> >>  			new_spte = *sptep & ~PT64_BASE_ADDR_MASK;
> >>  			new_spte |= (u64)new_pfn << PAGE_SHIFT;
> >>
> >> -			new_spte &= ~PT_WRITABLE_MASK;
> >> -			new_spte &= ~SPTE_HOST_WRITEABLE;
> >> -			new_spte &= ~shadow_accessed_mask;
> >> +			new_spte &= ~(PT_WRITABLE_MASK | SPTE_HOST_WRITEABLE |
> >> +				      shadow_accessed_mask | SPTE_ALLOW_WRITE);
> > 
> > Each bit should have a distinct meaning. Here the host pte is being
> > write-protected, which means only the SPTE_HOST_WRITEABLE bit
> > should be cleared.
> 
> 
> Hmm, it is no problem if SPTE_ALLOW_WRITE is not cleared.
> 
> But the meaning of SPTE_ALLOW_WRITE will become strange: we will see a
> spte with spte.SPTE_ALLOW_WRITE = 1 (means the spte is writable on host
> and guest) and spte.SPTE_HOST_WRITEABLE = 0 (means the spte is read-only
> on host).
 
You are combining gpte writable bit, and host pte writable bit (which
are separate and independent of each other) into one bit. 

SPTE_HOST_WRITEABLE already indicates whether the host pte is writable 
or not.

