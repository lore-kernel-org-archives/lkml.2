Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1L1K2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 05:28:15 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:57933 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab1L1K2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 05:28:11 -0500
Message-ID: <4EFAEF89.8050306@oss.ntt.co.jp>
Date: Wed, 28 Dec 2011 19:29:29 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.25) Gecko/20111213 Thunderbird/3.1.17
MIME-Version: 1.0
To: Liu ping fan <kernelfans@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        aliguori@us.ibm.com, gleb@redhat.com, mtosatti@redhat.com,
        xiaoguangrong.eric@gmail.com, jan.kiszka@web.de,
        Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Subject: Re: [PATCH v6] kvm: make vcpu life cycle separated from kvm instance
References: <1324091975-20930-1-git-send-email-kernelfans@gmail.com>	<1324975139-8836-1-git-send-email-kernelfans@gmail.com>	<4EF9AA59.7050003@oss.ntt.co.jp> <CAFgQCTu+qO=_Pc3Nps5N+esB0a9xYu83nRUT4Q6JepM6pAZYAA@mail.gmail.com>
In-Reply-To: <CAFgQCTu+qO=_Pc3Nps5N+esB0a9xYu83nRUT4Q6JepM6pAZYAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/12/28 15:54), Liu ping fan wrote:

>> You are introducing kvm_arch_vcpu_zap().
>>
>> Then, apart from the "zap" naming issue I mentioned last time,
> Yes, I will correct "zap", as you said, its meaning is quite different
> from destroy. :-)
>
>> what about other architectures than x86?
>>
> Have not considered it in detail yet. At first step, I just want to
> figure out the whole frame, then, I will push them on other arch.
> Maybe you foresee some problem when extending this onto other arch,
> please tell me, thanks ：-).

I do not mind if those are supported or not now.

But if not, you should write what is currently supported and what should
be done in the future.

Of course, you should at least make sure that other architectures will
not be broken by your patch.

>>
>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>> index 900c763..b88d418d 100644
>>> --- a/include/linux/kvm_host.h
>>> +++ b/include/linux/kvm_host.h
>>> @@ -117,6 +117,7 @@ enum {
>>>
>>>    struct kvm_vcpu {
>>>        struct kvm *kvm;
>>> +     struct list_head list;
>>>    #ifdef CONFIG_PREEMPT_NOTIFIERS
>>>        struct preempt_notifier preempt_notifier;
>>>    #endif
>>> @@ -251,12 +252,14 @@ struct kvm {
>>>        struct mm_struct *mm; /* userspace tied to this vm */
>>>        struct kvm_memslots *memslots;
>>>        struct srcu_struct srcu;
>>> +     struct srcu_struct srcu_vcpus;
>>> +
>>
>> Another srcu.  This alone is worth explaining in the changelog IMO.
>>
> Sorry, but why? I think it is just a srcu, and because it has
> different aim and want a independent grace period, so not multiplex
> kvm->srcu.

I cannot say what MUST be explained in the changelog.
But many well known maintainers are telling the importance of changelog.

It is up to you, and KVM maintainers.

	Takuya
