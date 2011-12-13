Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1LMAlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 19:41:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62499 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab1LMAlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 19:41:05 -0500
MIME-Version: 1.0
In-Reply-To: <20111212143750.GA27267@pengutronix.de>
References: <1323384057-31452-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<74CDBE0F657A3D45AFBB94109FB122FF1750B77BD8@HQMAIL01.nvidia.com>
	<20111209010147.GH7913@S2100-06.ap.freescale.net>
	<4EE18403.30604@nvidia.com>
	<20111209043220.GJ7913@S2100-06.ap.freescale.net>
	<4EE192DC.3080209@nvidia.com>
	<20111209051413.GK7913@S2100-06.ap.freescale.net>
	<20111209110807.GG27267@pengutronix.de>
	<CACRpkdYpq1phHTTLy875xSr-upiW5BmvKMPO_d-niG+-J14t9w@mail.gmail.com>
	<20111212143750.GA27267@pengutronix.de>
Date: Tue, 13 Dec 2011 01:41:05 +0100
Message-ID: <CACRpkdZz=1xf19feiO8SkzGr=x6ntaNzSwiCjyYmOrz0Z33phA@mail.gmail.com>
Subject: Re: [PATCH] [RFC] pinctrl: add a driver for Energy Micro's efm32 SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@freescale.com>, Stephen Warren <swarren@nvidia.com>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 3:37 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Sat, Dec 10, 2011 at 01:18:43AM +0100, Linus Walleij wrote:
>> On Fri, Dec 9, 2011 at 12:08 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>>
>> > Drivers should not be bothered with pin muxing *at all*.
>>
>> Not if they are simple. Like - set them up once and for all and
>> then forget about it.
>>
>> It gets problematic when we get to sleep states and the system
>> need to reconfigure all pins on say idle or deep sleep.
>
> If you need to reconfigure your pins in deep sleep and you control
> the pins in the driver this seems to suggest that your device won't
> suspend properly if the driver is not loaded?

In our case (ux500) it's more like all pins have a defined nice
state for active, sleep and idle. (Pull-ups, downs, wakeups etc
set in a certain way.)

Then there are some real agressive stuff PM people start to do.
Some of them require you to shut down things in a certain
sequence, like this device has to have its pins turned off first,
the clock released, then regulator, etc. And others do it in the
reverse order, or any order.

If all your hardware was engineered the
same way with this in mind it could probably be done
centrally, like the nice stuff Magnus Damm has for managing
clocks in drivers/base/power/clock_ops.c for all SHmobile
clocks. Would be real nice if it worked for us, sadly not all
hardware is designed in such a consistent way.

For our hardware it's better to spread it out across the
drivers and then consolidate once we have the entire
picture, I'm afraid. For others it will be different, maybe
your systems will never need it and you can keep all in
central places.

Linus Walleij
