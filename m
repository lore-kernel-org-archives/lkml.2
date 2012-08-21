Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2HUJud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:50:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36081 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753593Ab2HUJua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:50:30 -0400
Date: Tue, 21 Aug 2012 10:50:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 5/8] mfd: Provide the PRCMU with its own IRQ domain
Message-ID: <20120821095026.GU26991@opensource.wolfsonmicro.com>
References: <CACRpkdZ7bMBytyDppV2sB1d1sUbDpPRqAQVOq8k4UOYdmg+Mkw@mail.gmail.com>
 <201208140942.54773.arnd@arndb.de>
 <CACRpkdYbOBEPNbCdfi+=gupdqS8_7t7MpOgXs7VCVTs8Y3j_mQ@mail.gmail.com>
 <20120820083640.GH8450@gmail.com>
 <20120820121055.GA26991@opensource.wolfsonmicro.com>
 <20120820125531.GA20242@gmail.com>
 <20120820162923.GF26991@opensource.wolfsonmicro.com>
 <20120820164949.GB22749@gmail.com>
 <20120820175155.GH26991@opensource.wolfsonmicro.com>
 <20120821085618.GA26899@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p8mP+8RrBGerSNjm"
Content-Disposition: inline
In-Reply-To: <20120821085618.GA26899@gmail.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p8mP+8RrBGerSNjm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 09:56:19AM +0100, Lee Jones wrote:

> Wherever we do this from to be able to obtain the IRQ domain pointer,=20
> which is where I'm currently struggling. Our options are:

> - If we're only talking MFD here, we can handle this stuff in the MFD
> core, but we need more information. The IRQ domain subsystem only allows
> domain look-up via a Device Tree node, so we need to get our hands on

What makes you say this?  This is just a convenience for finding a
domain, irqdomains are *completely* indepentant of device tree.

> the domain another way in the case of non-DT enabled devices. Either we
> add another parameter to mfd_add_device(irq_domain, ...), or we
> standardise the 'irq_domain' variable name and use:
>         irq_domain =3D container_of(parent, struct irq_domain, irq_domain=
);

Passing the domain into mfd seems like the obvious solution here - it's
exactly what we currently do for legacy stuff (where we pass in the irq
base), ideally what we'd end up with over time is that we could just
remove the irq_base parameter entirely as everything would in time be
moved over to using irqdomains.

> - I know that you have interest in pushing the functionality into the
> IRQ domain subsystem, but I'm struggling to see how. It's calling into
> the IRQ domain where we're seeing issues in the first place, specifically
> irq_create_mapping(). How about if we passed 'irq_domain' as a parameter
> when requesting the IRQ? That way we can pass the correct IRQ without
> worry of conversion. If 'irq_domain' is !NULL the IRQ management subsystem
> can do the necessary conversions. If 'irq_domain' is NULL it continues to
> use the requested IRQ as a virq.

This is totally orthogonal to doing the mapping in the MFD subsystem
which is the issue here.

--p8mP+8RrBGerSNjm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM1lxAAoJEFJkBDiqVpZ4XkYP/A7wGs6Xb/QDFr5gO5vdJS0E
vKHfuwby+28TvghgZOfvvg5Vz35mMbsSeYlbjDjO4QIB/izhAi/6d1XNXTvzTEdG
r3lkIATXP2wQzP1m59FFxQbm6NAYFftDqE/AIJ/8M7SuUwWXb0ad3DGeczVXUiUq
hrj58X+9TWPELwi4Yurux134Y6XJtM7y10ZwKqXTXPCAjfaTeNI3VDUj8cMrd8U7
KtFpLuh9VORYTqP2JGCwKtxp0+f01BOwqRp4i/uAAja2sOW5k/w51yHlykAGUEKm
tv3OBYTFKrnZOsooMdpgNTVKxHE4DiAlGmvPvE1Aj+r1b+qfn5jsFQMoLPwbsJXK
8TMtefRsh8C72Ot47DBsiwCUBpHEru3zbSok2tRKZzrff2BZRXtmr7Fdm1qs0Qzm
yptFTBoM1vgryP8xXq1iTgKV649gNRulUifIHHmo5mgXyUPmclNioGQgPi64jTlO
BzKf0mqb1qUgj7bgNrK/L/ietX/L8KWDEMoRlgDwfsOu6nD/2HeJ5UrlmrZSOr6t
4aPPHjMD/vBCsRwodelRNv9ZS6DDhJKnp2dgr8aTOpa3xg6KqyoHo0W9ypRc6dL9
qxG5/mmN7mj3ItgyN/gZgMQOHhYKBijg/a6bP4Bjw4a0ACGZB6u6euNM3aHByzY/
UsOE2G6utp5DTq4jwaZ1
=raN0
-----END PGP SIGNATURE-----

--p8mP+8RrBGerSNjm--
