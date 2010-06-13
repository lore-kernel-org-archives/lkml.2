Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab0FMIJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 04:09:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab0FMIJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 04:09:19 -0400
Message-ID: <4C149229.5080300@redhat.com>
Date: Sun, 13 Jun 2010 11:09:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, kvm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] kvm, ept: remove the default write bit
References: <4C121E6A.9000009@cn.fujitsu.com> <20100611195052.GC12317@amt.cnet>
In-Reply-To: <20100611195052.GC12317@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2010 10:50 PM, Marcelo Tosatti wrote:
> On Fri, Jun 11, 2010 at 07:30:50PM +0800, Lai Jiangshan wrote:
>    
>> When ept enabled, current code set shadow_base_present_pte
>> including the write bit, thus all pte entries have
>> writabe bit, and it means guest os can always
>> write to any mapped page (even VMM maps RO pages for
>> the guest.)
>>
>> We always use get_user_pages(write=1), so this bad code does not
>> cause any bad result currently.
>>
>> But it is really bad, so fix it, and we will use RO pages future.
>>
>> We will set writabe bit when it is really writable (determined by
>> the parameters of the set_spte())
>>
>> Signed-off-by: Lai Jiangshan<laijs@cn.fujitsu.com>
>> ---
>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>> index fdb18cf..c7565ea 100644
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -4365,8 +4365,7 @@ static int __init vmx_init(void)
>>
>>   	if (enable_ept) {
>>   		bypass_guest_pf = 0;
>> -		kvm_mmu_set_base_ptes(VMX_EPT_READABLE_MASK |
>> -			VMX_EPT_WRITABLE_MASK);
>> +		kvm_mmu_set_base_ptes(VMX_EPT_READABLE_MASK);
>>   		kvm_mmu_set_mask_ptes(0ull, 0ull, 0ull, 0ull,
>>   				VMX_EPT_EXECUTABLE_MASK);
>>   		kvm_enable_tdp();
>>      
> You can remove the call to kvm_mmu_set_base_ptes entirely, because
> VMX_EPT_READABLE_MASK == PT_PRESENT_MASK.
>    

We can leave that to a later patch which removes kvm_mmu_set_base_ptes() 
entirely.

-- 
error compiling committee.c: too many arguments to function

