Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab1LGJBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:01:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60758 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab1LGJBN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:01:13 -0500
MIME-Version: 1.0
In-Reply-To: <20189.50504.375779.311903@ipc1.ka-ro>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
	<1322999384-7886-2-git-send-email-b29396@freescale.com>
	<CACRpkdaYz+-nZA6atxA+5kvWOO84YeSHQPNiojq_R4zkHUGz3Q@mail.gmail.com>
	<20111205211838.GG27267@pengutronix.de>
	<20111206062500.GA3649@S2100-06.ap.freescale.net>
	<20189.50504.375779.311903@ipc1.ka-ro>
Date: Wed, 7 Dec 2011 10:01:13 +0100
Message-ID: <CACRpkdY43PuU50nZxd4TMqj5T+4ZOGXOhOsOKOKNQ-wA_qUgaA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] pinctrl: imx: add pinmux-imx53 support
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@karo-electronics.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc: linus.walleij@stericsson.com, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Dong Aisheng <b29396@freescale.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 8:33 AM, Lothar Waﬂmann <LW@karo-electronics.de> wrote:
> Shawn Guo writes:
>> On Mon, Dec 05, 2011 at 10:18:38PM +0100, Sascha Hauer wrote:

>> > This brings me to the point that currently we have the pins described as
>> >
>> > #define MX53_PAD_<name>__<function>
>> >
>> But that's also the reason why we have so many lengthy iomux-mx*.h on
>> imx. †Taking iomux-mx53.h for example, it's a 109K header with 1219
>> LOC, but probably only 10% of the definitions will actually be used.
>>
> Which has the benefit of having correct pin definitions for everyone
> to use. If developers who need to use currently unused pindefs have to
> create them on their own, there will always be a good chance in
> getting them wrong.
>
>> > which means that you don't have to look into the datasheet to get the
>> > different options for a pin
>>
>> Looking at the datasheet when we write code is a pretty natural thing
>> to me.
>>
> The pindefs are like interrupt numbers or IO addresses for which there
> also is a complete list of definitions in the kernel no matter whether
> they are actually all in use.

In both cases I'd say it's not the business of the pin control
implementation to worry about size of .h files in arch/arm/*

Getting rid of such defines and board data is the business of the
device tree and nothing else, if I understand the way people are
thinking about this.

So I would prefer to keep these two concepts separate:
1) get something in place that integrates nicely with pinctrl
2) get device tree in place
3) get rid of old board files and huge .h define lists including
   I/O, irqs, pinmux lists...
4) ...
5) profit

So don't try to solve all things at once or you'll end up trying
to drink the ocean.

Yours,
Linus Walleij
