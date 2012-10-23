Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab2JWKph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:45:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37410 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab2JWKpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:45:35 -0400
MIME-Version: 1.0
In-Reply-To: <20121023102903.GA24820@arwen.pp.htv.fi>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
	<20121022155028.GA13791@core.coreip.homeip.net>
	<CACRpkdaQ1WfRWrx=RXMVkeFtwdERJsOpVa3DaXBTU2KZdgqhRQ@mail.gmail.com>
	<508664CA.7000601@ti.com>
	<CACRpkdbhCS-Vb0DtbTZQ_Zw_8SOh3Bqutme3Y2-QrxNqvMiNNw@mail.gmail.com>
	<20121023100333.GA24418@arwen.pp.htv.fi>
	<20121023122312.56b23e1c@skate>
	<CACRpkdb+f44jw1vTYvJT0bnMOP8XQe8ztDUHiwtS2JHtPWAGXw@mail.gmail.com>
	<20121023102903.GA24820@arwen.pp.htv.fi>
Date: Tue, 23 Oct 2012 12:45:33 +0200
Message-ID: <CACRpkdZhUwMTg0suqbZiukN7Se6fzdYP3-0Dspm9WF6qZniNVQ@mail.gmail.com>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: balbi@ti.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Magnus Damm <damm@opensource.se>,
        Paul Mundt <lethal@linux-sh.org>, Benoit Cousson <b-cousson@ti.com>,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Sourav Poddar <sourav.poddar@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 12:29 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Oct 23, 2012 at 12:29:28PM +0200, Linus Walleij wrote:

>> So the biggest implementation of the notifier approach to resource
>> handling is the SH clock thing:
>> drivers/base/power/clock_ops.c
>
> that's different right ? It's just creating the list of clocks, device
> drivers still have to call pm_clk_add().
>
> That's ok, I guess, otherwise all struct device would allocate memory
> which hardly ever used (so far).

Hm so I have had this idea of runtime PM core helping out
with pins, so I could add something like

pm_pins_fetch()
pm_pins_default()
pm_pins_idle()
pm_pins_sleep()

So if one is using the pin states defined in <linux/pinctrl/pinctrl-state.h>
then the PM core can help out in keeping track of the pins
and states, and the driver will just tell the PM core what
to do and when.

Would this fit the bill for everyone's code consolidation needs?
It would sure work for us...

It however require that no custom states are used and that we
keep to the state semantics I just happen to think is most
common.

Yours,
Linus Walleij
