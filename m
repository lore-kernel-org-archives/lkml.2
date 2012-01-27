Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab2A0NLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 08:11:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63486 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab2A0NLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 08:11:44 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB45E@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
	<20120116182808.GG4223@ponder.secretlab.ca>
	<20120118141329.GA22818@atomide.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1780DAAEBB@HQMAIL01.nvidia.com>
	<20120119105728.GE22818@atomide.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1780DAB45E@HQMAIL01.nvidia.com>
Date: Fri, 27 Jan 2012 14:11:43 +0100
Message-ID: <CACRpkdaRePot9qt-z3Chk-GHqHDfyu07ojKfGA2HEXxvjKn=Vg@mail.gmail.com>
Subject: Re: Pinmux bindings proposal
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@secretlab.ca>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 9:50 PM, Stephen Warren <swarren@nvidia.com> wrote:

> For Tegra20 (and IIRC some other HW), the pin mux HW actually muxes
> groups of pins; one register field sets n (1, 2, 3, ...) pins to that
> function at once. Hence, the entries are real physical groups.

Maybe I am getting things wrong, but I've read:

http://en.wiktionary.org/wiki/real
http://en.wiktionary.org/wiki/virtual

And now I am trying to address this from my understanding of
"real" as defined in clause 1:

"1. That has physical existence.
    No one has ever seen a real unicorn."

And "virtual" as defined in clause 3:

"3. Of something that is simulated in a computer or on-line.
    The virtual world of his computer game allowed character interaction."

Please tell me if I have the wrong definitions in my
head, I am not trying to play smart, I just want to understand
why this rubs me the wrong way. So:

On the Nomadik GPIO controller (not yet migrated to the pin
control subsystem, mea culpa) pins 0,1,2,3 can be used for UART0.

These four pins can also be used for GPIO, and two other
functions.

Does that make the group UART0 = {0,1,2,3} a virtual group
in sense (3) of the wiktionary article, i.e. "simulated in a
computer"?

To me: no, not at all.

Because it is a very real physical property of these pins that
UART0 can *only* appear on these 4 pins, not 4 other pins.
It is clear from the data sheet.

And even if they could appear on other pins, the number of
such appearances would be limited by physical factors, and
UART0_1 = {0,1,2,3} vs UART0_2 = {4,5,6,7} wouldn't
make it virtual. This is also a physical property, not simulated or virtual.

The *only* case where I could *maybe* accept the "virtual"
terminology would be for a phone-exchange type of
pinmux, where say this UART could appear on any 4 pins,
arbitrarily chosen. Still this is not fully virtual since it is
a physical fact that the UART group has to have 4 pins,
not 1, not 17.

Notice that I don't involve the use of that group on a
specific board in this argument, since the *silicon* limits the
muxable properties of this group, and it is a very real
group of pins.

This is why I think it is a bad idea to try to define pins as
being in a "real" or "virtual" group like this, where the only
criteria for that terminology is whether each pin has its own
control register or not.

I'm all happy with "Tegra type groups" and "Tegra type pins"
or "groups with separate control registers" or "pins with
separate control registers" which tells us what it really is,
"real" or "virtual" does not fit our discussion here the way
I see it.

Yours,
Linus Walleij
