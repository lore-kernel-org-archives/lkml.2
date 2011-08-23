Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1HWSu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:50:29 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4314 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab1HWSuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:50:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 23 Aug 2011 11:49:58 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>,
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
Date: Tue, 23 Aug 2011 11:49:56 -0700
Subject: RE: [RFC PATCH v2 00/13] arm/tegra: Initialize GPIO & pinmux from DT
Thread-Topic: [RFC PATCH v2 00/13] arm/tegra: Initialize GPIO & pinmux from
 DT
Thread-Index: Acxhk1p7XP+Iyx1dSairtd6oqLK+4gAMYQag
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B24A38E6@HQMAIL01.nvidia.com>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
	<201108161509.17157.arnd@arndb.de>
	<CACRpkdaVx=6AJ5DFjVN1ZYQ++hu9pT6WxD9n+pqmYVaCf1xawg@mail.gmail.com>
	<201108161637.16620.arnd@arndb.de>
	<74CDBE0F657A3D45AFBB94109FB122FF04AEA25368@HQMAIL01.nvidia.com>
 <CACRpkdY=nVQYnznTU7=_D0n1V1U_xOKH2y75-jKp7k7NzwH8Zw@mail.gmail.com>
In-Reply-To: <CACRpkdY=nVQYnznTU7=_D0n1V1U_xOKH2y75-jKp7k7NzwH8Zw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Tuesday, August 23, 2011 6:51 AM:
> On Tue, Aug 16, 2011 at 7:12 PM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > One issue here: There isn't always a single gpio/pinmux parent; as a
> > concrete example, the ALSA/ASoC driver for Tegra+WM8903 uses GPIOs both
> > from Tegra itself, and from the WM8903 audio codec.
> 
> The Ux500 have pinmuxing on the DB8500 and AB8500 - the latter
> is a PMIC (&misc) connected to the DB8500 via I2C.
> 
> In the pincontrol subsystem I'm brewing, each of these will have
> their own pin controller instance and their own struct gpio_chip as
> well, so:
> 
> DB8500: pinctrl.0, gpio.0
> AB8500: pinctrl.1, gpio.1

Makes sense to far.

> Each GPIO chip may have it's respective pin controller as parent
> I guess, or they may simply be the same struct device * whatdoIknow.

I'm not clear on why the GPIO and pinmux would have any kind of parent
relationship. Perhaps that's how your HW is designed. In Tegra, GPIO
and pinmux are completely separate HW blocks without much of a defined
relationship.

I can certainly see both being implemented by the same code if it makes
sense to do so. On Tegra, I think I'd still lean towards keeping them
as separate devices, since they have separate register spaces and are
documented separately etc. However, I can certainly see that other HW
might have both sets of functionality in one HW block.

> I know this is vaporware, but does this reasoning hold also to
> the Tegra+WM8903 combo?

-- 
nvpublic

