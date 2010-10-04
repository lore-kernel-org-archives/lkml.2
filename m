Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab0JDWUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 18:20:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58115 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab0JDWUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 18:20:45 -0400
Message-ID: <4CAA52EF.3030302@zytor.com>
Date: Mon, 04 Oct 2010 15:19:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, cpu: Fix X86_FEATURE_NOPL
References: <20101003093701.GB3733@liondog.tnic>	<4CA89681.8000202@zytor.com>	<20101003152212.GA13233@liondog.tnic>	<a3fce0e5-e6c5-4bf0-b8c0-4954825a7065@email.android.com>	<20101003201139.GA16532@liondog.tnic>	<dc1a5ce2-0414-4f15-9e7b-fcfa4435adb5@email.android.com>	<20101004073127.GA20305@liondog.tnic>	<AANLkTikBs5R2KmGfDSXyi5y-cKuZepZCdr0KOVe5-MX6@mail.gmail.com>	<4CAA4102.3070205@zytor.com>	<AANLkTimXj+5ixx=xoVYOCmM4+W6CGR1XOi6CHDTZzns0@mail.gmail.com>	<4CAA455D.8000902@zytor.com> <AANLkTiniYToWCeVvMXmyUFTudW9g_mpGXRMwQ20kxXUk@mail.gmail.com>
In-Reply-To: <AANLkTiniYToWCeVvMXmyUFTudW9g_mpGXRMwQ20kxXUk@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2010 03:17 PM, Hugh Dickins wrote:
> On Mon, Oct 4, 2010 at 2:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 10/04/2010 02:12 PM, Linus Torvalds wrote:
>>> On Mon, Oct 4, 2010 at 2:02 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>>
>>>> Actually, cpu_has() depends on:
>>>> #if defined(CONFIG_X86_P6_NOP) || defined(CONFIG_X86_64)
>>>
>>> Ahh. Right you are. The place that depends on just P6_NOP is the
>>> default NOP choice logic in <asm/nops.h>
>>>
>>> But the end result ends up being the same: can we please clean this
>>> all up so that it isn't so confusing? Rather than add to the
>>> confusion?
>>>
>>
>> Agreed that this should be cleaned up.  However, in the meantime I'd
>> like to keep Borislav's patch in the tree since it makes the code
>> technically correct at least.
> 
> Another piece of the confusion I noticed a couple of days ago:
> X86_MINIMUM_CPU_FAMILY defaults to "6" if X86_32 &&
> X86_P6_NOP; whereas X86_P6_NOP depends on X86_64.
> 

Again, it's completely consistent -- if you keep in mind that
CONFIG_X86_P6_NOP depending on X86_64 is a policy decision; that policy
can theoretically be changed.  However, it really doesn't seem worth it
to ever contemplate at this point.

	-hpa
