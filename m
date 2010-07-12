Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab0GLM2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 08:28:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab0GLM2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 08:28:11 -0400
Message-ID: <4C3B0A58.5050009@redhat.com>
Date: Mon, 12 Jul 2010 15:28:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 5/9] KVM: MMU: introduce gfn_to_page_many_atomic()
 function
References: <4C330918.6040709@cn.fujitsu.com> <4C330A00.50108@cn.fujitsu.com> <4C39C030.6080009@redhat.com> <4C3A8435.4050805@cn.fujitsu.com>
In-Reply-To: <4C3A8435.4050805@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 05:55 AM, Xiao Guangrong wrote:
>
>>> @@ -1011,6 +1021,23 @@ pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
>>>        return hva_to_pfn(kvm, addr, false);
>>>    }
>>>
>>> +int gfn_to_page_many_atomic(struct kvm *kvm, gfn_t gfn,
>>> +                struct page **pages, int nr_pages, bool *enough)
>>> +{
>>> +    unsigned long addr;
>>> +    int entry, ret;
>>> +
>>> +    addr = gfn_to_hva_many(kvm, gfn,&entry);
>>> +    if (kvm_is_error_hva(addr))
>>> +        return -1;
>>> +
>>> +    entry = min(entry, nr_pages);
>>> +    *enough = (entry == nr_pages) ? true : false;
>>>
>>>        
>
>> Why not return 0 if !enough?
>>
>>      
> I think it's better that handle the reset pages in the slot, for example,
> we expect 16 pages are consecutive, but only 12 pages in the slot, the better
> way is handle the reset 12 pages not throw those away.

It will almost never happen, let's remove edge cases.




-- 
error compiling committee.c: too many arguments to function

