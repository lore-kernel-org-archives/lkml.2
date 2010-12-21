Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703Ab0LUKAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 05:00:47 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:61016 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab0LUKAp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 05:00:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e2A928E/DAZMGzH3Br8hny0yVFXRbDBaRbdphornCyHT9YEY7ytWq10XpM0u/z+Dv5
         f3FRxCZjxMdEUhAP/6QX0FGCV7bQHxj08TZQtOnBuVBGZ+WMaojDDwy5wwu/IfNslJ8f
         fOn25x/Hl2r+3isMAXU4zrBxRfcDg4xaqGURY=
MIME-Version: 1.0
In-Reply-To: <4D1011CF.9080800@bluewatersys.com>
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
	<AANLkTinyYKrhTcBMMCE4A2oFQHm11cqSZQozytGu+d6o@mail.gmail.com>
	<4D1011CF.9080800@bluewatersys.com>
Date: Tue, 21 Dec 2010 13:00:43 +0300
Message-ID: <AANLkTi=7O-HwQRcybnLSt+r+A64g=D7rZY7NbdEMFys3@mail.gmail.com>
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
> On 12/21/2010 12:49 PM, Alexey Charkov wrote:
>> 2010/12/21 Ryan Mallon <ryan@bluewatersys.com>:
>>> On 12/21/2010 12:00 PM, Alexey Charkov wrote:
>>>> 2010/12/21 Ryan Mallon <ryan@bluewatersys.com>:
>>>>> On 12/21/2010 10:48 AM, Alexey Charkov wrote:
>>>>>> 2010/12/20 Ryan Mallon <ryan@bluewatersys.com>:
>>>>>>> On 12/21/2010 08:54 AM, Alexey Charkov wrote:
>>>>>>>> This adds support for the family of Systems-on-Chip produced initially
>>>>>>>> by VIA and now its subsidiary WonderMedia that have recently become
>>>>>>>> widespread in lower-end Chinese ARM-based tablets and netbooks.
>>>>>>>>
>>>>>>>> Support is included for both VT8500 and WM8505, selectable by a
>>>>>>>> configuration switch at kernel build time.
>>>>>>>>
>>>>>>>> Included are basic machine initialization files, register and
>>>>>>>> interrupt definitions, support for the on-chip interrupt controller,
>>>>>>>> high-precision OS timer, GPIO lines, necessary macros for early debug,
>>>>>>>> pulse-width-modulated outputs control, as well as platform device
>>>>>>>> configurations for the specific drivers implemented elsewhere.
>>>>>>>>
>>>>>>>> Signed-off-by: Alexey Charkov <alchark@gmail.com>
>>>>>>>
>>>>>>> Hi Alexey,
>>>>>>>
>>>>>>> Quick review below.
>>>>>
>>>>>> <snip>
>>>>>>>> +void __init wmt_set_resources(void)
>>>>>>>> +{
>>>>>>>> +     resources_lcdc[0].start = wmt_current_regs->lcdc;
>>>>>>>> +     resources_lcdc[0].end = wmt_current_regs->lcdc + SZ_1K - 1;
>>>>>>>> +     resources_lcdc[1].start = wmt_current_irqs->lcdc;
>>>>>>>> +     resources_lcdc[1].end = wmt_current_irqs->lcdc;
>>>>>>>
>>>>>>> Ah, this makes more sense. But why have all the indirection? The
>>>>>>> wmt_regmaps table could just be replaced with #defines and then have
>>>>>>> separate device files for the VT8500 and the WM8505. This would also
>>>>>>> make clearer which variants have which peripherals.
>>>>>>>
>>>>>>
>>>>>> This was the way I implemented it originally. However, Arnd made quite
>>>>>> a valid suggestion to allow runtime selection of the chip variant,
>>>>>> thus registers and interrupts need to be held in an indexed data type
>>>>>> instead of just compile-time macros. In addition, there is now some
>>>>>> overall movement towards unification of binary kernel images for
>>>>>> different ARM variants (as far as I can see), so this would be
>>>>>> required in any case.
>>>>>>
>>>>>> Furthermore, as with many unbranded Chinese products, it's somewhat
>>>>>> difficult to reliably determine the exact chip version used in your
>>>>>> netbook without disassembling it. Reading a hardware register for
>>>>>> identification is easier :)
>>>>>
>>>>> Okay, that makes sense. I still think there must be a better way than
>>>>> having a massive indirect table with all the values. Why not detect the
>>>>> variant in the core code and then have something like:
>>>>>
>>>>> int init_devices(void)
>>>>> {
>>>>>        int board_type = detect_board_type();
>>>>>
>>>>>        switch (board_type) {
>>>>>        case BOARD_TYPE_VT8500:
>>>>>                return vt8500_init_devices();
>>>>>
>>>>>        case BOARD_TYPE_WM8505:
>>>>>                return wm8500_init_devices();
>>>>>        }
>>>>>
>>>>>        pr_err("Unknown board type\n");
>>>>>        BUG(); /* panic()? */
>>>>>        while (1)
>>>>>                ;
>>>>> }
>>>>>
>>>>> Then you can have the peripheral setup for each of the variants in their
>>>>> own files and use #defines. It may get tricky in a couple of places if
>>>>> you need to be able to access some value directly which is different on
>>>>> each of the variants, but that can be handled on a case by case basis.
>>>>> The majority of the numbers will be passed into drivers via the resource
>>>>> structs.
>>>>>
>>>>
>>>> This is more or less what I'm doing right now - except for the
>>>> separation between different files. I tried to avoid duplication of
>>>> similar things here. Is the indirect table really a big issue? I'm a
>>>> bit reluctant to copy about the whole devices.c for each chip variant,
>>>> which would be otherwise required. Further, it would add more
>>>> complexity to the timer, irq, gpio, i8042 and probably some other
>>>> places.
>>>
>>> Yeah, agreed about the duplication. My approach would require the common
>>> peripherals to be defined for each variant. I'm not entirely against the
>>> indirect table (and am even starting to think it may be the best overall
>>> solution), it's just that it can be a bit difficult to follow because to
>>> add a device you need to do the following:
>>>
>>>  - Add a partially empty resource/platform_device struct
>>>  - Add resource entries to the resource table definition
>>>  - Add resource values to the resource table
>>>  - Add assignment of resource values to device init code
>>>
>>
>> That's actually only one step more than what machines with static
>> resource definitions require (the last one). Flexibility does come at
>> a cost, so there should be a mathematical limit to optimization of
>> this thing :)
>
> No it isn't. You don't have the massive table, which requires
> modifications to both the definition and declaration, on machines with
> static resource definitions.
>
> How about using the resource structures directly rather than introducing
> the table which is effectively holding the same information? Something
> like this?
>
> In vt8500_resources.c (and similarly for wm8505_resources.c):
>
> static struct resource vt8500_resources_uart0[] __initdata = {
>        [0] = {
>                .flags  = IORESOURCE_MEM,
>                .start  = VT8500_UART0_PHYS_BASE,
>                .end    = VT8500_UART0_PHYS_BASE + 0xff,
>        },
>        [1] = {
>                .flags  = IORESOURCE_IRQ,
>                .start  = VT8500_UART0_IRQ,
>                .end    = VT8500_UART0_IRQ,
>        },
> };
>
> struct resource *vt8500_resources[] __initdata = {
>        [VT8500_UART0] = &vt8500_resources_uart0,
>        ...
> };
>
> In devices.c:
>
> extern struct resource *vt8500_resources;
> extern struct resource *wm8505_resources;
>
> /* Set this pointer according to board variant */
> static struct resource *resources;
>
> void __init wmt_set_resources(void)
> {
>        vt8500_device_uart0.resource = resources[VT8500_UART0];
>        ...
> }
>
> This way we only have a single externed resource structure per
> board-variant, there is no additional table needed, and the resource
> definitions can be read clearly. Alternatively the wmt_regmaps/wmt_irqs
> tables could be modified to use struct resource rather than individual
> fields which would simplify the assignments later.

This way we will again duplicate quite much: those files will mostly
differ in just the macro definitions of specific registers/irqs.

What if I just move all the initializations inside my runtime helper
function, and add a macro to save space and improve readability?
Something along the lines of:

static struct resource resources_lcdc[2] __initdata;

#define WMT_MMIO_RES(__start, __size) \
{\
        .flags = IORESOURCE_MEM,\
        .start = __start,\
        .end = __start + __size - 1,\
}
#define WMT_IRQ_RES(__irq) \
{\
        .flags = IORESOURCE_IRQ,\
        .start = __irq,\
        .end = __irq,\
}

void __init wmt_set_resources(void)
{
     resources_lcdc[0] = WMT_MMIO_RES(wmt_current_regs->lcdc, SZ_1K);
     resources_lcdc[1] = WMT_IRQ_RES(wmt_current_irqs->lcdc);
...
}

Then there will be no half-empty initializations scattered around
separate from the other assignments (which is probably the worst thing
in current configuration).

Best regards,
Alexey
