Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab0DZDQs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 23:16:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54243 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab0DZDQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 23:16:47 -0400
Message-ID: <4BD504E4.9080309@cn.fujitsu.com>
Date: Mon, 26 Apr 2010 11:13:40 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 9/10] KVM MMU: separate invlpg code form kvm_mmu_pte_write()
References: <4BD3E306.4020202@cn.fujitsu.com> <4BD3E8EB.1010006@cn.fujitsu.com> <4BD411F6.6030800@redhat.com>
In-Reply-To: <4BD411F6.6030800@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 04/25/2010 10:02 AM, Xiao Guangrong wrote:
>> Let invlpg not depends on kvm_mmu_pte_write path, later patch will need
>> this feature
>>
>>
>>       if (mmu_topup_memory_caches(vcpu))
>>           return;
>> -    kvm_mmu_pte_write(vcpu, pte_gpa, NULL, sizeof(pt_element_t), 0);
>> +
>> +    kvm_read_guest_page(vcpu->kvm, gfn,&gentry, offset,
>> +                sizeof(pt_element_t));
>> +
>>    
> 
> Need error check.
> 
>> +    mmu_guess_page_from_pte_write(vcpu, gfn_to_gpa(gfn) + offset,
>> gentry);
>>    
> 
> This needs an undo operation to drop the page if we don't update_pte();
> see the end of kvm_mmu_pte_write().  That needs to go into a helper to
> avoid duplication.
> 

Ah, i forgot those, will fix in v3, thanks for you point out.
