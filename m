Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab2EaI4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:56:16 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:57191 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350Ab2EaI4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:56:14 -0400
Date: Thu, 31 May 2012 11:54:33 +0300
From: Felipe Balbi <balbi@ti.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Felipe Balbi <balbi@ti.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC PATCH] clk: add extension API
Message-ID: <20120531085432.GK5377@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
 <4FC5DFCF.1020606@codeaurora.org>
 <20120531075125.GL8026@tbergstrom-lnx.Nvidia.com>
 <20120531081841.GG5377@arwen.pp.htv.fi>
 <20120531083131.GQ8026@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PpocKf6TCvdC9BKE"
Content-Disposition: inline
In-Reply-To: <20120531083131.GQ8026@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PpocKf6TCvdC9BKE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, May 31, 2012 at 11:31:31AM +0300, Peter De Schrijver wrote:
> On Thu, May 31, 2012 at 10:18:42AM +0200, Felipe Balbi wrote:
> > * PGP Signed by an unknown key
> >=20
> > On Thu, May 31, 2012 at 10:51:25AM +0300, Peter De Schrijver wrote:
> > > On Wed, May 30, 2012 at 10:52:31AM +0200, Stephen Boyd wrote:
> > > > On 5/29/2012 2:58 AM, Peter De Schrijver wrote:
> > > > > Add an extension API for clocks. This allows clocktypes to provid=
e extensions
> > > > > for features which are uncommon and cannot be easily mapped onto =
normal clock
> > > > > framework concecpts. eg: resetting blocks, configuring clock phas=
e etc.
> > > >=20
> > > > This seems rather generic. Why not add more specific APIs/concepts =
like
> > > > clk_reset(), clk_set_phase(), etc.? If they don't map, maybe we sho=
uld
> > > > make them map.
> > > >=20
> > >=20
> > > Some of those might be very SoC specific. Eg OMAP doesn't need softwa=
re
> > > controlled modulereset. I don't think we should add a new function to=
 the
> >=20
> > it depends on what you call modulereset. We have soft-reset logic hidden
> > under the hood, it's done before device creation, so drivers (most of
> > them) assume we're probe with the IP in reset state.
> >=20
> > What I wonder most is if this should be done at the clock level or at
> > the device level. In the end you reset the IP block, not the clock,
> > right ?
>=20
> Yes. but, every block has at least 1 clock and thus the mapping is identi=
cal
> down to the register level. Ie. we could do this outside the clockframewo=
rk,

What if a module needs two clocks and you drive the reset on both of the
clocks ? What would happen ?

> but then we would have the keep a list of IDs (1 per module) which the dr=
ivers
> can use to call some tegra reset function which would in the end use regi=
sters
> in the same memory area to cause a reset. (the registers controlling
> modulereset are interleaved with those controlling the enable/disable of =
the
> main moduleclock and bitpositions are identical)

Well, under a generic device-level API, you could just call an internal
clk_reset() function because you know which clocks feed into which
devices anyway. It could look something like:

on Tegra:

device_reset(dev)
	-> dev_pm_domain->reset()
		-> tegra_periph_reset()

on OMAP:

device_reset(dev)
	-> dev_pm_domain->reset()
		-> omap_hwmod_reset()


btw:

tegra_periph_reset(....)
{
	tegra_periph_reset_assert(...);
	udelay(2);
	tegra_periph_reset_deassert(...);
}

--=20
balbi

--PpocKf6TCvdC9BKE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPxzHIAAoJEIaOsuA1yqREplUP/1GZ6p4XwNw+5AFHKvcQKj7K
CzdyKfcMZxq7k5yPRrGsieFYRjJRbsZfTaFJ4l/SQTmIg062NUfAgwAZtc143vcS
kphF4YhtQaCyUmvCJ/qi5goDzpoSO5K4wrJ+2L6X6oxpPq43I1whCqI9fbYq/ycp
0LqOzEv0gr/UdwTM4w8PtBm52//O7HG0yBwWa8A/ZXHI8Y5lx+GX6NI17jwyae0X
POwik1HwZVcobdkHpmEWEnowdJz7YOiVaMaFr2sNkTzGWTTEPBEVHohfMGSiY5zb
ARBCdlF2CS8BRQ/b7cNbsEt9Lqok9m/8P3O0DqT+QjMMGDo4toKzaNRTsT9kbTJ6
X3mtd+EyTtsI5b6m18tzUhpeHvnOc1V7+C3KXnk8+R2A2esx2pdfyZbRCvknhnnE
q+SV25k0q0F1ltKBVdC58IfOzLyCIGV3aOIcw1gCtXhtHgOoS8Gr5rpn0b+oiLQU
VC2Rrz0XzQI3wsNgstw/qQzMPsaZxmEwCqRglIdhnD04HrsU2fsRA+nbgpUDInMX
On3itHk61skD3hcUDwVnHe31rg/OdbPgyldfr4+G6rs506SHZr2e2LuW1JEsTD5h
7azLo/+9rcWIk1EguNJZ8PEVd6dROPIT98jq+EuhY86Co3eaU934Z47yNHZeDVie
d5ZVLooPrRfzttyuJWui
=/j9N
-----END PGP SIGNATURE-----

--PpocKf6TCvdC9BKE--
