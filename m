Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab1KRKDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:03:18 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:44727 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab1KRKDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:03:17 -0500
Message-ID: <4EC62D58.103@linux.vnet.ibm.com>
Date: Fri, 18 Nov 2011 18:03:04 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 6/6] KVM: introduce a table to map slot id to index
 in memslots arry
References: <4EC6226B.3080408@linux.vnet.ibm.com> <4EC6235A.90705@linux.vnet.ibm.com> <1321609536.8010.30.camel@lappy>
In-Reply-To: <1321609536.8010.30.camel@lappy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11111723-6102-0000-0000-0000003200EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 05:45 PM, Sasha Levin wrote:


>>  struct kvm {
>> @@ -340,14 +342,13 @@ static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
>>  static inline struct kvm_memory_slot *
>>  id_to_memslot(struct kvm_memslots *slots, int id)
>>  {
>> -	int i;
>> +	int index = slots->id_to_index[id];
>> +	struct kvm_memory_slot *slot;
>>
>> -	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
>> -		if (slots->memslots[i].id == id)
>> -			return &slots->memslots[i];
>> +	slot = &slots->memslots[index];
>>
>> -	WARN_ON(1);
>> -	return NULL;
>> +	WARN_ON(slot->id != id);
>> +	return slot;
>>  }
> 
> If we didn't find the right memslot we shouldn't be returning a wrong
> one, we should be failing.
> 


Um, in the current code, the "id" has already been checked by the caller,
that means "id" should be < KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS, so,
if we can not find the memslot for this slot, it must be a bug.

