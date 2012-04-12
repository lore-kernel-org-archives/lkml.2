Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760792Ab2DLXjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 19:39:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757900Ab2DLXjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 19:39:51 -0400
Date: Thu, 12 Apr 2012 20:08:28 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: Avi Kivity <avi@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 08/13] KVM: MMU: fask check whether page is writable
Message-ID: <20120412230828.GA20207@amt.cnet>
References: <4F742951.7080003@linux.vnet.ibm.com>
 <4F742A74.1050304@linux.vnet.ibm.com>
 <4F7879A1.2020301@redhat.com>
 <4F7DDC6C.90304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7DDC6C.90304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 01:54:52AM +0800, Xiao Guangrong wrote:
> Hi Avi,
> 
> Thanks very much for your review!
> 
> Sorry for the delay reply since i was on vacation.
> 
> On 04/01/2012 11:52 PM, Avi Kivity wrote:
> 
> > On 03/29/2012 11:25 AM, Xiao Guangrong wrote:
> >> Using PTE_LIST_WRITE_PROTECT bit in rmap store the write-protect status to
> >> avoid unnecessary shadow page walking
> >>
> >> Also if no shadow page is indirect, the page is write-free
> >>
> >>
> >> @@ -2262,6 +2291,9 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
> >>  	}
> >>  	if (need_unsync)
> >>  		kvm_unsync_pages(vcpu, gfn);
> >> +
> >> +	*rmap &= ~PTE_LIST_WRITE_PROTECT;
> >> +
> >>
> > 
> > So what are the rules for PTE_LIST_WRITE_PROTECT?  Is is a cache for the
> > mmu_need_write_protect?
> > 
> > I'd like to understand it, I guess it can be set while write protection
> > is unneeded, and cleared on the next check?
> > 
> 
> 
> Yes, it is used as a cache for mmu_need_write_protect.
> 
> When the gfn is protected by sync sp or read-only host page we set this bit,
> and it is be cleared when the sp become unsync or host page becomes writable.

Wouldnt dropping support for shadow entirely make it much simpler? 

The idea to handle RO->RW without mmu_lock is very neat, but the
complexity with shadow is horrible.


