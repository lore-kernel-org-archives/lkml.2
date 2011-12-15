Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab1LOI0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 03:26:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49366 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758380Ab1LOI0k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 03:26:40 -0500
MIME-Version: 1.0
In-Reply-To: <20111215070505.GA22541@S2101-09.ap.freescale.net>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
	<1323878622-26602-5-git-send-email-b29396@freescale.com>
	<20111214211152.GM27267@pengutronix.de>
	<CACRpkdYHtgx3Qgx4QRdgOahQXjvSWE_iogWCZjaYQ-VnyS62uQ@mail.gmail.com>
	<20111215070505.GA22541@S2101-09.ap.freescale.net>
Date: Thu, 15 Dec 2011 09:26:40 +0100
Message-ID: <CACRpkdbN26q1_d4tPkJp4f4_KdvoEEk9uCCRyOfEU97DOWAnEw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Dong Aisheng <b29396@freescale.com>,
        linus.walleij@stericsson.com, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 8:05 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
>[Me]
>> So if you want to do this for i.MX you need something like
>> selectable dummy pinmuxes, i.e. pinmux_get() to return something
>> that just say "OK" to everything like the dummy regulators.
>>
>> Shall I try to create something like that?
>>
> Isn't the empty functions defined in include/linux/pinctrl/pinmux.h
> for this purpose?

No, these are for compiling it *out*, dummy pinmuxes would
be if you compile it *in*, but don't find an apropriate pinmux,
you still get something that does nothing and still works.

Dummy regulators work exactly this way.

> It does not solve the problem with single image.

I think it does.

> You might probably mean that we create a dummy_pinctrl_desc and register
> it to pinctrl core with pinctrl_register() if we detect that the kernel
> is running on a soc that has no pinctrl support?

No. You have a #ifdef CONFIG_PINMUX_DUMMY in pinmux_get()
that makes sure you return a working no-op pinmux handle even
though there is no real pinmux behind it.

> This is not a problem to pinctrl migration only.  We have the same
> problem with common clk migration.  Unless we migrate imx3, imx5 and
> imx6 to common clk at the same time, single image build just does not
> cope with clk_* api.

And  you could have the same problem with regulator migration...
Luckily dummy regulators saves you in that case.

Thanks,
Linus Walleij
