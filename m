Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346Ab0LTXtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:49:23 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:43073 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143Ab0LTXtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:49:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JVPkdDD+QiKZzy46NacT9xn7FRR5ka/xondQt+93LR5osLl5ZvLG8GHq9hDaqgqBWo
         bUCArWW5/ZYNasa1lfkV5KlVv+JsZ+uzf+MCSp8GmAZAU0Q8tia83hZNDz0O9mILvXt8
         AIe6Bo9LO4iyAnXyD4eFPCl2ZKJzDI4VMEwS0=
MIME-Version: 1.0
In-Reply-To: <4D0FE546.7050302@bluewatersys.com>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>
	<20101107165745.GB1759@n2100.arm.linux.org.uk>
	<AANLkTimFJ=Brx4pDiUqZOKDfABaDg0s_yFC7EkZGi7D8@mail.gmail.com>
	<20101107171726.GF1759@n2100.arm.linux.org.uk>
	<20101108171930.GA1471@alchark-u3s.lan>
	<20101111212322.GA15533@alchark-u3s.lan>
	<20101111234957.GA28735@n2100.arm.linux.org.uk>
	<20101219174017.GA31832@alchark-u3s>
	<20101220191549.GH28157@n2100.arm.linux.org.uk>
	<20101220195423.GA14509@alchark-u3s>
	<4D0FC1AE.2050708@bluewatersys.com>
	<AANLkTin4XqbGwznp56Xjt_zest6rxNmir0QDJWTySY4+@mail.gmail.com>
	<4D0FD747.9020700@bluewatersys.com>
	<AANLkTikAWjK7ACyt=LedhyyrhsCk1WCiyWz182CXMe9C@mail.gmail.com>
	<4D0FE546.7050302@bluewatersys.com>
Date: Tue, 21 Dec 2010 02:49:20 +0300
Message-ID: <AANLkTinyYKrhTcBMMCE4A2oFQHm11cqSZQozytGu+d6o@mail.gmail.com>
Subject: Re: [PATCH 1/6 v9] ARM: Add basic architecture support for
 VIA/WonderMedia 85xx SoC's
From: Alexey Charkov <alchark@gmail.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/21 Ryan Mallon <ryan@bluewatersys.com>:
> On 12/21/2010 12:00 PM, Alexey Charkov wrote:
>> 2010/12/21 Ryan Mallon <ryan@bluewatersys.com>:
>>> On 12/21/2010 10:48 AM, Alexey Charkov wrote:
>>>> 2010/12/20 Ryan Mallon <ryan@bluewatersys.com>:
>>>>> On 12/21/2010 08:54 AM, Alexey Charkov wrote:
>>>>>> This adds support for the family of Systems-on-Chip produced initially
>>>>>> by VIA and now its subsidiary WonderMedia that have recently become
>>>>>> widespread in lower-end Chinese ARM-based tablets and netbooks.
>>>>>>
>>>>>> Support is included for both VT8500 and WM8505, selectable by a
>>>>>> configuration switch at kernel build time.
>>>>>>
>>>>>> Included are basic machine initialization files, register and
>>>>>> interrupt definitions, support for the on-chip interrupt controller,
>>>>>> high-precision OS timer, GPIO lines, necessary macros for early debug,
>>>>>> pulse-width-modulated outputs control, as well as platform device
>>>>>> configurations for the specific drivers implemented elsewhere.
>>>>>>
>>>>>> Signed-off-by: Alexey Charkov <alchark@gmail.com>
>>>>>
>>>>> Hi Alexey,
>>>>>
>>>>> Quick review below.
>>>
>>>> <snip>
>>>>>> +void __init wmt_set_resources(void)
>>>>>> +{
>>>>>> +     resources_lcdc[0].start = wmt_current_regs->lcdc;
>>>>>> +     resources_lcdc[0].end = wmt_current_regs->lcdc + SZ_1K - 1;
>>>>>> +     resources_lcdc[1].start = wmt_current_irqs->lcdc;
>>>>>> +     resources_lcdc[1].end = wmt_current_irqs->lcdc;
>>>>>
>>>>> Ah, this makes more sense. But why have all the indirection? The
>>>>> wmt_regmaps table could just be replaced with #defines and then have
>>>>> separate device files for the VT8500 and the WM8505. This would also
>>>>> make clearer which variants have which peripherals.
>>>>>
>>>>
>>>> This was the way I implemented it originally. However, Arnd made quite
>>>> a valid suggestion to allow runtime selection of the chip variant,
>>>> thus registers and interrupts need to be held in an indexed data type
>>>> instead of just compile-time macros. In addition, there is now some
>>>> overall movement towards unification of binary kernel images for
>>>> different ARM variants (as far as I can see), so this would be
>>>> required in any case.
>>>>
>>>> Furthermore, as with many unbranded Chinese products, it's somewhat
>>>> difficult to reliably determine the exact chip version used in your
>>>> netbook without disassembling it. Reading a hardware register for
>>>> identification is easier :)
>>>
>>> Okay, that makes sense. I still think there must be a better way than
>>> having a massive indirect table with all the values. Why not detect the
>>> variant in the core code and then have something like:
>>>
>>> int init_devices(void)
>>> {
>>>        int board_type = detect_board_type();
>>>
>>>        switch (board_type) {
>>>        case BOARD_TYPE_VT8500:
>>>                return vt8500_init_devices();
>>>
>>>        case BOARD_TYPE_WM8505:
>>>                return wm8500_init_devices();
>>>        }
>>>
>>>        pr_err("Unknown board type\n");
>>>        BUG(); /* panic()? */
>>>        while (1)
>>>                ;
>>> }
>>>
>>> Then you can have the peripheral setup for each of the variants in their
>>> own files and use #defines. It may get tricky in a couple of places if
>>> you need to be able to access some value directly which is different on
>>> each of the variants, but that can be handled on a case by case basis.
>>> The majority of the numbers will be passed into drivers via the resource
>>> structs.
>>>
>>
>> This is more or less what I'm doing right now - except for the
>> separation between different files. I tried to avoid duplication of
>> similar things here. Is the indirect table really a big issue? I'm a
>> bit reluctant to copy about the whole devices.c for each chip variant,
>> which would be otherwise required. Further, it would add more
>> complexity to the timer, irq, gpio, i8042 and probably some other
>> places.
>
> Yeah, agreed about the duplication. My approach would require the common
> peripherals to be defined for each variant. I'm not entirely against the
> indirect table (and am even starting to think it may be the best overall
> solution), it's just that it can be a bit difficult to follow because to
> add a device you need to do the following:
>
>  - Add a partially empty resource/platform_device struct
>  - Add resource entries to the resource table definition
>  - Add resource values to the resource table
>  - Add assignment of resource values to device init code
>

