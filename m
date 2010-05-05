Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934664Ab0EEMie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:38:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64048 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934492Ab0EEMic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:38:32 -0400
Message-ID: <4BE16609.1030705@cn.fujitsu.com>
Date: Wed, 05 May 2010 20:35:21 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM MMU: fix for forgot mark parent->unsync_children
 bit
References: <4BE16265.7060004@cn.fujitsu.com> <4BE164D9.2030301@redhat.com>
In-Reply-To: <4BE164D9.2030301@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 05/05/2010 03:19 PM, Xiao Guangrong wrote:
>> When mapping a new parent to unsync shadow page, we should mark
>> parent's unsync_children bit
>>
>> Reported-by: Marcelo Tosatti<mtosatti@redhat.com>
>> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
>> ---
>>   arch/x86/kvm/mmu.c |    4 +++-
>>   1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 97f2ea0..bf35a2f 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -1374,7 +1374,9 @@ static struct kvm_mmu_page
>> *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>>               if (sp->unsync_children) {
>>                   set_bit(KVM_REQ_MMU_SYNC,&vcpu->requests);
>>                   kvm_mmu_mark_parents_unsync(sp);
>> -            }
>> +            } else if (sp->unsync)
>> +                kvm_mmu_mark_parents_unsync(sp);
>> +
>>               trace_kvm_mmu_get_page(sp, false);
>>               return sp;
>>           }
>>    
> 
> 
> Which patch does this fix?  If it wasn't merge yet, please repost with
> the fix included.

Oh, OK, i'll sent the previous pathset that are reverted by Marcelo.

Thanks,
Xiao
