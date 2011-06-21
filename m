Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1FUCwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 22:52:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab1FUCwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 22:52:42 -0400
Message-ID: <4E000776.7000504@redhat.com>
Date: Tue, 21 Jun 2011 10:52:38 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dave Anderson <anderson@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary
 physical addresses
References: <818132268.99935.1308576273046.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <818132268.99935.1308576273046.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年06月20日 21:24, Dave Anderson 写道:
>> On Mon, Jun 20, 2011 at 10:42:47, Amerigo Wang<amwang@redhat.com>  wrote:
>>> On Fri, Jun 17, 2011 at 5:55 PM, Petr Tesarik<ptesarik@suse.cz>  wrote:
>>> Dne PÃ¡ 17. Äervna 2011 11:30:32 Ingo Molnar napsal(a):
>>>> * Petr Tesarik<ptesarik@suse.cz>  wrote:
>>>>> This patch series enhances /dev/mem, so that read and write is
>>>>> possible at any address. The patchset includes actual
>>>>> implementation for x86.
>>>>
>>>> This series lacks a description of why this is desired.
>>>
>>> Hi Ingo,
>>>
>>>> My strong opinion is that it's not desired at all: /dev/mem never
>>>> worked beyond 4G addresses so by today it has become largely obsolete
>>>> and is on the way out really.
>>>>
>>>> I'm aware of these current /dev/mem uses:
>>>>
>>>>   - Xorg maps below 4G non-RAM addresses and the video BIOS
>>>>
>>>>   - It used to have some debugging role but these days kexec and kgdb
>>>>     has largely taken over that role - partly due to the 4G limit.
>>>
>>> It is still used as a "memory source" by Dave Anderson's crash utility for
>>> live examination of a running system. Redhat has "overcome" the /dev/mem
>>> deficiencies by writing an out-of-tree re-implementation of /dev/mem, which
>>> uses /dev/crash instead. As it is an "unnecessary duplication of an existing
>>> driver", this method was rejected by the project manager here at SUSE.
>>>
>>> The suggested alternative was to enhance (or fix) the existing driver. Without
>>> this patch series there is no way to access high memory. In conjunction with
>>> CONFIG_HIGHPTE, it makes the crash utility near to useless on anything with
>>> high memory, because crash can no longer translate virtual to physical
>>> addresses.
>>>
>>
>> How about /proc/kcore? AFAIK, it can access highmem, but Dave didn't consider
>> it for some reason.
>
> I don't know what you mean by I "didn't consider it", because
> the crash utility does support using /proc/kcore as an alternative
> live memory source.

Sorry, I recall that in our last discussion you didn't
mention this. But it is good to know that crash supports this!

>
> The problem is that /proc/kcore can only access highmem if it
> is mapped as kernel virtual address.  So it cannot read 32-bit
> highmem PTE's, user-space memory, etc.
>

Hmm, looking at the code, you are right, it only has
low memory in kernel space.

But what's the problem of adding highmem into kcore? :-/

Thanks.
