Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab1HPOpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 10:45:45 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48468 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab1HPOpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 10:45:43 -0400
MIME-Version: 1.0
In-Reply-To: <201108161637.16620.arnd@arndb.de>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
	<201108161509.17157.arnd@arndb.de>
	<CACRpkdaVx=6AJ5DFjVN1ZYQ++hu9pT6WxD9n+pqmYVaCf1xawg@mail.gmail.com>
	<201108161637.16620.arnd@arndb.de>
Date: Tue, 16 Aug 2011 16:45:42 +0200
Message-ID: <CACRpkdZydMLj5qzbth=tEW9P8p0rrXEzHM2frebsWcDzCJLq8w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/13] arm/tegra: Initialize GPIO & pinmux from DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 4:37 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 16 August 2011, Linus Walleij wrote:
>> Say mmc instance 0 need pingroup foo on pincontroller bar
>> means that there must be a specific reference from mmc.0:s
>> struct device * to pinctrl bar:s struct device *. Maybe this is
>> peanuts in DT, sorry not enough insight.
>
> I think what you are looking for is the equivalent of the
> interrupt-parent property for pinmux. The idea is that each
> node in the device tree can point to a device managing the
> pinmux, so reference would point to a local number in that
> space. We have discussed this for the GPIO case already, and
> I suspect that the two should be identical (gpio-controller
> and pinmux-controller using the same device node and same
> property to refer to them).

Yes. I discussed with Grant and his idea is for e.g.
advanced combined pincontrol + GPIO blocks that handle
a lot of stuff like muxing, biasing and GPIO, to expose
a single pinctrl device that in turn provide also a gpio_chip
in addition to the pinctrl interfaces so tehy should be
all on the same struct device *

> Since the pinmux-parent
> (gpio-parent, ...) property gets inherited by all child
> devices, you only need to set it once at the root of the
> device tree for the simple case where there is only one
> controller.

This will likely be the case for most of the advanced muxes
I know of, OMAP, Tegra and Nomadik.

Thanks,
Linus Walleij
