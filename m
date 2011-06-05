Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab1FESvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 14:51:05 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:38946 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755556Ab1FESvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 14:51:02 -0400
Date: Sun, 5 Jun 2011 21:50:49 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: balbi@ti.com, Keshava Munegowda <keshava_mgowda@ti.com>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, khilman@ti.com,
        b-cousson@ti.com, paul@pwsan.com
Subject: Re: [PATCH 4/4] mfd: global Suspend and resume support of ehci and
 ohci
Message-ID: <20110605185047.GB18731@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1306934847-6098-1-git-send-email-keshava_mgowda@ti.com>
 <201106011554.38415.rjw@sisk.pl>
 <20110601143256.GG2409@legolas.emea.dhcp.ti.com>
 <201106051919.38637.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
Content-Disposition: inline
In-Reply-To: <201106051919.38637.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Jun 05, 2011 at 07:19:38PM +0200, Rafael J. Wysocki wrote:
> > On Wed, Jun 01, 2011 at 03:54:38PM +0200, Rafael J. Wysocki wrote:
> > > > +static const struct dev_pm_ops usbhsomap_dev_pm_ops =3D {
> > > > +	.suspend	=3D usbhs_suspend,
> > > > +	.resume		=3D usbhs_resume,
> > > > +};
> > >=20
> > > Please add .freeze()/.thaw() and .poweroff()/.restore() callbacks too.
> > > They may point to the same routines, but must be present.
> > >=20
> > > You can actually use the SIMPLE_DEV_PM_OPS() convenience macro for th=
is
> > > purpose.
> >=20
> > good point. BTW, do we need this #ifdef CONFIG_PM stuff which has been
> > popping on most drivers recently ? To me it looks like driver.pm field
> > is always available even if PM is disabled, so what's the point ? Saving
> > a few bytes ?
>=20
> Basically, yes (you may want to avoid defining the object this points to =
if
> CONFIG_PM is unset).

wouldn't it look nicer to have a specific section for dev_pm_ops which
gets automatically freed if CONFIG_PM isn't set ? I mean, there are a
few drivers which don't have the ifdeferry around dev_pm_ops anyway.

So, something like:

#define __pm_ops	__section(.pm.ops)

static const struct dev_pm_ops my_driver_pm_ops __pm_ops =3D {
	.suspend	=3D my_driver_suspend,
	.resume		=3D my_driver_resume,
	[ blablabla ]
};

to simplify things, you could:

#define DEFINE_DEV_PM_OPS(_ops)		\
	const struct dev_pm_ops _ops __pm_ops

that would mean changes to all linker scripts, though and a utility call
that only does anything ifndef CONFIG_PM to free the .pm.ops section.

--=20
balbi

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN69AHAAoJEAv8Txj19kN1NAAH/3VBSEOKpPM3QqZLB+wVORN6
gPBtgRapDGeXuPdlpvnvwNAZIgluZqA1PrRnmYj1HU6cj2wUT3dNIB+VliPG6R8A
1qZjuNiLCy9RKUIzxFYhypM5LQnbxVwrdvaluYBnf0Y1kD8QRpV1fBZMlRgQlPxr
DRrlcpzZ6U3gqTA94Yi+RKFHv91iEDMu7jCzirlJfIvSfZHlD/Au7vQAjBYv0qgR
Dv6CbhnKYp/gKLbgEXQyrhkWhj5znHi0joJ2E97m0Jc0PVpIc2eWeJY8e/OI5nkF
lTkfCaZvocTQqxQoHBTjPD2bDBoGmfSMhpVv07MihvVFg3tsL5paqkaTTkR8SWI=
=OJYM
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--
