Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab0DLLOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 07:14:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58219 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753265Ab0DLLOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 07:14:23 -0400
Message-ID: <4BC2FFF0.20303@cn.fujitsu.com>
Date: Mon, 12 Apr 2010 19:11:44 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] KVM MMU: reduce kvm_mmu_page size
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D43A.5020003@cn.fujitsu.com> <4BC2DB95.70704@redhat.com>
In-Reply-To: <4BC2DB95.70704@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 04/12/2010 11:05 AM, Xiao Guangrong wrote:
>> 'multimapped' and 'unsync' in 'struct kvm_mmu_page' are just indication
>> field, we can use flag bits instand of them
>>
>> @@ -202,9 +202,10 @@ struct kvm_mmu_page {
>>        * in this shadow page.
>>        */
>>       DECLARE_BITMAP(slot_bitmap, KVM_MEMORY_SLOTS +
>> KVM_PRIVATE_MEM_SLOTS);
>> -    int multimapped;         /* More than one parent_pte? */
>>       int root_count;          /* Currently serving as active root */
>> -    bool unsync;
>> +    #define MMU_PAGE_MULTIMAPPED 0x1        /* More than one
>> parent_pte? */
>> +    #define MMU_PAGE_UNSYNC 0x2
>> +    unsigned int flags;
>>       unsigned int unsync_children;
>>       union {
>>    
> 
> Please just use bool for multimapped.  If we grow more than 4 flags, we
> can use 'bool flag : 1;' to reduce space while retaining readability.
> 

Yeah, good idea, i'll fix it in the next version

Thanks,
Xiao
