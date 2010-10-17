Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab0JQKpB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 06:45:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932340Ab0JQKo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 06:44:59 -0400
Message-ID: <4CBAD36B.4020507@redhat.com>
Date: Sun, 17 Oct 2010 12:43:55 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v7 03/12] Retry fault before vmentry
References: <1287048176-2563-1-git-send-email-gleb@redhat.com> <1287048176-2563-4-git-send-email-gleb@redhat.com> <4CBAD111.3070406@redhat.com>
In-Reply-To: <4CBAD111.3070406@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/17/2010 12:33 PM, Avi Kivity wrote:
>  On 10/14/2010 11:22 AM, Gleb Natapov wrote:
>> When page is swapped in it is mapped into guest memory only after guest
>> tries to access it again and generate another fault. To save this fault
>> we can map it immediately since we know that guest is going to access
>> the page. Do it only when tdp is enabled for now. Shadow paging case is
>> more complicated. CR[034] and EFER registers should be switched before
>> doing mapping and then switched back.
>>
>> +void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct 
>> kvm_async_pf *work)
>> +{
>> +    if (!vcpu->arch.mmu.direct_map || is_error_page(work->page))
>> +        return;
>> +    vcpu->arch.mmu.page_fault(vcpu, work->gva, 0, true);
>> +}
>
> Missing mmu_topup_memory_caches().
>

Actually not.  tdp_page_fault() has its own topup.


-- 
error compiling committee.c: too many arguments to function

