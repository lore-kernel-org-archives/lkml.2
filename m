Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab2DVPND (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 11:13:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab2DVPNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 11:13:00 -0400
Message-ID: <4F941FF7.10808@redhat.com>
Date: Sun, 22 Apr 2012 18:12:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 4/9] KVM: MMU: introduce SPTE_ALLOW_WRITE bit
References: <4F911B74.4040305@linux.vnet.ibm.com> <4F911BE7.30206@linux.vnet.ibm.com> <20120420213925.GB13817@amt.cnet> <4F9229EF.4010506@gmail.com> <20120421042208.GB2763@amt.cnet>
In-Reply-To: <20120421042208.GB2763@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2012 07:22 AM, Marcelo Tosatti wrote:
> On Sat, Apr 21, 2012 at 11:30:55AM +0800, Xiao Guangrong wrote:
> > On 04/21/2012 05:39 AM, Marcelo Tosatti wrote:
> > 
> > 
> > >> @@ -1177,9 +1178,8 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
> > >>  			new_spte = *sptep & ~PT64_BASE_ADDR_MASK;
> > >>  			new_spte |= (u64)new_pfn << PAGE_SHIFT;
> > >>
> > >> -			new_spte &= ~PT_WRITABLE_MASK;
> > >> -			new_spte &= ~SPTE_HOST_WRITEABLE;
> > >> -			new_spte &= ~shadow_accessed_mask;
> > >> +			new_spte &= ~(PT_WRITABLE_MASK | SPTE_HOST_WRITEABLE |
> > >> +				      shadow_accessed_mask | SPTE_ALLOW_WRITE);
> > > 
> > > Each bit should have a distinct meaning. Here the host pte is being
> > > write-protected, which means only the SPTE_HOST_WRITEABLE bit
> > > should be cleared.
> > 
> > 
> > Hmm, it is no problem if SPTE_ALLOW_WRITE is not cleared.
> > 
> > But the meaning of SPTE_ALLOW_WRITE will become strange: we will see a
> > spte with spte.SPTE_ALLOW_WRITE = 1 (means the spte is writable on host
> > and guest) and spte.SPTE_HOST_WRITEABLE = 0 (means the spte is read-only
> > on host).
>  
> You are combining gpte writable bit, and host pte writable bit (which
> are separate and independent of each other) into one bit. 
>
> SPTE_HOST_WRITEABLE already indicates whether the host pte is writable 
> or not.

Maybe we should rename SPTE_ALLOW_WRITE to SPTE_NOT_SHADOWED (or
SPTE_SHADOWED with the opposite meaning).

Alternatively, SPTE_MMU_WRITEABLE (complements SPTE_HOST_WRITEABLE).

-- 
error compiling committee.c: too many arguments to function

