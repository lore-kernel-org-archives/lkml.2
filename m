Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab2EaIU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:20:26 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:46684 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751301Ab2EaIUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:20:22 -0400
Date: Thu, 31 May 2012 11:18:42 +0300
From: Felipe Balbi <balbi@ti.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC PATCH] clk: add extension API
Message-ID: <20120531081841.GG5377@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
 <4FC5DFCF.1020606@codeaurora.org>
 <20120531075125.GL8026@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MiFvc8Vo6wRSORdP"
Content-Disposition: inline
In-Reply-To: <20120531075125.GL8026@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MiFvc8Vo6wRSORdP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 31, 2012 at 10:51:25AM +0300, Peter De Schrijver wrote:
> On Wed, May 30, 2012 at 10:52:31AM +0200, Stephen Boyd wrote:
> > On 5/29/2012 2:58 AM, Peter De Schrijver wrote:
> > > Add an extension API for clocks. This allows clocktypes to provide ex=
tensions
> > > for features which are uncommon and cannot be easily mapped onto norm=
al clock
> > > framework concecpts. eg: resetting blocks, configuring clock phase et=
c.
> >=20
> > This seems rather generic. Why not add more specific APIs/concepts like
> > clk_reset(), clk_set_phase(), etc.? If they don't map, maybe we should
> > make them map.
> >=20
>=20
> Some of those might be very SoC specific. Eg OMAP doesn't need software
> controlled modulereset. I don't think we should add a new function to the

it depends on what you call modulereset. We have soft-reset logic hidden
under the hood, it's done before device creation, so drivers (most of
them) assume we're probe with the IP in reset state.

What I wonder most is if this should be done at the clock level or at
the device level. In the end you reset the IP block, not the clock,
right ?

> clock framework for clock related features which only exist in a single
> SoC or family. Ideally we could use inheritance to add methods to derived
> clocktypes, but that's not really possible in C unfortunately.

Well, it can be done... in a weird manner, but it can:

struct my_new_clk {
	struct clk	clk;

	int		(*reset)(struct my_new_clk *m);
};

int clk_reset(struct clk *clk)
{
	strut my_new_clk	*m =3D container_of(clk, struct my_new_clk, clk);

	return m->reset(m);
}

it doesn't look pretty, but it can be done.

--=20
balbi

--MiFvc8Vo6wRSORdP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPxylhAAoJEIaOsuA1yqRElcsQAJ7R9C2VdjyBIRsUKXU6ci+G
puUlb0DeWT9f9rrJnYVDKP9GoFNrGYeBorwQ9+IIl4ts8pBQTnrI0G/foKQef7Ow
wNn0l7JNYXrV4ke5/VmZYeTc9BoaFIepsN8B2YMqNTOgD2LEs+jOh6gg3Pp6wMhX
qC6m7ImDU5PLlOti5pi0RfwwpSiD4tdjwmMMwrB7i39Mo/oSWVK9Eex2zk8y9BcZ
0/AMFLQ7NSLeXQlNyL7EfIz6UP6ESyhjUwQWk9vUdYrw6KJpKheobdvBjgf08Kbx
3o68MOlobod5bgmRJ6V1mEFV/82xUSt08W2QpEHPzg7CGBTCWuV49rZzgLYPwGJd
901lxl7eWXfBMFXpMtatmrOoPGoH3f14EZ9fJ0a8m2JKVqp5T0JzRo6d5XOEP/So
xvF4c7nuf0T3IxvaT3wo8m+sK8TleoHuJxaC6yv/LRNGHidEwPLgIlZfuoXZdIl8
pD4icQwjGOAdYUVUSVYUJI9fn/4R4oMAGD2sfR9iLT7fdWkhzaShMa/8IhJeFefz
moPkxz9EwGYNZso+VhSYdssLQL0UK32FX8ungGKUt2MZ7dCSYo6SabeKSmPEoySh
gM7pfLK3vOApsBoQuIwe7JBfHebynsya1J0hYip63favi71hZ8XGez1LVo2qYeV0
D3FCQoAlUmPamlxkpNOg
=4kNz
-----END PGP SIGNATURE-----

--MiFvc8Vo6wRSORdP--
