Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab2E1NYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 09:24:12 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:42005 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab2E1NYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 09:24:10 -0400
Message-ID: <4FC363EE.6060204@linux.vnet.ibm.com>
Date: Mon, 28 May 2012 19:39:26 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: MMU: fix huge page adapted on non-PAE host
References: <4FC316E3.6080607@linux.vnet.ibm.com> <4FC35A15.6080000@redhat.com>
In-Reply-To: <4FC35A15.6080000@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052813-9574-0000-0000-000002F44D3A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 06:57 PM, Avi Kivity wrote:

> On 05/28/2012 09:10 AM, Xiao Guangrong wrote:
>> The huge page size is 4M on non-PAE host, but 2M page size is used in
>> transparent_hugepage_adjust(), so the page we get after adjust the
>> mapping level is not the head page, the BUG_ON() will be triggered
>>
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 72102e0..be3cea4 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -2595,8 +2595,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
>>  			*gfnp = gfn;
>>  			kvm_release_pfn_clean(pfn);
>>  			pfn &= ~mask;
>> -			if (!get_page_unless_zero(pfn_to_page(pfn)))
>> -				BUG();
>> +			kvm_get_pfn(pfn);
>>  			*pfnp = pfn;
>>  		}
>>  	}
> 
> Shouldn't we adjust mask instead?
> 


Adjusting mask to map the whole 4M huge page to KVM guest?
But it seams 4M page size is not supported on VMX/SVM.

