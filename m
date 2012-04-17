Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab2DQHlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 03:41:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab2DQHlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 03:41:46 -0400
Message-ID: <4F8D1EB5.2000302@redhat.com>
Date: Tue, 17 Apr 2012 10:41:41 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 10/16] KVM: MMU: fask check whether page is writable
References: <4F87FA69.5060106@linux.vnet.ibm.com> <4F87FC82.2050302@linux.vnet.ibm.com> <4F8AE64F.7080909@redhat.com> <4F8B9115.2030807@linux.vnet.ibm.com> <4F8BEE1B.8000704@redhat.com> <4F8BF265.7020405@linux.vnet.ibm.com> <4F8C06ED.6020805@redhat.com> <4F8CE9CF.6050506@linux.vnet.ibm.com>
In-Reply-To: <4F8CE9CF.6050506@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 06:55 AM, Xiao Guangrong wrote:
> On 04/16/2012 07:47 PM, Avi Kivity wrote:
>
> > On 04/16/2012 01:20 PM, Xiao Guangrong wrote:
> >>>>
> >>>> It is used to avoid the unnecessary overload 
> >>>
> >>> It's overloading me :(
> >>>
> >>
> >>
> >> Sorry.
> >>
> > 
> > The trick is to send those in separate patchset so the maintainer
> > doesn't notice.
> > 
>
>
> Thanks for your suggestion, i will pay more attention on it in the
> further.
>
> For this patch, what did you mean of "those"? You mean the whole
> rmap.PTE_LIST_WP_BIT (fast check for shadow page table write protection
> and host write protection) or just about host_page_write_protect
> (for KSM only)?

All of it.  Let's start with just modifying sptes concurrently and only
later add reading bits from rmap concurrently, if it proves necessary.

>
> If we do not have rmap.PTE_LIST_WP_BIT, there may have regression on
> shadow mmu.
>
> Hmm, do i need implement rmap.PTE_LIST_WP_BIT, then fast page fault?

Let's try to measure the effect without rmap.PTE_LIST_WP_BIT.  Usually
PTE chains for page tables are short so the effect would be small.  Of
course we can't tell about all guest.

-- 
error compiling committee.c: too many arguments to function

