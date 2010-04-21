Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab0DUUIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:08:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58099 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab0DUUIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:08:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qxzd/1kaXIADcM/q816aZFmHZtg2qA+433Df0T8MqFbcB2ZkRLhMmbtA9+LgZTwF2s
         I68Zi0Uo3WKfuyzPpxdVBMVSRUUkWXy+XEoF2SHL8wqqZsXvlrBRnFetVpnkYQUpX+Ex
         F2zGOkth3yZwLwHqaAipsM3a7Jv1fSoIcmabU=
MIME-Version: 1.0
In-Reply-To: <x2u9bde694e1004200316i6417ad36oe399b88cb385cf54@mail.gmail.com>
References: <j2n448a67a1004190442h2d01f517ld1cd0449c7a0513@mail.gmail.com>
	 <x2n448a67a1004190620z6b23d12vc4ba54f2d460d125@mail.gmail.com>
	 <o2p9bde694e1004190623n24a4308le84451cc076d4a46@mail.gmail.com>
	 <r2l19f34abd1004200101xbe260a00l98cadfe24d41b7c2@mail.gmail.com>
	 <x2u9bde694e1004200316i6417ad36oe399b88cb385cf54@mail.gmail.com>
Date: Thu, 22 Apr 2010 04:08:46 +0800
Message-ID: <h2waf3ea28a1004211308x2bd81c6cna4db366f9299eb38@mail.gmail.com>
Subject: Re: Kmemcheck issue
From: ye janboe <janboe.ye@gmail.com>
To: naveen yadav <yad.naveen@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       linux-arm-kernel-request@lists.arm.linux.org.uk,
       linux newbie <linux.newbie79@gmail.com>, linux-kernel@vger.kernel.org,
       Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, Naveen

Since kmemcheck is slow on arm which lack hw singlestep, I do not plan
to maintain this patch.

If you want to check slab error, please try kmudflap I posted in the mail list.

Janboe

2010/4/20 naveen yadav <yad.naveen@gmail.com>:
> Hi Vegard,
>
> Thanks for your answer, but this is coming from kmemchek only
>
> thanks
> naveen
> On Tue, Apr 20, 2010 at 1:31 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> On 19 April 2010 15:23, naveen yadav <yad.naveen@gmail.com> wrote:
>>> Hi,
>>>
>>> á á á I áam átrying to á run áKmemcheck on á a áCortex ( ARM-v7)
>>> board árunning áLinux 2.6.30.9
>>>
>>> At boot-up time, áas ásoon áas áTimer-device is áenabled, á I áfind
>>> that á timer ágets ádisabled ábecause ásystem
>>> gets spurious áinterrupts áon áthat áirq áline.
>>>
>>>
>>> PID hash table entries: 1024 (order: 10, 4096 bytes)
>>> Linux System timer initialize
>>> irq 23: nobody cared (try booting with the "irqpoll" option)
>>> [<c002e148>] (unwind_backtrace+0x0/0xe8) from [<c002c4b8>]
>>> (dump_stack+0x18/0x1c)
>>> [<c002c4b8>] (dump_stack+0x18/0x1c) from [<c006ad74>]
>>> (__report_bad_irq+0x80/0xb0)
>>> [<c006ad74>] (__report_bad_irq+0x80/0xb0) from [<c006af28>]
>>> (note_interrupt+0x184/0x1f0)
>>> [<c006af28>] (note_interrupt+0x184/0x1f0) from [<c006ba38>]
>>> (handle_edge_irq+0xe8/0x160)
>>> [<c006ba38>] (handle_edge_irq+0xe8/0x160) from [<c0027060>]
>>> (asm_do_IRQ+0x60/0x74)
>>> [<c0027060>] (asm_do_IRQ+0x60/0x74) from [<c0027a30>] (__irq_svc+0x30/0x80)
>>> Exception stack(0xc0373ec0 to 0xc0373f08)
>>> 3ec0: 00000017 c0372000 00000002 00000000 00000002 c038e8f4 00000000 0aa00000
>>> 3ee0: c0372000 c03bfc40 0000001f c0373f44 00000100 c0373f08 c0047ffc c0047c98
>>> 3f00: 20000153 ffffffff
>>> [<c0027a30>] (__irq_svc+0x30/0x80) from [<c0047ffc>] (irq_exit+0x44/0x4c)
>>> [<c0047ffc>] (irq_exit+0x44/0x4c) from [<c0047ffc>] (irq_exit+0x44/0x4c)
>>> [<c0047ffc>] (irq_exit+0x44/0x4c) from [<c0027064>] (asm_do_IRQ+0x64/0x74)
>>> [<c0027064>] (asm_do_IRQ+0x64/0x74) from [<c0027a30>] (__irq_svc+0x30/0x80)
>>> Exception stack(0xc0373f78 to 0xc0373fc0)
>>> 3f60: á á á á á á á á á á á á á á á á á á á á á á á á á á á 00000000 c037c15c
>>> 3f80: 00000001 600001d3 955fffff c00242ec c0399f80 0aa00000 c0023000 412fc082
>>> 3fa0: 0000001f c0373ff4 c0373fc0 c0373fc0 c0008974 c0019798 20000153 ffffffff
>>> [<c0027a30>] (__irq_svc+0x30/0x80) from [<c0008974>] (start_kernel+0x168/0x3e4)
>>> [<c0008974>] (start_kernel+0x168/0x3e4) from [<60008034>] (0x60008034)
>>> handlers:
>>> [<c003a604>] (sdp_timer_interrupt+0x0/0x38)
>>> Disabling IRQ #23
>>> Console: colour dummy device 80x30
>>> console [ttyS1] enabled
>>> Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
>>> Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
>>>
>>>
>>> Later, áwhen ácalibrating delay áloop, áthe system is hung áas timer
>>> is not working.
>>>
>>> The problem happens áeven if áI áset kmemcheck_enabled = 0 at áboot.
>>> ( I also commented out á á pagetable_init(&meminfo) á).
>>>
>>> áIf áyou have seen this before, áplease let me know.
>>>
>>> ( I know that áyour patch was written for á ARM v6. á á My cpu is
>>> Cortex . á áI am aware that áI may have to make some change in the
>>> áinstruction simulation handling. )
>>>
>>> Thanks
>>
>> Hi,
>>
>> First up, I see a lot of funny á characters in your text.
>>
>> I think that this is not about kmemcheck, but kmemleak. kmemcheck is
>> for catching references to uninitialized memory while kmemleak is for
>> detecting memory leaks. kmemcheck only works on x86 so far (with an
>> ARM patch by Ye Janboe, but it is not in mainline). kmemleak, however,
>> was written on ARM.
>>
>> I put Catalin Marinas (kmemleak author) on Cc.
>>
>> Please correct me if I am wrong. Good luck.
>>
>>
>> Vegard
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
