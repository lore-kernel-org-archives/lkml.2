Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab2KIPrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:47:21 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:40547 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab2KIPrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:47:19 -0500
MIME-Version: 1.0
In-Reply-To: <509D1BC5.7020208@linux.intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <1351928793-14375-2-git-send-email-mika.westerberg@linux.intel.com>
 <CACxGe6tVcqoSg03JtcTdLP5GakyKM-24D8uK2mQj+1iiSE8Yog@mail.gmail.com>
 <20121108193808.GB16012@intel.com> <509D0F1F.70001@linux.intel.com>
 <CACxGe6sgNEqEhiXC_EoBuAg+QaaRis_4eRb7s5k0MKtfZF-3dA@mail.gmail.com> <509D1BC5.7020208@linux.intel.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 9 Nov 2012 15:46:58 +0000
X-Google-Sender-Auth: KcK9fBIMYzS9E-kR4-_KvJNw1U8
Message-ID: <CACxGe6uBqSZfHTDPAr3xTXTjOYrrn-AAM5kRkZ=nfVPGCT6z=Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpio / ACPI: add ACPI support
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 3:05 PM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:
> On 11/09/2012 04:18 PM, Grant Likely wrote:
>>
>> On Fri, Nov 9, 2012 at 2:11 PM, Mathias Nyman
>> <mathias.nyman@linux.intel.com>  wrote:
>>>
>>> On 11/08/2012 09:38 PM, Mika Westerberg wrote:
>>> ...
>>>
>>>>>> +#include<linux/errno.h>
>>>>>> +#include<linux/gpio.h>
>>>>>> +#include<linux/module.h>
>>>>>> +#include<linux/acpi_gpio.h>
>>>>>> +#include<linux/acpi.h>
>>>>>> +
>>>>>> +static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
>>>>>> +{
>>>>>> +       acpi_handle handle = data;
>>>>>> +       acpi_handle gc_handle;
>>>>>> +
>>>>>> +       if (!gc->dev)
>>>>>> +               return false;
>>>>>> +
>>>>>> +       gc_handle = gc->dev->acpi_handle;
>>>>>> +       if (!gc_handle)
>>>>>> +               return false;
>>>>>
>>>>>
>>>>>
>>>>> This test is redundant with the next one... unless 'handle' is also
>>>>> NULL
>>>>> :-)
>>>>>
>>>>> Is it at all possible for multiple gpiochips to be used for a single
>>>>> ACPI gpio controller node? Such as if the gpio controller has multiple
>>>>> banks that should be controlled separately? If so then this won't be
>>>>> sufficient. I've got the same issue with DT support where the find
>>>>> function needs to also check if the pin is provided by that specific
>>>>> gpiochip.
>>>>
>>>>
>>>>
>>>> AFAIK no but I'll let Mathias to answer that as he knows this better.
>>>
>>>
>>>
>>> I'm interpreting it the same way as Mika, max one actual controller per
>>> ACPI
>>> device node
>>>
>>> The path (called ResourceSource in ACPI5 specs) in GpioIO/GpioInt
>>> resources
>>> is a "string which uniquely identifies the GPIO controller referred to by
>>> this descriptor."  The pin number is zero based controller relative.
>>>
>>> The  ACPI device controller node includes all other resources needed by
>>> the
>>> controller driver (ioport/mem base, range, interrupt, and Hardware ID
>>> used
>>> to pair with a driver)
>>>
>>> Checked a board with two identical gpio controllers on it and it had two
>>> separate ACPI device node entries. (with only different io address base
>>> and
>>> interrupt resources)
>>
>>
>> That's not really the situation that I'm thinking about. What I mean
>> is for a gpio controller that is more convenient for Linux to support
>> using multiple gpiochips (Linux internal detail), even though there it
>> is described with a single ACPI node.
>>
>
> Ok, now I get it.
>
> Yes, in case a driver uses several gpiochips internally for different banks
> of a controller then all would have the same acpi_handle.
> acpi_get_gpio() would use the gpiobase of the first gpiochip that matches
> the handle, even if it's the wrong one.
>
> I guess It's possible to write a driver like that.
> The only acpi enumerated driver with the acpi_handle set (soon coming to
> upstream) is not done like that.
>
> Do you think this is a case that should be solved now?  or just expect acpi
> gpio device driver to not use several gpiochips in one driver?

Look at what the DT code does. It is actually pretty easy to solve. I
would do it now, but I won't block the changes if you do not.

g.
