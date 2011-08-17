Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab1HQLXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 07:23:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53722 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab1HQLXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 07:23:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@nvidia.com>
Subject: Re: [RFC PATCH v2 00/13] arm/tegra: Initialize GPIO & pinmux from DT
Date: Wed, 17 Aug 2011 13:23:38 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
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
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com> <201108161637.16620.arnd@arndb.de> <74CDBE0F657A3D45AFBB94109FB122FF04AEA25368@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04AEA25368@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108171323.38441.arnd@arndb.de>
X-Provags-ID: V02:K0:XCmy56cr3AvzV9LmY+LVEjxdPSV9bCKOPAtfGnf0BOn
 TZDQQUL/P9v16HdKCyrC/SIacKqUG8rYpmcuC1tTdXGhuHU/9l
 AzLFI5Y/pESXW6dGKahsDMseIimuYTG7W9qXtpkEVxmDcQct2j
 1vFyMaBsw8CD1Ngj5fewGjDKpe4mNBh9Rwa7jOhlEE6IWd6ORJ
 YW0HuKbTs8NEm7GjGpAmg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 August 2011, Stephen Warren wrote:
> One issue here: There isn't always a single gpio/pinmux parent; as a
> concrete example, the ALSA/ASoC driver for Tegra+WM8903 uses GPIOs both
> from Tegra itself, and from the WM8903 audio codec.
> 
> I could imagine the same being true in basically any case where one
> device uses N GPIOs (e.g. SD controller with power, change-detect,
> and read-only GPIOs; some could easily come from the SoC and some
> from a GPIO expander).
> 
> I'm not quite so sure that multiple parents would be useful for pinmux,
> but I wouldn't say that it was impossible...

Hmm, how common do you think the example is?

It it's just a very rare case, we can still special-case it by
introducing fake subdevices for the Tegra+WM8903 driver, each of
which has only one gpio-parent. This is ugly but keeps the special
case to the rare devices.

If we can expect more than a handful of these, we probably need
a better design for the binding, which will cause a burden for
all drivers.

	Arnd
