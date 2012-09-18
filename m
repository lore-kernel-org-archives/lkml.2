Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab2IRSPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:15:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35646 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2IRSPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:15:06 -0400
Message-ID: <5058BA26.20403@wwwdotorg.org>
Date: Tue, 18 Sep 2012 12:15:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Rob Herring <robherring2@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: Describe interrupt-controller binding
References: <1347958274-19425-1-git-send-email-thierry.reding@avionic-design.de> <505876F0.6010809@gmail.com> <50588B6C.6080402@wwwdotorg.org> <20120918180600.GA29360@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120918180600.GA29360@avionic-0098.mockup.avionic-design.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2012 12:06 PM, Thierry Reding wrote:
> On Tue, Sep 18, 2012 at 08:55:40AM -0600, Stephen Warren wrote:
>> On 09/18/2012 07:28 AM, Rob Herring wrote:
>>> On 09/18/2012 03:51 AM, Thierry Reding wrote:
>>>> In order to use GPIO controllers as interrupt controllers,
>>>> they need to be marked with the DT interrupt-controller
>>>> property. This commit adds some documentation about this to
>>>> the general GPIO binding document.
>>>> 
>>>> Cc: Linus Walleij <linus.walleij@stericsson.com> Cc: Grant
>>>> Likely <grant.likely@secretlab.ca> Cc: Rob Herring
>>>> <rob.herring@calxeda.com> Cc:
>>>> devicetree-discuss@lists.ozlabs.org Cc:
>>>> linux-kernel@vger.kernel.org Signed-off-by: Thierry Reding
>>>> <thierry.reding@avionic-design.de>
>>> 
>>> Applied for 3.7.
>>> 
>>> Rob
>>> 
>>>> --- Documentation/devicetree/bindings/gpio/gpio.txt | 33
>>>> +++++++++++++++++++++++++ 1 file changed, 33 insertions(+)
>>>> 
>>>> diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt
>>>> b/Documentation/devicetree/bindings/gpio/gpio.txt index
>>>> 4e16ba4..8d125b0 100644 ---
>>>> a/Documentation/devicetree/bindings/gpio/gpio.txt +++
>>>> b/Documentation/devicetree/bindings/gpio/gpio.txt @@ -75,4
>>>> +75,37 @@ Example of two SOC GPIO banks defined as
>>>> gpio-controller nodes: gpio-controller; };
>>>> 
>>>> +If the GPIO controller supports the generation of
>>>> interrupts, it should +also contain an empty
>>>> "interrupt-controller" property as well as an 
>>>> +"#interrupt-cells" property. This is required in order for
>>>> other nodes +to use the GPIO controller as their interrupt
>>>> parent.
>> 
>> Surely this is generic information for any interrupt controller,
>> and hence doesn't belong in the GPIO binding?
> 
> LinusW requested this in order to avoid having to list these
> properties in every GPIO controller.

There's no need to list this property in an individual GPIO
controller's binding either; it's a standard property for any
interrupt controller of any type.

> I suppose that having it in an extra binding for interrupt
> controllers might make sense as well, but in that case we should
> probably provide a reference because the GPIO binding is where 
> people are most likely to look for this information.

Yes, we probably should have a centralized .txt for the base interrupt
controller properties. I guess we don't today because it's probably so
old everyone assumes it.

For some other patches I sent, I created
Documentation/devicetree/bindings/interrupt-controller/ - a file in
that directory would make sense (bike-shedding: irq.txt, interrupts.txt?)

Yes, each individual GPIO binding (that actually is an interrupt
controller; some may not be) should probably mention this and refer to
whatever documents the interrupt controller properties.

> There is Documentation/devicetree/bindings/open-pic.txt, which
> already lists most of this information, so maybe a reference to
> that document will do just as well?

I think that's just one random interrupt controller. The common/core
properties probably should be separated out.

>>>> +If #interrupt-cells is 1, the single cell is used to specify
>>>> the number +of the GPIO that is to be used as an interrupt. 
>>>> + +If #interrupt-cells is 2, the first cell is used to
>>>> specify the number +of the GPIO that is to be used as an
>>>> interrupt, whereas the second cell +is used to specify any of
>>>> the following flags: +  - bits[3:0] trigger type and level
>>>> flags +      1 = low-to-high edge triggered +      2 =
>>>> high-to-low edge triggered +      4 = active high
>>>> level-sensitive +      8 = active low level-sensitive
>> 
>> That certainly shouldn't be in the generic GPIO binding; the
>> format of the interrupt specifier is determined by the binding
>> for the individual device that is the interrupt controller. Just
>> because a device is also a GPIO controller doesn't mean that it
>> has to conform to a specific format for the interrupt specifier.
> 
> I think it does make sense to provide a description of the most
> commonly used variants. The above certainly is what the majority is
> using and many of those that do not use one of the predefined
> irq_domain_xlate_*() functions reimplement them with some
> additional checks or conversions.

OK, but the document can't say "this is how the IRQ specifier is
formatted", when it clearly isn't generally true.

The document should say that the format of the IRQ specifier is
entirely determined by the individual binding, but that bindings may
often choose to re-use the following common format. Each individual
binding would then need to document whether it did choose to use that
common format, or whether it instead chose something custom.
