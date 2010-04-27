Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab0D0Nhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:37:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab0D0Nhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:37:45 -0400
Message-ID: <4BD6E8A6.5040008@redhat.com>
Date: Tue, 27 Apr 2010 16:37:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/22] KVM: MMU: Track page fault data in struct vcpu
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com> <1272364712-17425-17-git-send-email-joerg.roedel@amd.com> <4BD6DF7C.1090203@redhat.com> <20100427132801.GI11097@amd.com>
In-Reply-To: <20100427132801.GI11097@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 04:28 PM, Joerg Roedel wrote:
>
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index d9dfc8c..8426870 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -298,6 +298,9 @@ struct kvm_vcpu_arch {
>>>   	/* Used for two dimensional paging emulation */
>>>   	struct kvm_mmu nested_mmu;
>>>
>>> +	unsigned long fault_address;
>>>        
>> Probably a problem on i386.  How does npt handle faults when the
>> guest is using pae paging and the host (in our case the guest...)
>> isn't?  I see it uses exit_info_2 for the address, which is a u64.
>>      
> This shouldn't be an issue. If we run on 32bit host with nested paging
> the guest can't have more than 4gb of addressable memory because of the
> page table limitations (nested page table is always in host format).
>    

But the nested guest can use pae paging and generate a #NPF with 
exit_info_2 > 4GB.  So we need to keep the full fault address; if we 
truncate, the guest might actually resolve the fault and let the nested 
guest continue.

-- 
error compiling committee.c: too many arguments to function

