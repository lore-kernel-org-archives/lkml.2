Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047Ab0FFQEb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 12:04:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080Ab0FFQEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 12:04:30 -0400
Message-ID: <4C0BC709.5040307@redhat.com>
Date: Sun, 06 Jun 2010 19:04:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: rework remove-write-access for a slot
References: <4C061C16.9040208@cn.fujitsu.com> <4C063E01.7040206@redhat.com> <4C08B5D0.6090104@cn.fujitsu.com>
In-Reply-To: <4C08B5D0.6090104@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2010 11:14 AM, Lai Jiangshan wrote:
>
>
>> - I thought of a different approach to write protection: write protect
>> the L4 sptes, on write fault add write permission to the L4 spte and
>> write protect the L3 sptes that it points to, etc.  This method can use
>> the slot bitmap to reduce the number of write faults.  However we can
>> reintroduce the slot bitmap if/when we use the method, this shouldn't
>> block the patch.
>>      
> It is very a good approach and it is blazing fast.
>
> I have no time to implement it currently,
> could you update it into the TODO list?
>    

Done.

>>> +static void rmapp_remove_write_access(struct kvm *kvm, unsigned long
>>> *rmapp)
>>> +{
>>> +    u64 *spte = rmap_next(kvm, rmapp, NULL);
>>> +
>>> +    while (spte) {
>>> +        /* avoid RMW */
>>> +        if (is_writable_pte(*spte))
>>> +            *spte&= ~PT_WRITABLE_MASK;
>>>        
>> Must use an atomic operation here to avoid losing dirty or accessed bit.
>>
>>      
> Atomic operation is too expensive, I retained the comment "/* avoid RMW */"
> and wait someone take a good approach for it.
>    

You are right, it is an existing problem.  I just posted a patchset 
which fixes the problem, when it's merged please rebase on top.

-- 
error compiling committee.c: too many arguments to function

