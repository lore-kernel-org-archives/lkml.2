Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab0GAMRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 08:17:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55268 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab0GAMRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 08:17:33 -0400
Message-ID: <4C2C8674.4080607@cn.fujitsu.com>
Date: Thu, 01 Jul 2010 20:13:40 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 9/11] KVM: MMU: prefetch ptes when intercepted guest
 #PF
References: <4C2AF9FA.9020601@cn.fujitsu.com> <4C2AFB65.2030807@cn.fujitsu.com> <20100630204324.GA5366@amt.cnet> <4C2BEB48.3080705@cn.fujitsu.com> <4C2C85E6.1050303@redhat.com>
In-Reply-To: <4C2C85E6.1050303@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 07/01/2010 04:11 AM, Xiao Guangrong wrote:
>>
>> Marcelo Tosatti wrote:
>>
>>   
>>>> +
>>>> +        addr = gfn_to_hva_many(vcpu->kvm, gfn,&entry);
>>>> +        if (kvm_is_error_hva(addr))
>>>> +            return -1;
>>>> +
>>>> +        entry = min(entry, (int)(end - start));
>>>> +        ret = __get_user_pages_fast(addr, entry, 1, pages);
>>>> +        if (ret<= 0)
>>>> +            return -1;
>>>>        
>>> Why can't you use gfn_to_pfn_atomic() here, one page at a time? Is
>>> the overhead significant that this is worthwhile?
>>>
>>> You're bypassing the centralized interface.
>>>      
>> I think it's worthwhile to do since we can reduce gup overhead, no reason
>> to traverse process's page table again and again for the consecutive
>> pages.
>>    
> 
> Then we should make the centralized interface work in terms of multiple
> pages, and write the single-page interfaces in terms of the multipage
> interfaces.
> 

Umm, i'll import a new function named gfn_to_pfn_many_atomic(... int *enough),
using 'enough' to indicate whether have got the all consecutive pages in the slot,
Marcelo, how about it? :-)
