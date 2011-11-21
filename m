Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab1KUDdv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 22:33:51 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:33573 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab1KUDdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 22:33:49 -0500
Message-ID: <4EC9C695.3060907@linux.vnet.ibm.com>
Date: Mon, 21 Nov 2011 11:33:41 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] KVM: introduce kvm_for_each_memslot macro
References: <4EC6226B.3080408@linux.vnet.ibm.com> <4EC622F8.30005@linux.vnet.ibm.com> <4EC8E2D3.1080804@redhat.com>
In-Reply-To: <4EC8E2D3.1080804@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11112017-0260-0000-0000-000000135A27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2011 07:21 PM, Avi Kivity wrote:

> On 11/18/2011 11:18 AM, Xiao Guangrong wrote:
>> index bb8728e..10524c0 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -307,6 +307,10 @@ static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
>>  	     (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
>>  	     idx++)
>>
>> +#define kvm_for_each_memslot(slots, memslot, i)	\
>> +	for (i = 0; i < (slots)->nmemslots &&	\
>> +	      ({ memslot = &(slots)->memslots[i]; 1; }); i++)
>> +
>>
> 
> Statement expression not needed, you can use the comma operator:
> 
>   i < (slots)->nmemslots && (memslot = @(slots)->memslots[i], true)
> 
> or even
> 
>   memslot = &(slots)->memslots[i], i < (slots)->nmemslots
> 
> or just kill i and make memslot the loop variable.
> 


Good, will fix it in the next version, thanks!

