Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab2EaJr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 05:47:59 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:49609 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409Ab2EaJr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 05:47:58 -0400
Date: Thu, 31 May 2012 12:46:17 +0300
From: Felipe Balbi <balbi@ti.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Felipe Balbi <balbi@ti.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@ti.com>, Benoit Cousson <b-cousson@ti.com>
Subject: Re: [RFC PATCH] clk: add extension API
Message-ID: <20120531094616.GP5377@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
 <4FC5DFCF.1020606@codeaurora.org>
 <20120531075125.GL8026@tbergstrom-lnx.Nvidia.com>
 <20120531081841.GG5377@arwen.pp.htv.fi>
 <20120531083131.GQ8026@tbergstrom-lnx.Nvidia.com>
 <20120531085432.GK5377@arwen.pp.htv.fi>
 <20120531090518.GR8026@tbergstrom-lnx.Nvidia.com>
 <20120531092603.GM5377@arwen.pp.htv.fi>
 <20120531094301.GT8026@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e9fMjeYs+GPci+mg"
Content-Disposition: inline
In-Reply-To: <20120531094301.GT8026@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e9fMjeYs+GPci+mg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 31, 2012 at 12:43:01PM +0300, Peter De Schrijver wrote:
> > > > on Tegra:
> > > >=20
> > > > device_reset(dev)
> > > > 	-> dev_pm_domain->reset()
> > > > 		-> tegra_periph_reset()
> > > >=20
> > >=20
> > > These methods are also needed internally by the powergating code.
> >=20
> > so ? Just call them when you need...
> >=20
>=20
> the powergating code calls assert and deassert indepedently
> ie:
>=20
> tegra_periph_reset_assert()
>=20
> do stuff
>=20
> tegra_periph_reset_assert()

I don't see the issue here. expose tegra_periph_reset() for the device
API only, internally you can do whatever you like. Call them
independently if you need.

> > > > on OMAP:
> > > >=20
> > > > device_reset(dev)
> > > > 	-> dev_pm_domain->reset()
> > > > 		-> omap_hwmod_reset()
> > > >=20
> > > >=20
> > > > btw:
> > > >=20
> > > > tegra_periph_reset(....)
> > > > {
> > > > 	tegra_periph_reset_assert(...);
> > > > 	udelay(2);
> > > > 	tegra_periph_reset_deassert(...);
> > > > }
> > >=20
> > > which uses the clockframework currently.
> >=20
> > no problems there. The point is that you already know which clock feed
> > into which device, so if you have a device-based API for device
> > soft-reset, you can figure out which exact clock to toggle, right ?
>=20
> you have the struct clk, you could dive into that and grab clk_hw and call
> some function directly. But sounds quite horrible to me.

Well, that's just because struct device doesn't know about its own clock
providers, right ? Should that be patched too ?

Russell, as the orignal author of the clk API, what do you think ?

--=20
balbi

--e9fMjeYs+GPci+mg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPxz3oAAoJEIaOsuA1yqRE6XAP/1854pm167vZX04foVA/cq6M
1J+jidFReCB4wFmL9XKvx/V6NW3lOXjYbat8BAEu1P+NVe4mOepsbYXptx0qMrMf
nZirviTJJwWCtBD3oXrOsSH0QazFSCVrEoazXpuPsCWEHJKB8JzYZqxYM0eqKmuV
gxb6GlqZhtgZNeE8JxPB4Lm8MONEi3H0udPBHXddSt9ItpBc/XuRwN3vthunOG76
Fd8lKJf8/cwQbW3V3hIjEsEuitD3NGpvf4kAlaog8ImNcqhAOBJQmNHH5AEwBWMz
ib4jR8QPBR0go9+oYvMNuEoLFfk/0Ph0ieeCdHR9ppmprfKSXGeYrcrEk3CWL6xB
GOSh1cpF48UdFv0atePjtS3wAc2uVrVQz37qcveANiinrWBOCHEzyw4Fukua3Zg5
vCnSdo43n1EiFDAKplaIvnjJcv4Ui6W+eyUI3bLSc+1pYA+Y477eqXiQV+X52y70
mRXMvsC2ELXTO745LDlcSIC6GO7KhLtQDF+TTOHjQbhqTSfVvGIzGr6NsMBDApWc
tl3pIu9co9ZpsnyS/n+UXy0EDvn4oEh4QE8a0lxyju09xNdGzCqsCQRlZ7MYOG2v
a4/J7IINcK8Of8+lw0Mrq7lySmp8Ve8mR/58GHXpRMSBlW2zVf0q0BgI/iVBOk9U
hwTPsP0R3Ios2pFe6nir
=9B9z
-----END PGP SIGNATURE-----

--e9fMjeYs+GPci+mg--
