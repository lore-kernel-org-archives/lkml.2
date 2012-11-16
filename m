Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab2KPTcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:32:52 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42434 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab2KPTcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:32:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXJqyUf7qAspG_ZKUPV96QQjayp8cM0ihQ0RpyU5AxBMA@mail.gmail.com>
References: <1353055989-31939-1-git-send-email-yinghai@kernel.org>
	<1353055989-31939-9-git-send-email-yinghai@kernel.org>
	<50A6644D.80205@zytor.com>
	<CAE9FiQXJqyUf7qAspG_ZKUPV96QQjayp8cM0ihQ0RpyU5AxBMA@mail.gmail.com>
Date: Fri, 16 Nov 2012 11:32:50 -0800
X-Google-Sender-Auth: gXGJDR1XAYuluK6dLYUukKRReEY
Message-ID: <CAE9FiQUkWug18Bdyjp7ocJxCCJxpa7+tY0+eQ301pY1a-f+JUw@mail.gmail.com>
Subject: Re: [PATCH 8/9] x86: ramdisk info print with high bits.
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 11:21 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Nov 16, 2012 at 8:05 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 11/16/2012 12:53 AM, Yinghai Lu wrote:
>>> ramdisk could be loaded high now for 64bit.
>>>
>>> So need to print more digits for them.
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>> Cc: Matt Fleming <matt.fleming@intel.com>
>>> ---
>>>  arch/x86/kernel/setup.c |    8 ++++----
>>>  1 files changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>>> index c2eb535..0e13c6e 100644
>>> --- a/arch/x86/kernel/setup.c
>>> +++ b/arch/x86/kernel/setup.c
>>> @@ -341,7 +341,7 @@ static void __init relocate_initrd(void)
>>>       memblock_reserve(ramdisk_here, area_size);
>>>       initrd_start = ramdisk_here + PAGE_OFFSET;
>>>       initrd_end   = initrd_start + ramdisk_size;
>>> -     printk(KERN_INFO "Allocated new RAMDISK: [mem %#010llx-%#010llx]\n",
>>> +     printk(KERN_INFO "Allocated new RAMDISK: [mem %#018llx-%#018llx]\n",
>>>                        ramdisk_here, ramdisk_here + ramdisk_size - 1);
>>
>> NAK, this is expected to match the resource print format (%pR), which
>> prints 10 digits by default and then expands.  Furthermore, printing
>> *18* digits is downright silly since we still don't have 72-bit addressing.
>
> that is the same as in e820_print_map::
>
>                 printk(KERN_INFO "%s: [mem %#018Lx-%#018Lx] ", who,
>                        (unsigned long long) e820.map[i].addr,
>                        (unsigned long long)
>                        (e820.map[i].addr + e820.map[i].size - 1));
>
>
> that is for 64bit address.
>
> that extra 2 is for "0x"
>
> or you prefer to cast them to pointer and use %pR for them all?
>
> or fix printk to add extra 2 for "0x" when # is found?

looks like we have lots of %#010llx or %#010Lx there in arch/x86.

We need to fix printk to make it acting like %pR ?
