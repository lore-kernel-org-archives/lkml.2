Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab0GAMLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 08:11:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab0GAMLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 08:11:22 -0400
Message-ID: <4C2C85E6.1050303@redhat.com>
Date: Thu, 01 Jul 2010 15:11:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 9/11] KVM: MMU: prefetch ptes when intercepted guest
 #PF
References: <4C2AF9FA.9020601@cn.fujitsu.com> <4C2AFB65.2030807@cn.fujitsu.com> <20100630204324.GA5366@amt.cnet> <4C2BEB48.3080705@cn.fujitsu.com>
In-Reply-To: <4C2BEB48.3080705@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2010 04:11 AM, Xiao Guangrong wrote:
>
> Marcelo Tosatti wrote:
>
>    
>>> +
>>> +		addr = gfn_to_hva_many(vcpu->kvm, gfn,&entry);
>>> +		if (kvm_is_error_hva(addr))
>>> +			return -1;
>>> +
>>> +		entry = min(entry, (int)(end - start));
>>> +		ret = __get_user_pages_fast(addr, entry, 1, pages);
>>> +		if (ret<= 0)
>>> +			return -1;
>>>        
>> Why can't you use gfn_to_pfn_atomic() here, one page at a time? Is
>> the overhead significant that this is worthwhile?
>>
>> You're bypassing the centralized interface.
>>      
> I think it's worthwhile to do since we can reduce gup overhead, no reason
> to traverse process's page table again and again for the consecutive pages.
>    

Then we should make the centralized interface work in terms of multiple 
pages, and write the single-page interfaces in terms of the multipage 
interfaces.

-- 
error compiling committee.c: too many arguments to function

