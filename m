Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab2GTNeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 09:34:13 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:33771 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab2GTNeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 09:34:12 -0400
Message-ID: <50095E46.5070207@linux.vnet.ibm.com>
Date: Fri, 20 Jul 2012 21:33:58 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/9] KVM: MMU: fask check write-protect for direct mmu
References: <50056DB8.7080702@linux.vnet.ibm.com> <50056E59.4090003@linux.vnet.ibm.com> <20120720003917.GA8951@amt.cnet> <5008C3B4.1070006@linux.vnet.ibm.com> <20120720110908.GB16859@amt.cnet>
In-Reply-To: <20120720110908.GB16859@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072013-4790-0000-0000-000003C65286
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 07:09 PM, Marcelo Tosatti wrote:
> On Fri, Jul 20, 2012 at 10:34:28AM +0800, Xiao Guangrong wrote:
>> On 07/20/2012 08:39 AM, Marcelo Tosatti wrote:
>>> On Tue, Jul 17, 2012 at 09:53:29PM +0800, Xiao Guangrong wrote:
>>>> If it have no indirect shadow pages we need not protect any gfn,
>>>> this is always true for direct mmu without nested
>>>>
>>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>>
>>> Xiao,
>>>
>>> What is the motivation? Numbers please.
>>>
>>
>> mmu_need_write_protect is the common path for both soft-mmu and
>> hard-mmu, checking indirect_shadow_pages can skip hash-table walking
>> for the case which is tdp is enabled without nested guest.
> 
> I mean motivation as observation that it is a bottleneck.
> 
>> I will post the Number after I do the performance test.
>>
>>> In fact, what case was the original indirect_shadow_pages conditional in
>>> kvm_mmu_pte_write optimizing again?
>>>
>>
>> They are the different paths, mmu_need_write_protect is the real
>> page fault path, and kvm_mmu_pte_write is caused by mmio emulation.
> 
> Sure. What i am asking is, what use case is the indirect_shadow_pages
> optimizing? What scenario, what workload? 
> 

Sorry, Marcelo, i do know why i completely misunderstood your mail. :(

I am not sure whether this is a bottleneck, i just got it from
code review, i will measure it to see if we can get benefit from
it. :p

> See the "When to optimize" section of
> http://en.wikipedia.org/wiki/Program_optimization.
> 
> Can't remember why indirect_shadow_pages was introduced in
> kvm_mmu_pte_write.
> 

Please refer to:
	https://lkml.org/lkml/2011/5/18/174

