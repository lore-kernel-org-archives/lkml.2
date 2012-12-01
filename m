Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab2LATek (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 14:34:40 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41487 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab2LATei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 14:34:38 -0500
MIME-Version: 1.0
In-Reply-To: <20121126112823.GI12782@gmail.com>
References: <912d88b8906ce87cf5459cf3d5798e03bfce34c7.1353649737.git.viresh.kumar@linaro.org>
	<20121123103400.GO17471@gmail.com>
	<CAKohponW-Wd+Vrnj8mbdFMmJvwQgPq1jFCZRipBFoEhTknStHQ@mail.gmail.com>
	<20121123121413.GB22268@gmail.com>
	<20121123123048.GM5384@localhost.localdomain>
	<20121126112823.GI12782@gmail.com>
Date: Sat, 1 Dec 2012 20:34:37 +0100
Message-ID: <CACRpkda6=UPW+Xy9ztkAtFvCMySt4iR8YabYNNTdnZBpVc98rQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: stmpe: Add DT support for stmpe gpio
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 12:28 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Fri, 23 Nov 2012, Shiraz Hashim wrote:

[About st-norequest-mask]
>> This is a board dependent parameter which just informs gpio driver
>> about pins, which must not be requested. It may happen for a stmpe
>> variant where such gpio pins are multiplexed with some other
>> function.
>>
>> Hence it must be part of DT itself.
>
> Doesn't pinctrl normally handle this kind of stuff?

So this is a signal that something might be strange about the
driver architecture at large.

The datasheet for STMPE1601 says:

"The STMPE1601 offers great flexibility, as each
I/O can be configured as input, output or specific
functions."

Hm hm. Well this driver existed before the pin control
system so we have to live with this. We *could* assume
that the above DT property could be set beacause someone
connected a GPIO to ground and trying to use it
would burn the system or something. But if it's actually
dealing with the sideeffects of pinmuxing it's done in the
wrong place.

Apart from the pinctrl API another way to handle these
beasts is what I do in the drivers/mfd/tps6105x.c,
where the hardware is such that you basically always
nail down the hardware for one specific use case
of 3 possible. Then it's done by configuring the root
MFD device.

The crucial question is: can the STMPE controllers be
used for GPIO, PWM, keypad and touchscreen at the
*same time* or are they nailed to *one* usecase during
electronics design?

Yours,
Linus Walleij
