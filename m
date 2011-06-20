Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1FTNYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 09:24:35 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:60767 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab1FTNYd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 09:24:33 -0400
Date: Mon, 20 Jun 2011 09:24:33 -0400 (EDT)
From: Dave Anderson <anderson@redhat.com>
To: amwang@redhat.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <818132268.99935.1308576273046.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary
 physical addresses
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Jun 20, 2011 at 10:42:47, Amerigo Wang <amwang@redhat.com> wrote:
>> On Fri, Jun 17, 2011 at 5:55 PM, Petr Tesarik <ptesarik@suse.cz> wrote:
>> Dne PÃ¡ 17. Äervna 2011 11:30:32 Ingo Molnar napsal(a):
>>> * Petr Tesarik <ptesarik@suse.cz> wrote:
>>> > This patch series enhances /dev/mem, so that read and write is
>>> > possible at any address. The patchset includes actual
>>> > implementation for x86.
>>>
>>> This series lacks a description of why this is desired.
>>
>> Hi Ingo,
>>
>>> My strong opinion is that it's not desired at all: /dev/mem never
>>> worked beyond 4G addresses so by today it has become largely obsolete
>>> and is on the way out really.
>>>
>>> I'm aware of these current /dev/mem uses:
>>>
>>>  - Xorg maps below 4G non-RAM addresses and the video BIOS
>>>
>>>  - It used to have some debugging role but these days kexec and kgdb
>>>    has largely taken over that role - partly due to the 4G limit.
>>
>> It is still used as a "memory source" by Dave Anderson's crash utility for
>> live examination of a running system. Redhat has "overcome" the /dev/mem
>> deficiencies by writing an out-of-tree re-implementation of /dev/mem, which
>> uses /dev/crash instead. As it is an "unnecessary duplication of an existing
>> driver", this method was rejected by the project manager here at SUSE.
>>
>> The suggested alternative was to enhance (or fix) the existing driver. Without
>> this patch series there is no way to access high memory. In conjunction with
>> CONFIG_HIGHPTE, it makes the crash utility near to useless on anything with
>> high memory, because crash can no longer translate virtual to physical
>> addresses.
>>
>
> How about /proc/kcore? AFAIK, it can access highmem, but Dave didn't consider
> it for some reason.

I don't know what you mean by I "didn't consider it", because 
the crash utility does support using /proc/kcore as an alternative
live memory source.

The problem is that /proc/kcore can only access highmem if it
is mapped as kernel virtual address.  So it cannot read 32-bit 
highmem PTE's, user-space memory, etc.

Dave

