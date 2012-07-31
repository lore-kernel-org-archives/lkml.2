Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab2GaWDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 18:03:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59335 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab2GaWDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 18:03:09 -0400
Message-ID: <50185619.5090706@gmail.com>
Date: Tue, 31 Jul 2012 17:03:05 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH v2] gpio: Add Avionic Design N-bit GPIO expander support
References: <1343044770-6591-1-git-send-email-thierry.reding@avionic-design.de> <CACRpkdaZcUvcJMUZTqCEU5FQYhE3EvSSfUEnEx0dYRt-6x5Nig@mail.gmail.com> <20120730074714.GC15245@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120730074714.GC15245@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 02:47 AM, Thierry Reding wrote:
> On Sun, Jul 29, 2012 at 07:13:57PM +0200, Linus Walleij wrote:
>> On Mon, Jul 23, 2012 at 1:59 PM, Thierry Reding
>> <thierry.reding@avionic-design.de> wrote:
>>
>>> This commit adds a driver for the Avionic Design N-bit GPIO expander.
>>> The expander provides a variable number of GPIO pins with interrupt
>>> support.
>> (...)
>>> diff --git a/Documentation/devicetree/bindings/gpio/gpio-adnp.txt b/Documentation/devicetree/bindings/gpio/gpio-adnp.txt
>>> new file mode 100644
>>> index 0000000..513a18e
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/gpio/gpio-adnp.txt
>>> @@ -0,0 +1,38 @@
>>> +Avionic Design N-bit GPIO expander bindings
>>> +
>>> +Required properties:
>>> +- compatible: should be "ad,gpio-adnp"
>>> +- reg: The I2C slave address for this device.
>>> +- interrupt-parent: phandle of the parent interrupt controller.
>>> +- interrupts: Interrupt specifier for the controllers interrupt.
>>> +- #gpio-cells: Should be 2. The first cell is the GPIO number and the
>>> +  second cell is used to specify optional parameters:
>>> +  - bit 0: polarity (0: normal, 1: inverted)
>>> +- gpio-controller: Marks the device as a GPIO controller
>>> +- #interrupt-cells: Should be 2. The first cell contains the GPIO number,
>>> +  whereas the second cell is used to specify flags:
>>> +    bits[3:0] trigger type and level flags
>>> +      1 = low-to-high edge triggered
>>> +      2 = high-to-low edge triggered
>>> +      4 = active high level-sensitive
>>> +      8 = active low level-sensitive
>>
>> Why on earth would a bunch of flags be an "interrupt cell"?
>>
>> Maybe there is something about DT bindings I don't get so
>> please educate me.
>>
>> I can see that OMAP is doing this, but is it a good idea?
>> I really need Rob/Grant to comment on this.
>>
>>> +- interrupt-controller: Marks the device as an interrupt controller.
>>> +- nr-gpios: The number of pins supported by the controller.
>>
>> These two last things look very generic, like something every GPIO
>> driver could want to expose.
> 
> As Arnd mentioned, interrupt-controller is a generic property required
> by all interrupt controller nodes. Perhaps it shouldn't be listed in the
> DT binding for this driver.
> 
> As to the nr-gpios property, this is actually not only for informational
> purposes, but it also allows the driver to be configured to handle any
> number of bits (powers of two). However since this is also a description
> of the hardware it may be useful to make this into a generic property
> for GPIO controllers.
> 
>> I'd really like to have Grant's word on GPIO DT bindings and how these
>> should look, I had some discussion with Wolfram (the I2C maintainer)
>> about bindings turning out less generic than they ought to be, so we
>> need some discussion on this.
>>
>> Arnd recently consolidated some MMC props, maybe we need to do
>> the same for GPIO drivers.

For nr-gpios, I think it is typically not needed. Generally, you will
know how many gpio lines the h/w has based on the compatible string. If
this part really is the same part but different packages with different
numbers of gpio, then this property makes sense. Otherwise, I would say
drop it.

If your goal is how many gpios are you using, you really need a bitmap
instead if you want it to be generic.

IIRC, Tegra also needed this in that they N instances of some number of
bits and the registers are interleaved so they can't have separate nodes.

Rob
