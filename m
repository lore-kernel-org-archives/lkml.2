Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab2KPUKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 15:10:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35799 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab2KPUKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 15:10:11 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAE9FiQUJO-HfLs8ddLJ3D_jwpJi_tkxrx19Ro6PNOMGfu4=O-A@mail.gmail.com>
References: <1353055989-31939-1-git-send-email-yinghai@kernel.org> <1353055989-31939-9-git-send-email-yinghai@kernel.org> <50A6644D.80205@zytor.com> <CAE9FiQXJqyUf7qAspG_ZKUPV96QQjayp8cM0ihQ0RpyU5AxBMA@mail.gmail.com> <50A69664.6070009@zytor.com> <CAE9FiQUJO-HfLs8ddLJ3D_jwpJi_tkxrx19Ro6PNOMGfu4=O-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 8/9] x86: ramdisk info print with high bits.
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 16 Nov 2012 12:08:46 -0800
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Message-ID: <a06b0eea-8d4a-4033-9c74-705b0d72ad83@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use %#010llx

Yinghai Lu <yinghai@kernel.org> wrote:

>On Fri, Nov 16, 2012 at 11:39 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 11/16/2012 11:21 AM, Yinghai Lu wrote:
>>>>
>>>> NAK, this is expected to match the resource print format (%pR),
>which
>>>> prints 10 digits by default and then expands.  Furthermore,
>printing
>>>> *18* digits is downright silly since we still don't have 72-bit
>addressing.
>>>
>>> that is the same as in e820_print_map::
>>>
>>>                 printk(KERN_INFO "%s: [mem %#018Lx-%#018Lx] ", who,
>>>                        (unsigned long long) e820.map[i].addr,
>>>                        (unsigned long long)
>>>                        (e820.map[i].addr + e820.map[i].size - 1));
>>>
>>>
>>> that is for 64bit address.
>>> that extra 2 is for "0x"
>>>
>>
>> Oh, right.  It's the use of %#... I usually use 0x%... so I didn't
>think
>> of it.
>>
>>> or you prefer to cast them to pointer and use %pR for them all?
>>>
>>> or fix printk to add extra 2 for "0x" when # is found?
>>
>> We should normally use %pR or the equivalent format.  The only reason
>we
>> do it different for e820_print_map is because it prints a whole bunch
>of
>> lines in which we want the columns to line up.
>
>so we just use #llx or #Lx instead in this patch?

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
