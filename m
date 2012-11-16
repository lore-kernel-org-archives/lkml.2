Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab2KPTjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:39:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35475 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193Ab2KPTjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:39:40 -0500
Message-ID: <50A69664.6070009@zytor.com>
Date: Fri, 16 Nov 2012 11:39:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 8/9] x86: ramdisk info print with high bits.
References: <1353055989-31939-1-git-send-email-yinghai@kernel.org> <1353055989-31939-9-git-send-email-yinghai@kernel.org> <50A6644D.80205@zytor.com> <CAE9FiQXJqyUf7qAspG_ZKUPV96QQjayp8cM0ihQ0RpyU5AxBMA@mail.gmail.com>
In-Reply-To: <CAE9FiQXJqyUf7qAspG_ZKUPV96QQjayp8cM0ihQ0RpyU5AxBMA@mail.gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 11:21 AM, Yinghai Lu wrote:
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
> that extra 2 is for "0x"
> 

Oh, right.  It's the use of %#... I usually use 0x%... so I didn't think
of it.

> or you prefer to cast them to pointer and use %pR for them all?
> 
> or fix printk to add extra 2 for "0x" when # is found?

We should normally use %pR or the equivalent format.  The only reason we
do it different for e820_print_map is because it prints a whole bunch of
lines in which we want the columns to line up.

	-hpa

