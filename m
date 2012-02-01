Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab2BANYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 08:24:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab2BANYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 08:24:45 -0500
Message-ID: <4F293D14.5030008@redhat.com>
Date: Wed, 01 Feb 2012 15:24:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [RFC][PATCH] srcu: Implement call_srcu()
References: <1328016724.2446.229.camel@twins> <4F27F0E6.1040309@redhat.com>  <1328017807.2446.230.camel@twins>  <20120131222447.GH2391@linux.vnet.ibm.com> <1328091749.2760.34.camel@laptop> <4F29178A.1090306@redhat.com> <4F2918D5.4050104@redhat.com> <4F291B56.30600@oss.ntt.co.jp> <4F291B92.8070402@redhat.com> <4F291E1F.3030505@oss.ntt.co.jp>
In-Reply-To: <4F291E1F.3030505@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 01:12 PM, Takuya Yoshikawa wrote:
> (2012/02/01 20:01), Avi Kivity wrote:
>> On 02/01/2012 01:00 PM, Takuya Yoshikawa wrote:
>
>>> How about just doing:
>>>
>>> take a spin_lock
>>> copy the entire (or some portions of) bitmap locally
>>> clear the bitmap
>>> unlock
>>>
>>
>> That means that vcpus dirtying memory also have to take that lock, and
>> spin while the bitmap is being copied.  So kvm_vm_ioctl_get_dirty_log()
>> will become faster, at the expense of vcpus, which I think is a bad
>> tradeoff.
>
> Almost every caller is already holding the mmu_lock.

True.  But let's not add more locks.

>
> Isn't it possible to make others hold the lock only for the case of
> marking to the bitmap? (I will check myself too.)

Yes, in walk_addr(), while setting accessed and dirty bits in guest
PTEs, or while emulating instructions and writing to guest memory.

>> That'll be great, numbers are better than speculation.
>>
>
>
> Yes, I already have some good numbers to show (and some patches).

Looking forward.

-- 
error compiling committee.c: too many arguments to function

