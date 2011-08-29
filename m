Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab1H2IkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 04:40:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58931 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab1H2IkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 04:40:04 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B24A412A@HQMAIL01.nvidia.com>
References: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B24A3BC0@HQMAIL01.nvidia.com>
	<CACRpkdaZfG4hiGf8vug3EGMRMc0c92xbj=L_HAQcS27DAXYc4Q@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B24A3EDB@HQMAIL01.nvidia.com>
	<CACRpkdbBBaNFETLLcxeCFZoLbdMok7uRi_o-HcbpYdMtRiGFcw@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B24A412A@HQMAIL01.nvidia.com>
Date: Mon, 29 Aug 2011 10:40:03 +0200
Message-ID: <CACRpkdahBjE5cyz5i44BNPi-q=+v+HM1hmgCWszuOFNq6xedSQ@mail.gmail.com>
Subject: Re: [PATCH 1/4 v4] drivers: create a pin control subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        ext Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 7:33 PM, Stephen Warren <swarren@nvidia.com> wrote:

> However, we'd then need a extra table defining what each locality meant:
>
> function locality list_of_pins_in_function_at_locality
> -------- -------- ------------------------------------
> i2c0     0        0, 1
> i2c0     1        2, 3
> (hard-coded into pinmux driver implementation)

I *think* this is what I have implemented in the v5 patch set,
have a look.

> It seems slightly more complex to me to have these two separate tables,
> rather than just iterating over n entries in a single mapping table.

I can deal with it....

> Still, I suppose this an implementation detail. I guess I also need to
> think a little more about how both those models would work with Tegra,
> where special functions are selected at a granularity of pin groups,
> yet GPIO is selected at a granularity of a single pin. Perhaps that
> final table I wrote above (mapping locality to pin list) might also help
> represent Tegra's pin-group- rather than pin-level muxing capabilities...

I have made the assumption that we want to handle groups
of pins, so a certain function in a certain position represents what
the device want to request.

Well, let's look at the code...

Thanks,
Linus Walleij
