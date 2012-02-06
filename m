Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab2BFEVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 23:21:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54569 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab2BFEVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 23:21:00 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF178E5D3160@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF178E5D3160@HQMAIL01.nvidia.com>
Date: Mon, 6 Feb 2012 05:20:59 +0100
Message-ID: <CACRpkdahin4srDh7dphgvq306gjz7CGP=h4dVkUY+w0z0wpXRQ@mail.gmail.com>
Subject: Re: An extremely simplified pinctrl bindings proposal
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Dong Aisheng <dongas86@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "ext Tony Lindgren (tony@atomide.com)" <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 5, 2012 at 6:31 AM, Stephen Warren <swarren@nvidia.com> wrote:

> Sorry, I haven't had a chance to read any of the pincrl emails from
> Friday onwards. However, I thought a bit more about this, and decided
> to propose someting much simpler:

I think this approach is quite interesting, but since it removes more
or less all semantic meaning of the pinctrl system, I don't see why
it would be a pinctrl rewrite at all or called pinctrl, rather it'd be
something new and separate, since it could (if I understand
correctly) very well be used to configure things that are totally
unrelated to pin control, could it not?

It is indeed described as "little more than a system to execute a
list of arbitrary register writes".

For example it could be readily used to set up the config registers
of parameters in an external memory controller - these are also a lot
of magic writes into various registers, nobody really knows what they
actually do, timings for access and whatnot.

Incidentally external memory controllers is another things that
is usually magically reconfigured at idle/sleep and on the way
back up.

Can we defined it then as controlled register processing at
determined points, some during boot, some at runtime, and
maybe tied to certain devices at certain points in time?

A controlled set of register read/writes and maybe also conditionals
(if that bit is 1, do this, else do that, plus a loop command to wait
for a flag or similar) are known as a "jam tables" and usually used
in BIOSes to do a compact machine initialization. I learned this term
in Bunnie Huang's "Hacking the Xbox, where he describes finding a
jam table interpreter in the Xbox ROM.

So if I understand the proposal correctly it would fit nice as
drivers/jamtable or so, and could do that kind of control of whatever
hardware you want to control with opaque register accesses,
then reflect it as raw register contents in debugfs etc.

If it turns out everyone is happy with that and we can move other
drivers over to it we can just scrap pinctrl, or have it only for those
systems that want a semantic representation.

While I would probably mourn the death of sematics I also see
that if the goal is to get huge static data sets out of the kernel,
something like this may be the best way to get there.

Thoughts?
Linus Walleij