That's actually only one step more than what machines with static
resource definitions require (the last one). Flexibility does come at
a cost, so there should be a mathematical limit to optimization of
this thing :)

> The indirection also makes it harder to quickly determine the IRQ number
> of memory address of a peripheral.
>
> The current solution using the indirect table is okay, but it would be
> nice to find a solution which reduces some of this effort.
>
>>>>>> +}
>>>>>> +
>>>>>> +int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
>>>>>> +{
>>>>>> +     unsigned long long c;
>>>>>> +     unsigned long period_cycles, prescale, pv, dc;
>>>>>> +
>>>>>> +     if (pwm == NULL || period_ns == 0 || duty_ns > period_ns)
>>>>>> +             return -EINVAL;
>>>>>> +
>>>>>> +     c = 25000000/2; /* wild guess --- need to implement clocks */
>>>>>> +     c = c * period_ns;
>>>>>> +     do_div(c, 1000000000);
>>>>>> +     period_cycles = c;
>>>>>
>>>>> This looks like it could be reworked to remove the do_div call.
>>>>>
>>>>
>>>> I just followed PXA implementation in this regard. Are there any
>>>> specific suggestions? Note that c should not be a complie-time
>>>> constant eventually, as this is the guessed PWM base frequency (should
>>>> be read from the hardware, but the code for clocks is not yet in).
>>>
>>> I didn't have a particular solution in mind, but often by changing the
>>> units used and rearranging the math a bit you can often avoid having to
>>> do horrible multiplies and divides.
>>>
>>> For now at least you could avoid the do_div by assigning period_cycles
>>> directly.
>>>
>>
>> It depends on period_ns, which is passed in as an argument from
>> whatever uses PWM, so I'm not sure it can be assigned directly.
>
> Ah. How big a number is period_ns? Can you do something like this instead?
>
>        period_cycles = ((250 / 2) * period_ns) / 10000;
>
> and still safely avoid overflows?
>

The only current in-kernel user of PWM is the backlight, and that
currently uses period_ns = 250000. At this value it does not overflow.
However, in a general case the base frequency will also be returned as
a large number (like 12500000) as per CLK infrastructure conventions
(once that part is implemented). Further, I can't see any built-in
reasons for period_ns to be bounded by anything below sizeof(int). The
hardware will work with up to 4096*1024*1000000000/base_frequency (see
the code for constraints), so it can in principle overflow with 32 bit
arithmetics.

Best regards,
Alexey
