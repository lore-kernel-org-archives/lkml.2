Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab0GAM16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 08:27:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab0GAM15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 08:27:57 -0400
Date: Thu, 1 Jul 2010 09:26:51 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 9/11] KVM: MMU: prefetch ptes when intercepted guest
 #PF
Message-ID: <20100701122651.GD18607@amt.cnet>
References: <4C2AF9FA.9020601@cn.fujitsu.com>
 <4C2AFB65.2030807@cn.fujitsu.com>
 <20100630204324.GA5366@amt.cnet>
 <4C2BEB48.3080705@cn.fujitsu.com>
 <4C2C85E6.1050303@redhat.com>
 <4C2C8674.4080607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2C8674.4080607@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 08:13:40PM +0800, Xiao Guangrong wrote:
> 
> 
> Avi Kivity wrote:
> > On 07/01/2010 04:11 AM, Xiao Guangrong wrote:
> >>
> >> Marcelo Tosatti wrote:
> >>
> >>   
> >>>> +
> >>>> +        addr = gfn_to_hva_many(vcpu->kvm, gfn,&entry);
> >>>> +        if (kvm_is_error_hva(addr))
> >>>> +            return -1;
> >>>> +
> >>>> +        entry = min(entry, (int)(end - start));
> >>>> +        ret = __get_user_pages_fast(addr, entry, 1, pages);
> >>>> +        if (ret<= 0)
> >>>> +            return -1;
> >>>>        
> >>> Why can't you use gfn_to_pfn_atomic() here, one page at a time? Is
> >>> the overhead significant that this is worthwhile?
> >>>
> >>> You're bypassing the centralized interface.
> >>>      
> >> I think it's worthwhile to do since we can reduce gup overhead, no reason
> >> to traverse process's page table again and again for the consecutive
> >> pages.
> >>    
> > 
> > Then we should make the centralized interface work in terms of multiple
> > pages, and write the single-page interfaces in terms of the multipage
> > interfaces.
> > 
> 
> Umm, i'll import a new function named gfn_to_pfn_many_atomic(... int *enough),
> using 'enough' to indicate whether have got the all consecutive pages in the slot,
> Marcelo, how about it? :-)

Fine.
