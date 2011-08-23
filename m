Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab1HWMv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 08:51:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38297 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab1HWMvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 08:51:19 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04AEA25368@HQMAIL01.nvidia.com>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
	<201108161509.17157.arnd@arndb.de>
	<CACRpkdaVx=6AJ5DFjVN1ZYQ++hu9pT6WxD9n+pqmYVaCf1xawg@mail.gmail.com>
	<201108161637.16620.arnd@arndb.de>
	<74CDBE0F657A3D45AFBB94109FB122FF04AEA25368@HQMAIL01.nvidia.com>
Date: Tue, 23 Aug 2011 14:51:17 +0200
Message-ID: <CACRpkdY=nVQYnznTU7=_D0n1V1U_xOKH2y75-jKp7k7NzwH8Zw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/13] arm/tegra: Initialize GPIO & pinmux from DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 7:12 PM, Stephen Warren <swarren@nvidia.com> wrote:

> One issue here: There isn't always a single gpio/pinmux parent; as a
> concrete example, the ALSA/ASoC driver for Tegra+WM8903 uses GPIOs both
> from Tegra itself, and from the WM8903 audio codec.

The Ux500 have pinmuxing on the DB8500 and AB8500 - the latter
is a PMIC (&misc) connected to the DB8500 via I2C.

In the pincontrol subsystem I'm brewing, each of these will have
their own pin controller instance and their own struct gpio_chip as
well, so:

DB8500: pinctrl.0, gpio.0
AB8500: pinctrl.1, gpio.1

Each GPIO chip may have it's respective pin controller as parent
I guess, or they may simply be the same struct device * whatdoIknow.

I know this is vaporware, but does this reasoning hold also to
the Tegra+WM8903 combo?

Linus Walleij
