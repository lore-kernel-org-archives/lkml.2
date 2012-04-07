Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab2DGSyJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 14:54:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51468 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab2DGSyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 14:54:08 -0400
MIME-Version: 1.0
In-Reply-To: <4F807D41.5000008@antcom.de>
References: <1333497518-25838-1-git-send-email-stigge@antcom.de>
	<20120407035327.9D7923E246E@localhost>
	<4F80460E.50605@antcom.de>
	<CAKON4OxuP6AytcJDtDvbTaho4vFvUTQ0VfJiBnN5QEbK1xo1XQ@mail.gmail.com>
	<4F807D41.5000008@antcom.de>
Date: Sat, 7 Apr 2012 14:54:06 -0400
Message-ID: <CAKON4OyQr+tTDPeb1+01SXbjPKOt3=Lxba5uVpELM9A7sQPVhw@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: Device tree support for LPC32xx
From: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com,
        devicetree-discuss <devicetree-discuss@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 7, 2012 at 1:45 PM, Roland Stigge <stigge@antcom.de> wrote:
> On 07/04/12 19:17, jonsmirl@gmail.com wrote:
>>> Please consider how the groups are specified in
>>> drivers/gpio/gpio-lpc32xx.c. They each have different numbers of lines
>>> and GPIO / GPI / GPO functionality. So they also have different callback
>>> sets, and we need to do separate gpiochip_add()s which leads to the
>>> separate gpio-bank specifications in the dtsi file. Separate enabling of
>>> those banks via OF are a nice by-product.
>>
>> When you have six banks of 32b registers with sparse, active GPIOs in
>> the banks, is there any advantage to saying bank one has 8 gpios, bank
>> 2 has 14, bank 3 has 2, etc in the gpiochip?  Or just just register
>> them as six banks of 32 GPIOs without indicating which are
>> valid/invalid?
>
> I think it is a good idea to only register GPIOs that are real when we
> already have many (~100) instead of registering hundreds of invalid
> extra ones (that will _always_ be invalid for this very driver).

I only want to apply this to identical controller banks. For example
the lpc31xx has 12 identical banks of 32 bits.  You can program all
384 of these locations identically, but only about 100 locations are
actually hooked to real hardware.

We could add something like this to the device tree for gpio-controller:
gpios-valid = <0x1234 0x1234 0x1234 0x1234 0x1234 0x1234 0x1234 0x1234 ...>
12 groups of bits indicating which gpios are valid.

Or we could just ignore the invalid bits. On the lpc31xx they all
work, just just don't do anything.

>
> Also corresponds nicely to the hardware specs when there are banks of
> odd sizes which can be found registered accordingly in the kernel.

I agree that if the structure of the GPIO banks is irregular they
should be different gpiochips.

>
> Roland



-- 
Jon Smirl
jonsmirl@gmail.com
