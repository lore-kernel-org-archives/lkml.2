Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422676Ab2KAMHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 08:07:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51959 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165Ab2KAMHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 08:07:17 -0400
Date: Thu, 1 Nov 2012 12:07:14 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121101120713.GA4413@opensource.wolfsonmicro.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121024161429.GA16350@core.coreip.homeip.net>
 <CACRpkdai3NocZQnW6YRF+k6GXUSx3P_Ge=F-tkuivrFm6tBbLg@mail.gmail.com>
 <4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
 <CACRpkdaiLXVeUg1quuw3XPTenbKOjn+aWbGQezpcyvzQCtCWow@mail.gmail.com>
 <20121030113407.GA24335@sirena.org.uk>
 <CACRpkdapQJY0aoam741O0fb8EeM9BLk_Psq5TaPG84J7wEvCLw@mail.gmail.com>
 <87obji8kta.fsf@deeprootsystems.com>
 <CACRpkdbCk9+HSBPtfT-1dO8paSRYJ5VXX_0SxiyxgrObnJEvmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <CACRpkdbCk9+HSBPtfT-1dO8paSRYJ5VXX_0SxiyxgrObnJEvmQ@mail.gmail.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 01, 2012 at 09:54:00AM +0100, Linus Walleij wrote:

> Well, the pinctrl grabbers in these drivers are using these states also
> for platforms that do not even select CONFIG_PM.  For example
> mach-nomadik is quite happy that the PL011 driver is thusly
> muxing in its pins. And would require refactoring to use PM
> domains.

> So basically this requirement comes down to:

> - When dealing with a SoC IP block driver

> - That need to multiplex pins

> - Then your SoC must select CONFIG_PM and
>   CONFIG_PM_RUNTIME and
>   CONFIG_PM_GENERIC_DOMAINS and implement
>   proper domain handling hooks.

> Is this correct? And for Mark, Dmitry, does this correspond to
> your view?

For the pin hogging I'd actually been thinking separately that we should
just have the device core do a devm_pinctrl_get_set_default() prior to
probing the device and store the result in the struct device.  That
would immediately remove almost all of the current pinctrl users, users
that do need to do things with the data or check the result can then
pick up the pinctrl pointer from the device struct.

> It's actually something that needs to be acknowledged by the
> ARM SoC maintainers, because they will be the ones telling
> all subarch maintainers to go implement full PM handling
> with these three frameworks whenever an SoC driver want
> to handle pins.

Well, they're going to have to implement it somewhere anyway - either in
the drivers or in the SoC stuff.

> And IIUC not only pins but also silicon block clocks?

> I can surely fix these for "my" systems, but it really needs
> to be enforced widely or it will be a mess.

We definitely need to decide if it's something that should be open coded
everywhere.

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkmXfAAoJELSic+t+oim9lv8P/RcG5AERpmiuXndh99c9UqA0
SJQ3PWKgXJcYCt18PwEaGeHls72+KOZntEX5FtpGG4g2V3prtkg9PWCAaL8Ae8Ix
yuo1GRAQai0nRYg1FIDJk/eU7CJPS30HF0XWO8DqH2flTOM9dwWICpX11AYC2Ye3
4FNUNhEvYB0yMLbjfW3udWbAe9jheEPvVDQu9l83o9/Eo6Mm/trwrWeKKntN2lcZ
fezka4KfLguIaTUSAP73f1P7+l20T3hQdmjxPrw2mTru3l9WUa/YCkpt4nAW9xn0
JMxWTN02CAIB8IERChxxe/ZpEiCIE9PYFc8XE5Gop1DMiLv3sZUZOoUjV+QxX/lP
ADi48Bu40wa5JtKGyrb63GnhlgmJad16JbxjW+EXfqX6iL5QmyYqv5QxhVuHocPD
BZUoWM0UhWqFbSasXd8BDzzVYqrVzIMXtnDujAyHiJ9BB2yM46rGpzMwsTMyOwHe
QeB/4tU++q46+SmTJ0RIW2Pe1/HWcL2j5rWfmfbS6x5n95feB8jNG3TV0nd5XpeT
NFpOsHccqguNItcsZFf40+QfAvTOo4QugmfX4E/Gv0TXlidyYUKsixOAUXDozl/p
/DeRth8rqDMxMWlKG+eJ1QuEYJsNILdrFjSmFxERVpEQ0LoHH+GVPr5gG8rLnBpd
Mw4PqP9BsygEMB5b6uWU
=B8ef
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
