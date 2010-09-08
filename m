Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab0IHHRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 03:17:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757729Ab0IHHRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 03:17:10 -0400
Message-ID: <4C87386B.2030109@redhat.com>
Date: Wed, 08 Sep 2010 10:16:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, Alexander Graf <agraf@suse.de>,
        joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/27] KVM: MMU: Refactor mmu_alloc_roots function
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com> <1283788566-29186-23-git-send-email-joerg.roedel@amd.com> <20100907203952.GA14489@amt.cnet>
In-Reply-To: <20100907203952.GA14489@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/07/2010 11:39 PM, Marcelo Tosatti wrote:
>
>> @@ -2406,16 +2441,11 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
>>   			root_gfn = pdptr>>  PAGE_SHIFT;
>>   			if (mmu_check_root(vcpu, root_gfn))
>>   				return 1;
>> -		} else if (vcpu->arch.mmu.root_level == 0)
>> -			root_gfn = 0;
>> -		if (vcpu->arch.mmu.direct_map) {
>> -			direct = 1;
>> -			root_gfn = i<<  30;
>>   		}
>>   		spin_lock(&vcpu->kvm->mmu_lock);
>>   		kvm_mmu_free_some_pages(vcpu);
>>   		sp = kvm_mmu_get_page(vcpu, root_gfn, i<<  30,
>> -				      PT32_ROOT_LEVEL, direct,
>> +				      PT32_ROOT_LEVEL, 0,
>>   				      ACC_ALL, NULL);
> Should not write protect the gfn for nonpaging mode.
>

nonpaging mode should have direct_map set, so wouldn't enter this path 
at all.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

