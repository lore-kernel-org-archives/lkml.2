Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab2KVSvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:51:00 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55183 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab2KVSu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:50:58 -0500
MIME-Version: 1.0
In-Reply-To: <20121122154612.GC10986@gmail.com>
References: <f1d508c64a01dfd492a1ab1fda28af4b7647d8ab.1353560936.git.viresh.kumar@linaro.org>
	<b81641051dad9660b72b0028d001e5620d901160.1353560936.git.viresh.kumar@linaro.org>
	<20121122112451.GE4328@gmail.com>
	<CAKohpo=F91sZ7St3XVXqwAEgmSWXjAxxXwRs1RD5qPyW99P1vA@mail.gmail.com>
	<20121122154612.GC10986@gmail.com>
Date: Thu, 22 Nov 2012 22:31:48 +0530
Message-ID: <CAKohpok6v65TH5yZAthyxcH7bCVgF8A8m2bY_mp3yS_Y_yH1Xw@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] mfd: stmpe: Extend DT support in stmpe driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 November 2012 21:16, Lee Jones <lee.jones@linaro.org> wrote:
>> >> diff --git a/Documentation/devicetree/bindings/mfd/stmpe.txt b/Documentation/devicetree/bindings/mfd/stmpe.txt
>> >> +- irq-over-gpio: bool, true if gpio is used to get irq
>> >> +- irq-gpios: gpio number over which irq will be requested (significant only if
>> >> +  irq-over-gpio is true)
>> >
>> > You don't need these. Use gpio_to_irq() instead.
>>
>> I am passing gpio numbers here and am doing gpio_to_irq() in driver.
>> Didn't get this one :(
>
> For a start you have 'irq-over-gpio' in the binding document and Device Tree
> and 'irq_over_gpio' in the code. Has it even been tested?
>
> GPIOs are used as IRQ lines in many other previously DT:ed drivers. Take a
> look to see how they are handled without adding unnecessary DT bindings.

I already knew it, should have picked that up. :(

>> stmpe is an interrupt controller for the IP's which are present inside
>> it: gpio, adc.
>> But interrupt lines for them are managed by stmpe driver internally. So should
>> we really add interrupt-controller for it?
>
> You can't manage IRQ lines internally, you have to go through
> the IRQ subsystem. When you request an IRQ via device tree you
> will do so like this:

By that i meant, there is no external node which would have stmpe as
interrupt controller. Because all of them would be its child node.

This is guaranteed because stmpe is an external device is present on board.
So, it will have its entry in board dts file, and so wouldn't be
scattered in different
files.

> The STMPE GPIO controller can't be used by Device Tree yet in any case,
> because it doesn't have an IRQ domain. This is compulsory, or it won't
> work. Have you tried to test this functionality yet?

I don't have SPEAr board to test it anymore. I have moved out of ST now and
working in linaro as ARM asignee. Just pushing these as an part time activity.

Though ST guys would have tested stmpe, but stmpe-gpio, i am not sure about.

> Okay, I've just had a look at my tested bindings.
>
> We already have these:
>
>   debounce-interval   /* This is a generic binding */
>   st,scan-count       /* These are vendor specific */
>   st,no-autorepeat    /*            "              */
>
> Vendor specific bindings should be "<vendor>,<binding>", rather than
> "<type_of_driver>,<binding>"

Will take care of these.

>> >> +             reg = <0>;
>> >
>> > You have reg twice here. Also reg should never be '0'.
>>
>> For SPI, there are chip selects and there is no reg offset.
>
> I understand the addressing issues, but you have 'reg' twice.
>
> Which one should be used?

I haven't replied on that, because it was accepted. Only one
definition should be there for reg.

> I didn't go through them, but are you sure that:
>
> 1. Can I do without them?
>    1.1 Can I derive the configuration from other things?
>    2.2 Are they _really_ required, or am I just blindly copying platform data?
> 2. Does a similar binding already exist?
> 3. Can other drivers make use of them?
>    3.1 If so, create a generic binding
>    3.2 If not, prepend the binding with "<vendor>,"

I will go through them again.

>> >> diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
>> Because i wanted to keep all DT stuff together. Obviously i have seen keypad
>> driver earlier :)
>
> If you had, you'd realise that these bindings already exist. ;)

Ok. I had seen it during my V1 and missed these bindings. will fix them now.

--
viresh
