Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab2GaXWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 19:22:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57428 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2GaXWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 19:22:43 -0400
Message-ID: <501868C0.3090806@wwwdotorg.org>
Date: Tue, 31 Jul 2012 17:22:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        devicetree-discuss@lists.ozlabs.org,
        Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] gpio: Add Avionic Design N-bit GPIO expander support
References: <1343044770-6591-1-git-send-email-thierry.reding@avionic-design.de> <CACRpkdaZcUvcJMUZTqCEU5FQYhE3EvSSfUEnEx0dYRt-6x5Nig@mail.gmail.com> <20120730074714.GC15245@avionic-0098.mockup.avionic-design.de> <50185619.5090706@gmail.com>
In-Reply-To: <50185619.5090706@gmail.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 04:03 PM, Rob Herring wrote:
> On 07/30/2012 02:47 AM, Thierry Reding wrote:
>> On Sun, Jul 29, 2012 at 07:13:57PM +0200, Linus Walleij wrote:
>>> On Mon, Jul 23, 2012 at 1:59 PM, Thierry Reding
>>> <thierry.reding@avionic-design.de> wrote:
>>>
>>>> This commit adds a driver for the Avionic Design N-bit GPIO expander.
>>>> The expander provides a variable number of GPIO pins with interrupt
>>>> support.

>>>> diff --git a/Documentation/devicetree/bindings/gpio/gpio-adnp.txt b/Documentation/devicetree/bindings/gpio/gpio-adnp.txt

>>>> +Required properties:

>>>> +- nr-gpios: The number of pins supported by the controller.

> For nr-gpios, I think it is typically not needed. Generally, you will
> know how many gpio lines the h/w has based on the compatible string. If
> this part really is the same part but different packages with different
> numbers of gpio, then this property makes sense. Otherwise, I would say
> drop it.
> 
> If your goal is how many gpios are you using, you really need a bitmap
> instead if you want it to be generic.
> 
> IIRC, Tegra also needed this in that they N instances of some number of
> bits and the registers are interleaved so they can't have separate nodes.

In the end, I got away without having a separate property to represent
this. Instead, the code keys off the number of interrupts listed in the
interrupts property, there being one interrupt per GPIO bank, and hence
dynamically instantiates the number of banks based on that.
