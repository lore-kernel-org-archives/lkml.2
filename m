Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0HXJFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:05:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab0HXJF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:05:28 -0400
Message-ID: <4C738B23.6040205@redhat.com>
Date: Tue, 24 Aug 2010 12:04:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v5 08/12] Inject asynchronous page fault into a guest
 if page is swapped out.
References: <1279553462-7036-1-git-send-email-gleb@redhat.com> <1279553462-7036-9-git-send-email-gleb@redhat.com> <4C729F10.40005@redhat.com> <20100824075258.GX10499@redhat.com>
In-Reply-To: <20100824075258.GX10499@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/24/2010 10:52 AM, Gleb Natapov wrote:
>> This nice cache needs to be outside apf to reduce complexity for
>> reviewers and since it is useful for others.
>>
>> Would be good to have memslot-cached kvm_put_guest() and kvm_get_guest().
> Will look into it.

In the meantime, you can just drop the caching.


>>> +		       struct kvm_arch_async_pf *arch)
>>> +{
>>> +	struct kvm_async_pf *work;
>>> +
>>> +	if (vcpu->async_pf_queued>= ASYNC_PF_PER_VCPU)
>>> +		return 0;
>> 100 == too high.  At 16 vcpus, this allows 1600 kernel threads to
>> wait for I/O.
> Number of kernel threads are limited by other means. Slow work subsystem
> has its own knobs to tune that. Here we limit how much slow work items
> can be queued per vcpu.

OK.

>> Would have been best if we could ask for a page to be paged in
>> asynchronously.
>>
> You mean to have core kernel facility for that? I agree it would be
> nice, but much harder.

Yes, that's what I meant.

-- 
error compiling committee.c: too many arguments to function

