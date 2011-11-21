Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab1KUIeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 03:34:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab1KUIeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 03:34:15 -0500
Message-ID: <4ECA0D00.8080708@redhat.com>
Date: Mon, 21 Nov 2011 10:34:08 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] KVM: introduce kvm_for_each_memslot macro
References: <4EC6226B.3080408@linux.vnet.ibm.com> <4EC622F8.30005@linux.vnet.ibm.com> <4EC8E2D3.1080804@redhat.com> <4EC9A136.7080004@oss.ntt.co.jp>
In-Reply-To: <4EC9A136.7080004@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2011 02:54 AM, Takuya Yoshikawa wrote:
> (2011/11/20 20:21), Avi Kivity wrote:
>> On 11/18/2011 11:18 AM, Xiao Guangrong wrote:
>>> index bb8728e..10524c0 100644
>>> --- a/include/linux/kvm_host.h
>>> +++ b/include/linux/kvm_host.h
>>> @@ -307,6 +307,10 @@ static inline struct kvm_vcpu
>>> *kvm_get_vcpu(struct kvm *kvm, int i)
>>>            (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
>>>            idx++)
>>>
>>> +#define kvm_for_each_memslot(slots, memslot, i)    \
>>> +    for (i = 0; i<  (slots)->nmemslots&&    \
>>> +          ({ memslot =&(slots)->memslots[i]; 1; }); i++)
>>> +
>>>
>>
>> Statement expression not needed, you can use the comma operator:
>>
>>    i<  (slots)->nmemslots&&  (memslot = @(slots)->memslots[i], true)
>>
>> or even
>>
>>    memslot =&(slots)->memslots[i], i<  (slots)->nmemslots
>>
>> or just kill i and make memslot the loop variable.
>>
>
> Do you have any preference for the arguments ordering?
>
> I think placing the target one, memslot in this case, first is
> conventional in
> the kernel code, except when we want to place "kvm" or something like
> that.
>
> But in kvm code, there seems to be some difference.

You mean for the macro?  Yes, making memslot the first argument is a
good idea.  Any difference in kvm code is not intentional.


-- 
error compiling committee.c: too many arguments to function

