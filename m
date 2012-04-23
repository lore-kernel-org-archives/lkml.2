Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2DWHbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 03:31:31 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:51430 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab2DWHba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 03:31:30 -0400
Message-ID: <4F95039E.9060009@linux.vnet.ibm.com>
Date: Mon, 23 Apr 2012 15:24:14 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 4/9] KVM: MMU: introduce SPTE_ALLOW_WRITE bit
References: <4F911B74.4040305@linux.vnet.ibm.com> <4F911BE7.30206@linux.vnet.ibm.com> <20120420213925.GB13817@amt.cnet> <4F9229EF.4010506@gmail.com> <20120421042208.GB2763@amt.cnet> <4F941FF7.10808@redhat.com>
In-Reply-To: <4F941FF7.10808@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12042221-5140-0000-0000-0000011F0EC7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2012 11:12 PM, Avi Kivity wrote:

> On 04/21/2012 07:22 AM, Marcelo Tosatti wrote:
>> On Sat, Apr 21, 2012 at 11:30:55AM +0800, Xiao Guangrong wrote:
>>> On 04/21/2012 05:39 AM, Marcelo Tosatti wrote:
>>>
>>>
>>>>> @@ -1177,9 +1178,8 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
>>>>>  			new_spte = *sptep & ~PT64_BASE_ADDR_MASK;
>>>>>  			new_spte |= (u64)new_pfn << PAGE_SHIFT;
>>>>>
>>>>> -			new_spte &= ~PT_WRITABLE_MASK;
>>>>> -			new_spte &= ~SPTE_HOST_WRITEABLE;
>>>>> -			new_spte &= ~shadow_accessed_mask;
>>>>> +			new_spte &= ~(PT_WRITABLE_MASK | SPTE_HOST_WRITEABLE |
>>>>> +				      shadow_accessed_mask | SPTE_ALLOW_WRITE);
>>>>
>>>> Each bit should have a distinct meaning. Here the host pte is being
>>>> write-protected, which means only the SPTE_HOST_WRITEABLE bit
>>>> should be cleared.
>>>
>>>
>>> Hmm, it is no problem if SPTE_ALLOW_WRITE is not cleared.
>>>
>>> But the meaning of SPTE_ALLOW_WRITE will become strange: we will see a
>>> spte with spte.SPTE_ALLOW_WRITE = 1 (means the spte is writable on host
>>> and guest) and spte.SPTE_HOST_WRITEABLE = 0 (means the spte is read-only
>>> on host).
>>  
>> You are combining gpte writable bit, and host pte writable bit (which
>> are separate and independent of each other) into one bit. 
>>
>> SPTE_HOST_WRITEABLE already indicates whether the host pte is writable 
>> or not.
> 
> Maybe we should rename SPTE_ALLOW_WRITE to SPTE_NOT_SHADOWED (or
> SPTE_SHADOWED with the opposite meaning).
> 
> Alternatively, SPTE_MMU_WRITEABLE (complements SPTE_HOST_WRITEABLE).
> 


I like SPTE_MMU_WRITEABLE :)

