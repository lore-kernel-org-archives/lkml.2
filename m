Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab1HRGXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 02:23:18 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10981 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab1HRGXP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 02:23:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 17 Aug 2011 23:22:19 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
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
Date: Wed, 17 Aug 2011 23:22:16 -0700
Subject: RE: [RFC PATCH v2 00/13] arm/tegra: Initialize GPIO & pinmux from DT
Thread-Topic: [RFC PATCH v2 00/13] arm/tegra: Initialize GPIO & pinmux from
 DT
Thread-Index: Acxc0CITA8qn+5rqS065qJKkqs2QRgAnX6qA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04AF6F3062@HQMAIL01.nvidia.com>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
 <201108161637.16620.arnd@arndb.de>
 <74CDBE0F657A3D45AFBB94109FB122FF04AEA25368@HQMAIL01.nvidia.com>
 <201108171323.38441.arnd@arndb.de>
In-Reply-To: <201108171323.38441.arnd@arndb.de>
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

Arnd Bergmann wrote at Wednesday, August 17, 2011 5:24 AM:
> On Tuesday 16 August 2011, Stephen Warren wrote:
> > One issue here: There isn't always a single gpio/pinmux parent; as a
> > concrete example, the ALSA/ASoC driver for Tegra+WM8903 uses GPIOs both
> > from Tegra itself, and from the WM8903 audio codec.
> >
> > I could imagine the same being true in basically any case where one
> > device uses N GPIOs (e.g. SD controller with power, change-detect,
> > and read-only GPIOs; some could easily come from the SoC and some
> > from a GPIO expander).
> >
> > I'm not quite so sure that multiple parents would be useful for pinmux,
> > but I wouldn't say that it was impossible...
> 
> Hmm, how common do you think the example is?
> 
> It it's just a very rare case, we can still special-case it by
> introducing fake subdevices for the Tegra+WM8903 driver, each of
> which has only one gpio-parent. This is ugly but keeps the special
> case to the rare devices.
> 
> If we can expect more than a handful of these, we probably need
> a better design for the binding, which will cause a burden for
> all drivers.

It looks like DT already supports the generic case for GPIO; each GPIO
reference is of the form:

<&gpio 69 0>

and so each GPIO has a "parent" specified, and hence can come from a
different controller.

For drivers, this is all completely hidden by of_get_gpio().

I imagine we'd just use the same pattern for pinmux. This would both
support the general case, and end up being consistent with how GPIOs
already work, so this seems like a win both ways.

-- 
nvpublic

