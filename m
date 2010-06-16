Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab0FPLIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 07:08:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111Ab0FPLIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 07:08:32 -0400
Message-ID: <4C18B0A6.4000208@redhat.com>
Date: Wed, 16 Jun 2010 14:08:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: huang ying <huang.ying.caritas@gmail.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH 3/6] KVM: MMU: introduce gfn_to_page_atomic() and 	gfn_to_pfn_atomic()
References: <4C16E6ED.7020009@cn.fujitsu.com>	<4C16E75F.6020003@cn.fujitsu.com>	<4C16E7AD.1060101@cn.fujitsu.com>	<4C16E999.6050004@cn.fujitsu.com>	<4C17625E.3020308@redhat.com> <AANLkTikZfElLWJvRX2S97FBN2ZVptxg9kYZ7utjHstC6@mail.gmail.com>
In-Reply-To: <AANLkTikZfElLWJvRX2S97FBN2ZVptxg9kYZ7utjHstC6@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 01:51 PM, huang ying wrote:
> On Tue, Jun 15, 2010 at 7:22 PM, Avi Kivity<avi@redhat.com>  wrote:
>    
>> btw, is_hwpoison_address() is racy.  While it looks up the address, some
>> other task can unmap the page tables under us.
>>
>> Andi/Huang?
>>
>> One way of fixing it is get_user_pages_ptes_fast(), which also returns the
>> pte, also atomically.  I want it for other reasons as well (respond to a
>> read fault by gupping the page for read, but allowing write access if the
>> pte indicates it is writeable).
>>      
> Yes. is_hwpoison_address() is racy. But I think it is not absolutely
> necessary to call is_hwpoison_address() in hva_to_pfn_atomic(), is it?
>    

We can probably ignore it, yes.

> For is_hwpoison_address() in hva_to_pfn(), we can protect it with mmap_sem.
>    

Not very appealing, but should work.

-- 
error compiling committee.c: too many arguments to function

